require('dotenv').config();
const { Pool } = require('pg');

const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
  ssl: { rejectUnauthorized: false }
});

// Maps DB dining hall names to the query param the Villanova site expects
const DINING_HALL_NAMES = {
  'Dougherty Hall': 'DOUGHERTY HALL',
  'Donahue Hall':   'DONAHUE HALL',
  "St. Mary's Dining Hall": "ST. MARY'S DINING HALL",
};

const MEAL_TYPES = ['BREAKFAST', 'BRUNCH', 'LUNCH', 'DINNER', 'LATE NIGHT'];

const PROXY_URL = 'https://webapps.villanova.edu/dininghallmenu/form_confirmation_proxy.jsp?template=no';

// Convert YYYY-MM-DD to MM/DD/YYYY for the Villanova API
function toVillanovaDate(dateStr) {
  const [year, month, day] = dateStr.split('-');
  return `${month}/${day}/${year}`;
}

function addDays(dateStr, days) {
  const d = new Date(dateStr);
  d.setDate(d.getDate() + days);
  return d.toISOString().split('T')[0];
}

async function fetchMenuJson(hallName, mealType, dateStr) {
  const body = `command=Menu&hall=${encodeURIComponent(hallName)}&date=${encodeURIComponent(toVillanovaDate(dateStr))}&meal=${encodeURIComponent(mealType)}`;
  const res = await fetch(PROXY_URL, {
    method: 'POST',
    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
    body,
  });
  if (!res.ok) {
    throw new Error(`Villanova request failed: ${res.status} ${res.statusText}`);
  }
  return res.json();
}

// Stations have no numeric ID in this API — use name as the unique key
async function upsertStation(client, diningHallId, name) {
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

async function upsertMenuItem(client, stationId, villanovaFoodId, name, mealType, nutrition) {
  const result = await client.query(
    `INSERT INTO menu_items_master
       (station_id, name, meal_type, nutrition_source, nutrition_status,
        scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size,
        nutrislice_food_id, is_active, admin_review_status)
     VALUES ($1, $2, $3, 'scraped', 'accepted', $4, $5, $6, $7, $8, $9, true, 'pending')
      ON CONFLICT (station_id, name)     DO UPDATE SET
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
      nutrition.servingSize, villanovaFoodId
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

async function scrapeDiningHallMealType(client, diningHallId, hallName, mealType, dateStr) {
  const json = await fetchMenuJson(hallName, mealType, dateStr);

  const menuItems = json.menu || [];
  if (menuItems.length === 0) return { stations: 0, items: 0 };

  // Cache station IDs within this call to avoid redundant DB hits
  const stationCache = {};
  let itemCount = 0;

  for (const item of menuItems) {
    const courseName = item.course || 'General';

    if (!stationCache[courseName]) {
      stationCache[courseName] = await upsertStation(client, diningHallId, courseName);
    }
    const stationId = stationCache[courseName];

    // Normalize meal type to lowercase to match DB constraint
    const dbMealType = mealType === 'LATE NIGHT' ? 'dinner'
      : mealType === 'BRUNCH' ? 'breakfast'
      : mealType.toLowerCase();

    const itemId = await upsertMenuItem(
      client,
      stationId,
      item.id,
      item.itemName,
      dbMealType,
      {
        calories:    item.calories    != null ? Math.round(item.calories)    : null,
        protein:     item.protein     != null ? Math.round(item.protein)     : null,
        carbs:       item.carbohydrate != null ? Math.round(item.carbohydrate) : null,
        fat:         item.fat         != null ? Math.round(item.fat)         : null,
        servingSize: item.portion     || null,
      }
    );

    await scheduleItem(client, itemId, dateStr);
    itemCount++;
  }

  const stationCount = Object.keys(stationCache).length;
  console.log(`  ${hallName}/${mealType}: ${stationCount} stations, ${itemCount} items for ${dateStr}`);
  return { stations: stationCount, items: itemCount };
}

async function scrapeDateForHall(client, hall, hallName, dateStr) {
  let totalItems = 0;
  for (const mealType of MEAL_TYPES) {
    try {
      const result = await scrapeDiningHallMealType(client, hall.id, hallName, mealType, dateStr);
      totalItems += result.items;
    } catch (err) {
      console.error(`  Error scraping ${hallName}/${mealType} for ${dateStr}:`, err.message);
    }
  }
  return totalItems;
}

async function scrapeForward(client, hall, hallName) {
  let dateStr = new Date().toISOString().split('T')[0];
  let consecutiveEmptyDays = 0;
  const MAX_EMPTY = 3;

  console.log(`  Scraping forward from ${dateStr}...`);

  while (consecutiveEmptyDays < MAX_EMPTY) {
    const items = await scrapeDateForHall(client, hall, hallName, dateStr);
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
  const specificDate = process.argv[2];

  const client = await pool.connect();
  try {
    const hallsResult = await client.query('SELECT id, name FROM dining_halls');

    for (const hall of hallsResult.rows) {
      const hallName = DINING_HALL_NAMES[hall.name];
      if (!hallName) {
        console.log(`Skipping ${hall.name}: no Villanova name configured`);
        continue;
      }

      console.log(`\n${hall.name} (${hallName}):`);

      if (specificDate) {
        await scrapeDateForHall(client, hall, hallName, specificDate);
      } else {
        await scrapeForward(client, hall, hallName);
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