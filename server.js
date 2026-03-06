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

// ========== AUTH ROUTES ==========

app.post('/api/auth/signup', async (req, res) => {
  try {
    const { email, password } = req.body;
    if (!email || !password) return res.status(400).json({ error: 'Email and password required' });
    const existingUser = await pool.query('SELECT * FROM users WHERE email = $1', [email.toLowerCase()]);
    if (existingUser.rows.length > 0) return res.status(400).json({ error: 'Email already registered' });
    const hashedPassword = await bcrypt.hash(password, 10);
    const result = await pool.query(
      'INSERT INTO users (email, password_hash) VALUES ($1, $2) RETURNING id, email',
      [email.toLowerCase(), hashedPassword]
    );
    const user = result.rows[0];
    const token = jwt.sign({ userId: user.id, email: user.email }, process.env.JWT_SECRET);
    res.status(201).json({ token, user: { id: user.id, email: user.email } });
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
    const token = jwt.sign({ userId: user.id, email: user.email }, process.env.JWT_SECRET);
    res.json({ token, user: { id: user.id, email: user.email } });
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

// ========== MENU ROUTES ==========

app.get('/api/menu/:diningHallId', authenticateToken, async (req, res) => {
  try {
    const { diningHallId } = req.params;
    const hallResult = await pool.query('SELECT * FROM dining_halls WHERE id = $1', [diningHallId]);
    if (hallResult.rows.length === 0) return res.status(404).json({ error: 'Dining hall not found' });

    const result = await pool.query(
      `SELECT mi.id, mi.dining_hall_id, mi.name, mi.category, mi.sub_station, mi.calories, mi.protein, mi.carbs, mi.fat,
              mi.serving_size,
              COALESCE(ip.portion, mi.portion) as portion,
              COALESCE(
                mi.display_calories,
                mi.calories + COALESCE((
                  SELECT SUM(io.calories_delta)
                  FROM item_options io
                  JOIN item_option_groups iog ON io.group_id = iog.id
                  WHERE iog.menu_item_id = mi.id AND io.is_default = true
                ), 0)
              ) as display_calories,
              EXISTS(SELECT 1 FROM item_option_groups iog WHERE iog.menu_item_id = mi.id) as has_options
       FROM menu_items mi
       LEFT JOIN item_portions ip ON LOWER(mi.name) = LOWER(ip.name)
       WHERE mi.dining_hall_id = $1
       ORDER BY mi.category, mi.sub_station, mi.name`,
      [diningHallId]
    );
    res.json(result.rows);
  } catch (error) {
    console.error('Error fetching menu:', error);
    res.status(500).json({ error: 'Server error' });
  }
});

// ========== MEAL LOG ROUTES ==========

// Log a meal
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

    // Write to recent_meals (upsert so each item only appears once per user)
    if (menuItemId) {
      const menuItem = await pool.query('SELECT * FROM menu_items WHERE id = $1', [menuItemId]);
      if (menuItem.rows.length > 0) {
        const mi = menuItem.rows[0];
        await pool.query(
          `INSERT INTO recent_meals (user_id, menu_item_id, menu_item_name, calories, protein, carbs, fat, servings, last_logged_at)
           VALUES ($1, $2, $3, $4, $5, $6, $7, $8, NOW())
           ON CONFLICT (user_id, menu_item_id)
           DO UPDATE SET last_logged_at = NOW(), calories = $4, protein = $5, carbs = $6, fat = $7, servings = $8`,
          [userId, menuItemId, mi.name, calories || mi.calories, protein || mi.protein, carbs || mi.carbs, fat || mi.fat, servings || 1]
        );
      }
    }

    res.status(201).json(result.rows[0]);
  } catch (error) {
    console.error('Error logging meal:', error);
    res.status(500).json({ error: 'Server error' });
  }
});

