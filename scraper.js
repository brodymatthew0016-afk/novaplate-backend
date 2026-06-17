/**
 * NovaPlate — Database Scraper (v9 — Nutrislice edition)
 * Pulls menu + nutrition data from Villanova's Nutrislice site:
 *   https://villanovauniversity.nutrislice.com/menu/<hall-slug>/<meal-slug>/<YYYY-MM-DD>
 * via its underlying JSON API:
 *   https://villanovauniversity.api.nutrislice.com/menu/api/weeks/school/<hall-slug>/menu-type/<meal-slug>/<YYYY>/<MM>/<DD>/
 *
 * Replaces the old webapps.villanova.edu scraper entirely. No LLM enrichment —
 * everything (name, calories, macros, serving size, ingredients) comes straight
 * from the Nutrislice response.
 *
 * Run:
 *   node scraper.js              ← scrapes today + writes menu_dump_YYYY-MM-DD.xlsx
 *   node scraper.js 2026-02-23   ← scrapes specific date
 *   node scraper.js --analyze    ← scrapes last 35 days, writes menu_analysis.xlsx
 *                                   (does NOT insert into DB)
 *
 * Debugging:
 *   DEBUG_FIELDS=1 node scraper.js   ← logs the raw shape of the first menu_item
 *                                       and first food object seen, so field-name
 *                                       mismatches are easy to spot and fix.
 *
 * IMPORTANT — verify before relying on this in production:
 * Nutrislice's exact JSON field names vary slightly between deployments/versions.
 * This scraper defensively tries several known field-name variants (see
 * `pickNutrition` / `pickField` below), but it has NOT been verified against a
 * live response from villanovauniversity.api.nutrislice.com (that host isn't
 * reachable from this environment). Run with DEBUG_FIELDS=1 on the first run
 * and check the console output against what actually comes back — if any
 * values look wrong/missing, send me that debug output and I'll adjust the
 * field mappings in one pass.
 */

require('dotenv').config();
const https = require('https');
const { Pool } = require('pg');
const XLSX = require('xlsx');

const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
  ssl: { rejectUnauthorized: false },
});

// ─── DINING HALL CONFIG ───────────────────────────────────────────────────────
//
// `slug` = the path segment Nutrislice uses, e.g.
//   https://villanovauniversity.nutrislice.com/menu/dougherty-hall/dinner/2026-06-17
//                                                     ^^^^^^^^^^^^^ this is the slug
//
// Confirmed from the URL you gave me: 'dougherty-hall'.
// Donahue + St. Mary's slugs below are my best guess based on Nutrislice's usual
// "<name>-hall" pattern and Villanova's own naming — PLEASE VERIFY by visiting
// https://villanovauniversity.nutrislice.com and checking the dropdown / URL for
// each hall, then fix here if needed. Easiest way: open the site, click each hall,
// and copy whatever appears after /menu/ in the address bar.

const DINING_HALLS = [
  { slug: 'dougherty-hall', dbId: 2, name: 'Dougherty Hall' },
  { slug: 'donahue-hall',   dbId: 1, name: 'Donahue Court'  }, // GUESS — verify
  { slug: 'st-marys-hall',  dbId: 3, name: 'St. Marys Hall' }, // GUESS — verify
];

// Nutrislice "menu-type" slugs. These are usually just lowercase meal names,
// confirmed for dinner via your URL. Breakfast/lunch follow the same pattern
// on virtually every Nutrislice deployment, but verify if either comes back empty.
const MEALS = [
  { slug: 'breakfast', label: 'Breakfast' },
  { slug: 'lunch',     label: 'Lunch'     },
  { slug: 'dinner',    label: 'Dinner'    },
];

const NUTRISLICE_HOST = 'villanovauniversity.api.nutrislice.com';

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

function getLastNDates(n) {
  const dates = [];
  const today = new Date(new Date().toLocaleString('en-US', { timeZone: 'America/New_York' }));
  for (let i = n; i >= 0; i--) {
    const d = new Date(today);
    d.setDate(d.getDate() - i);
    const y = d.getFullYear();
    const m = String(d.getMonth() + 1).padStart(2, '0');
    const day = String(d.getDate()).padStart(2, '0');
    dates.push(`${y}-${m}-${day}`);
  }
  return dates;
}

