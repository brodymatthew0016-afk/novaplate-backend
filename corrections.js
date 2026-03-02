const CORRECTIONS = {
  'Chipolte Sour Cream':  { calories: 60,  protein: 1, carbs: 2, fat: 5 },
  'SP SOUR CREAM':        { calories: 60,  protein: 1, carbs: 2, fat: 5 },
  'Olive Oil':            { calories: 120, protein: 0, carbs: 0, fat: 14 },
  'Spaghetti Sauce':      { calories: 80,  protein: 2, carbs: 12, fat: 2 },
  'Organic Pumpkin Seed': { calories: 70,  protein: 4, carbs: 2, fat: 6 },
  'Roasted Shelled Sunflower Seed': { calories: 80, protein: 3, carbs: 3, fat: 7 },
  'Overnight Oats':       { calories: 180, protein: 6, carbs: 30, fat: 4 },
  'Penne Pasta':          { calories: 200, protein: 7, carbs: 42, fat: 1 },
  'Tikka Masala':         { calories: 280, protein: 18, carbs: 12, fat: 18 },
  // add more as you find them
};

const REPLACEMENTS = {
  'Assorted Cereal': [
    { name: 'Cheerios',         calories: 100, protein: 3, carbs: 20, fat: 2 },
    { name: 'Frosted Flakes',   calories: 110, protein: 1, carbs: 26, fat: 0 },
    { name: 'Raisin Bran',      calories: 190, protein: 5, carbs: 46, fat: 1 },
    { name: 'Corn Flakes',      calories: 100, protein: 2, carbs: 24, fat: 0 },
    { name: 'Lucky Charms',     calories: 110, protein: 2, carbs: 22, fat: 1 },
    // add whatever Villanova actually stocks
  ],
};

module.exports = { CORRECTIONS, REPLACEMENTS };
