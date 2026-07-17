require('dotenv').config();
const express = require('express');
const cors = require('cors');
const { Pool } = require('pg');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');

const app = express();
const PORT = process.env.PORT || 3000;

app.use(cors({ origin: '*', credentials: true }));
app.use(express.json());
app.use(express.static('public'));

const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
  ssl: { rejectUnauthorized: false }
});

pool.connect((err, client, release) => {
  if (err) console.error('❌ Error connecting to database:', err.stack);
  else { console.log('✅ Database connected successfully'); release(); }
});

const authenticateToken = (req, res, next) => {
  const authHeader = req.headers['authorization'];
  const token = authHeader && authHeader.split(' ')[1];
  if (!token) return res.status(401).json({ error: 'Access token required' });
  jwt.verify(token, process.env.JWT_SECRET, (err, user) => {
    if (err) return res.status(403).json({ error: 'Invalid token' });
    req.user = user;
    next();
  });
};

const adminOnly = (req, res, next) => {
  if (!req.user.isAdmin) return res.status(403).json({ error: 'Admin access required' });
  next();
};

// ========== AUTH ROUTES ==========

app.post('/api/auth/signup', async (req, res) => {
  try {
    const { email, password } = req.body;
    if (!email || !password) return res.status(400).json({ error: 'Email and password required' });
    const existingUser = await pool.query('SELECT * FROM users WHERE email = $1', [email.toLowerCase()]);
    if (existingUser.rows.length > 0) return res.status(400).json({ error: 'Email already registered' });
    const hashedPassword = await bcrypt.hash(password, 10);
    const result = await pool.query(
      'INSERT INTO users (email, password_hash) VALUES ($1, $2) RETURNING id, email, is_admin',
      [email.toLowerCase(), hashedPassword]
    );
    const user = result.rows[0];
    const token = jwt.sign({ userId: user.id, email: user.email, isAdmin: false }, process.env.JWT_SECRET);
    res.status(201).json({ token, user: { id: user.id, email: user.email, isAdmin: false } });
  } catch (error) {
    console.error('Signup error:', error);
    res.status(500).json({ error: 'Server error during signup' });
  }
});

app.post('/api/auth/login', async (req, res) => {
  try {
    const { email, password } = req.body;
    if (!email || !password) return res.status(400).json({ error: 'Email and password required' });
    const result = await pool.query('SELECT * FROM users WHERE email = $1', [email.toLowerCase()]);
    if (result.rows.length === 0) return res.status(401).json({ error: 'Invalid credentials' });
    const user = result.rows[0];
    const validPassword = await bcrypt.compare(password, user.password_hash);
    if (!validPassword) return res.status(401).json({ error: 'Invalid credentials' });
    const token = jwt.sign({ userId: user.id, email: user.email, isAdmin: user.is_admin }, process.env.JWT_SECRET);
    res.json({ token, user: { id: user.id, email: user.email, isAdmin: user.is_admin } });
  } catch (error) {
    console.error('Login error:', error);
    res.status(500).json({ error: 'Server error during login' });
  }
});

// ========== DINING HALL ROUTES ==========

app.get('/api/dining-halls', authenticateToken, async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM dining_halls ORDER BY name');
    res.json(result.rows);
  } catch (error) {
    console.error('Error fetching dining halls:', error);
    res.status(500).json({ error: 'Server error' });
  }
});

// ========== STATION ROUTES ==========

app.get('/api/dining-halls/:diningHallId/stations', authenticateToken, async (req, res) => {
  try {
    const { diningHallId } = req.params;
    const result = await pool.query(
      'SELECT * FROM stations WHERE dining_hall_id = $1 ORDER BY name',
      [diningHallId]
    );
    res.json(result.rows);
  } catch (error) {
    console.error('Error fetching stations:', error);
    res.status(500).json({ error: 'Server error' });
  }
});

app.post('/api/admin/stations', authenticateToken, adminOnly, async (req, res) => {
  try {
    const { dining_hall_id, name } = req.body;
    if (!dining_hall_id || !name) return res.status(400).json({ error: 'dining_hall_id and name required' });
    const result = await pool.query(
      `INSERT INTO stations (dining_hall_id, name)
       VALUES ($1, $2)
       RETURNING *`,
      [dining_hall_id, name]
    );
    res.status(201).json(result.rows[0]);
  } catch (error) {
    if (error.code === '23505') return res.status(400).json({ error: 'A station with that name already exists in this dining hall.' });
    res.status(500).json({ error: 'Server error' });
  }
});