// ─── HTTP HELPER ──────────────────────────────────────────────────────────────

function getJSON(path) {
  return new Promise((resolve, reject) => {
    const options = {
      hostname: NUTRISLICE_HOST,
      path,
      method: 'GET',
      headers: {
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36',
        'Accept': 'application/json',
      },
    };
    const req = https.request(options, res => {
      let data = '';
      res.on('data', chunk => data += chunk);
      res.on('end', () => {
        if (res.statusCode < 200 || res.statusCode >= 300) {
          return reject(new Error(`HTTP ${res.statusCode} for ${path}`));
        }
        try {
          resolve(JSON.parse(data));
        } catch (err) {
          reject(new Error(`JSON parse failed for ${path}: ${err.message}`));
        }
      });
    });
    req.on('error', reject);
    req.end();
  });
}

/**
 * Builds the Nutrislice weekly-menu API path for a given hall/meal/date.
 * Nutrislice always returns the *whole week* containing the requested date —
 * we filter down to the single day we want after fetching.
 */
function weekApiPath(hallSlug, mealSlug, dateStr) {
  const [y, m, d] = dateStr.split('-');
  return `/menu/api/weeks/school/${hallSlug}/menu-type/${mealSlug}/${y}/${m}/${d}/`;
}

// ─── FIELD EXTRACTION HELPERS ──────────────────────────────────────────────────
//
// Nutrislice nutrition fields have been observed under a few different key
// names depending on deployment/version. We try each in order and take the
// first defined value. If DEBUG_FIELDS=1, we log the raw keys we saw so any
// missing mapping is obvious and easy to add.

function pickField(obj, candidates, fallback = null) {
  if (!obj) return fallback;
  for (const key of candidates) {
    if (obj[key] !== undefined && obj[key] !== null && obj[key] !== '') {
      return obj[key];
    }
  }
  return fallback;
}

function pickNutrition(food) {
  // Most Nutrislice deployments nest nutrition under `rounded_nutrition_info`
  // (preferred — pre-rounded for display) and fall back to `nutrition_info`.
  const nutrition = food.rounded_nutrition_info || food.nutrition_info || food;

  return {
    calories: round(pickField(nutrition, ['calories', 'g_calories'], 0)),
    protein:  round(pickField(nutrition, ['g_protein', 'protein'], 0)),
    carbs:    round(pickField(nutrition, ['g_carbs', 'g_carbohydrate', 'carbohydrate', 'carbs'], 0)),
    fat:      round(pickField(nutrition, ['g_fat', 'fat'], 0)),
  };
}

function round(val) {
  const n = parseFloat(val);
  return Number.isFinite(n) ? Math.round(n) : 0;
}

function servingSize(food) {
  const amount = pickField(food, ['serving_size_amount']);
  const unit   = pickField(food, ['serving_size_unit', 'serving_size']);
  if (amount && unit) return `${amount} ${unit}`;
  if (unit) return String(unit);
  return null;
}

function extractIngredients(food) {
  // Observed as a plain string field on the food object in most deployments.
  const raw = pickField(food, ['ingredients']);
  if (!raw) return null;
  return String(raw).replace(/\s+/g, ' ').trim();
}

/**
 * Pulls a station/category label for a menu item. Nutrislice groups items
 * within a day's menu_items array using a station/section reference — the
 * exact field varies (`food.category_name`, item-level `station_name` /
 * `menu_section`, or a separate `stations`/`sections` array keyed by id).
 * This tries the common flat fields; if your response groups stations
 * differently (e.g. a parallel `days[].menu_items` entries with
 * `is_section_title: true` headers), run with DEBUG_FIELDS=1 and send me
 * the structure so I can adjust this function specifically.
 */
function extractStation(item, food) {
  return pickField(item, ['station_name', 'menu_section', 'section_name'])
      || pickField(food, ['category_name', 'food_category'])
      || 'Other';
}

// ─── PARSE ONE DAY'S MENU ITEMS FROM A WEEK RESPONSE ──────────────────────────

function findDayInWeek(weekResponse, dateStr) {
  const days = weekResponse?.days || [];
  return days.find(d => d.date === dateStr) || null;
}

