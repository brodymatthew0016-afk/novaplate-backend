require('dotenv').config();
const express = require('express');
const cors = require('cors');
const { Pool } = require('pg');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const scraper = require('./scraper');

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(cors({
     origin: '*',
     credentials: true
   }));
app.use(express.json());

// Database connection
const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
  ssl: {
    rejectUnauthorized: false
  }
});

// Test database connection
pool.connect((err, client, release) => {
  if (err) {
    console.error('❌ Error connecting to database:', err.stack);
  } else {
    console.log('✅ Database connected successfully');
    release();
  }
});

// Auth Middleware
const authenticateToken = (req, res, next) => {
  const authHeader = req.headers['authorization'];
  const token = authHeader && authHeader.split(' ')[1];

  if (!token) {
    return res.status(401).json({ error: 'Access token required' });
  }

  jwt.verify(token, process.env.JWT_SECRET, (err, user) => {
    if (err) {
      return res.status(403).json({ error: 'Invalid token' });
    }
    req.user = user;
    next();
  });
};

// ========== AUTH ROUTES ==========

// Sign up
app.post('/api/auth/signup', async (req, res) => {
  try {
    const { email, password } = req.body;

    // Validate input
    if (!email || !password) {
      return res.status(400).json({ error: 'Email and password required' });
    }

    // Check if user exists
    const existingUser = await pool.query(
      'SELECT * FROM users WHERE email = $1',
      [email.toLowerCase()]
    );

    if (existingUser.rows.length > 0) {
      return res.status(400).json({ error: 'Email already registered' });
    }

    // Hash password
    const hashedPassword = await bcrypt.hash(password, 10);

    // Create user
    const result = await pool.query(
      'INSERT INTO users (email, password_hash) VALUES ($1, $2) RETURNING id, email',
      [email.toLowerCase(), hashedPassword]
    );

    const user = result.rows[0];

    // Generate token
    const token = jwt.sign({ userId: user.id, email: user.email }, process.env.JWT_SECRET);

    res.status(201).json({ token, user: { id: user.id, email: user.email } });
  } catch (error) {
    console.error('Signup error:', error);
    res.status(500).json({ error: 'Server error during signup' });
  }
});

// Login
app.post('/api/auth/login', async (req, res) => {
  try {
    const { email, password } = req.body;

    // Validate input
    if (!email || !password) {
      return res.status(400).json({ error: 'Email and password required' });
    }

    // Find user
    const result = await pool.query(
      'SELECT * FROM users WHERE email = $1',
      [email.toLowerCase()]
    );

    if (result.rows.length === 0) {
      return res.status(401).json({ error: 'Invalid credentials' });
    }

    const user = result.rows[0];

    // Check password
    const validPassword = await bcrypt.compare(password, user.password_hash);
    if (!validPassword) {
      return res.status(401).json({ error: 'Invalid credentials' });
    }

    // Generate token
    const token = jwt.sign({ userId: user.id, email: user.email }, process.env.JWT_SECRET);

    res.json({ token, user: { id: user.id, email: user.email } });
  } catch (error) {
    console.error('Login error:', error);
    res.status(500).json({ error: 'Server error during login' });
  }
});

// ========== DINING HALL ROUTES ==========

// Get all dining halls
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

