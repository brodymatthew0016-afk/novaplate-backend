/**
 * NovaPlate — Database Scraper
 * Scrapes menus for all 3 dining halls and inserts into Neon PostgreSQL
 *
 * Run:
 *   node scraper.js              ← scrapes today
 *   node scraper.js 20260223     ← scrapes specific date
 */

require('dotenv').config();
const puppeteer = require('puppeteer');
const { Pool } = require('pg');
const { CORRECTIONS, REPLACEMENTS } = require('./corrections');

const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
  ssl: { rejectUnauthorized: false },
});

// ─── DINING HALL CONFIG ───────────────────────────────────────────────────────

const DINING_HALLS = [
  { scrapeId: 'the_court_at_donahue', dbId: 1, name: 'Donahue Court' },
  { scrapeId: 'dougherty_hall',       dbId: 2, name: 'Dougherty Hall' },
  { scrapeId: 'st_marys_hall',        dbId: 3, name: 'St. Marys Hall' },
];


// ─── BLOCKLIST ────────────────────────────────────────────────────────────────
// Items replaced by static DB entries — scraper should skip these entirely
const BLOCKLIST = [
  'Assorted Cereal',
  'Assorted Cereals',
];

// ─── DATE HELPERS ─────────────────────────────────────────────────────────────

function getTodayEST() {
  const est = new Date(new Date().toLocaleString('en-US', { timeZone: 'America/New_York' }));
  const y = est.getFullYear();
  const m = String(est.getMonth() + 1).padStart(2, '0');
  const d = String(est.getDate()).padStart(2, '0');
  return `${y}${m}${d}`;
}

function toDBDate(dateStr) {
  return `${dateStr.slice(0, 4)}-${dateStr.slice(4, 6)}-${dateStr.slice(6, 8)}`;
}

function isWeekend(dateStr) {
  const y = parseInt(dateStr.slice(0, 4));
  const m = parseInt(dateStr.slice(4, 6)) - 1;
  const d = parseInt(dateStr.slice(6, 8));
  return [0, 6].includes(new Date(y, m, d).getDay());
}

// ─── SCRAPE ONE MEAL ──────────────────────────────────────────────────────────

async function scrapeMeal(dateStr, hallScrapeId, meal) {
  const browser = await puppeteer.launch({
    headless: true,
    args: ['--no-sandbox', '--disable-setuid-sandbox', '--disable-dev-shm-usage', '--disable-gpu'],
  });
  const page = await browser.newPage();

  try {
    const url = `https://www.villanova.edu/villanova/services/dining/menus-ii.html#${hallScrapeId}-${meal}-${dateStr}`;
    console.log(`  Scraping: ${url}`);
    await page.goto(url, { waitUntil: 'networkidle2', timeout: 60000 });
    await new Promise(r => setTimeout(r, 3000));

    let foundSelector = null;
    for (const sel of ['.menuItemCollapse', '.menu-item', '.itemTitle', '.food-item']) {
      try {
        await page.waitForSelector(sel, { timeout: 5000 });
        const count = await page.$$eval(sel, els => els.length);
        if (count > 0) { foundSelector = sel; break; }
      } catch { continue; }
    }

    if (!foundSelector) {
      console.log(`    ⚠️  No items found`);
      await browser.close();
      return [];
    }

    const items = await page.evaluate((sel) => {
      const results = [];
      document.querySelectorAll(sel).forEach(el => {
        const nameEl =
          el.querySelector('.itemTitle strong') ||
          el.querySelector('.itemTitle') ||
          el.querySelector('strong') ||
          el.querySelector('h3') ||
          el.querySelector('h4');
        const name = nameEl ? nameEl.textContent.trim() : el.textContent.split('\n')[0].trim();
        if (!name || name.length < 3) return;

        const junk = ['relevance', 'date', 'please note', 'filter', 'search', 'menu', 'navigation'];
        if (junk.some(j => name.toLowerCase().includes(j))) return;

        const nf = {};
        el.querySelectorAll('.nutritionFacts, [class*="nutrition"]').forEach(fact => {
          const m = fact.textContent.trim().match(/(.+?):\s*(.+)/);
          if (m) nf[m[1].trim().toLowerCase().replace(/\s+/g, '_')] = m[2].trim();
        });

        results.push({
          name,
          calories: parseInt(nf.calories) || 0,
          protein:  parseInt(nf.protein?.match(/\d+/)?.[0]) || 0,
          carbs:    parseInt(nf.carbohydrate?.match(/\d+/)?.[0]) || 0,
          fat:      parseInt(nf.fat?.match(/\d+/)?.[0]) || 0,
        });
      });
      return results;
    }, foundSelector);

    console.log(`    ✅ ${items.length} items scraped`);
    await browser.close();
    return items;

  } catch (err) {
    console.error(`    ❌ Error: ${err.message}`);
    await browser.close();
    return [];
  }
}

