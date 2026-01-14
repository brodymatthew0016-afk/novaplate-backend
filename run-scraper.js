// run-scraper.js
// Standalone script to run the scraper (for GitHub Actions)

require('dotenv').config();
const scraper = require('./scraper');

async function main() {
  console.log('🕐 Starting menu scraping...');
  console.log(`📅 Date: ${new Date().toISOString()}`);
  
  try {
    await scraper.scrapeAllMenus();
    console.log('✅ Menu scraping completed successfully');
    process.exit(0);
  } catch (error) {
    console.error('❌ Error during scraping:', error);
    process.exit(1);
  }
}

main();