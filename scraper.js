require('dotenv').config();
const { Pool } = require('pg');

const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
  ssl: { rejectUnauthorized: false }
});

// Pulls menus from Villanova's Nutrislice site
// (https://villanovauniversity.nutrislice.com). The site's pages load their
// data from this public JSON API; one request returns a full week (Sun-Sat)
// of a hall's menu for one meal, with station, nutrition, serving size and
// ingredients for every item — so no per-item requests are needed.
const API_BASE = 'https://villanovauniversity.api.nutrislice.com/menu/api/weeks/school';

// Maps dining_halls.name (as stored in the DB) -> Nutrislice school slug.
// Other locations Nutrislice has, if you ever want to add them:
// 'cafe-nova', 'cabrini-dining-hall', 'connelly-center', 'exchange-commodities'.
const DINING_HALL_SLUGS = {
  'Dougherty Hall': 'dougherty-hall',
  'Donahue Hall': 'donahue-hall',
  "St. Mary's Dining Hall": 'st-marys-dining-hall',
};

const MEAL_TYPES = ['breakfast', 'lunch', 'dinner'];

// Fixed-menu halls: same menu every day, so instead of scheduling items per
// date we keep one standing list of active items (the app shows all active
// items for 'fixed' halls). Each entry lists the Nutrislice menus to pull.
//   stripPrefix: removed from station names ("Cafe Nova Corner Grill" -> "Corner Grill")
//   defaultStation: used when Nutrislice has no station headers
const FIXED_HALLS = {
  'Café Nova': { slug: 'cafe-nova', menus: ['lunch', 'dinner'], stripPrefix: 'Cafe Nova ' },
  'Connelly Center': { slug: 'connelly-center', menus: ['retail-lunch'], defaultStation: 'Sushi & Bowls' },
};
// Fixed halls can be closed for a week or two (breaks), so look this many
// weeks ahead for a day that has a menu posted.
const FIXED_LOOKAHEAD_WEEKS = 4;

// Stop scraping forward after this many weeks in a row with nothing posted.
const MAX_EMPTY_WEEKS = 2;
// Hard cap so a misbehaving API can't keep us looping forever.
const MAX_WEEKS = 6;

function todayEastern() {
  return new Date().toLocaleDateString('en-CA', { timeZone: 'America/New_York' }); // YYYY-MM-DD
}

function addDays(dateStr, days) {
  const d = new Date(`${dateStr}T12:00:00Z`);
  d.setUTCDate(d.getUTCDate() + days);
  return d.toISOString().split('T')[0];
}

async function fetchWeek(slug, mealType, dateStr) {
  const [year, month, day] = dateStr.split('-');
  const url = `${API_BASE}/${slug}/menu-type/${mealType}/${year}/${month}/${day}/`;
  const res = await fetch(url, { headers: { Accept: 'application/json' } });
  if (!res.ok) {
    throw new Error(`Nutrislice request failed: ${res.status} ${res.statusText} (${url})`);
  }
  return res.json();
}

const round = v => (v == null || v === '' || Number.isNaN(Number(v)) ? null : Math.round(Number(v)));

// Turns one day's flat Nutrislice menu_items list into
// [{ stationName, food }] — station headers are separate rows in the list,
// so map each food to its station's header text via station_id (falling back
// to the most recent header above it).
function foodsWithStations(menuItems, defaultStation = 'Unassigned') {
  const stationNames = new Map();
  for (const mi of menuItems) {
    if (mi.is_station_header && mi.text) stationNames.set(mi.station_id, mi.text.trim());
  }
  const out = [];
  let lastHeader = null;
  for (const mi of menuItems) {
    if (mi.is_station_header) { lastHeader = mi.text ? mi.text.trim() : lastHeader; continue; }
    if (!mi.food) continue;
    const stationName = stationNames.get(mi.station_id) || lastHeader || defaultStation;
    out.push({ stationName, food: mi.food, item: mi });
  }
  return out;
}