app.delete('/api/admin/stations/:id', authenticateToken, adminOnly, async (req, res) => {
  try {
    const { id } = req.params;
    const result = await pool.query('DELETE FROM stations WHERE id = $1 RETURNING *', [id]);
    if (result.rows.length === 0) return res.status(404).json({ error: 'Station not found' });
    res.json({ message: 'Deleted', station: result.rows[0] });
  } catch (error) {
    res.status(500).json({ error: 'Server error' });
  }
});

// ========== FIXED ITEM ROUTES ==========

app.get('/api/admin/fixed-items', authenticateToken, adminOnly, async (req, res) => {
  try {
    const { dining_hall_id } = req.query;
    if (!dining_hall_id) return res.status(400).json({ error: 'dining_hall_id required' });
    const result = await pool.query(`
      SELECT
        mi.id, mi.name, mi.meal_type,
        mi.scraped_calories, mi.scraped_protein, mi.scraped_carbs, mi.scraped_fat, mi.scraped_serving_size,
        mi.override_calories, mi.override_protein, mi.override_carbs, mi.override_fat, mi.override_serving_size,
        mi.admin_review_status, mi.is_customizable,
        s.id as station_id, s.name as station_name
      FROM menu_items_master mi
      JOIN stations s ON mi.station_id = s.id
      JOIN dining_halls dh ON s.dining_hall_id = dh.id
      WHERE dh.id = $1 AND dh.type = 'fixed' AND mi.is_active = true
      ORDER BY s.name, mi.name
    `, [dining_hall_id]);
    res.json(result.rows);
  } catch (error) {
    console.error('Fixed items fetch error:', error);
    res.status(500).json({ error: 'Server error' });
  }
});

app.post('/api/admin/fixed-items', authenticateToken, adminOnly, async (req, res) => {
  try {
    const { station_id, name, meal_type, calories, protein, carbs, fat, serving_size } = req.body;
    if (!station_id || !name) return res.status(400).json({ error: 'station_id and name required' });
    const result = await pool.query(`
      INSERT INTO menu_items_master
        (station_id, name, meal_type, nutrition_source, nutrition_status,
         scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size,
         is_active, admin_review_status)
      VALUES ($1, $2, $3, 'manual', 'accepted', $4, $5, $6, $7, $8, true, 'reviewed')
      RETURNING *
    `, [station_id, name, meal_type, calories, protein, carbs, fat, serving_size]);
    res.status(201).json(result.rows[0]);
  } catch (error) {
    console.error('Fixed item insert error:', error);
    if (error.code === '23505') return res.status(400).json({ error: 'An item with that name already exists in this station.' });
    res.status(500).json({ error: 'Server error' });
  }
});

app.delete('/api/admin/fixed-items/:id', authenticateToken, adminOnly, async (req, res) => {
  try {
    const { id } = req.params;
    const result = await pool.query('DELETE FROM menu_items_master WHERE id = $1 RETURNING *', [id]);
    if (result.rows.length === 0) return res.status(404).json({ error: 'Item not found' });
    res.json({ message: 'Deleted', item: result.rows[0] });
  } catch (error) {
    console.error('Fixed item delete error:', error);
    res.status(500).json({ error: 'Server error' });
  }
});

// ========== MENU ROUTES ==========