function parseMenuItems(day, debugLabel) {
  const rawItems = day?.menu_items || [];

  if (process.env.DEBUG_FIELDS && rawItems.length > 0) {
    const firstWithFood = rawItems.find(i => i.food) || rawItems[0];
    console.log(`      🔑 [${debugLabel}] raw menu_item keys:`, Object.keys(firstWithFood).join(', '));
    if (firstWithFood.food) {
      console.log(`      🔑 [${debugLabel}] raw food keys:`, Object.keys(firstWithFood.food).join(', '));
      const nutrObj = firstWithFood.food.rounded_nutrition_info || firstWithFood.food.nutrition_info;
      if (nutrObj) {
        console.log(`      🔑 [${debugLabel}] raw nutrition keys:`, Object.keys(nutrObj).join(', '));
      }
    }
  }

  const items = [];
  for (const item of rawItems) {
    const food = item.food;
    // Section headers / text-only rows have no `food` object — skip them.
    if (!food || !food.name) continue;
    if (food.name.length < 2) continue;

    const { calories, protein, carbs, fat } = pickNutrition(food);

    items.push({
      name:         food.name,
      station:      extractStation(item, food),
      calories,
      protein,
      carbs,
      fat,
      serving_size: servingSize(food),
      ingredients:  extractIngredients(food),
    });
  }
  return items;
}

// ─── SCRAPE ONE MEAL (ONE HALL, ONE MEAL TYPE, ONE DATE) ──────────────────────

async function scrapeMeal(hallSlug, meal, dateStr) {
  console.log(`    🔄 ${hallSlug} — ${meal.label} — ${dateStr}`);

  let weekResponse;
  try {
    weekResponse = await getJSON(weekApiPath(hallSlug, meal.slug, dateStr));
  } catch (err) {
    console.log(`      ⚠️  Failed to fetch/parse: ${err.message}`);
    return [];
  }

  const day = findDayInWeek(weekResponse, dateStr);
  if (!day) {
    console.log(`      ⚠️  No day entry found for ${dateStr} in week response`);
    return [];
  }

  const items = parseMenuItems(day, `${hallSlug}/${meal.slug}`);
  console.log(`      📋 ${items.length} items found`);
  return items;
}

// ─── INSERT INTO DATABASE ─────────────────────────────────────────────────────

async function insertItem(client, dbHallId, item, mealType, dbDate) {
  // NOTE: schema needs `ingredients` and `category`/`sub_station` columns.
  // If they don't exist yet, run:
  //   ALTER TABLE menu_items ADD COLUMN IF NOT EXISTS ingredients TEXT;
  await client.query(
    `INSERT INTO menu_items
     (dining_hall_id, name, calories, protein, carbs, fat, meal_type, date,
      is_static, category, sub_station, serving_size, ingredients)
     VALUES ($1, $2, $3, $4, $5, $6, $7, $8, false, $9, $10, $11, $12)
     ON CONFLICT (dining_hall_id, name, meal_type, date) DO UPDATE SET
       calories     = EXCLUDED.calories,
       protein      = EXCLUDED.protein,
       carbs        = EXCLUDED.carbs,
       fat          = EXCLUDED.fat,
       serving_size = EXCLUDED.serving_size,
       category     = COALESCE(EXCLUDED.category,     menu_items.category),
       sub_station  = COALESCE(EXCLUDED.sub_station,  menu_items.sub_station),
       ingredients  = COALESCE(EXCLUDED.ingredients,  menu_items.ingredients)`,
    [dbHallId, item.name, item.calories, item.protein, item.carbs, item.fat,
     mealType, dbDate,
     item.category    || null,
     item.sub_station || null,
     item.serving_size || null,
     item.ingredients  || null]
  );
}

// ─── SCRAPE ONE DAY (normal mode) ─────────────────────────────────────────────

