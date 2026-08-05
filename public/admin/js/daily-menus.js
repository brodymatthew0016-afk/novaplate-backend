// ---- DAILY MENUS ----

  function loadDailyMenuTab() {
    const dateInput = document.getElementById('daily-date-input');
    if (!dateInput.value) {
      // Default to today, in local time, formatted as yyyy-mm-dd for <input type="date">.
      const now = new Date();
      const yyyy = now.getFullYear();
      const mm = String(now.getMonth() + 1).padStart(2, '0');
      const dd = String(now.getDate()).padStart(2, '0');
      dateInput.value = `${yyyy}-${mm}-${dd}`;
    }
    const select = document.getElementById('daily-hall-select');
    if (!select.value && variableHalls.length > 0) {
      select.value = variableHalls[0].id;
    }
    loadDailyMenu();
  }

  async function loadDailyMenu() {
    const hallId = document.getElementById('daily-hall-select').value;
    const date = document.getElementById('daily-date-input').value;
    dailySelectedHallId = hallId;
    const tbody = document.getElementById('daily-tbody');
    if (!hallId || !date) {
      tbody.innerHTML = '<tr><td colspan="9" class="empty">Pick a dining hall and date above.</td></tr>';
      document.getElementById('daily-count-label').textContent = '';
      return;
    }
    tbody.innerHTML = '<tr><td colspan="9" class="loading">Loading...</td></tr>';
    const res = await apiFetch(`/api/admin/daily-menu?dining_hall_id=${hallId}&date=${date}`);
    if (!res) return;
    const rows = await res.json();
    renderDailyMenuTable(rows);
  }

  function renderDailyMenuTable(rows) {
    const tbody = document.getElementById('daily-tbody');
    document.getElementById('daily-count-label').textContent = `${rows.length} item${rows.length === 1 ? '' : 's'} scheduled`;
    if (rows.length === 0) {
      tbody.innerHTML = '<tr><td colspan="9" class="empty">Nothing scheduled for this hall on this date yet.</td></tr>';
      return;
    }
    tbody.innerHTML = rows.map(r => `
      <tr>
        <td class="item-name">${escHtml(r.name)}</td>
        <td>${escHtml(r.station_name)}</td>
        <td>${escHtml(r.meal_type)}</td>
        <td>${r.calories ?? '—'}</td>
        <td>${r.protein ?? '—'}</td>
        <td>${r.carbs ?? '—'}</td>
        <td>${r.fat ?? '—'}</td>
        <td>${escHtml(r.serving_size)}</td>
        <td><button class="delete-btn" onclick="removeDailyMenuItem(${r.schedule_id})">Remove</button></td>
      </tr>
    `).join('');
  }

  async function removeDailyMenuItem(scheduleId) {
    const res = await apiFetch(`/api/admin/daily-menu/${scheduleId}`, { method: 'DELETE' });
    if (!res) return;
    if (!res.ok) { alert('Failed to remove item.'); return; }
    loadDailyMenu();
  }

  function debounceDailySearch() {
    clearTimeout(dailyDebounceTimer);
    dailyDebounceTimer = setTimeout(searchDailyAddItems, 250);
  }

  async function searchDailyAddItems() {
    const query = document.getElementById('daily-add-search').value.trim();
    const resultsEl = document.getElementById('daily-add-results');
    if (!query || !dailySelectedHallId) {
      resultsEl.style.display = 'none';
      resultsEl.innerHTML = '';
      return;
    }
    const res = await apiFetch(`/api/admin/menu-items?dining_hall_id=${dailySelectedHallId}&search=${encodeURIComponent(query)}`);
    if (!res) return;
    const items = await res.json();
    if (items.length === 0) {
      resultsEl.innerHTML = '<div class="daily-add-result-row"><span>No matching items in this hall.</span></div>';
      resultsEl.style.display = 'block';
      return;
    }
    resultsEl.innerHTML = items.slice(0, 20).map(item => `
      <div class="daily-add-result-row" onclick="addDailyMenuItem(${item.id}, '${escHtml(item.name).replace(/'/g, "\\'")}')">
        <span>${escHtml(item.name)}</span>
        <span class="meta">${escHtml(item.station_name)}</span>
      </div>
    `).join('');
    resultsEl.style.display = 'block';
  }

  async function addDailyMenuItem(menuItemId, name) {
    const date = document.getElementById('daily-date-input').value;
    const res = await apiFetch('/api/admin/daily-menu', {
      method: 'POST',
      body: JSON.stringify({ menu_item_id: menuItemId, date })
    });
    if (!res) return;
    if (!res.ok) { const data = await res.json(); alert(data.error || 'Failed to add item.'); return; }
    document.getElementById('daily-add-search').value = '';
    document.getElementById('daily-add-results').style.display = 'none';
    loadDailyMenu();
  }