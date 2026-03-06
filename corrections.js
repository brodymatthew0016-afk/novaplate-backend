const CORRECTIONS = {
  'Chipolte Sour Cream':  { calories: 60,  protein: 1, carbs: 2, fat: 5 },
  'SP SOUR CREAM':        { calories: 60,  protein: 1, carbs: 2, fat: 5 },
  'Olive Oil':            { calories: 120, protein: 0, carbs: 0, fat: 14 },
  'Spaghetti Sauce':      { calories: 80,  protein: 2, carbs: 12, fat: 2 },
  'Organic Pumpkin Seed': { calories: 70,  protein: 4, carbs: 2, fat: 6 },
  'Roasted Shelled Sunflower Seed': { calories: 80, protein: 3, carbs: 3, fat: 7 },
  'Overnight Oats':       { calories: 180, protein: 6, carbs: 30, fat: 4 },
  'Penne Pasta':          { calories: 200, protein: 7, carbs: 42, fat: 1 },
  '100% Natural Rolled Oatmeal': { calories: 150, protein: 5, carbs: 27, fat: 3 },
  '100% Whole Grain Bread': { calories: 90, protein: 4, carbs: 18, fat: 2 },
  'Adobo Chicken': { calories: 190, protein: 28, carbs: 2, fat: 8 },
  'Basmati Rice': { calories: 205, protein: 4, carbs: 44, fat: 0 },
  'Whipped Butter': { calories: 80, protein: 0, carbs: 0, fat: 9 },
  'Whipped Cream Cheese': { calories: 65, protein: 1, carbs: 2, fat: 6 },
  'Tortilla Chips': { calories: 140, protein: 2, carbs: 19, fat: 7 },
  'Tikka Masala': { calories: 100, protein: 2, carbs: 10, fat: 6 },
  'Vanilla Soft Serve Ice Cream': { calories: 240, protein: 6, carbs: 38, fat: 8 },
  'Cilantro Lime Rice': { calories: 200, protein: 4, carbs: 44, fat: 0 },
  'Shredded Lettuce': { calories: 5, protein: 0, carbs: 1, fat: 0 },
  'Cheddar Cheese': { calories: 110, protein: 7, carbs: 0, fat: 9 },
  // add more as you find them
};


const REPLACEMENTS = {
  'SP SOUR CREAM': [{ name: 'Sour Cream', calories: 60, protein: 1, carbs: 2, fat: 5 }],
  'Cooked  to order Stir Fry': [{ name: 'Cooked to order Stir Fry', calories: 0, protein: 0, carbs: 0, fat: 0 }],
  'Eggs and Omelets': [{ name: 'Cooked to order Eggs & Omelets', calories: 0, protein: 0, carbs: 0, fat: 0 }],
};
module.exports = { CORRECTIONS, REPLACEMENTS };