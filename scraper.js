/**
 * NovaPlate — Database Scraper (v5)
 * Uses direct POST requests to webapps.villanova.edu (JSON API)
 * Nutrition enriched via Groq LLM (batch mode), cached in nutrition_cache table.
 *
 * Run:
 *   node scraper.js              ← scrapes today
 *   node scraper.js 2026-02-23   ← scrapes specific date (YYYY-MM-DD)
 *
 * First-time DB setup (run once in your DB):
 *   CREATE TABLE nutrition_cache (
 *     normalized_name TEXT PRIMARY KEY,
 *     calories        INT,
 *     protein         INT,
 *     carbs           INT,
 *     fat             INT,
 *     serving_size    TEXT,
 *     created_at      TIMESTAMPTZ DEFAULT NOW()
 *   );
 */

require('dotenv').config();
const https = require('https');
const { Pool } = require('pg');
const { enrichItems, loadNutritionCache } = require('./nutritionEnricher');

const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
  ssl: { rejectUnauthorized: false },
});

// ─── DINING HALL CONFIG ───────────────────────────────────────────────────────

const DINING_HALLS = [
  { siteValue: 'ST MARYS HALL',  dbId: 3, name: 'St. Marys Hall'  },
  { siteValue: 'DOUGHERTY HALL', dbId: 2, name: 'Dougherty Hall'  },
  { siteValue: 'DONAHUE COURT',  dbId: 1, name: 'Donahue Court'   },
];

const MEALS = ['Breakfast', 'Lunch', 'Dinner'];

// ─── BLOCKLIST ────────────────────────────────────────────────────────────────

const BLOCKLIST = [
  'Assorted  Cereal',
  'Assorted Cereal',
];

// ─── DATE HELPERS ─────────────────────────────────────────────────────────────

function getTodayEST() {
  const est = new Date(new Date().toLocaleString('en-US', { timeZone: 'America/New_York' }));
  const y = est.getFullYear();
  const m = String(est.getMonth() + 1).padStart(2, '0');
  const d = String(est.getDate()).padStart(2, '0');
  return `${y}-${m}-${d}`;
}

function toSiteDate(dateStr) {
  const [y, m, d] = dateStr.split('-');
  return `${m}/${d}/${y}`;
}

// ─── HTTP HELPER ──────────────────────────────────────────────────────────────

function postForm(path, fields) {
  return new Promise((resolve, reject) => {
    const body = new URLSearchParams(fields).toString();
    const options = {
      hostname: 'webapps.villanova.edu',
      path,
      method: 'POST',
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Content-Length': Buffer.byteLength(body),
        'User-Agent': 'Mozilla/5.0',
      },
    };
    const req = https.request(options, res => {
      let data = '';
      res.on('data', chunk => data += chunk);
      res.on('end', () => resolve(data));
    });
    req.on('error', reject);
    req.write(body);
    req.end();
  });
}

// ─── SCRAPE ONE MEAL ──────────────────────────────────────────────────────────

async function scrapeMeal(hallValue, mealValue, siteDate) {
  console.log(`    🔄 ${hallValue} — ${mealValue} — ${siteDate}`);

  const raw = await postForm('/dininghallmenu/form_confirmation_proxy.jsp?template=no', {
    command: 'Menu',
    hall: hallValue,
    date: siteDate,
    meal: mealValue,
  });

  let parsed;
  try {
    parsed = JSON.parse(raw.trim());
  } catch {
    console.log(`      ⚠️  Failed to parse response`);
    return [];
  }

  const items = (parsed.menu || [])
    .map(item => ({
      name:     item.itemName,
      course:   item.course || 'Other',
      calories: Math.round(item.calories      || 0),
      protein:  Math.round(item.protein       || 0),
      carbs:    Math.round(item.carbohydrate  || 0),
      fat:      Math.round(item.fat           || 0),
    }))
    .filter(item => item.name && item.name.length >= 2);

  console.log(`      📋 ${items.length} items found`);
  return items;
}

// ─── INSERT INTO DATABASE ─────────────────────────────────────────────────────

async function insertItem(client, dbHallId, item, mealType, dbDate) {
  await client.query(
    `INSERT INTO menu_items 
     (dining_hall_id, name, calories, protein, carbs, fat, meal_type, date, is_static, category, sub_station, serving_size)
     VALUES ($1, $2, $3, $4, $5, $6, $7, $8, false, $9, $10, $11)
     ON CONFLICT (dining_hall_id, name, meal_type, date) DO UPDATE SET
       calories     = EXCLUDED.calories,
       protein      = EXCLUDED.protein,
       carbs        = EXCLUDED.carbs,
       fat          = EXCLUDED.fat,
       serving_size = EXCLUDED.serving_size,
       category     = COALESCE(EXCLUDED.category, menu_items.category),
       sub_station  = COALESCE(EXCLUDED.sub_station, menu_items.sub_station)`,
    [dbHallId, item.name, item.calories, item.protein, item.carbs, item.fat,
     mealType, dbDate, item.category || null, item.sub_station || null, item.serving_size || null]
  );
}

// ─── MAIN ─────────────────────────────────────────────────────────────────────

async function main() {
  const dateStr  = process.argv[2] || getTodayEST();
  const siteDate = toSiteDate(dateStr);
  const client   = await pool.connect();

  console.log(`\n📅 Scraping menus for ${dateStr} (site format: ${siteDate})\n`);

  try {
    // Load category overrides from DB
    const { rows: categoryRows } = await client.query(
      'SELECT name, category, sub_station FROM item_categories'
    );
    const ITEM_CATEGORIES = Object.fromEntries(categoryRows.map(r => [r.name, r]));
    console.log(`📂 Loaded ${categoryRows.length} category overrides`);

    // Load nutrition cache from DB
    const nutritionCache = await loadNutritionCache(client);
    console.log(`🧠 Loaded ${Object.keys(nutritionCache).length} cached nutrition entries\n`);

    for (const hall of DINING_HALLS) {
      console.log(`\n🏫 ${hall.name}`);

      // Clear today's scraped items for this hall
      await client.query(
        'DELETE FROM menu_items WHERE dining_hall_id = $1 AND date = $2 AND is_static = FALSE',
        [hall.dbId, dateStr]
      );

      for (const meal of MEALS) {
        const rawItems = await scrapeMeal(hall.siteValue, meal, siteDate);

        // Filter blocklist
        const filteredItems = rawItems.filter(item =>
          !BLOCKLIST.some(b => b.toLowerCase() === item.name.toLowerCase())
        );

        // Enrich all items in one Groq batch call (cache hits are free)
        const enrichedItems = await enrichItems(client, filteredItems, nutritionCache);

        let inserted = 0;
        for (const item of enrichedItems) {
          let finalItem = { ...item, category: item.course };

          // item_categories overrides take priority
          const override = ITEM_CATEGORIES[finalItem.name];
          if (override) {
            if (override.category)    finalItem.category    = override.category;
            if (override.sub_station) finalItem.sub_station = override.sub_station;
          }

          await insertItem(client, hall.dbId, finalItem, meal, dateStr);
          inserted++;
        }

        console.log(`      ✅ ${meal}: ${inserted} inserted`);
        await new Promise(r => setTimeout(r, 300));
      }
    }

    console.log(`\n✅ Done — all menus inserted for ${dateStr}`);

  } catch (err) {
    console.error('❌ Fatal error:', err);
  } finally {
    client.release();
    await pool.end();
  }
}

main();