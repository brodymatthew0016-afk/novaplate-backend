/**
 * NovaPlate — LLM Nutrition Enricher (Batch Mode)
 * Sends all new menu items in a single Groq request per meal.
 * Caches results in `nutrition_cache` so repeat items are never re-estimated.
 *
 * Setup: Add GROQ_API_KEY to your .env — free at https://console.groq.com
 *
 * DB Migration (run once):
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

const https = require('https');

const GROQ_MODEL = 'llama-3.1-8b-instant';

// ─── NAME KEY ─────────────────────────────────────────────────────────────────

function cacheKey(name) {
  return name.toLowerCase().trim();
}

// ─── GROQ API CALL ────────────────────────────────────────────────────────────

function callGroq(prompt, maxTokens = 2000) {
  return new Promise((resolve, reject) => {
    const body = JSON.stringify({
      model: GROQ_MODEL,
      max_tokens: maxTokens,
      messages: [{ role: 'user', content: prompt }],
    });

    const options = {
      hostname: 'api.groq.com',
      path: '/openai/v1/chat/completions',
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${process.env.GROQ_API_KEY}`,
        'Content-Length': Buffer.byteLength(body),
      },
    };

    const req = https.request(options, res => {
      let data = '';
      res.on('data', chunk => (data += chunk));
      res.on('end', () => {
        try {
          const parsed = JSON.parse(data);
          const text = parsed.choices?.[0]?.message?.content || '';
          resolve(text);
        } catch (err) {
          reject(new Error(`Groq parse error: ${err.message}`));
        }
      });
    });

    req.on('error', reject);
    req.write(body);
    req.end();
  });
}

// ─── BATCH ESTIMATE ───────────────────────────────────────────────────────────
// Takes an array of item names, returns a map of { name -> nutrition }

async function batchEstimate(itemNames) {
  const list = itemNames.map((name, i) => `${i + 1}. ${name}`).join('\n');

  const prompt = `You are a nutrition database. Estimate nutrition for each dining hall food item below for a single standard serving.

${list}

Respond with ONLY a JSON array in the same order, no explanation, no markdown:
[
  { "name": "<exact item name>", "serving_size": "<e.g. '1 cup', '4 oz'>", "calories": <int>, "protein": <int>, "carbs": <int>, "fat": <int> },
  ...
]`;

  const raw = await callGroq(prompt, Math.max(2000, itemNames.length * 60));
  const cleaned = raw.replace(/```json|```/g, '').trim();

  let results;
  try {
    results = JSON.parse(cleaned);
  } catch {
    throw new Error(`Failed to parse batch response: ${raw.slice(0, 200)}`);
  }

  if (!Array.isArray(results) || results.length !== itemNames.length) {
    throw new Error(`Expected ${itemNames.length} results, got ${results?.length}`);
  }

  // Build name -> nutrition map
  const map = {};
  for (const r of results) {
    if (!r.name || !r.calories || r.calories < 5 || r.calories > 2000) continue;
    map[cacheKey(r.name)] = {
      serving_size: r.serving_size || '1 serving',
      calories: Math.round(r.calories),
      protein:  Math.round(r.protein  || 0),
      carbs:    Math.round(r.carbs    || 0),
      fat:      Math.round(r.fat      || 0),
    };
  }
  return map;
}

// ─── CACHE LOAD ───────────────────────────────────────────────────────────────

async function loadNutritionCache(client) {
  const { rows } = await client.query(
    'SELECT normalized_name, calories, protein, carbs, fat, serving_size FROM nutrition_cache'
  );
  return Object.fromEntries(rows.map(r => [r.normalized_name, r]));
}

// ─── CACHE SAVE ───────────────────────────────────────────────────────────────

async function saveManyToCache(client, nutritionMap) {
  for (const [key, nutrition] of Object.entries(nutritionMap)) {
    await client.query(
      `INSERT INTO nutrition_cache (normalized_name, calories, protein, carbs, fat, serving_size)
       VALUES ($1, $2, $3, $4, $5, $6)
       ON CONFLICT (normalized_name) DO NOTHING`,
      [key, nutrition.calories, nutrition.protein, nutrition.carbs, nutrition.fat, nutrition.serving_size]
    );
  }
}

// ─── MAIN ENRICHMENT FUNCTION ─────────────────────────────────────────────────
// Call once per meal with the full item list.
// Items already in cache are returned instantly — only new ones hit Groq.

async function enrichItems(client, items, cache) {
  // Split into cached vs new
  const cached = [];
  const newItems = [];

  for (const item of items) {
    const key = cacheKey(item.name);
    if (cache[key]) {
      cached.push({ ...item, ...cache[key] });
    } else {
      newItems.push(item);
    }
  }

  if (newItems.length === 0) {
    console.log(`      ✨ All ${items.length} items from cache`);
    return cached;
  }

  console.log(`      🤖 Estimating ${newItems.length} new items in one batch (${cached.length} from cache)`);

  let nutritionMap = {};
  try {
    nutritionMap = await batchEstimate(newItems.map(i => i.name));
  } catch (err) {
    console.warn(`      ⚠️  Batch failed: ${err.message}. Using scraped values for new items.`);
    return [...cached, ...newItems];
  }

  // Persist new results to DB + in-memory cache
  await saveManyToCache(client, nutritionMap);
  Object.assign(cache, nutritionMap);

  // Merge nutrition back into items (fallback to scraped if a specific item failed)
  const enriched = newItems.map(item => {
    const key = cacheKey(item.name);
    if (nutritionMap[key]) {
      return { ...item, ...nutritionMap[key] };
    }
    console.warn(`      ⚠️  No estimate returned for "${item.name}", using scraped values`);
    return item;
  });

  return [...cached, ...enriched];
}

module.exports = { enrichItems, loadNutritionCache };