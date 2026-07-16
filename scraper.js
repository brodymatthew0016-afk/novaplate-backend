require('dotenv').config();
const { Pool } = require('pg');

const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
  ssl: { rejectUnauthorized: false }
});

const DINING_HALL_SLUGS = {
  'Dougherty Hall': 'dougherty-hall',
  'Donahue Hall': 'donahue-hall',
  "St. Mary's Dining Hall": 'st-marys-dining-hall',
};

const MEAL_TYPES = ['breakfast', 'lunch', 'dinner'];

function buildUrl(slug, mealType, dateStr) {
  const [year, month, day] = dateStr.split('-');
  return `https://villanovauniversity.api.nutrislice.com/menu/api/weeks/school/${slug}/menu-type/${mealType}/${year}/${month}/${day}/`;
}

function addDays(dateStr, days) {
  const d = new Date(dateStr);
  d.setDate(d.getDate() + days);
  return d.toISOString().split('T')[0];
}

async function fetchMenuJson(slug, mealType, dateStr) {
  const url = buildUrl(slug, mealType, dateStr);
  const res = await fetch(url);
  if (!res.ok) {
    throw new Error(`Nutrislice request failed: ${res.status} ${res.statusText} (${url})`);
  }
  return res.json();
}

async function upsertStation(client, diningHallId, nutrisliceStationId, name) {
  const result = await client.query(
    `INSERT INTO stations (dining_hall_id, name, nutrislice_station_id)
     VALUES ($1, $2, $3)
     ON CONFLICT (nutrislice_station_id)
     DO UPDATE SET name = EXCLUDED.name
     RETURNING id`,
    [diningHallId, name, nutrisliceStationId]
  );
  return result.rows[0].id;
}

async function upsertMenuItem(client, stationId, nutrisliceFoodId, name, mealType, nutrition) {
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
      nutrition.servingSize, nutrisliceFoodId
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
  for (const row of result.rows) map.set(row.nutrislice_food_id, row.id);
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

async function scrapeDiningHallMealType(client, diningHallId, slug, mealType, dateStr) {
  const json = await fetchMenuJson(slug, mealType, dateStr);

  const dayEntry = json.days.find(d => d.date === dateStr);
  if (!dayEntry) {
    return { stations: 0, items: 0 };
  }

  const assortedFoodIds = await getAssortedFoodIds(client, diningHallId);

  const menuItems = dayEntry.menu_items || [];
  let currentStationId = null;
  let stationCount = 0;
  let itemCount = 0;

  for (const entry of menuItems) {
    if (entry.is_station_header) {
      currentStationId = await upsertStation(client, diningHallId, entry.station_id, entry.text);
      stationCount++;
      continue;
    }

    if (!entry.food || currentStationId === null) continue;

    const food = entry.food;

    // Assorted (dispenser) items: don't overwrite admin-managed macros, and
    // don't schedule the parent placeholder itself — schedule its children.
    if (assortedFoodIds.has(food.id)) {
      const parentId = assortedFoodIds.get(food.id);
      const children = await getActiveChildren(client, parentId);
      for (const child of children) {
        await scheduleItem(client, child.id, dateStr);
      }
      itemCount += children.length;
      continue;
    }

    const nutrition = food.rounded_nutrition_info || {};

    const itemId = await upsertMenuItem(
      client,
      currentStationId,
      food.id,
      food.name,
      mealType,
      {
        calories: nutrition.calories != null ? Math.round(nutrition.calories) : null,
        protein: nutrition.g_protein != null ? Math.round(nutrition.g_protein) : null,
        carbs: nutrition.g_carbs != null ? Math.round(nutrition.g_carbs) : null,
        fat: nutrition.g_fat != null ? Math.round(nutrition.g_fat) : null,
        servingSize: food.serving_size_info
          ? `${food.serving_size_info.serving_size_amount} ${food.serving_size_info.serving_size_unit}`
          : null,
      }
    );

    await scheduleItem(client, itemId, dateStr);
    itemCount++;
  }

  console.log(`  ${slug}/${mealType}: ${stationCount} stations, ${itemCount} items for ${dateStr}`);
  return { stations: stationCount, items: itemCount };
}

// Scrape a single date across all meal types for a hall
async function scrapeDateForHall(client, hall, slug, dateStr) {
  let totalItems = 0;
  for (const mealType of MEAL_TYPES) {
    try {
      const result = await scrapeDiningHallMealType(client, hall.id, slug, mealType, dateStr);
      totalItems += result.items;
    } catch (err) {
      console.error(`  Error scraping ${slug}/${mealType} for ${dateStr}:`, err.message);
    }
  }
  return totalItems;
}

// Scrape forward from today until Nutrislice stops returning data
async function scrapeForward(client, hall, slug) {
  let dateStr = new Date().toISOString().split('T')[0];
  let consecutiveEmptyDays = 0;
  const MAX_EMPTY = 3;

  console.log(`  Scraping forward from ${dateStr}...`);

  while (consecutiveEmptyDays < MAX_EMPTY) {
    const items = await scrapeDateForHall(client, hall, slug, dateStr);
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
      const slug = DINING_HALL_SLUGS[hall.name];
      if (!slug) {
        console.log(`Skipping ${hall.name}: no Nutrislice slug configured`);
        continue;
      }

      console.log(`\n${hall.name} (${slug}):`);

      if (specificDate) {
        await scrapeDateForHall(client, hall, slug, specificDate);
      } else {
        await scrapeForward(client, hall, slug);
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