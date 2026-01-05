const { Pool } = require('pg');

const pool = new Pool({
  user: 'postgres',
  host: 'localhost',
  database: 'novaplate',
  password: 'WC16tmh5', // Replace with your password
  port: 5432,
});

const covaMenu = [
  // The Corner Grille
  { category: 'The Corner Grille', name: 'Cheesesteak', portion: 'Standard', calories: 600, protein: 35, carbs: 45, fat: 30 },
  { category: 'The Corner Grille', name: 'Chicken Cheesesteak', portion: 'Standard', calories: 550, protein: 35, carbs: 45, fat: 25 },
  { category: 'The Corner Grille', name: 'Cova Buffalo Chicken Cheesesteak', portion: 'Standard', calories: 650, protein: 36, carbs: 45, fat: 33 },
  { category: 'The Corner Grille', name: 'Philly Steak Loaded Fries', portion: 'Standard', calories: 800, protein: 35, carbs: 60, fat: 45 },
  { category: 'The Corner Grille', name: 'Side of Fries', portion: 'Standard', calories: 350, protein: 4, carbs: 45, fat: 15 },
  
  // Cova Greens
  { category: 'Cova Greens', name: 'BBQ Chicken Salad', portion: 'Standard', calories: 500, protein: 35, carbs: 35, fat: 25 },
  { category: 'Cova Greens', name: 'Cova Caesar Salad', portion: 'Standard', calories: 450, protein: 30, carbs: 30, fat: 20 },
  { category: 'Cova Greens', name: 'Buffalo Chicken Salad', portion: 'Standard', calories: 500, protein: 35, carbs: 30, fat: 25 },
  { category: 'Cova Greens', name: 'Cova Caesar Salad Wrap', portion: 'Standard', calories: 450, protein: 30, carbs: 35, fat: 20 },
  { category: 'Cova Greens', name: 'Buffalo Chicken Wrap', portion: 'Standard', calories: 480, protein: 33, carbs: 35, fat: 23 },
  { category: 'Cova Greens', name: 'BBQ Chicken Wrap', portion: 'Standard', calories: 500, protein: 34, carbs: 40, fat: 25 },
  
  // The Italian Kitchen
  { category: 'The Italian Kitchen', name: 'Chicken Parmesan Sandwich', portion: 'Standard', calories: 560, protein: 50, carbs: 50, fat: 16 },
  { category: 'The Italian Kitchen', name: 'BBQ Chicken Pizza', portion: '1 Slice', calories: 545, protein: 43, carbs: 44, fat: 21 },
  { category: 'The Italian Kitchen', name: 'Margherita Pizza', portion: '1 Slice', calories: 370, protein: 17, carbs: 34, fat: 18 },
  { category: 'The Italian Kitchen', name: 'Pepperoni Pizza', portion: '1 Slice', calories: 500, protein: 23, carbs: 32, fat: 30 },
  { category: 'The Italian Kitchen', name: 'Plain Pizza', portion: '1 Slice', calories: 360, protein: 17, carbs: 32, fat: 18 },
  
  // Blue Fin
  { category: 'Blue Fin', name: 'Vegetarian Poke Bowl', portion: 'Standard', calories: 500, protein: 18, carbs: 70, fat: 20 },
  { category: 'Blue Fin', name: 'Salmon Poke Bowl', portion: 'Standard', calories: 550, protein: 30, carbs: 65, fat: 25 },
  { category: 'Blue Fin', name: 'Tuna Poke Bowl', portion: 'Standard', calories: 540, protein: 30, carbs: 65, fat: 22 },
];

async function insertCovaMenu() {
  const client = await pool.connect();
  try {
    // Get Cova's dining hall ID
    const covaResult = await client.query(
      "SELECT id FROM dining_halls WHERE name = 'Cova'"
    );
    const covaId = covaResult.rows[0].id;

    // Insert each menu item
    for (const item of covaMenu) {
      await client.query(
        `INSERT INTO menu_items 
        (dining_hall_id, name, portion, calories, protein, carbs, fat, category, is_static) 
        VALUES ($1, $2, $3, $4, $5, $6, $7, $8, TRUE)`,
        [covaId, item.name, item.portion, item.calories, item.protein, item.carbs, item.fat, item.category]
      );
    }

    console.log('✅ Cova menu inserted successfully!');
  } catch (error) {
    console.error('Error inserting Cova menu:', error);
  } finally {
    client.release();
    pool.end();
  }
}

insertCovaMenu();