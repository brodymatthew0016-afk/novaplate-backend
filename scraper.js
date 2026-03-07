/**
 * NovaPlate — Database Scraper (v8)
 * Uses direct POST requests to webapps.villanova.edu (JSON API)
 * All nutrition data comes directly from the scrape — no LLM enrichment.
 * v8: Now fetches ingredients from the per-item nutrition page.
 *
 * Run:
 *   node scraper.js              ← scrapes today + writes menu_dump_YYYY-MM-DD.xlsx
 *   node scraper.js 2026-02-23   ← scrapes specific date
 *   node scraper.js --analyze    ← scrapes last 35 days, writes menu_analysis.xlsx
 *                                   (does NOT insert into DB)
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

// ─── HTTP HELPERS ─────────────────────────────────────────────────────────────

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

function getPage(path) {
  return new Promise((resolve, reject) => {
    const options = {
      hostname: 'webapps.villanova.edu',
      path,
      method: 'GET',
      headers: { 'User-Agent': 'Mozilla/5.0' },
    };
    const req = https.request(options, res => {
      let data = '';
      res.on('data', chunk => data += chunk);
      res.on('end', () => resolve(data));
    });
    req.on('error', reject);
    req.end();
  });
}

// ─── INGREDIENTS FETCHER ──────────────────────────────────────────────────────
//
// The nutrition popup URL is:
//   webapps.villanova.edu/dininghallmenu/nutrition.htm?template=no&index=<N>
//
// The raw menu API response includes a field that maps to this index.
// Common field names seen in Villanova's API: `menuItemIndex`, `index`, `itemIndex`, `id`.
// We try them all and fall back to null if none are present.
//
// The HTML contains a paragraph like:
//   <p>Marinade Chix Slmn Paneer, Boneless Skinless Chicken Thighs</p>
// immediately after the <h2>Ingredients</h2> heading.

function extractItemIndex(rawItem) {
  // Try the most likely field names the API might use for the nutrition page index
  return rawItem.menuItemIndex
      ?? rawItem.itemIndex
      ?? rawItem.index
      ?? rawItem.menuIndex
      ?? rawItem.id
      ?? rawItem.itemId
      ?? null;
}

/**
 * Given a numeric index, fetches the nutrition page and returns the
 * ingredients string, or null if not found / on any error.
 */
async function fetchIngredients(id) {
  if (id === null || id === undefined) return null;

  try {
    const raw = await postForm('/dininghallmenu/form_confirmation_proxy.jsp?template=no', {
      command: 'Ingredients',
      id: id,
    });

    const parsed = JSON.parse(raw.trim());
    const arr = parsed.ingredients;
    if (!arr || !arr.length) return null;
    return arr.join(', ');
  } catch {
    return null;
  }
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
    return { items: [], raw: [] };
  }

  const rawItems = parsed.menu || [];

  // Log the first raw item's keys once so we can verify the index field name
  if (rawItems.length > 0 && process.env.DEBUG_FIELDS) {
    console.log('      🔑 Raw item keys:', Object.keys(rawItems[0]).join(', '));
  }

  const items = await Promise.all(
    rawItems
      .map(item => ({
        _raw:         item,
        name:         item.itemName,
        course:       item.course        || 'Other',
        calories:     Math.round(item.calories     || 0),
        protein:      Math.round(item.protein      || 0),
        carbs:        Math.round(item.carbohydrate || 0),
        fat:          Math.round(item.fat          || 0),
        serving_size: item.portion       || null,
      }))
      .filter(item => item.name && item.name.length >= 2)
      .map(async item => {
        const index = extractItemIndex(item._raw);
        const ingredients = await fetchIngredients(index);
        // small delay to be polite to the server
        await new Promise(r => setTimeout(r, 100));
        return {
          name:         item.name,
          course:       item.course,
          calories:     item.calories,
          protein:      item.protein,
          carbs:        item.carbs,
          fat:          item.fat,
          serving_size: item.serving_size,
          ingredients:  ingredients,
          _index:       extractItemIndex(item._raw),
        };
      })
  );

  console.log(`      📋 ${items.length} items found`);
  return { items, raw: rawItems.map(r => ({ ...r, _meal: mealValue })) };
}

