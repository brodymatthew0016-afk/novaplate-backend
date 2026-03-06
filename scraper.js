/**
 * NovaPlate — Database Scraper (v9)
 * Uses direct POST requests to webapps.villanova.edu (JSON API)
 * v8: Fetches ingredients via JSON API.
 * v9: Batch LLM estimation of est_calories/protein/carbs/fat/serving_size via Groq.
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


// ─── GROQ BATCH ESTIMATOR ────────────────────────────────────────────────────
//
// Sends all items for a meal in one API call.
// Returns a map of itemName (lowercase) -> { est_calories, est_protein, est_carbs, est_fat, est_serving_size }

const GROQ_CHUNK_SIZE = 20; // max items per Groq call to stay within token limits

function groqRequest(apiKey, body) {
  return new Promise((resolve) => {
    const options = {
      hostname: 'api.groq.com',
      path: '/openai/v1/chat/completions',
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${apiKey}`,
        'Content-Length': Buffer.byteLength(body),
      },
    };
    const req = https.request(options, res => {
      let data = '';
      res.on('data', chunk => data += chunk);
      res.on('end', () => resolve(data));
    });
    req.on('error', err => resolve(JSON.stringify({ _reqError: err.message })));
    req.write(body);
    req.end();
  });
}

function parseRetryAfterMs(errorMessage) {
  // Groq error messages say things like "Please try again in 4.06s" or "310ms"
  const secMatch  = errorMessage.match(/try again in ([\d.]+)s/);
  const msMatch   = errorMessage.match(/try again in ([\d.]+)ms/);
  const minMatch  = errorMessage.match(/try again in ([\d.]+)m([\d.]+)s/);
  if (minMatch)  return (parseFloat(minMatch[1]) * 60 + parseFloat(minMatch[2])) * 1000 + 500;
  if (secMatch)  return parseFloat(secMatch[1]) * 1000 + 500;
  if (msMatch)   return parseFloat(msMatch[1]) + 500;
  return 10000; // default 10s
}

async function estimateNutritionChunk(items, apiKey) {
  console.log('🧪 Sample ingredients being sent to Groq:', JSON.stringify(items.slice(0, 3).map(i => ({ name: i.name, ingredients: i.ingredients })), null, 2));

  const itemLines = items.map((item, i) =>
    `${i + 1}. Name: "${item.name}" | Ingredients: ${item.ingredients || 'unknown'}`
  ).join('\n');

  const prompt = `You are a nutrition expert. For each dining hall food item below, estimate the nutrition for a TYPICAL single dining hall serving portion.

Items:
${itemLines}

Respond ONLY with a JSON array — no explanation, no markdown, no code fences. Each element must have exactly these keys:
- "name": the exact item name as given
- "est_calories": integer
- "est_protein": integer (grams)
- "est_carbs": integer (grams)
- "est_fat": integer (grams)
- "est_serving_size": string (e.g. "1 cup", "6 oz", "1 slice")

Base estimates on the ingredients provided and typical dining hall portion sizes.`;

  const body = JSON.stringify({
    model: 'llama-3.1-8b-instant',
    max_tokens: 8192,
    temperature: 0.1,
    messages: [{ role: 'user', content: prompt }],
  });

  const MAX_RETRIES = 5;
  for (let attempt = 1; attempt <= MAX_RETRIES; attempt++) {
    const data = await groqRequest(apiKey, body);
    try {
      const json = JSON.parse(data);

      // Handle rate limit errors by waiting and retrying
      if (json.error) {
        const waitMs = parseRetryAfterMs(json.error.message || '');
        console.log(`      ⏳ Rate limited — waiting ${(waitMs/1000).toFixed(1)}s then retrying (attempt ${attempt}/${MAX_RETRIES})...`);
        await new Promise(r => setTimeout(r, waitMs));
        continue;
      }

      const text = json.choices?.[0]?.message?.content || '';
      const clean = text.replace(/```json|```/gi, '').trim();
      const arr = JSON.parse(clean);
      const map = {};
      for (const entry of arr) {
        map[entry.name.toLowerCase().trim()] = {
          est_calories:     Math.round(entry.est_calories     || 0),
          est_protein:      Math.round(entry.est_protein      || 0),
          est_carbs:        Math.round(entry.est_carbs        || 0),
          est_fat:          Math.round(entry.est_fat          || 0),
          est_serving_size: entry.est_serving_size            || null,
        };
      }
      return map;
    } catch (err) {
      console.log(`      ⚠️  Groq parse error (attempt ${attempt}): ${err.message}`);
      if (attempt < MAX_RETRIES) await new Promise(r => setTimeout(r, 5000));
    }
  }

  console.log(`      ⚠️  Chunk failed after ${MAX_RETRIES} attempts — skipping`);
  return {};
}

async function estimateNutritionBatch(items) {
  const apiKey = process.env.GROQ_API_KEY;
  if (!apiKey) {
    console.log('      ⚠️  GROQ_API_KEY not set — skipping LLM estimates');
    return {};
  }

  // Split into chunks to avoid token limit
  const chunks = [];
  for (let i = 0; i < items.length; i += GROQ_CHUNK_SIZE) {
    chunks.push(items.slice(i, i + GROQ_CHUNK_SIZE));
  }

  console.log(`      🤖 Sending ${chunks.length} chunk(s) of up to ${GROQ_CHUNK_SIZE} items to Groq...`);

  // Run chunks sequentially to avoid Groq rate limits
  const results = [];
  for (let i = 0; i < chunks.length; i++) {
    const result = await estimateNutritionChunk(chunks[i], apiKey);
    results.push(result);
    if (i < chunks.length - 1) await new Promise(r => setTimeout(r, 500));
  }

  // Merge all chunk maps into one
  return Object.assign({}, ...results);
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
        };
      })
  );

  console.log(`      📋 ${items.length} items found`);
  return { items, raw: rawItems.map(r => ({ ...r, _meal: mealValue })) };
}

// ─── INSERT INTO DATABASE ─────────────────────────────────────────────────────

async function insertItem(client, dbHallId, item, mealType, dbDate) {
  await client.query(
    `INSERT INTO menu_items 
     (dining_hall_id, name, calories, protein, carbs, fat, meal_type, date,
      is_static, category, sub_station, serving_size, ingredients,
      est_calories, est_protein, est_carbs, est_fat, est_serving_size)
     VALUES ($1, $2, $3, $4, $5, $6, $7, $8, false, $9, $10, $11, $12, $13, $14, $15, $16, $17)
     ON CONFLICT (dining_hall_id, name, meal_type, date) DO UPDATE SET
       calories         = EXCLUDED.calories,
       protein          = EXCLUDED.protein,
       carbs            = EXCLUDED.carbs,
       fat              = EXCLUDED.fat,
       serving_size     = EXCLUDED.serving_size,
       category         = COALESCE(EXCLUDED.category,         menu_items.category),
       sub_station      = COALESCE(EXCLUDED.sub_station,      menu_items.sub_station),
       ingredients      = COALESCE(EXCLUDED.ingredients,      menu_items.ingredients),
       est_calories     = COALESCE(EXCLUDED.est_calories,     menu_items.est_calories),
       est_protein      = COALESCE(EXCLUDED.est_protein,      menu_items.est_protein),
       est_carbs        = COALESCE(EXCLUDED.est_carbs,        menu_items.est_carbs),
       est_fat          = COALESCE(EXCLUDED.est_fat,          menu_items.est_fat),
       est_serving_size = COALESCE(EXCLUDED.est_serving_size, menu_items.est_serving_size)`,
    [dbHallId, item.name, item.calories, item.protein, item.carbs, item.fat,
     mealType, dbDate,
     item.category         || null,
     item.sub_station      || null,
     item.serving_size     || null,
     item.ingredients      || null,
     item.est_calories     ?? null,
     item.est_protein      ?? null,
     item.est_carbs        ?? null,
     item.est_fat          ?? null,
     item.est_serving_size || null]
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

      // Batch LLM estimation for all items in this meal
      console.log(`      🤖 Estimating nutrition for ${rawItems.length} items...`);
      const estimates = await estimateNutritionBatch(rawItems);

      // Merge LLM estimates into items
      const enrichedItems = rawItems.map(item => ({
        ...item,
        ...(estimates[item.name.toLowerCase().trim()] || {}),
      }));

      // Push enriched items (includes ingredients + est_ fields) for the Excel dump
      allEnrichedItems.push(...enrichedItems.map(item => ({ ...item, _meal: meal })));

      const filteredItems = enrichedItems.filter(item =>
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
      const EXCEL_COLS = [
        '_meal', 'name', 'course',
        'serving_size', 'calories', 'protein', 'carbs', 'fat',
        'est_serving_size', 'est_calories', 'est_protein', 'est_carbs', 'est_fat',
        'ingredients',
      ];
      const cleanItems = allEnrichedItems.map(item => {
        const row = {};
        for (const col of EXCEL_COLS) row[col] = item[col] ?? null;
        return row;
      });
      const ws = XLSX.utils.json_to_sheet(cleanItems, { header: EXCEL_COLS });
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