// Get meal logs for a specific date
app.get('/api/meal-logs', authenticateToken, async (req, res) => {
  try {
    const userId = req.user.userId;
    const { date } = req.query;
    const selectedDate = date || new Date().toISOString().split('T')[0];

    const result = await pool.query(
      `SELECT ml.*,
              mi.name as menu_item_name,
              COALESCE(ml.calories, mi.calories * COALESCE(ml.servings, 1)) as calories,
              COALESCE(ml.protein, mi.protein * COALESCE(ml.servings, 1)) as protein,
              COALESCE(ml.carbs, mi.carbs * COALESCE(ml.servings, 1)) as carbs,
              COALESCE(ml.fat, mi.fat * COALESCE(ml.servings, 1)) as fat,
              mi.portion, mi.category, dh.name as dining_hall_name
       FROM meal_logs ml
       LEFT JOIN menu_items mi ON ml.menu_item_id = mi.id
       LEFT JOIN dining_halls dh ON mi.dining_hall_id = dh.id
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

// Get daily totals (pulled from menu_items via join)
app.get('/api/meal-logs/totals', authenticateToken, async (req, res) => {
  try {
    const userId = req.user.userId;
    const { date } = req.query;
    const selectedDate = date || new Date().toISOString().split('T')[0];

    const result = await pool.query(
      `SELECT
        COALESCE(SUM(COALESCE(ml.calories, mi.calories * COALESCE(ml.servings, 1))), 0) as total_calories,
        COALESCE(SUM(COALESCE(ml.protein, mi.protein * COALESCE(ml.servings, 1))), 0) as total_protein,
        COALESCE(SUM(COALESCE(ml.carbs, mi.carbs * COALESCE(ml.servings, 1))), 0) as total_carbs,
        COALESCE(SUM(COALESCE(ml.fat, mi.fat * COALESCE(ml.servings, 1))), 0) as total_fat
       FROM meal_logs ml
       LEFT JOIN menu_items mi ON ml.menu_item_id = mi.id
       WHERE ml.user_id = $1 AND ml.log_date = $2`,
      [userId, selectedDate]
    );
    res.json(result.rows[0]);
  } catch (error) {
    console.error('Error fetching totals:', error);
    res.status(500).json({ error: 'Server error' });
  }
});

// Get recently logged unique meals
app.get('/api/meal-logs/recent', authenticateToken, async (req, res) => {
  try {
    const userId = req.user.userId;
    const result = await pool.query(
      `SELECT rm.id, rm.menu_item_name, rm.menu_item_id, rm.calories, rm.protein, rm.carbs, rm.fat,
              rm.last_logged_at as created_at, rm.servings,
              mi.portion, mi.category, dh.name as dining_hall_name,
              EXISTS(SELECT 1 FROM item_option_groups iog WHERE iog.menu_item_id = rm.menu_item_id) as has_options
       FROM recent_meals rm
       LEFT JOIN menu_items mi ON rm.menu_item_id = mi.id
       LEFT JOIN dining_halls dh ON mi.dining_hall_id = dh.id
       WHERE rm.user_id = $1
       ORDER BY rm.last_logged_at DESC
       LIMIT 20`,
      [userId]
    );
    res.json(result.rows);
  } catch (error) {
    console.error('Error fetching recent meals:', error);
    res.status(500).json({ error: 'Server error' });
  }
});

// Delete a recent meal
app.delete('/api/recent-meals/:id', authenticateToken, async (req, res) => {
  try {
    const { id } = req.params;
    const userId = req.user.userId;
    const result = await pool.query(
      'DELETE FROM recent_meals WHERE id = $1 AND user_id = $2 RETURNING *',
      [id, userId]
    );
    if (result.rows.length === 0) return res.status(404).json({ error: 'Recent meal not found' });
    res.json({ message: 'Removed from recents' });
  } catch (error) {
    console.error('Error deleting recent meal:', error);
    res.status(500).json({ error: 'Server error' });
  }
});

// Delete a meal log
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

// ========== FEEDBACK ROUTES ==========

app.post('/api/feedback', authenticateToken, async (req, res) => {
  try {
    const userId = req.user.userId;
    const { feedbackText, feedbackType } = req.body;
    const result = await pool.query(
      'INSERT INTO feedback (user_id, feedback_text, feedback_type) VALUES ($1, $2, $3) RETURNING *',
      [userId, feedbackText, feedbackType]
    );
    const userResult = await pool.query('SELECT email FROM users WHERE id = $1', [userId]);
    const userEmail = userResult.rows[0]?.email || 'unknown';
    try {
      const axios = require('axios');
      const FormData = require('form-data');
      const GOOGLE_FORM_ID = '1FAIpQLScQPTt23NbQ1Nrty007ZRFs9mFCHk-goAilKITl5_Hfd4CDcg';
      const formData = new FormData();
      formData.append('entry.1176347361', userEmail);
      formData.append('entry.2069532797', feedbackType);
      formData.append('entry.843023838', feedbackText);
      await axios.post(`https://docs.google.com/forms/d/e/${GOOGLE_FORM_ID}/formResponse`, formData, {
        headers: formData.getHeaders(), validateStatus: () => true
      });
      console.log('✅ Feedback submitted to Google Form');
    } catch (googleError) {
      console.error('Error submitting to Google Form:', googleError.message);
    }
    res.status(201).json(result.rows[0]);
  } catch (error) {
    console.error('Error submitting feedback:', error);
    res.status(500).json({ error: 'Server error' });
  }
});
app.get('/api/menu-items/:menuItemId/options', authenticateToken, async (req, res) => {
  try {
    const { menuItemId } = req.params;
    const groups = await pool.query(
      `SELECT * FROM item_option_groups WHERE menu_item_id = $1 ORDER BY id`,
      [menuItemId]
    );
    const options = await pool.query(
      `SELECT * FROM item_options WHERE group_id = ANY($1) ORDER BY group_id, id`,
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

// ========== START SERVER ==========

app.listen(PORT, () => {
  console.log(`🚀 Server running on http://localhost:${PORT}`);
});