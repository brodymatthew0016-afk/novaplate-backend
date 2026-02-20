require('dotenv').config();
const puppeteer = require('puppeteer');
const { Pool } = require('pg');

const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
  ssl: {
    rejectUnauthorized: false
  }
});

// ========== CATEGORY MAPPING ==========

function getCategoryForItem(itemName, hallName, mealType) {
  const name = itemName.toLowerCase().trim();

  // ========== SPIT (the_court_at_donahue) ==========
  if (hallName === 'the_court_at_donahue') {

    // --- SALAD BAR (shared across all meals) ---
    const saladBarItems = [
      'spring mix', 'romaine', 'little leaf', 'shredded carrot', 'cherry tomato',
      'cucumber', 'hard boiled egg', 'red onion', 'olive', 'mozzarella cheese',
      'blue cheese', 'black bean', 'roasted chickpea', 'spiced pepita',
      'pickled shallot', 'marinated artichoke', 'parmesan blue cheese crisp',
      'umami bomb tofu', 'miso chicken', 'lemon & herb quinoa', 'roasted brussels sprout',
      'asian sesame vinaigrette', 'balsamic vinegar', 'balsamic vinaigrette',
      'blue cheese dressing', 'french catalina', 'honey mustard dressing',
      'italian dressing', 'olive oil', 'poppy seed vinaigrette', 'red wine vinegar'
    ];
    if (saladBarItems.some(i => name.includes(i))) return 'Salad Bar';

    // --- AUGGIE'S DELI (shared across lunch & dinner) ---
    const auggiesDeliItems = [
      'turkey breast', 'genoa salami', 'roast beef', 'domestic ham',
      'grilled chicken', 'buffalo chicken breast', 'green goddess crunch wrap',
      'country white bread', 'country wheat bread', 'multigrain bread',
      'hoagie roll', 'assorted wrap', '100% whole grain bread',
      'domestic swiss cheese', 'provolone cheese', 'pepper jack cheese',
      'fresh mozzarella cheese', 'cheddar cheese', 'american cheese',
      'assorted dairy free cheese',
      'sliced tomato', 'sweet pepper', 'sliced red onion', 'dill pickle',
      'roasted vegetable', 'chickpea salad', 'house made hummus',
      'house made red pepper hummus', 'grilled pita', 'vegan option : falafel',
      'dijon mustard', 'brown spicy mustard', 'honey mustard', 'hot sauce',
      'hot pepper', 'pesto sauce', 'red wine vinegar', 'olive oil', 'bacon',
      'green leaf lettuce'
    ];
    if (auggiesDeliItems.some(i => name.includes(i))) return "Auggie's Deli";

    // --- DESSERTS ---
    const dessertItems = [
      'soft serve', 'ice cream', 'brownie', 'cookie', 'sugar cookie', 'chocolate chip cookie'
    ];
    if (dessertItems.some(i => name.includes(i))) return 'Desserts';

    // --- BREAKFAST SPECIFIC ---
    if (mealType === 'breakfast') {
      const spreadablesBar = [
        'bagel', 'biscuit', 'cream cheese', 'guacamole', 'whipped butter',
        'hazelnut', 'chocolate spread', 'housemade jam', 'jam'
      ];
      if (spreadablesBar.some(i => name.includes(i))) return 'Spreadables Bar';

      const fryery = [
        'french toast', 'pancake', 'maple syrup', 'breakfast sandwich'
      ];
      if (fryery.some(i => name.includes(i))) return 'The Fryery';

      const traditions = [
        'pork sausage', 'tater tot', 'morning harvest burrito', 'burrito',
        'vegetable frittata', 'frittata', 'tofu scramble'
      ];
      if (traditions.some(i => name.includes(i))) return 'Traditions';

      const heavenlyThings = [
        'scrambled egg', 'egg white', 'eggs and omelet', 'just egg'
      ];
      if (heavenlyThings.some(i => name.includes(i))) return 'Heavenly Things';

      const grainsForLife = [
        'overnight oat', 'pumpkin seed', 'chia pudding', 'granola',
        'sunflower seed', 'rolled oatmeal', 'oatmeal'
      ];
      if (grainsForLife.some(i => name.includes(i))) return 'Grains For Life';

      const dailyBreakfast = [
        'muffin', 'loaf cake', 'cereal', 'hard boiled egg', 'daily cut fruit',
        'fresh berr', 'sorbet', 'honeydew', 'cantaloupe', 'pineapple',
        'grape', 'grapefruit', 'strawberr', 'raspberr', 'blueberr', 'blackberr',
        'greek yogurt', 'cottage cheese', 'vanilla yogurt', 'strawberry yogurt'
      ];
      if (dailyBreakfast.some(i => name.includes(i))) return 'Daily Breakfast';

      if (name.includes('salad bar') || name.includes('toppings available')) return 'Salad Bar';
    }

    // --- LUNCH SPECIFIC ---
    if (mealType === 'lunch') {
      const goodEarth = [
        'spinach', 'ricotta cheese', 'parmesan cheese', 'mushroom',
        'chicken', 'italian sausage', 'meatball', 'blush sauce',
        'spaghetti sauce', 'broccoli', 'pesto sauce', 'asparagus',
        'creamy alfredo'
      ];
      if (goodEarth.some(i => name.includes(i))) return 'Good Earth';

      const redLantern = [
        'vegetable fried rice', 'fried rice', 'stir fried noodle',
        'super green', 'teriyaki chicken', 'orange chicken', 'honey sesame shrimp'
      ];
      if (redLantern.some(i => name.includes(i))) return 'Red Lantern';

      const soup = ['chicken tortilla soup', 'black bean soup', 'soup'];
      if (soup.some(i => name.includes(i))) return 'Soup';

      const fryery = [
        'hollandaise', 'roasted brussels sprout', 'bistro steak frites', 'steak frite'
      ];
      if (fryery.some(i => name.includes(i))) return 'The Fryery';

      const traditions = [
        'grilled vegetable souvlaki', 'souvlaki', 'tomato, onion', 'feta filling',
        'grilled pita', 'gyro', 'tzatziki', 'falafel'
      ];
      if (traditions.some(i => name.includes(i))) return 'Traditions';

      const grainsForLife = [
        'buffalo & blue salad', 'apple salad', 'caesar salad',
        'cottage cheese'
      ];
      if (grainsForLife.some(i => name.includes(i))) return 'Grains For Life';
    }

    // --- DINNER SPECIFIC ---
    if (mealType === 'dinner') {
      const redLantern = [
        'vegetable fried rice', 'fried rice', 'stir fried noodle',
        'super green', 'honey sesame shrimp', 'orange chicken', 'teriyaki chicken'
      ];
      if (redLantern.some(i => name.includes(i))) return 'Red Lantern';

      const fryery = ['dumpling'];
      if (fryery.some(i => name.includes(i))) return 'The Fryery';

      const traditions = [
        'kung pao shrimp', 'garlic green bean', 'baby bok choy', 'sticky rice',
        "buddha's delight", 'vegetable spring roll', 'spring roll'
      ];
      if (traditions.some(i => name.includes(i))) return 'Traditions';

      const grainsForLife = [
        'ramen chicken', 'ramen broth', 'gooey egg', 'udon noodle',
        'shitake mushroom', 'shitaki mushroom', 'red cabbage', 'scallion',
        'pad thai', 'bok choy', 'apple salad', 'caesar salad',
        'cottage cheese'
      ];
      if (grainsForLife.some(i => name.includes(i))) return 'Grains For Life';

      const goodEarth = ['cooked to order stir fry', 'stir fry'];
      if (goodEarth.some(i => name.includes(i))) return 'Good Earth';
    }
  }

  // ========== DEFAULT ==========
  return 'Main Course';
}