app.get('/api/menu/:diningHallId', authenticateToken, async (req, res) => {
  try {
    const { diningHallId } = req.params;
    const { date, mealType } = req.query;
    const selectedDate = date || new Date().toISOString().split('T')[0];

    const hallResult = await pool.query('SELECT * FROM dining_halls WHERE id = $1', [diningHallId]);
    if (hallResult.rows.length === 0) return res.status(404).json({ error: 'Dining hall not found' });

    const hall = hallResult.rows[0];

    let query;
    const params = [diningHallId];

    if (hall.type === 'fixed') {
      // Fixed halls: skip daily_schedule, always show all active items
      query = `
        SELECT
          mi.id,
          mi.name,
          mi.meal_type,
          mi.is_customizable,
          mi.is_active,
          s.id as station_id,
          s.name as station_name,
          dh.id as dining_hall_id,
          dh.name as dining_hall_name,
          COALESCE(mi.override_calories, mi.scraped_calories) as calories,
          COALESCE(mi.override_protein, mi.scraped_protein) as protein,
          COALESCE(mi.override_carbs, mi.scraped_carbs) as carbs,
          COALESCE(mi.override_fat, mi.scraped_fat) as fat,
          COALESCE(mi.override_serving_size, mi.scraped_serving_size) as serving_size,
          mi.nutrition_source,
          mi.nutrition_status,
          EXISTS(SELECT 1 FROM option_groups og WHERE og.menu_item_id = mi.id) as has_options
        FROM menu_items_master mi
        JOIN stations s ON mi.station_id = s.id
        JOIN dining_halls dh ON s.dining_hall_id = dh.id
        WHERE dh.id = $1 AND mi.is_active = true AND mi.is_assorted = false
      `;
      if (mealType) {
        query += ` AND (mi.meal_type = $2 OR mi.meal_type = 'all')`;
        params.push(mealType);
      }
    } else {
      // Variable halls: join daily_schedule as before
      query = `
        SELECT
          mi.id,
          mi.name,
          mi.meal_type,
          mi.is_customizable,
          mi.is_active,
          s.id as station_id,
          s.name as station_name,
          dh.id as dining_hall_id,
          dh.name as dining_hall_name,
          COALESCE(mi.override_calories, mi.scraped_calories) as calories,
          COALESCE(mi.override_protein, mi.scraped_protein) as protein,
          COALESCE(mi.override_carbs, mi.scraped_carbs) as carbs,
          COALESCE(mi.override_fat, mi.scraped_fat) as fat,
          COALESCE(mi.override_serving_size, mi.scraped_serving_size) as serving_size,
          mi.nutrition_source,
          mi.nutrition_status,
          EXISTS(SELECT 1 FROM option_groups og WHERE og.menu_item_id = mi.id) as has_options
        FROM menu_items_master mi
        JOIN stations s ON mi.station_id = s.id
        JOIN dining_halls dh ON s.dining_hall_id = dh.id
        JOIN daily_schedule ds ON ds.menu_item_id = mi.id
        WHERE dh.id = $1
          AND ds.date = $2
          AND mi.is_active = true
          AND mi.is_assorted = false
      `;
      params.push(selectedDate);
      if (mealType) {
        query += ` AND (mi.meal_type = $3 OR mi.meal_type = 'all')`;
        params.push(mealType);
      }
    }

    query += ` ORDER BY s.name, mi.name`;

    const result = await pool.query(query, params);
    res.json(result.rows);
  } catch (error) {
    console.error('Error fetching menu:', error);
    res.status(500).json({ error: 'Server error' });
  }
});

app.get('/api/menu-items/:menuItemId/options', authenticateToken, async (req, res) => {
  try {
    const { menuItemId } = req.params;
    const groups = await pool.query(
      'SELECT * FROM option_groups WHERE menu_item_id = $1 ORDER BY id',
      [menuItemId]
    );
    const options = await pool.query(
      'SELECT * FROM options WHERE group_id = ANY($1) ORDER BY group_id, id',
      [groups.rows.map(g => g.id)]
    );
    const result = groups.rows.map(group => ({
      ...group,
      options: options.rows.filter(o => o.group_id === group.id)
    }));
    res.json(result);
  } catch (error) {
    console.error('Error fetching item options:', error);
    res.status(500).json({ error: 'Server error' });
  }
});

// ========== MEAL LOG ROUTES ==========

app.post('/api/meal-logs', authenticateToken, async (req, res) => {
  try {
    const { menuItemId, mealType, logDate, servings, calories, protein, carbs, fat, optionsText } = req.body;
    const userId = req.user.userId;
    const result = await pool.query(
      `INSERT INTO meal_logs (user_id, menu_item_id, meal_type, log_date, servings, calories, protein, carbs, fat, options_text)
       VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10)
       RETURNING *`,
      [userId, menuItemId || null, mealType, logDate, servings || 1, calories || null, protein || null, carbs || null, fat || null, optionsText || null]
    );
    res.status(201).json(result.rows[0]);
  } catch (error) {
    console.error('Error logging meal:', error);
    res.status(500).json({ error: 'Server error' });
  }
});