// Get menu for a dining hall on a specific date
app.get('/api/menu/:diningHallId', authenticateToken, async (req, res) => {
  try {
    const { diningHallId } = req.params;
    const { date } = req.query;
    console.log('RAW REQUEST - diningHallId:', diningHallId, 'date:', date, 'type:', typeof date);

    const selectedDate = date || new Date().toISOString().split('T')[0];

    console.log('API getting menu for hall', diningHallId, 'on date:', selectedDate);

    // Get dining hall info
    const hallResult = await pool.query(
      'SELECT * FROM dining_halls WHERE id = $1',
      [diningHallId]
    );

    if (hallResult.rows.length === 0) {
      return res.status(404).json({ error: 'Dining hall not found' });
    }

    const hall = hallResult.rows[0];

    let query;
    let params;

    if (hall.scrape_enabled) {
      // For Spit and Pit: get scraped menu for specific date PLUS static items
      query = `
        SELECT * FROM menu_items 
        WHERE dining_hall_id = $1 AND (date = $2 OR (is_static = TRUE AND date IS NULL))
        ORDER BY meal_type, category, sub_station, name
      `;
      params = [diningHallId, selectedDate];
    } else {
      // For Conn and other static menus: get static menu
      query = `
        SELECT * FROM menu_items 
        WHERE dining_hall_id = $1 AND is_static = TRUE
        ORDER BY category, sub_station, name
      `;
      params = [diningHallId];
    }

    const result = await pool.query(query, params);
    console.log('Query returned', result.rows.length, 'items');
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
    const { menuItemId, customName, calories, protein, carbs, fat, mealType, logDate } = req.body;
    const userId = req.user.userId;

    const result = await pool.query(
      `INSERT INTO meal_logs 
      (user_id, menu_item_id, custom_name, calories, protein, carbs, fat, meal_type, log_date) 
      VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9) 
      RETURNING *`,
      [userId, menuItemId, customName, calories, protein, carbs, fat, mealType, logDate]
    );

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
    const { date } = req.query; // format: YYYY-MM-DD

    const selectedDate = date || new Date().toISOString().split('T')[0];

    const result = await pool.query(
      `SELECT ml.*, mi.name as menu_item_name, dh.name as dining_hall_name
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

// Delete a meal log
app.delete('/api/meal-logs/:id', authenticateToken, async (req, res) => {
  try {
    const { id } = req.params;
    const userId = req.user.userId;

    const result = await pool.query(
      'DELETE FROM meal_logs WHERE id = $1 AND user_id = $2 RETURNING *',
      [id, userId]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Meal log not found' });
    }

    res.json({ message: 'Meal log deleted', log: result.rows[0] });
  } catch (error) {
    console.error('Error deleting meal log:', error);
    res.status(500).json({ error: 'Server error' });
  }
});

// Get daily totals
app.get('/api/meal-logs/totals', authenticateToken, async (req, res) => {
  try {
    const userId = req.user.userId;
    const { date } = req.query;

    const selectedDate = date || new Date().toISOString().split('T')[0];

    const result = await pool.query(
      `SELECT 
        COALESCE(SUM(calories), 0) as total_calories,
        COALESCE(SUM(protein), 0) as total_protein,
        COALESCE(SUM(carbs), 0) as total_carbs,
        COALESCE(SUM(fat), 0) as total_fat
       FROM meal_logs
       WHERE user_id = $1 AND log_date = $2`,
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
      `SELECT DISTINCT ON (COALESCE(ml.custom_name, mi.name))
        ml.id, ml.custom_name, mi.name as menu_item_name, mi.id as menu_item_id,
        ml.calories, ml.protein, ml.carbs, ml.fat, ml.created_at
       FROM meal_logs ml
       LEFT JOIN menu_items mi ON ml.menu_item_id = mi.id
       WHERE ml.user_id = $1
       ORDER BY COALESCE(ml.custom_name, mi.name), ml.created_at DESC
       LIMIT 20`,
      [userId]
    );

    res.json(result.rows);
  } catch (error) {
    console.error('Error fetching recent meals:', error);
    res.status(500).json({ error: 'Server error' });
  }
});
// ========== USER GOAL ROUTES ==========

// Get user's calorie goal
app.get('/api/user/goal', authenticateToken, async (req, res) => {
  try {
    const userId = req.user.userId;
    
    const result = await pool.query(
      'SELECT daily_calorie_goal FROM users WHERE id = $1',
      [userId]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'User not found' });
    }

    const calorieGoal = result.rows[0].daily_calorie_goal || 2000;
    res.json({ daily_calorie_goal: calorieGoal });
  } catch (error) {
    console.error('Error fetching calorie goal:', error);
    res.status(500).json({ error: 'Server error' });
  }
});

// Update user's calorie goal
app.put('/api/user/goal', authenticateToken, async (req, res) => {
  try {
    const userId = req.user.userId;
    const { daily_calorie_goal } = req.body;

    if (!daily_calorie_goal || daily_calorie_goal <= 0) {
      return res.status(400).json({ error: 'Invalid calorie goal' });
    }

    const result = await pool.query(
      'UPDATE users SET daily_calorie_goal = $1 WHERE id = $2 RETURNING daily_calorie_goal',
      [daily_calorie_goal, userId]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'User not found' });
    }

    res.json({ daily_calorie_goal: result.rows[0].daily_calorie_goal });
  } catch (error) {
    console.error('Error updating calorie goal:', error);
    res.status(500).json({ error: 'Server error' });
  }
});

// ========== FEEDBACK ROUTES ==========

// Submit feedback
app.post('/api/feedback', authenticateToken, async (req, res) => {
  try {
    const userId = req.user.userId;
    const { feedbackText, feedbackType } = req.body;

    // Save to database
    const result = await pool.query(
      'INSERT INTO feedback (user_id, feedback_text, feedback_type) VALUES ($1, $2, $3) RETURNING *',
      [userId, feedbackText, feedbackType]
    );

    // Get user email
    const userResult = await pool.query(
      'SELECT email FROM users WHERE id = $1',
      [userId]
    );
    const userEmail = userResult.rows[0]?.email || 'unknown';

    // Submit to Google Form
    try {
      const axios = require('axios');
      const FormData = require('form-data');
      
      const GOOGLE_FORM_ID = '1FAIpQLScQPTt23NbQ1Nrty007ZRFs9mFCHk-goAilKITl5_Hfd4CDcg';
      const EMAIL_ENTRY_ID = 'entry.1176347361';
      const TYPE_ENTRY_ID = 'entry.2069532797';
      const TEXT_ENTRY_ID = 'entry.843023838';
      
      const formData = new FormData();
      formData.append(EMAIL_ENTRY_ID, userEmail);
      formData.append(TYPE_ENTRY_ID, feedbackType);
      formData.append(TEXT_ENTRY_ID, feedbackText);
      
      await axios.post(
        `https://docs.google.com/forms/d/e/${GOOGLE_FORM_ID}/formResponse`,
        formData,
        {
          headers: formData.getHeaders(),
          validateStatus: () => true
        }
      );
      
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

// ========== SCRAPING ENDPOINTS ==========

// Manual trigger endpoint for testing
app.post('/api/scrape-menus', authenticateToken, async (req, res) => {
  try {
    await scraper.scrapeAllMenus();
    res.json({ message: 'Menus scraped successfully' });
  } catch (error) {
    console.error('Error scraping menus:', error);
    res.status(500).json({ error: 'Scraping failed' });
  }
});

// ========== START SERVER ==========

app.listen(PORT, () => {
  console.log(`🚀 Server running on http://localhost:${PORT}`);
  console.log('📅 Menu scraping handled by GitHub Actions (runs daily at 6:00 AM EST)');
});