function servingSizeOf(food, item) {
  const info = food.serving_size_info || {};
  const amount = info.serving_size_amount ?? item.serving_size_amount;
  const unit = info.serving_size_unit ?? item.serving_size_unit;
  if (amount == null && !unit) return null;
  return [amount, unit].filter(x => x != null && x !== '').join(' ') || null;
}

async function upsertStation(client, diningHallId, name) {
  // Stations are keyed on (dining_hall_id, name), which is already a unique
  // constraint on the table, so existing stations are reused by name.
  const result = await client.query(
    `INSERT INTO stations (dining_hall_id, name)
     VALUES ($1, $2)
     ON CONFLICT (dining_hall_id, name)
     DO UPDATE SET name = EXCLUDED.name
     RETURNING id`,
    [diningHallId, name]
  );
  return result.rows[0].id;
}

async function upsertMenuItem(client, stationId, foodId, name, mealType, nutrition, ingredients) {
  const result = await client.query(
    `INSERT INTO menu_items_master
       (station_id, name, meal_type, nutrition_source, nutrition_status,
        scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size,
        scraped_ingredients, nutrislice_food_id, is_active, admin_review_status)
     VALUES ($1, $2, $3, 'scraped', 'accepted', $4, $5, $6, $7, $8, $9, $10, true, 'pending')
     ON CONFLICT (station_id, nutrislice_food_id)
     DO UPDATE SET
       name = EXCLUDED.name,
       meal_type = EXCLUDED.meal_type,
       scraped_calories = EXCLUDED.scraped_calories,
       scraped_protein = EXCLUDED.scraped_protein,
       scraped_carbs = EXCLUDED.scraped_carbs,
       scraped_fat = EXCLUDED.scraped_fat,
       scraped_serving_size = EXCLUDED.scraped_serving_size,
       scraped_ingredients = COALESCE(EXCLUDED.scraped_ingredients, menu_items_master.scraped_ingredients),
       is_active = true,
       updated_at = CURRENT_TIMESTAMP,
       admin_review_status = CASE
         WHEN (
           menu_items_master.scraped_calories IS DISTINCT FROM EXCLUDED.scraped_calories OR
           menu_items_master.scraped_protein IS DISTINCT FROM EXCLUDED.scraped_protein OR
           menu_items_master.scraped_carbs IS DISTINCT FROM EXCLUDED.scraped_carbs OR
           menu_items_master.scraped_fat IS DISTINCT FROM EXCLUDED.scraped_fat
         ) AND menu_items_master.admin_review_status != 'pending'
         THEN 'pending'
         ELSE menu_items_master.admin_review_status
       END
     RETURNING id`,
    [
      stationId, name, mealType,
      nutrition.calories, nutrition.protein, nutrition.carbs, nutrition.fat,
      nutrition.servingSize, ingredients ?? null, foodId
    ]
  );
  return result.rows[0].id;
}

// Map of nutrislice_food_id -> menu_items_master.id for items an admin has
// flagged as "assorted" (dispenser-style) within this dining hall.
async function getAssortedFoodIds(client, diningHallId) {
  const result = await client.query(
    `SELECT mi.nutrislice_food_id, mi.id
     FROM menu_items_master mi
     JOIN stations s ON mi.station_id = s.id
     WHERE s.dining_hall_id = $1 AND mi.is_assorted = true`,
    [diningHallId]
  );
  const map = new Map();
  for (const row of result.rows) map.set(Number(row.nutrislice_food_id), row.id);
  return map;
}

// Active child items (e.g. individual cereals) belonging to an assorted parent item
async function getActiveChildren(client, parentId) {
  const result = await client.query(
    `SELECT id FROM menu_items_master WHERE parent_item_id = $1 AND is_active = true`,
    [parentId]
  );
  return result.rows;
}

async function scheduleItem(client, menuItemId, dateStr) {
  await client.query(
    `INSERT INTO daily_schedule (menu_item_id, date)
     VALUES ($1, $2)
     ON CONFLICT (menu_item_id, date) DO NOTHING`,
    [menuItemId, dateStr]
  );
}