app.get('/api/meal-logs', authenticateToken, async (req, res) => {
  try {
    const userId = req.user.userId;
    const { date } = req.query;
    const selectedDate = date || new Date().toISOString().split('T')[0];
    const result = await pool.query(
      `SELECT
        ml.*,
        mi.name as menu_item_name,
        s.name as station_name,
        dh.name as dining_hall_name,
        COALESCE(ml.calories, COALESCE(mi.override_calories, mi.scraped_calories) * COALESCE(ml.servings, 1)) as calories,
        COALESCE(ml.protein, COALESCE(mi.override_protein, mi.scraped_protein) * COALESCE(ml.servings, 1)) as protein,
        COALESCE(ml.carbs, COALESCE(mi.override_carbs, mi.scraped_carbs) * COALESCE(ml.servings, 1)) as carbs,
        COALESCE(ml.fat, COALESCE(mi.override_fat, mi.scraped_fat) * COALESCE(ml.servings, 1)) as fat
       FROM meal_logs ml
       LEFT JOIN menu_items_master mi ON ml.menu_item_id = mi.id
       LEFT JOIN stations s ON mi.station_id = s.id
       LEFT JOIN dining_halls dh ON s.dining_hall_id = dh.id
       WHERE ml.user_id = $1 AND ml.log_date = $2
       ORDER BY ml.created_at`,
      [userId, selectedDate]
    );
    res.json(result.rows);
  } catch (error) {
    console.error('Error fetching meal logs:', error);
    res.status(500).json({ error: 'Server error' });
  }
});

app.get('/api/meal-logs/totals', authenticateToken, async (req, res) => {
  try {
    const userId = req.user.userId;
    const { date } = req.query;
    const selectedDate = date || new Date().toISOString().split('T')[0];
    const result = await pool.query(
      `SELECT
        COALESCE(SUM(COALESCE(ml.calories, COALESCE(mi.override_calories, mi.scraped_calories) * COALESCE(ml.servings, 1))), 0) as total_calories,
        COALESCE(SUM(COALESCE(ml.protein, COALESCE(mi.override_protein, mi.scraped_protein) * COALESCE(ml.servings, 1))), 0) as total_protein,
        COALESCE(SUM(COALESCE(ml.carbs, COALESCE(mi.override_carbs, mi.scraped_carbs) * COALESCE(ml.servings, 1))), 0) as total_carbs,
        COALESCE(SUM(COALESCE(ml.fat, COALESCE(mi.override_fat, mi.scraped_fat) * COALESCE(ml.servings, 1))), 0) as total_fat
       FROM meal_logs ml
       LEFT JOIN menu_items_master mi ON ml.menu_item_id = mi.id
       WHERE ml.user_id = $1 AND ml.log_date = $2`,
      [userId, selectedDate]
    );
    res.json(result.rows[0]);
  } catch (error) {
    console.error('Error fetching totals:', error);
    res.status(500).json({ error: 'Server error' });
  }
});

app.delete('/api/meal-logs/:id', authenticateToken, async (req, res) => {
  try {
    const { id } = req.params;
    const userId = req.user.userId;
    const result = await pool.query(
      'DELETE FROM meal_logs WHERE id = $1 AND user_id = $2 RETURNING *',
      [id, userId]
    );
    if (result.rows.length === 0) return res.status(404).json({ error: 'Meal log not found' });
    res.json({ message: 'Meal log deleted', log: result.rows[0] });
  } catch (error) {
    console.error('Error deleting meal log:', error);
    res.status(500).json({ error: 'Server error' });
  }
});

// ========== USER GOAL ROUTES ==========

app.get('/api/user/goal', authenticateToken, async (req, res) => {
  try {
    const userId = req.user.userId;
    const result = await pool.query('SELECT daily_calorie_goal FROM users WHERE id = $1', [userId]);
    if (result.rows.length === 0) return res.status(404).json({ error: 'User not found' });
    res.json({ daily_calorie_goal: result.rows[0].daily_calorie_goal || 2000 });
  } catch (error) {
    console.error('Error fetching calorie goal:', error);
    res.status(500).json({ error: 'Server error' });
  }
});

