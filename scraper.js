require('dotenv').config();
const { Pool } = require('pg');

const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
  ssl: { rejectUnauthorized: false }
});

// Maps dining_halls.name (as stored in the DB) -> the exact `hall` query
// param this proxy expects.
//
// CONFIRMED via browser network tab: 'Dougherty Hall' -> 'DOUGHERTY HALL'
// UNVERIFIED (best guess, please confirm): Donahue Hall, St. Mary's Dining Hall
//   -> If either comes back with an empty `menu` array on days you know have
//      food, open DevTools on villanova.edu's dining page, switch to that
//      hall, and grab the real `hall=` value from the Network tab.
const DINING_HALL_PARAMS = {
  'Dougherty Hall': 'DOUGHERTY HALL',
  'Donahue Hall': 'DONAHUE HALL',
  "St. Mary's Dining Hall": "ST. MARY'S HALL",
};

const MEAL_TYPES = ['breakfast', 'lunch', 'dinner'];

// UNVERIFIED (best guess): confirmed only for 'dinner' -> 'Dinner' so far.
const MEAL_PARAM = {
  breakfast: 'Breakfast',
  lunch: 'Lunch',
  dinner: 'Dinner',
};

const BASE_URL = 'https://www.villanova.edu/etc/designs/villanova/ajax/dininghallmenu.proxy.json';

function buildUrl(hallParam, mealType, dateStr) {
  // dateStr is 'YYYY-MM-DD' -> proxy wants 'MM/DD/YYYY'
  const [year, month, day] = dateStr.split('-');
  const params = new URLSearchParams({
    command: 'Menu',
    hall: hallParam,
    meal: MEAL_PARAM[mealType],
    date: `${month}/${day}/${year}`,
  });
  return `${BASE_URL}?${params.toString()}`;
}

function addDays(dateStr, days) {
  const d = new Date(dateStr);
  d.setDate(d.getDate() + days);
  return d.toISOString().split('T')[0];
}

async function fetchMenuItems(hallParam, mealType, dateStr) {
  const url = buildUrl(hallParam, mealType, dateStr);
  const res = await fetch(url);
  if (!res.ok) {
    throw new Error(`Villanova dining proxy failed: ${res.status} ${res.statusText} (${url})`);
  }
  const json = await res.json();
  return Array.isArray(json.menu) ? json.menu : [];
}

async function upsertStation(client, diningHallId, name) {
  // This API doesn't hand back a stable numeric station id like Nutrislice
  // did, so we key stations on (dining_hall_id, name) instead, which is
  // already a unique constraint on the table.
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

async function upsertMenuItem(client, stationId, foodId, name, mealType, nutrition) {
  const result = await client.query(
    `INSERT INTO menu_items_master
       (station_id, name, meal_type, nutrition_source, nutrition_status,
        scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size,
        nutrislice_food_id, is_active, admin_review_status)
     VALUES ($1, $2, $3, 'scraped', 'accepted', $4, $5, $6, $7, $8, $9, true, 'pending')
     ON CONFLICT (station_id, nutrislice_food_id)
     DO UPDATE SET
       name = EXCLUDED.name,
       meal_type = EXCLUDED.meal_type,
       scraped_calories = EXCLUDED.scraped_calories,
       scraped_protein = EXCLUDED.scraped_protein,
       scraped_carbs = EXCLUDED.scraped_carbs,
       scraped_fat = EXCLUDED.scraped_fat,
       scraped_serving_size = EXCLUDED.scraped_serving_size,
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
      nutrition.servingSize, foodId
    ]
  );
  return result.rows[0].id;
}

async function scheduleItem(client, menuItemId, dateStr) {
  await client.query(
    `INSERT INTO daily_schedule (menu_item_id, date)
     VALUES ($1, $2)
     ON CONFLICT (menu_item_id, date) DO NOTHING`,
    [menuItemId, dateStr]
  );
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

async function scrapeDiningHallMealType(client, diningHallId, hallParam, mealType, dateStr) {
  const items = await fetchMenuItems(hallParam, mealType, dateStr);

  const assortedFoodIds = await getAssortedFoodIds(client, diningHallId);
  const stationCache = new Map();
  let itemCount = 0;

  for (const item of items) {
    const stationName = item.course || 'Unassigned';
    let stationId = stationCache.get(stationName);
    if (!stationId) {
      stationId = await upsertStation(client, diningHallId, stationName);
      stationCache.set(stationName, stationId);
    }

    const foodId = item.id;

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

    const menuItemId = await upsertMenuItem(
      client,
      stationId,
      foodId,
      item.itemName,
      mealType,
      {
        calories: item.calories != null ? Math.round(item.calories) : null,
        protein: item.protein != null ? Math.round(item.protein) : null,
        carbs: item.carbohydrate != null ? Math.round(item.carbohydrate) : null,
        fat: item.fat != null ? Math.round(item.fat) : null,
        servingSize: item.portion || null,
      }
    );

    await scheduleItem(client, menuItemId, dateStr);
    itemCount++;
  }

  console.log(`  ${hallParam}/${mealType}: ${stationCache.size} stations, ${itemCount} items for ${dateStr}`);
  return { stations: stationCache.size, items: itemCount };
}

// Scrape a single date across all meal types for a hall
async function scrapeDateForHall(client, hall, hallParam, dateStr) {
  let totalItems = 0;
  for (const mealType of MEAL_TYPES) {
    try {
      const result = await scrapeDiningHallMealType(client, hall.id, hallParam, mealType, dateStr);
      totalItems += result.items;
    } catch (err) {
      console.error(`  Error scraping ${hallParam}/${mealType} for ${dateStr}:`, err.message);
    }
  }
  return totalItems;
}

// Scrape forward from today until this proxy stops returning data
async function scrapeForward(client, hall, hallParam) {
  let dateStr = new Date().toISOString().split('T')[0];
  let consecutiveEmptyDays = 0;
  const MAX_EMPTY = 3;

  console.log(`  Scraping forward from ${dateStr}...`);

  while (consecutiveEmptyDays < MAX_EMPTY) {
    const items = await scrapeDateForHall(client, hall, hallParam, dateStr);
    if (items === 0) {
      consecutiveEmptyDays++;
      console.log(`  No items for ${dateStr} (${consecutiveEmptyDays}/${MAX_EMPTY} empty)`);
    } else {
      consecutiveEmptyDays = 0;
    }
    dateStr = addDays(dateStr, 1);
  }

  console.log(`  Done scraping ${hall.name}`);
}

async function main() {
  // If a date argument is passed, scrape just that date (original behavior)
  // If no argument, scrape forward from today until empty
  const specificDate = process.argv[2];

  const client = await pool.connect();
  try {
    const hallsResult = await client.query('SELECT id, name FROM dining_halls');

    for (const hall of hallsResult.rows) {
      const hallParam = DINING_HALL_PARAMS[hall.name];
      if (!hallParam) {
        console.log(`Skipping ${hall.name}: no dining hall param configured`);
        continue;
      }

      console.log(`\n${hall.name} (${hallParam}):`);

      if (specificDate) {
        await scrapeDateForHall(client, hall, hallParam, specificDate);
      } else {
        await scrapeForward(client, hall, hallParam);
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