// Saves one day of one meal for one hall.
async function saveDay(client, diningHallId, mealType, dateStr, menuItems, assortedFoodIds, stationCache) {
  let itemCount = 0;

  for (const { stationName, food, item } of foodsWithStations(menuItems)) {
    let stationId = stationCache.get(stationName);
    if (!stationId) {
      stationId = await upsertStation(client, diningHallId, stationName);
      stationCache.set(stationName, stationId);
    }

    const foodId = food.id;

    // Assorted (dispenser) items: don't overwrite admin-managed macros, and
    // don't schedule the parent placeholder itself — schedule its children.
    if (assortedFoodIds.has(Number(foodId))) {
      const parentId = assortedFoodIds.get(Number(foodId));
      const children = await getActiveChildren(client, parentId);
      for (const child of children) {
        await scheduleItem(client, child.id, dateStr);
      }
      itemCount += children.length;
      continue;
    }

    const n = food.rounded_nutrition_info || {};
    const ingredients = food.ingredients && food.ingredients.trim() ? food.ingredients.trim() : null;

    const menuItemId = await upsertMenuItem(
      client,
      stationId,
      foodId,
      food.name,
      mealType,
      {
        calories: round(n.calories),
        protein: round(n.g_protein),
        carbs: round(n.g_carbs),
        fat: round(n.g_fat),
        servingSize: servingSizeOf(food, item),
      },
      ingredients
    );

    await scheduleItem(client, menuItemId, dateStr);
    itemCount++;
  }

  return itemCount;
}

// Scrapes one hall/meal starting from the week containing `fromDate`.
// If `onlyDate` is set, saves just that date; otherwise keeps going week by
// week until Nutrislice has nothing posted.
async function scrapeHallMeal(client, hall, slug, mealType, fromDate, onlyDate) {
  const assortedFoodIds = await getAssortedFoodIds(client, hall.id);
  const stationCache = new Map();
  let total = 0;
  let emptyWeeks = 0;
  let weekDate = fromDate;

  for (let w = 0; w < MAX_WEEKS && emptyWeeks < MAX_EMPTY_WEEKS; w++) {
    const week = await fetchWeek(slug, mealType, weekDate);
    let weekItems = 0;

    for (const day of week.days || []) {
      if (onlyDate ? day.date !== onlyDate : day.date < fromDate) continue;
      const menuItems = day.menu_items || [];
      if (!menuItems.length) continue;
      const count = await saveDay(client, hall.id, mealType, day.date, menuItems, assortedFoodIds, stationCache);
      weekItems += count;
      console.log(`  ${slug}/${mealType} ${day.date}: ${count} items`);
    }

    total += weekItems;
    if (onlyDate) break;
    emptyWeeks = weekItems === 0 ? emptyWeeks + 1 : 0;
    // Jump to the next week (start_date is the Sunday of the returned week).
    weekDate = addDays(week.start_date || weekDate, 7);
  }

  return total;
}

// ---- FIXED-MENU HALLS ----

// Returns the first day (from fromDate on) that has items, for one menu.
async function firstPostedDay(slug, menu, fromDate) {
  let weekDate = fromDate;
  for (let w = 0; w < FIXED_LOOKAHEAD_WEEKS; w++) {
    const week = await fetchWeek(slug, menu, weekDate);
    const day = (week.days || []).find(d => d.date >= fromDate && (d.menu_items || []).some(i => i.food));
    if (day) return day;
    weekDate = addDays(week.start_date || weekDate, 7);
  }
  return null;
}