async function scrapeDay(client, dateStr, ITEM_CATEGORIES) {
  console.log(`\n📅 Scraping ${dateStr}`);

  const wb = XLSX.utils.book_new();

  for (const hall of DINING_HALLS) {
    console.log(`\n🏫 ${hall.name}`);

    await client.query(
      'DELETE FROM menu_items WHERE dining_hall_id = $1 AND date = $2 AND is_static = FALSE',
      [hall.dbId, dateStr]
    );

    const allItemsForDump = [];

    for (const meal of MEALS) {
      const rawItems = await scrapeMeal(hall.slug, meal, dateStr);
      allItemsForDump.push(...rawItems.map(item => ({ ...item, _meal: meal.label })));

      const filteredItems = rawItems.filter(item =>
        !BLOCKLIST.some(b => b.toLowerCase() === item.name.toLowerCase())
      );

      let inserted = 0;
      for (const item of filteredItems) {
        // `station` from Nutrislice becomes the default category;
        // manual overrides from item_categories still take priority.
        let finalItem = { ...item, category: item.station, sub_station: null };
        const override = ITEM_CATEGORIES[finalItem.name];
        if (override) {
          if (override.category)    finalItem.category    = override.category;
          if (override.sub_station) finalItem.sub_station = override.sub_station;
        }
        await insertItem(client, hall.dbId, finalItem, meal.label, dateStr);
        inserted++;
      }

      console.log(`      ✅ ${meal.label}: ${inserted} inserted`);
      await new Promise(r => setTimeout(r, 200));
    }

    if (allItemsForDump.length > 0) {
      const ws = XLSX.utils.json_to_sheet(allItemsForDump);
      XLSX.utils.book_append_sheet(wb, ws, hall.name.slice(0, 31));
    }
  }

  const filename = `menu_dump_${dateStr}.xlsx`;
  XLSX.writeFile(wb, filename);
  console.log(`\n📊 Raw dump saved: ${filename}`);
}

// ─── ANALYZE MODE — scrape last 35 days, write unique items to Excel ──────────

async function analyzeMode() {
  const dates = getLastNDates(35);
  console.log(`\n🔍 Analyze mode — scraping ${dates.length} days (no DB writes)\n`);

  const seen = new Map(); // itemName.lower -> first seen record

  for (const dateStr of dates) {
    console.log(`\n📅 ${dateStr}`);

    for (const hall of DINING_HALLS) {
      for (const meal of MEALS) {
        const items = await scrapeMeal(hall.slug, meal, dateStr);

        for (const item of items) {
          const key = item.name.toLowerCase().trim();
          if (!seen.has(key)) {
            seen.set(key, {
              itemName:    item.name,
              station:     item.station,
              calories:    item.calories,
              protein:     item.protein,
              carbs:       item.carbs,
              fat:         item.fat,
              servingSize: item.serving_size || '',
              ingredients: item.ingredients || '',
              firstDate:   dateStr,
              firstHall:   hall.name,
              firstMeal:   meal.label,
            });
          }
        }
        await new Promise(r => setTimeout(r, 150));
      }
    }
  }

  const allItems = Array.from(seen.values())
    .sort((a, b) => b.calories - a.calories);

  console.log(`\n📊 Total unique items found: ${allItems.length}`);

  const wb = XLSX.utils.book_new();
  const ws = XLSX.utils.json_to_sheet(allItems);

  const colWidths = Object.keys(allItems[0] || {}).map(key => ({
    wch: Math.max(key.length, ...allItems.map(r => String(r[key] || '').length))
  }));
  ws['!cols'] = colWidths;

  XLSX.utils.book_append_sheet(wb, ws, 'Unique Items');
  XLSX.writeFile(wb, 'menu_analysis.xlsx');
  console.log(`✅ Saved: menu_analysis.xlsx\n`);
}

// ─── MAIN ─────────────────────────────────────────────────────────────────────

async function main() {
  const arg = process.argv[2];

  if (arg === '--analyze') {
    try {
      await analyzeMode();
    } catch (err) {
      console.error('❌ Fatal error:', err);
    } finally {
      await pool.end();
    }
    return;
  }

  const dateStr = arg || getTodayEST();
  const client  = await pool.connect();

  console.log(`\n📅 Scraping menus for ${dateStr}\n`);

  try {
    const { rows: categoryRows } = await client.query(
      'SELECT name, category, sub_station FROM item_categories'
    );
    const ITEM_CATEGORIES = Object.fromEntries(categoryRows.map(r => [r.name, r]));
    console.log(`📂 Loaded ${categoryRows.length} category overrides`);

    await scrapeDay(client, dateStr, ITEM_CATEGORIES);

    console.log(`\n✅ Done`);
  } catch (err) {
    console.error('❌ Fatal error:', err);
  } finally {
    client.release();
    await pool.end();
  }
}

main();