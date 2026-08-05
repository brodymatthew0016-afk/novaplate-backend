const API = '';

  let token = localStorage.getItem('admin_token');

  let currentFilter = '';

  let editingId = null;

  let debounceTimer = null;

  let allItems = [];

  let currentHall = 'nova';

  let fixedHalls = {};

  let stationsByHall = { nova: [], connelly: [] };

  let fixedItemsByHall = { nova: [], connelly: [] };

  let variableHalls = [];

  let dailyDebounceTimer = null;

  let dailySelectedHallId = null;

  function authHeaders() {
    return { 'Content-Type': 'application/json', 'Authorization': `Bearer ${token}` };
  }

  async function apiFetch(path, options = {}) {
    const res = await fetch(`${API}${path}`, { ...options, headers: authHeaders() });
    if (res.status === 403) { logout(); return null; }
    return res;
  }

  // ---- LOAD DINING HALLS ----

  async function loadDiningHalls() {
    const res = await apiFetch('/api/dining-halls');
    if (!res) return;
    const halls = await res.json();

    const select = document.getElementById('hall-filter');
    halls.forEach(h => {
      const opt = document.createElement('option');
      opt.value = h.id;
      opt.textContent = h.name;
      select.appendChild(opt);
    });

    halls.forEach(h => {
      if (h.name === 'Café Nova') fixedHalls['nova'] = h;
      if (h.name === 'Connelly Center') fixedHalls['connelly'] = h;
    });

    variableHalls = halls.filter(h => h.type === 'variable');
    const dailySelect = document.getElementById('daily-hall-select');
    variableHalls.forEach(h => {
      const opt = document.createElement('option');
      opt.value = h.id;
      opt.textContent = h.name;
      dailySelect.appendChild(opt);
    });
  }