async function scrapeFixedHall(client, hall, cfg, fromDate) {
  // foodId -> { stationName, food, item, menus: Set }
  const foods = new Map();
  for (const menu of cfg.menus) {
    const day = await firstPostedDay(cfg.slug, menu, fromDate);
    if (!day) { console.log(`  ${menu}: nothing posted in the next ${FIXED_LOOKAHEAD_WEEKS} weeks`); continue; }
    console.log(`  ${menu}: using menu from ${day.date}`);
    for (const entry of foodsWithStations(day.menu_items, cfg.defaultStation)) {
      const key = Number(entry.food.id);
      if (!foods.has(key)) foods.set(key, { ...entry, menus: new Set() });
      foods.get(key).menus.add(menu);
    }
  }

  // Safety: if Nutrislice returned nothing, leave the existing menu alone
  // rather than switching every item off.
  if (foods.size === 0) {
    console.log('  No items found — leaving existing menu unchanged.');
    return 0;
  }

  const assortedFoodIds = await getAssortedFoodIds(client, hall.id);
  const stationCache = new Map();

  for (const [foodId, { stationName: rawStation, food, item, menus }] of foods) {
    if (assortedFoodIds.has(foodId)) continue; // admin manages assorted items + their children

    const stationName = cfg.stripPrefix && rawStation.startsWith(cfg.stripPrefix)
      ? rawStation.slice(cfg.stripPrefix.length)
      : rawStation;
    let stationId = stationCache.get(stationName);
    if (!stationId) {
      stationId = await upsertStation(client, hall.id, stationName);
      stationCache.set(stationName, stationId);
    }

    // On every menu this hall has (or a single all-day menu) -> 'all';
    // otherwise the specific meal it's served at.
    const mealType = menus.size === cfg.menus.length ? 'all' : [...menus][0];

    const n = food.rounded_nutrition_info || {};
    const ingredients = food.ingredients && food.ingredients.trim() ? food.ingredients.trim() : null;
    await upsertMenuItem(
      client, stationId, foodId, food.name, mealType,
      {
        calories: round(n.calories),
        protein: round(n.g_protein),
        carbs: round(n.g_carbs),
        fat: round(n.g_fat),
        servingSize: servingSizeOf(food, item),
      },
      ingredients
    );
  }

  // Switch off scraped items that are no longer on Nutrislice. Items added
  // by hand in the admin portal (no nutrislice_food_id) are left alone.
  const off = await client.query(
    `UPDATE menu_items_master mi
     SET is_active = false, updated_at = CURRENT_TIMESTAMP
     FROM stations s
     WHERE mi.station_id = s.id AND s.dining_hall_id = $1
       AND mi.is_active = true
       AND mi.nutrislice_food_id IS NOT NULL
       AND mi.is_assorted = false
       AND mi.parent_item_id IS NULL
       AND NOT (mi.nutrislice_food_id = ANY($2::int[]))`,
    [hall.id, [...foods.keys()]]
  );
  if (off.rowCount) console.log(`  Switched off ${off.rowCount} item(s) no longer on Nutrislice`);

  return foods.size;
}

async function main() {
  // Optional date argument (YYYY-MM-DD) scrapes just that date; otherwise
  // scrape forward from today until Nutrislice has nothing more posted.
  const specificDate = process.argv[2];
  const fromDate = specificDate || todayEastern();

  const client = await pool.connect();
  try {
    const hallsResult = await client.query('SELECT id, name FROM dining_halls');

    for (const hall of hallsResult.rows) {
      const fixedCfg = FIXED_HALLS[hall.name];
      if (fixedCfg) {
        // A single-date run (date argument) is for the daily menus only.
        if (specificDate) continue;
        console.log(`\n${hall.name} (${fixedCfg.slug}, fixed menu):`);
        try {
          const n = await scrapeFixedHall(client, hall, fixedCfg, fromDate);
          console.log(`  ${n} items on the menu`);
        } catch (err) {
          console.error(`  Error scraping ${fixedCfg.slug}:`, err.message);
        }
        continue;
      }

      const slug = DINING_HALL_SLUGS[hall.name];
      if (!slug) {
        console.log(`Skipping ${hall.name}: no Nutrislice slug configured`);
        continue;
      }

      console.log(`\n${hall.name} (${slug}):`);
      for (const mealType of MEAL_TYPES) {
        try {
          const n = await scrapeHallMeal(client, hall, slug, mealType, fromDate, specificDate);
          console.log(`  ${mealType}: ${n} items total`);
        } catch (err) {
          console.error(`  Error scraping ${slug}/${mealType}:`, err.message);
        }
      }
    }
  } finally {
    client.release();
    await pool.end();
  }

  console.log('\nDone.');
}

main().catch(err => {
  console.error('Fatal error:', err);
  process.exit(1);
});