// ─── INSERT INTO DATABASE ─────────────────────────────────────────────────────

async function insertItem(client, dbHallId, item, mealType, dbDate, isStatic = false) {
  await client.query(
    `INSERT INTO menu_items 
     (dining_hall_id, name, calories, protein, carbs, fat, meal_type, date, is_static)
     VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9)`,
    [dbHallId, item.name, item.calories, item.protein, item.carbs, item.fat, mealType, dbDate, isStatic]
  );
}

// ─── MAIN ─────────────────────────────────────────────────────────────────────

async function main() {
  const dateStr = process.argv[2] || getTodayEST();
  const dbDate  = toDBDate(dateStr);
  const weekend = isWeekend(dateStr);
  const client  = await pool.connect();

  console.log(`\n📅 Scraping menus for ${dateStr} (DB: ${dbDate}) — ${weekend ? 'Weekend' : 'Weekday'}\n`);

  try {
    for (const hall of DINING_HALLS) {
      console.log(`\n🏫 ${hall.name}`);

      // Clear today's scraped items for this hall
      await client.query(
        'DELETE FROM menu_items WHERE dining_hall_id = $1 AND date = $2 AND is_static = FALSE',
        [hall.dbId, dbDate]
      );

      const isSpit = hall.scrapeId === 'the_court_at_donahue';
      const meals  = (isSpit && weekend) ? ['brunch', 'dinner'] : ['breakfast', 'lunch', 'dinner'];

      for (const meal of meals) {
        const scrapeAs = meal === 'brunch' ? 'lunch' : meal;
        const mealType = meal.charAt(0).toUpperCase() + meal.slice(1);
        const items    = await scrapeMeal(dateStr, hall.scrapeId, scrapeAs);

        let inserted = 0;
        let corrected = 0;

        for (const item of items) {
          // Skip blocklisted items (replaced by static DB entries)
          if (BLOCKLIST.some(b => b.toLowerCase() === item.name.toLowerCase())) {
            console.log(`    🚫 Skipped (static): "${item.name}"`);
            continue;
          }

          // Handle replacements (e.g. "Assorted Cereal" → specific cereals)
          if (REPLACEMENTS[item.name]) {
            for (const replacement of REPLACEMENTS[item.name]) {
              await insertItem(client, hall.dbId, replacement, mealType, dbDate, true);
              inserted++;
            }
            console.log(`    🔄 Replaced "${item.name}" with ${REPLACEMENTS[item.name].length} specific items`);
            continue;
          }

          // Apply correction if one exists
          const correction = CORRECTIONS[item.name];
          if (correction) {
            console.log(`    ✏️  Corrected: ${item.name} — ${item.calories} → ${correction.calories} cal`);
            corrected++;
          }
          const finalItem = correction ? { ...item, ...correction } : item;

          await insertItem(client, hall.dbId, finalItem, mealType, dbDate, false);
          inserted++;
        }

        console.log(`    ✅ ${meal}: ${inserted} items inserted (${corrected} corrected)`);
        await new Promise(r => setTimeout(r, 2000));
      }
    }

    console.log(`\n✅ Done — all menus inserted for ${dbDate}`);

  } catch (err) {
    console.error('❌ Fatal error:', err);
  } finally {
    client.release();
    await pool.end();
  }
}

main();