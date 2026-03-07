require('dotenv').config();
const { Pool } = require('pg');
const XLSX = require('xlsx');

const pool = new Pool({ connectionString: process.env.DATABASE_URL, ssl: { rejectUnauthorized: false } });

pool.query(
  `SELECT name, meal_type, calories, protein, carbs, fat, serving_size,
          est_calories, est_protein, est_carbs, est_fat, est_serving_size, ingredients
   FROM menu_items
   WHERE date = '2026-02-23'
   ORDER BY meal_type, name`
).then(r => {
  const wb = XLSX.utils.book_new();
  const ws = XLSX.utils.json_to_sheet(r.rows);
  XLSX.utils.book_append_sheet(wb, ws, 'Feb 23');
  XLSX.writeFile(wb, 'compare_2026-02-23.xlsx');
  console.log(`Saved compare_2026-02-23.xlsx (${r.rows.length} rows)`);
  pool.end();
}).catch(err => {
  console.error('Error:', err.message);
  pool.end();
});