app.put('/api/user/goal', authenticateToken, async (req, res) => {
  try {
    const userId = req.user.userId;
    const { daily_calorie_goal } = req.body;
    if (!daily_calorie_goal || daily_calorie_goal <= 0) return res.status(400).json({ error: 'Invalid calorie goal' });
    const result = await pool.query(
      'UPDATE users SET daily_calorie_goal = $1 WHERE id = $2 RETURNING daily_calorie_goal',
      [daily_calorie_goal, userId]
    );
    if (result.rows.length === 0) return res.status(404).json({ error: 'User not found' });
    res.json({ daily_calorie_goal: result.rows[0].daily_calorie_goal });
  } catch (error) {
    console.error('Error updating calorie goal:', error);
    res.status(500).json({ error: 'Server error' });
  }
});

// ========== ADMIN ROUTES ==========

app.get('/api/admin/stats', authenticateToken, adminOnly, async (req, res) => {
  try {
    const result = await pool.query(`
      SELECT
        COUNT(*) FILTER (WHERE admin_review_status = 'pending') as pending,
        COUNT(*) FILTER (WHERE admin_review_status = 'reviewed') as reviewed,
        COUNT(*) FILTER (WHERE admin_review_status = 'overridden') as overridden,
        COUNT(*) as total
      FROM menu_items_master WHERE is_active = true
    `);
    res.json(result.rows[0]);
  } catch (error) {
    res.status(500).json({ error: 'Server error' });
  }
});

app.get('/api/admin/menu-items', authenticateToken, adminOnly, async (req, res) => {
  try {
    const { status, search, dining_hall_id } = req.query;
    let query = `
      SELECT
        mi.id, mi.name, mi.meal_type, mi.admin_review_status, mi.nutrition_source,
        mi.scraped_calories, mi.scraped_protein, mi.scraped_carbs, mi.scraped_fat, mi.scraped_serving_size, mi.scraped_ingredients,
        mi.override_calories, mi.override_protein, mi.override_carbs, mi.override_fat, mi.override_serving_size,
        COALESCE(mi.override_calories, mi.scraped_calories) as calories,
        COALESCE(mi.override_protein, mi.scraped_protein) as protein,
        COALESCE(mi.override_carbs, mi.scraped_carbs) as carbs,
        COALESCE(mi.override_fat, mi.scraped_fat) as fat,
        COALESCE(mi.override_serving_size, mi.scraped_serving_size) as serving_size,
        s.name as station_name,
        dh.id as dining_hall_id,
        dh.name as dining_hall_name,
        mi.updated_at
      FROM menu_items_master mi
      JOIN stations s ON mi.station_id = s.id
      JOIN dining_halls dh ON s.dining_hall_id = dh.id
      WHERE mi.is_active = true
    `;
    const params = [];
    if (status) { params.push(status); query += ` AND mi.admin_review_status = $${params.length}`; }
    if (dining_hall_id) { params.push(dining_hall_id); query += ` AND dh.id = $${params.length}`; }
    if (search) { params.push(`%${search}%`); query += ` AND mi.name ILIKE $${params.length}`; }
    query += ` ORDER BY mi.admin_review_status = 'pending' DESC, dh.name, s.name, mi.name`;
    const result = await pool.query(query, params);
    res.json(result.rows);
  } catch (error) {
    console.error('Admin menu items error:', error);
    res.status(500).json({ error: 'Server error' });
  }
});

app.put('/api/admin/menu-items/:id', authenticateToken, adminOnly, async (req, res) => {
  try {
    const { id } = req.params;
    const { override_calories, override_protein, override_carbs, override_fat, override_serving_size, admin_review_status } = req.body;
    const hasOverrides = override_calories != null || override_protein != null ||
      override_carbs != null || override_fat != null || override_serving_size != null;
    const status = admin_review_status || (hasOverrides ? 'overridden' : 'reviewed');
    const result = await pool.query(
      `UPDATE menu_items_master SET
        override_calories = $1, override_protein = $2, override_carbs = $3,
        override_fat = $4, override_serving_size = $5, admin_review_status = $6,
        nutrition_status = $7, updated_at = CURRENT_TIMESTAMP
       WHERE id = $8 RETURNING *`,
      [override_calories || null, override_protein || null, override_carbs || null,
       override_fat || null, override_serving_size || null, status,
       hasOverrides ? 'overridden' : 'accepted', id]
    );
    if (result.rows.length === 0) return res.status(404).json({ error: 'Item not found' });
    res.json(result.rows[0]);
  } catch (error) {
    console.error('Admin update error:', error);
    res.status(500).json({ error: 'Server error' });
  }
});