// ─── INSERT INTO DATABASE ─────────────────────────────────────────────────────

async function insertItem(client, dbHallId, item, mealType, dbDate) {
  // NOTE: your schema will need an `ingredients` column.
  // If it doesn't exist yet, run:
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
  const siteDate = toSiteDate(dateStr);
  console.log(`\n📅 Scraping ${dateStr}`);

  const wb = XLSX.utils.book_new();

  for (const hall of DINING_HALLS) {
    console.log(`\n🏫 ${hall.name}`);

    await client.query(
      'DELETE FROM menu_items WHERE dining_hall_id = $1 AND date = $2 AND is_static = FALSE',
      [hall.dbId, dateStr]
    );

    const allEnrichedItems = [];

    for (const meal of MEALS) {
      const { items: rawItems, raw } = await scrapeMeal(hall.siteValue, meal, siteDate);
      // Push enriched items (includes ingredients) for the Excel dump
      allEnrichedItems.push(...rawItems.map(item => ({ ...item, _meal: meal })));

      const filteredItems = rawItems.filter(item =>
        !BLOCKLIST.some(b => b.toLowerCase() === item.name.toLowerCase())
      );

      let inserted = 0;
      for (const item of filteredItems) {
        let finalItem = { ...item, category: item.course };
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

    if (allEnrichedItems.length > 0) {
      const ws = XLSX.utils.json_to_sheet(allEnrichedItems);
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

  const seen  = new Map(); // itemName.lower -> first seen record

  for (const dateStr of dates) {
    const siteDate = toSiteDate(dateStr);
    console.log(`\n📅 ${dateStr}`);

    for (const hall of DINING_HALLS) {
      for (const meal of MEALS) {
        const { items, raw } = await scrapeMeal(hall.siteValue, meal, siteDate);

        // items now includes ingredients; raw still holds the full API payload
        for (let i = 0; i < raw.length; i++) {
          const item = raw[i];
          if (!item.itemName) continue;
          const key = item.itemName.toLowerCase().trim();
          if (!seen.has(key)) {
            // Find the matching enriched item (same name) to get ingredients
            const enriched = items.find(
              it => it.name.toLowerCase().trim() === key
            );
            seen.set(key, {
              itemName:      item.itemName,
              portion:       item.portion        || '',
              calories:      parseFloat(item.calories      || 0).toFixed(1),
              protein:       parseFloat(item.protein       || 0).toFixed(1),
              carbs:         parseFloat(item.carbohydrate  || 0).toFixed(1),
              fat:           parseFloat(item.fat           || 0).toFixed(1),
              saturatedFat:  parseFloat(item.saturatedFat  || 0).toFixed(1),
              sodium:        parseFloat(item.sodium        || 0).toFixed(1),
              fiber:         parseFloat(item.fiber         || 0).toFixed(1),
              course:        item.course         || '',
              allergens:     item.allergens      || '',
              vegan:         item.vegan          ? 'Yes' : 'No',
              vegetarian:    item.vegitarian      ? 'Yes' : 'No',
              ingredients:   enriched?.ingredients || '',   // ← NEW
              firstDate:     dateStr,
              firstHall:     hall.name,
              firstMeal:     meal,
            });
          }
        }
        await new Promise(r => setTimeout(r, 150));
      }
    }
  }

  const allItems = Array.from(seen.values())
    .sort((a, b) => parseFloat(b.calories) - parseFloat(a.calories));

  console.log(`\n📊 Total unique items found: ${allItems.length}`);

  const wb = XLSX.utils.book_new();
  const ws = XLSX.utils.json_to_sheet(allItems);

  // Auto-size columns
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
    // Analyze mode — no DB needed
    try {
      await analyzeMode();
    } catch (err) {
      console.error('❌ Fatal error:', err);
    } finally {
      await pool.end();
    }
    return;
  }

  // Normal scrape mode
  const dateStr = arg || getTodayEST();
  const client  = await pool.connect();

  console.log(`\n📅 Scraping menus for ${dateStr} (site format: ${toSiteDate(dateStr)})\n`);

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