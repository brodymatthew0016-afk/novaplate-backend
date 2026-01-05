require('dotenv').config();
const puppeteer = require('puppeteer');
const { Pool } = require('pg');

const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
});

async function scrapeVillanovaMenu(date = null, diningHall = 'dougherty_hall', mealTime = 'lunch') {
  const browser = await puppeteer.launch({ 
    headless: true,
    args: [
      '--no-sandbox',
      '--disable-setuid-sandbox',
      '--disable-dev-shm-usage',
      '--disable-accelerated-2d-canvas',
      '--disable-gpu'
    ],
    ignoreDefaultArgs: ['--disable-extensions']
  });
  const page = await browser.newPage();
  
  try {
    const dateStr = date || formatDate(new Date());
    const url = `https://www1.villanova.edu/villanova/services/dining/menus-ii.html#${diningHall}-${mealTime}-${dateStr}`;
    
    console.log(`Scraping: ${url}`);
    await page.goto(url, { waitUntil: 'networkidle2', timeout: 60000 });
    
    // Wait a bit for dynamic content to load
    await new Promise(resolve => setTimeout(resolve, 3000));
    
    // Wait for the page to fully load and try to find menu items
    // Prioritize .menuItemCollapse as it's the most reliable selector
    let foundSelector = null;
    const possibleSelectors = [
      '.menuItemCollapse',  // Most reliable - use this first
      '.menu-item',
      '.itemTitle',
      '.food-item'
    ];
    
    for (const selector of possibleSelectors) {
      try {
        await page.waitForSelector(selector, { timeout: 5000 });
        const count = await page.$$eval(selector, els => els.length);
        if (count > 0) {
          foundSelector = selector;
          console.log(`Found ${count} elements using selector: ${selector}`);
          break;
        }
      } catch (e) {
        // Try next selector
        continue;
      }
    }
    
    // If no selector worked, let's see what's actually on the page
    if (!foundSelector) {
      const pageTitle = await page.title();
      const bodyText = await page.evaluate(() => document.body.innerText);
      console.log('Page loaded, but no menu items found. Page title:', pageTitle);
      console.log('Body text preview:', bodyText.substring(0, 300));
      await browser.close();
      return {
        date: dateStr,
        diningHall,
        mealTime,
        lastUpdated: new Date().toISOString(),
        items: []
      };
    }
    
    // Use the found selector for extraction
    const menuItems = await page.evaluate((selector) => {
      const items = [];
      const menuElements = document.querySelectorAll(selector);
      
      menuElements.forEach((element) => {
        // Try multiple ways to find the item name
        let nameEl = element.querySelector('.itemTitle strong') || 
                     element.querySelector('.itemTitle') ||
                     element.querySelector('strong') ||
                     element.querySelector('h3') ||
                     element.querySelector('h4');
        
        // If still no name, try getting text from the element itself
        if (!nameEl && selector === '.menuItemCollapse') {
          nameEl = element.querySelector('.itemTitle strong');
        }
        
        const name = nameEl ? nameEl.textContent.trim() : 
                     (element.textContent ? element.textContent.split('\n')[0].trim() : '');
        
        // Skip if no name found
        if (!name || name.length < 2) return;
        
        const dietaryIcons = [];
        const iconElements = element.querySelectorAll('.menuIcons img, .menuIcons span, [class*="icon"] img');
        iconElements.forEach(icon => {
          const alt = icon.getAttribute('alt') || icon.getAttribute('title') || icon.textContent;
          if (alt && alt.trim()) dietaryIcons.push(alt.trim());
        });
        
        const nutritionFacts = {};
        const nutritionElements = element.querySelectorAll('.nutritionFacts, [class*="nutrition"]');
        nutritionElements.forEach(fact => {
          const text = fact.textContent.trim();
          const match = text.match(/(.+?):\s*(.+)/);
          if (match) {
            const key = match[1].trim().toLowerCase().replace(/\s+/g, '_');
            const value = match[2].trim();
            nutritionFacts[key] = value;
          }
        });
        
        const calories = parseInt(nutritionFacts.calories) || 0;
        const protein = parseInt(nutritionFacts.protein?.match(/\d+/)?.[0]) || 0;
        const carbs = parseInt(nutritionFacts.carbohydrate?.match(/\d+/)?.[0]) || 0;
        const fat = parseInt(nutritionFacts.fat?.match(/\d+/)?.[0]) || 0;
        
        // Filter out non-menu items (UI elements, navigation, etc.)
        const invalidNames = ['relevance', 'date', 'please note', 'filter', 'search', 'menu', 'navigation'];
        const isInvalid = invalidNames.some(invalid => name.toLowerCase().includes(invalid)) ||
                         name.length < 3 ||
                         (calories === 0 && Object.keys(nutritionFacts).length === 0 && name.length < 10);
        
        if (!isInvalid) {
          items.push({
            name,
            calories,
            protein,
            carbs,
            fat,
            dietaryTags: dietaryIcons,
            fullNutrition: nutritionFacts
          });
        }
      });
      
      return items;
    }, foundSelector);
    
    console.log(`Found ${menuItems.length} menu items`);
    await browser.close();
    
    return {
      date: dateStr,
      diningHall,
      mealTime,
      lastUpdated: new Date().toISOString(),
      items: menuItems
    };
    
  } catch (error) {
    console.error('Error scraping menu:', error);
    await browser.close();
    throw error;
  }
}

