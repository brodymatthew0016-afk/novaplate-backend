// ---- HALL TABS ----

  function switchHall(hall) {
    currentHall = hall;
    document.getElementById('hall-btn-nova').classList.toggle('active', hall === 'nova');
    document.getElementById('hall-btn-connelly').classList.toggle('active', hall === 'connelly');

    const hallName = hall === 'nova' ? 'Café Nova' : 'Connelly Center';
    document.getElementById('stations-panel-title').textContent = `${hallName} Stations`;
    document.getElementById('add-item-title').textContent = `Add Item to ${hallName}`;
    document.getElementById('fixed-items-title').textContent = `${hallName} Items`;

    renderStations(hall);
    populateStationDropdown(hall);
    renderFixedItems(hall);
  }

  // ---- FIXED MENUS TAB ----

  async function loadFixedMenusTab() {
    await loadStationsForFixedHalls();
    renderStations(currentHall);
    populateStationDropdown(currentHall);
    await loadFixedItems('nova');
    await loadFixedItems('connelly');
    renderFixedItems(currentHall);
  }

  async function loadStationsForFixedHalls() {
    for (const key of ['nova', 'connelly']) {
      const hall = fixedHalls[key];
      if (!hall) continue;
      const res = await apiFetch(`/api/dining-halls/${hall.id}/stations`);
      if (!res) continue;
      stationsByHall[key] = await res.json();
    }
  }

  // ---- STATIONS ----

  function renderStations(hall) {
    const list = document.getElementById('station-list');
    const stations = stationsByHall[hall] || [];

    if (stations.length === 0) {
      list.innerHTML = '<div style="padding: 16px; font-size: 13px; color: #aaa; text-align: center;">No stations yet.</div>';
      return;
    }

    list.innerHTML = stations.map(s => `
      <div class="station-item">
        <span>${escHtml(s.name)}</span>
        <button class="station-delete-btn" onclick="deleteStation(${s.id}, '${hall}')">Remove</button>
      </div>
    `).join('');
  }

  function populateStationDropdown(hall) {
    const select = document.getElementById('new-item-station');
    select.innerHTML = '<option value="">Select station...</option>';
    const stations = stationsByHall[hall] || [];
    stations.forEach(s => {
      const opt = document.createElement('option');
      opt.value = s.id;
      opt.textContent = s.name;
      select.appendChild(opt);
    });
  }

  async function addStation() {
    const input = document.getElementById('new-station-name');
    const msgEl = document.getElementById('station-msg');
    const name = input.value.trim();
    msgEl.textContent = '';

    if (!name) { msgEl.innerHTML = '<span class="form-error">Station name is required.</span>'; return; }

    const hall = fixedHalls[currentHall];
    if (!hall) { msgEl.innerHTML = '<span class="form-error">Hall not found.</span>'; return; }

    const res = await apiFetch('/api/admin/stations', {
      method: 'POST',
      body: JSON.stringify({ dining_hall_id: hall.id, name })
    });

    if (!res || !res.ok) {
      const err = await res.json();
      msgEl.innerHTML = `<span class="form-error">${err.error || 'Failed to add station.'}</span>`;
      return;
    }

    const newStation = await res.json();
    stationsByHall[currentHall].push(newStation);
    stationsByHall[currentHall].sort((a, b) => a.name.localeCompare(b.name));

    input.value = '';
    msgEl.innerHTML = '<span class="form-success">✓ Station added.</span>';
    setTimeout(() => msgEl.textContent = '', 3000);

    renderStations(currentHall);
    populateStationDropdown(currentHall);
  }

  async function deleteStation(id, hall) {
    if (!confirm('Delete this station? All items in it will also be deleted.')) return;
    const res = await apiFetch(`/api/admin/stations/${id}`, { method: 'DELETE' });
    if (!res || !res.ok) { alert('Delete failed.'); return; }

    stationsByHall[hall] = stationsByHall[hall].filter(s => s.id !== id);
    renderStations(hall);
    populateStationDropdown(hall);
    await loadFixedItems(hall);
    renderFixedItems(hall);
  }

  // ---- FIXED ITEMS ----

  async function loadFixedItems(hall) {
    const hallObj = fixedHalls[hall];
    if (!hallObj) return;
    const res = await apiFetch(`/api/admin/fixed-items?dining_hall_id=${hallObj.id}`);
    if (!res) return;
    fixedItemsByHall[hall] = await res.json();
  }

  function renderFixedItems(hall) {
    const tbody = document.getElementById('fixed-items-tbody');
    const items = fixedItemsByHall[hall] || [];
    document.getElementById('fixed-items-count').textContent = `${items.length} items`;

    if (items.length === 0) {
      tbody.innerHTML = '<tr><td colspan="10" class="empty">No items yet. Add one above.</td></tr>';
      return;
    }

    const grouped = {};
    items.forEach(item => {
      const key = item.station_name || 'No Station';
      if (!grouped[key]) grouped[key] = [];
      grouped[key].push(item);
    });

    let html = '';
    Object.entries(grouped).forEach(([stationName, stationItems]) => {
      html += `<tr><td colspan="10" class="station-group-label">${escHtml(stationName)}</td></tr>`;
      stationItems.forEach(item => {
        const cal = item.override_calories ?? item.scraped_calories;
        const pro = item.override_protein ?? item.scraped_protein;
        const carb = item.override_carbs ?? item.scraped_carbs;
        const fat = item.override_fat ?? item.scraped_fat;
        const serving = item.override_serving_size ?? item.scraped_serving_size;
        const ingredientsTitle = item.scraped_ingredients ? escHtml(item.scraped_ingredients) : '';
        const ingredientsText = item.scraped_ingredients
          ? escHtml(item.scraped_ingredients)
          : '<span style="color:#bbb;font-style:italic;">—</span>';
        html += `
          <tr>
            <td><div class="item-name">${escHtml(item.name)}</div></td>
            <td>${escHtml(item.station_name)}</td>
            <td>${item.meal_type || '—'}</td>
            <td>${cal ?? '<span style="color:#e53e3e;font-style:italic">—</span>'}</td>
            <td>${pro ?? '—'}</td>
            <td>${carb ?? '—'}</td>
            <td>${fat ?? '—'}</td>
            <td>${escHtml(serving) || '—'}</td>
            <td class="ingredients-cell${item.scraped_ingredients ? '' : ' none'}" title="${ingredientsTitle}">${ingredientsText}</td>
            <td><button class="delete-btn" onclick="deleteFixedItem(${item.id}, '${hall}')">Delete</button></td>
          </tr>
        `;
      });
    });

    tbody.innerHTML = html;
  }

  async function addFixedItem() {
    const msgEl = document.getElementById('add-item-msg');
    msgEl.textContent = '';

    const name = document.getElementById('new-item-name').value.trim();
    const stationId = document.getElementById('new-item-station').value;
    const mealType = 'all';
    const cal = document.getElementById('new-item-cal').value;
    const pro = document.getElementById('new-item-pro').value;
    const carb = document.getElementById('new-item-carb').value;
    const fat = document.getElementById('new-item-fat').value;
    const serving = document.getElementById('new-item-serving').value.trim();

    if (!name) { msgEl.innerHTML = '<span class="form-error">Item name is required.</span>'; return; }
    if (!stationId) { msgEl.innerHTML = '<span class="form-error">Please select a station.</span>'; return; }

    const body = {
      station_id: parseInt(stationId),
      name,
      meal_type: mealType,
      calories: cal !== '' ? parseInt(cal) : null,
      protein: pro !== '' ? parseInt(pro) : null,
      carbs: carb !== '' ? parseInt(carb) : null,
      fat: fat !== '' ? parseInt(fat) : null,
      serving_size: serving || null,
    };

    const res = await apiFetch('/api/admin/fixed-items', {
      method: 'POST',
      body: JSON.stringify(body)
    });

    if (!res || !res.ok) {
      const err = await res.json();
      msgEl.innerHTML = `<span class="form-error">${err.error || 'Failed to add item.'}</span>`;
      return;
    }

    document.getElementById('new-item-name').value = '';
    document.getElementById('new-item-cal').value = '';
    document.getElementById('new-item-pro').value = '';
    document.getElementById('new-item-carb').value = '';
    document.getElementById('new-item-fat').value = '';
    document.getElementById('new-item-serving').value = '';
    msgEl.innerHTML = '<span class="form-success">✓ Item added.</span>';
    setTimeout(() => msgEl.textContent = '', 3000);

    await loadFixedItems(currentHall);
    renderFixedItems(currentHall);
  }

  async function deleteFixedItem(id, hall) {
    if (!confirm('Delete this item?')) return;
    const res = await apiFetch(`/api/admin/fixed-items/${id}`, { method: 'DELETE' });
    if (!res || !res.ok) { alert('Delete failed.'); return; }
    await loadFixedItems(hall);
    renderFixedItems(hall);
  }