// ========== SCRAPER ==========

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
    const url = `https://www.villanova.edu/villanova/services/dining/menus-ii.html#${diningHall}-${mealTime}-${dateStr}`;
    
    console.log(`Scraping: ${url}`);
    await page.goto(url, { waitUntil: 'networkidle2', timeout: 60000 });
    
    await new Promise(resolve => setTimeout(resolve, 3000));
    
    let foundSelector = null;
    const possibleSelectors = [
      '.menuItemCollapse',
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
        continue;
      }
    }
    
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
    
    const menuItems = await page.evaluate((selector) => {
      const items = [];
      const menuElements = document.querySelectorAll(selector);
      
      menuElements.forEach((element) => {
        let nameEl = element.querySelector('.itemTitle strong') || 
                     element.querySelector('.itemTitle') ||
                     element.querySelector('strong') ||
                     element.querySelector('h3') ||
                     element.querySelector('h4');
        
        if (!nameEl && selector === '.menuItemCollapse') {
          nameEl = element.querySelector('.itemTitle strong');
        }
        
        const name = nameEl ? nameEl.textContent.trim() : 
                     (element.textContent ? element.textContent.split('\n')[0].trim() : '');
        
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

function formatDateForDB(dateStr) {
  if (dateStr.length === 8) {
    return `${dateStr.substring(0, 4)}-${dateStr.substring(4, 6)}-${dateStr.substring(6, 8)}`;
  }
  return dateStr;
}

const diningHallMap = {
  'dougherty_hall': 'Pit',
  'the_court_at_donahue': 'Spit',
  'st_marys_hall': 'St Marys Hall'
};

const mealTypeMap = {
  'breakfast': 'Breakfast',
  'lunch': 'Lunch',
  'dinner': 'Dinner'
};

async function scrapeAllMenus(dateStr = null) {
  const client = await pool.connect();
  
  try {
    const scrapeDateStr = dateStr || formatDate(new Date());
    const dbDate = formatDateForDB(scrapeDateStr);
    
    console.log(`Starting scraping for date: ${scrapeDateStr} (DB: ${dbDate})`);
    
    const hallsResult = await client.query(
      "SELECT * FROM dining_halls WHERE scrape_enabled = TRUE"
    );
    
    const diningHalls = [
      'dougherty_hall',
      'the_court_at_donahue',
      'st_marys_hall'
    ];
    
    const mealTimes = ['breakfast', 'lunch', 'dinner'];
    
    for (const hall of diningHalls) {
      const hallName = diningHallMap[hall];
      
      const dbHall = hallsResult.rows.find(h => h.name === hallName);
      if (!dbHall) {
        console.log(`Skipping ${hall} - not found in database`);
        continue;
      }
      
      console.log(`\nProcessing ${hallName} (${hall})...`);
      
      await client.query(
        'DELETE FROM menu_items WHERE dining_hall_id = $1 AND date = $2',
        [dbHall.id, dbDate]
      );
      
      for (const meal of mealTimes) {
        try {
          console.log(`  Scraping ${meal}...`);
          const menuData = await scrapeVillanovaMenu(scrapeDateStr, hall, meal);
          
          for (const item of menuData.items) {
            if (item.name === 'Assorted Cereal') {
              console.log(`    Skipping ${item.name} - using specific cereals instead`);
              continue;
            }

            // Get category from mapping function
            const category = getCategoryForItem(item.name, hall, meal);
            
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
                category,
                mealTypeMap[meal],
                dbDate,
              ]
            );
          }
          
          console.log(`    ✅ Added ${menuData.items.length} items for ${meal}`);
          
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