function formatDate(date) {
  const year = date.getFullYear();
  const month = String(date.getMonth() + 1).padStart(2, '0');
  const day = String(date.getDate()).padStart(2, '0');
  return `${year}${month}${day}`;
}

// Function to convert date format from YYYYMMDD to YYYY-MM-DD
function formatDateForDB(dateStr) {
  if (dateStr.length === 8) {
    return `${dateStr.substring(0, 4)}-${dateStr.substring(4, 6)}-${dateStr.substring(6, 8)}`;
  }
  return dateStr;
}

// Map dining hall names to database IDs
const diningHallMap = {
  'dougherty_hall': 'Pit',    // Dougherty Hall = Spit
  'the_court_at_donahue': 'Spit'        // The Court at Donahue = Pit
};

// Map meal times to meal types
const mealTypeMap = {
  'breakfast': 'Breakfast',
  'lunch': 'Lunch',
  'dinner': 'Dinner'
};

async function scrapeAllMenus(dateStr = null) {
  const client = await pool.connect();
  
  try {
    // Use provided date or today
    const scrapeDateStr = dateStr || formatDate(new Date());
    const dbDate = formatDateForDB(scrapeDateStr);
    
    console.log(`Starting scraping for date: ${scrapeDateStr} (DB: ${dbDate})`);
    
    // Get dining halls that need scraping (Spit and Pit only)
    const hallsResult = await client.query(
      "SELECT * FROM dining_halls WHERE scrape_enabled = TRUE"
    );
    
    // Only scrape Spit and Pit (not St. Mary's Hall)
    const diningHalls = [
      'dougherty_hall',  // Spit
      'the_court_at_donahue'    // Pit
    ];
    
    const mealTimes = ['breakfast', 'lunch', 'dinner'];
    
    for (const hall of diningHalls) {
      const hallName = diningHallMap[hall];
      
      // Find the database ID for this hall
      const dbHall = hallsResult.rows.find(h => h.name === hallName);
      if (!dbHall) {
        console.log(`Skipping ${hall} - not found in database`);
        continue;
      }
      
      console.log(`\nProcessing ${hallName} (${hall})...`);
      
      // Delete old menu items for this hall and date
      await client.query(
        'DELETE FROM menu_items WHERE dining_hall_id = $1 AND date = $2',
        [dbHall.id, dbDate]
      );
      
      for (const meal of mealTimes) {
        try {
          console.log(`  Scraping ${meal}...`);
          const menuData = await scrapeVillanovaMenu(scrapeDateStr, hall, meal);
          
          // Insert menu items into database
          for (const item of menuData.items) {
            // Skip items with no nutritional data
            if (item.calories === 0 && item.protein === 0 && item.carbs === 0 && item.fat === 0) {
              console.log(`    Skipping ${item.name} - no nutrition data`);
              continue;
            }
            
            await client.query(
              `INSERT INTO menu_items 
              (dining_hall_id, name, portion, calories, protein, carbs, fat, category, meal_type, date, is_static) 
              VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, FALSE)`,
              [
                dbHall.id,
                item.name,
                'Standard',
                item.calories,
                item.protein,
                item.carbs,
                item.fat,
                item.dietaryTags.join(', ') || 'Main Course',
                mealTypeMap[meal],
                dbDate,
              ]
            );
          }
          
          console.log(`    ✅ Added ${menuData.items.length} items for ${meal}`);
          
          // Wait between requests to be nice to the server
          await new Promise(resolve => setTimeout(resolve, 2000));
          
        } catch (error) {
          console.error(`    ❌ Failed to scrape ${hallName} - ${meal}:`, error.message);
        }
      }
    }
    
    console.log(`\n✅ Menu scraping completed for ${dbDate}`);
    
  } catch (error) {
    console.error('Error in scrapeAllMenus:', error);
    throw error;
  } finally {
    client.release();
  }
}

module.exports = { scrapeAllMenus, scrapeVillanovaMenu, formatDate };