app.delete('/api/admin/menu-items/:id', authenticateToken, adminOnly, async (req, res) => {
  try {
    const { id } = req.params;
    const result = await pool.query('DELETE FROM menu_items_master WHERE id = $1 RETURNING *', [id]);
    if (result.rows.length === 0) return res.status(404).json({ error: 'Item not found' });
    res.json({ message: 'Deleted', item: result.rows[0] });
  } catch (error) {
    console.error('Menu item delete error:', error);
    res.status(500).json({ error: 'Server error' });
  }
});

// ========== ASSORTED ITEM ROUTES ==========

app.put('/api/admin/menu-items/:id/mark-assorted', authenticateToken, adminOnly, async (req, res) => {
  try {
    const { id } = req.params;
    const { is_assorted } = req.body;
    const result = await pool.query(
      `UPDATE menu_items_master SET is_assorted = $1, updated_at = CURRENT_TIMESTAMP WHERE id = $2 RETURNING *`,
      [!!is_assorted, id]
    );
    if (result.rows.length === 0) return res.status(404).json({ error: 'Item not found' });
    res.json(result.rows[0]);
  } catch (error) {
    console.error('Mark assorted error:', error);
    res.status(500).json({ error: 'Server error' });
  }
});

app.get('/api/admin/menu-items/:id/children', authenticateToken, adminOnly, async (req, res) => {
  try {
    const result = await pool.query(
      `SELECT * FROM menu_items_master WHERE parent_item_id = $1 ORDER BY name`,
      [req.params.id]
    );
    res.json(result.rows);
  } catch (error) {
    console.error('Fetch children error:', error);
    res.status(500).json({ error: 'Server error' });
  }
});

app.post('/api/admin/menu-items/:id/children', authenticateToken, adminOnly, async (req, res) => {
  try {
    const { name, meal_type, calories, protein, carbs, fat, serving_size } = req.body;
    if (!name) return res.status(400).json({ error: 'name required' });

    const parent = await pool.query('SELECT station_id, meal_type FROM menu_items_master WHERE id = $1', [req.params.id]);
    if (parent.rows.length === 0) return res.status(404).json({ error: 'Parent not found' });

    const result = await pool.query(`
      INSERT INTO menu_items_master
        (station_id, parent_item_id, name, meal_type, nutrition_source, nutrition_status,
         scraped_calories, scraped_protein, scraped_carbs, scraped_fat, scraped_serving_size,
         is_active, admin_review_status)
      VALUES ($1, $2, $3, $4, 'manual', 'accepted', $5, $6, $7, $8, $9, true, 'reviewed')
      RETURNING *
    `, [
      parent.rows[0].station_id, req.params.id, name,
      meal_type || parent.rows[0].meal_type,
      calories || null, protein || null, carbs || null, fat || null, serving_size || null
    ]);
    res.status(201).json(result.rows[0]);
  } catch (error) {
    console.error('Add child error:', error);
    if (error.code === '23505') return res.status(400).json({ error: 'An item with that name already exists in this station.' });
    res.status(500).json({ error: 'Server error' });
  }
});

app.delete('/api/admin/menu-items/:id/overrides', authenticateToken, adminOnly, async (req, res) => {
  try {
    const { id } = req.params;
    const result = await pool.query(
      `UPDATE menu_items_master SET
        override_calories = NULL, override_protein = NULL, override_carbs = NULL,
        override_fat = NULL, override_serving_size = NULL,
        admin_review_status = 'reviewed', nutrition_status = 'accepted',
        updated_at = CURRENT_TIMESTAMP
       WHERE id = $1 RETURNING *`,
      [id]
    );
    if (result.rows.length === 0) return res.status(404).json({ error: 'Item not found' });
    res.json(result.rows[0]);
  } catch (error) {
    console.error('Admin clear overrides error:', error);
    res.status(500).json({ error: 'Server error' });
  }
});

app.post('/api/admin/bypass', async (req, res) => {
  const result = await pool.query('SELECT * FROM users WHERE email = $1', ['tmhansen16@gmail.com']);
  const user = result.rows[0];
  const token = jwt.sign({ userId: user.id, email: user.email, isAdmin: user.is_admin }, process.env.JWT_SECRET);
  res.json({ token, user: { id: user.id, email: user.email, isAdmin: user.is_admin } });
});

// ========== START SERVER ==========

app.listen(PORT, () => {
  console.log(`🚀 Server running on http://localhost:${PORT}`);
});