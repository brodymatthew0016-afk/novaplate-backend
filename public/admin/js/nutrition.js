// ---- NUTRITION REVIEW ----

  async function loadStats() {
    const res = await apiFetch('/api/admin/stats');
    if (!res) return;
    const data = await res.json();
    document.getElementById('stat-pending').textContent = data.pending;
    document.getElementById('stat-overridden').textContent = data.overridden;
    document.getElementById('stat-reviewed').textContent = data.reviewed;
    document.getElementById('stat-needs-count').textContent = data.needs_count;
    document.getElementById('stat-total').textContent = data.total;
  }

  function setFilter(status) {
    currentFilter = status;
    ['all', 'pending', 'overridden', 'reviewed', 'needs_count'].forEach(f => {
      document.getElementById(`filter-${f}`).classList.toggle('active',
        (f === 'all' && status === '') || f === status);
    });
    loadItems();
  }

  function debounceLoad() {
    clearTimeout(debounceTimer);
    debounceTimer = setTimeout(loadItems, 300);
  }

  async function loadItems() {
    const tbody = document.getElementById('items-tbody');
    tbody.innerHTML = '<tr><td colspan="11" class="loading">Loading...</td></tr>';
    editingId = null;

    const search = document.getElementById('search-input').value;
    const diningHallId = document.getElementById('hall-filter').value;
    const params = new URLSearchParams();
    if (currentFilter) params.set('status', currentFilter);
    if (diningHallId) params.set('dining_hall_id', diningHallId);
    if (search) params.set('search', search);

    const res = await apiFetch(`/api/admin/menu-items?${params}`);
    if (!res) return;
    allItems = await res.json();
    document.getElementById('count-label').textContent = `${allItems.length} items`;
    renderItems(allItems);
  }

  function renderItems(items) {
    const tbody = document.getElementById('items-tbody');
    if (items.length === 0) {
      tbody.innerHTML = '<tr><td colspan="11" class="empty">No items found.</td></tr>';
      return;
    }
    tbody.innerHTML = items.map(item => renderItemRow(item)).join('');
  }

  function renderItemRow(item) {
    const cal     = renderNutritionCell(item.override_calories,     item.scraped_calories);
    const pro     = renderNutritionCell(item.override_protein,      item.scraped_protein);
    const carb    = renderNutritionCell(item.override_carbs,        item.scraped_carbs);
    const fat     = renderNutritionCell(item.override_fat,          item.scraped_fat);
    const serving = renderNutritionCell(item.override_serving_size, item.scraped_serving_size, true);

    const mfpUrl = `https://www.myfitnesspal.com/food/search?search=${encodeURIComponent(item.name)}`;

    const showQuickReview = item.admin_review_status === 'pending';

    const ingredientsTitle = item.scraped_ingredients ? escHtml(item.scraped_ingredients) : '';
    const ingredientsText = item.scraped_ingredients
      ? escHtml(item.scraped_ingredients)
      : '—';

    return `
      <tr id="row-${item.id}">
        <td>
          <div class="item-name">
            ${escHtml(item.name)}
            <a href="${mfpUrl}" target="_blank" class="mfp-link" title="Search MyFitnessPal">↗ MFP</a>
          </div>
        </td>
        <td>
          <div>${escHtml(item.dining_hall_name)}</div>
          <div class="item-sub">${escHtml(item.station_name)}</div>
        </td>
        <td>${item.meal_type || '—'}</td>
        <td class="nutrition-cell" onclick="startInlineEdit(${item.id}, 'calories', this)" title="Click to edit">${cal}</td>
        <td class="nutrition-cell" onclick="startInlineEdit(${item.id}, 'protein', this)" title="Click to edit">${pro}</td>
        <td class="nutrition-cell" onclick="startInlineEdit(${item.id}, 'carbs', this)" title="Click to edit">${carb}</td>
        <td class="nutrition-cell" onclick="startInlineEdit(${item.id}, 'fat', this)" title="Click to edit">${fat}</td>
        <td class="nutrition-cell" onclick="startInlineEdit(${item.id}, 'serving', this)" title="Click to edit">${serving}</td>
        <td class="ingredients-cell${item.scraped_ingredients ? '' : ' none'}" title="${ingredientsTitle}">${ingredientsText}</td>
        <td><span class="badge ${item.admin_review_status}">${item.admin_review_status}</span></td>
        <td style="white-space:nowrap;">
          <button class="edit-btn" onclick="toggleEdit(${item.id})">Edit</button>
          ${showQuickReview ? `<button class="quick-review-btn" onclick="quickReview(${item.id})" title="Mark as reviewed">✓</button>` : ''}
        </td>
      </tr>
      <tr id="edit-row-${item.id}" class="edit-row" style="display:none;">
        <td colspan="11">${renderEditForm(item)}</td>
      </tr>
    `;
  }

  function renderNutritionCell(override, scraped, isText = false) {
    if (override != null && override !== '') return `<span class="override">${escHtml(String(override))}</span>`;
    if (scraped == null) return `<span class="null-val">missing</span>`;
    return `<span class="scraped">${escHtml(String(scraped))}</span>`;
  }

  function renderEditForm(item) {
    const ingredientsBlock = item.scraped_ingredients
      ? `<div class="ingredients-hint"><strong>Ingredients (scraped, read-only):</strong> ${escHtml(item.scraped_ingredients)}</div>`
      : `<div class="ingredients-hint"><strong>Ingredients:</strong> not available from scraper</div>`;

    const assortedChecked = item.is_assorted ? 'checked' : '';

    const assortedPanel = item.is_assorted ? `
      <div class="assorted-panel" id="assorted-panel-${item.id}" style="margin-top:12px; padding:12px; background:#fff; border:1px solid #dbe4ff; border-radius:8px;">
        <div style="font-size:13px; font-weight:600; margin-bottom:8px;">Dispensed Items</div>
        <div id="children-list-${item.id}">Loading...</div>
        <div style="display:flex; gap:6px; margin-top:8px; flex-wrap:wrap;">
          <input type="text" id="child-name-${item.id}" placeholder="Name" style="width:140px; padding:6px 8px; border:1px solid #ddd; border-radius:6px; font-size:13px;" />
          <input type="number" id="child-cal-${item.id}" placeholder="Cal" style="width:60px; padding:6px 8px; border:1px solid #ddd; border-radius:6px; font-size:13px;" />
          <input type="number" id="child-pro-${item.id}" placeholder="Pro" style="width:60px; padding:6px 8px; border:1px solid #ddd; border-radius:6px; font-size:13px;" />
          <input type="number" id="child-carb-${item.id}" placeholder="Carb" style="width:60px; padding:6px 8px; border:1px solid #ddd; border-radius:6px; font-size:13px;" />
          <input type="number" id="child-fat-${item.id}" placeholder="Fat" style="width:60px; padding:6px 8px; border:1px solid #ddd; border-radius:6px; font-size:13px;" />
          <input type="text" id="child-serving-${item.id}" placeholder="Serving" style="width:90px; padding:6px 8px; border:1px solid #ddd; border-radius:6px; font-size:13px;" />
          <button class="btn-add-station" onclick="addChildItem(${item.id})">+ Add</button>
        </div>
      </div>
    ` : '';

    return `
      <div class="edit-form">
        <div class="field">
          <label>Calories</label>
          <input type="number" id="edit-cal-${item.id}" value="${item.override_calories ?? ''}" placeholder="${item.scraped_calories ?? 'null'}" />
        </div>
        <div class="field">
          <label>Protein (g)</label>
          <input type="number" id="edit-pro-${item.id}" value="${item.override_protein ?? ''}" placeholder="${item.scraped_protein ?? 'null'}" />
        </div>
        <div class="field">
          <label>Carbs (g)</label>
          <input type="number" id="edit-carb-${item.id}" value="${item.override_carbs ?? ''}" placeholder="${item.scraped_carbs ?? 'null'}" />
        </div>
        <div class="field">
          <label>Fat (g)</label>
          <input type="number" id="edit-fat-${item.id}" value="${item.override_fat ?? ''}" placeholder="${item.scraped_fat ?? 'null'}" />
        </div>
        <div class="field">
          <label>Serving Size</label>
          <input type="text" id="edit-serving-${item.id}" class="wide" value="${item.override_serving_size ?? ''}" placeholder="${item.scraped_serving_size ?? 'null'}" />
        </div>
        <div class="field">
          <label>Status</label>
          <select id="edit-status-${item.id}">
            <option value="pending"     ${item.admin_review_status === 'pending'     ? 'selected' : ''}>Pending</option>
            <option value="reviewed"    ${item.admin_review_status === 'reviewed'    ? 'selected' : ''}>Reviewed</option>
            <option value="overridden"  ${item.admin_review_status === 'overridden'  ? 'selected' : ''}>Overridden</option>
            <option value="needs_count" ${item.admin_review_status === 'needs_count' ? 'selected' : ''}>Needs Count</option>
          </select>
        </div>
        <div class="field">
          <label>Assorted</label>
          <input type="checkbox" id="edit-assorted-${item.id}" ${assortedChecked}
            onchange="toggleAssorted(${item.id}, this.checked)" style="width:auto; margin-top:8px;" />
        </div>
      </div>
      ${assortedPanel}
      <div class="scraped-hint">
        Scraped values: cal ${item.scraped_calories ?? 'null'} · pro ${item.scraped_protein ?? 'null'}g · carb ${item.scraped_carbs ?? 'null'}g · fat ${item.scraped_fat ?? 'null'}g · serving ${item.scraped_serving_size ?? 'null'}
      </div>
      ${ingredientsBlock}
      <div class="edit-actions" style="margin-top:12px;">
        <button class="btn-save" onclick="saveItem(${item.id})">Save</button>
        <button class="btn-clear" onclick="clearOverrides(${item.id})">Clear Overrides</button>
        <button class="btn-cancel" onclick="toggleEdit(${item.id})">Cancel</button>
        <span class="save-success" id="save-success-${item.id}">✓ Saved</span>
      </div>
    `;
  }

  function toggleEdit(id) {
    if (editingId && editingId !== id) {
      document.getElementById(`edit-row-${editingId}`).style.display = 'none';
    }
    const editRow = document.getElementById(`edit-row-${id}`);
    const isOpen = editRow.style.display !== 'none';
    editRow.style.display = isOpen ? 'none' : 'table-row';
    editingId = isOpen ? null : id;

    if (!isOpen) {
      const item = allItems.find(i => i.id === id);
      if (item && item.is_assorted) loadChildren(id);
    }
  }

  // ---- ASSORTED ITEMS ----

  async function toggleAssorted(id, checked) {
    const res = await apiFetch(`/api/admin/menu-items/${id}/mark-assorted`, {
      method: 'PUT',
      body: JSON.stringify({ is_assorted: checked })
    });
    if (!res || !res.ok) { alert('Failed to update.'); return; }
    const idx = allItems.findIndex(i => i.id === id);
    if (idx !== -1) allItems[idx].is_assorted = checked;

    // Actually rebuild the edit form's HTML in place so the Dispensed Items panel appears/disappears
    const editRow = document.getElementById(`edit-row-${id}`);
    if (editRow) {
      editRow.querySelector('td').innerHTML = renderEditForm(allItems[idx]);
    }
    if (checked) loadChildren(id);
  }

  async function loadChildren(id) {
    const res = await apiFetch(`/api/admin/menu-items/${id}/children`);
    if (!res) return;
    const children = await res.json();
    const list = document.getElementById(`children-list-${id}`);
    if (!list) return;
    list.innerHTML = children.length === 0
      ? '<span style="color:#aaa; font-size:13px;">No items added yet.</span>'
      : children.map(c => `
          <div style="display:flex; justify-content:space-between; padding:4px 0; font-size:13px; border-bottom:1px solid #f0f0f0;">
            <span>${escHtml(c.name)} — ${c.scraped_calories ?? '—'} cal</span>
            <button class="delete-btn" onclick="deleteChild(${c.id}, ${id})">Delete</button>
          </div>
        `).join('');
  }

  async function addChildItem(parentId) {
    const name = document.getElementById(`child-name-${parentId}`).value.trim();
    if (!name) return alert('Name required.');
    const body = {
      name,
      calories: document.getElementById(`child-cal-${parentId}`).value || null,
      protein: document.getElementById(`child-pro-${parentId}`).value || null,
      carbs: document.getElementById(`child-carb-${parentId}`).value || null,
      fat: document.getElementById(`child-fat-${parentId}`).value || null,
      serving_size: document.getElementById(`child-serving-${parentId}`).value || null,
    };
    const res = await apiFetch(`/api/admin/menu-items/${parentId}/children`, {
      method: 'POST', body: JSON.stringify(body)
    });
    if (!res || !res.ok) { alert('Failed to add.'); return; }
    ['name','cal','pro','carb','fat','serving'].forEach(f => document.getElementById(`child-${f}-${parentId}`).value = '');
    await loadChildren(parentId);
  }

  async function deleteChild(childId, parentId) {
    if (!confirm('Delete this dispensed item?')) return;
    const res = await apiFetch(`/api/admin/menu-items/${childId}`, { method: 'DELETE' });
    if (!res || !res.ok) { alert('Delete failed.'); return; }
    await loadChildren(parentId);
  }

  async function quickReview(id) {
    const item = allItems.find(i => i.id === id);
    if (!item) return;
    const body = {
      override_calories:     item.override_calories     ?? null,
      override_protein:      item.override_protein      ?? null,
      override_carbs:        item.override_carbs        ?? null,
      override_fat:          item.override_fat          ?? null,
      override_serving_size: item.override_serving_size ?? null,
      admin_review_status:   'reviewed',
    };
    const res = await apiFetch(`/api/admin/menu-items/${id}`, { method: 'PUT', body: JSON.stringify(body) });
    if (!res || !res.ok) { alert('Save failed.'); return; }
    const updated = await res.json();
    const idx = allItems.findIndex(i => i.id === id);
    if (idx !== -1) { allItems[idx] = { ...allItems[idx], ...updated }; updateRow(allItems[idx]); }
    await loadStats();
  }

  function startInlineEdit(id, field, cell) {
    if (cell.querySelector('input')) return;

    const item = allItems.find(i => i.id === id);
    if (!item) return;

    const fieldMap = {
      calories: 'override_calories',
      protein:  'override_protein',
      carbs:    'override_carbs',
      fat:      'override_fat',
      serving:  'override_serving_size',
    };
    const scrapedMap = {
      calories: 'scraped_calories',
      protein:  'scraped_protein',
      carbs:    'scraped_carbs',
      fat:      'scraped_fat',
      serving:  'scraped_serving_size',
    };

    const currentVal = item[fieldMap[field]] ?? '';
    const placeholder = item[scrapedMap[field]] ?? '';
    const isText = field === 'serving';

    const original = cell.innerHTML;
    cell.innerHTML = `<input
      type="${isText ? 'text' : 'number'}"
      value="${escHtml(String(currentVal))}"
      placeholder="${escHtml(String(placeholder))}"
      style="width:${isText ? '110px' : '70px'}; padding:3px 6px; border:1px solid #003087; border-radius:4px; font-size:13px;"
      onclick="event.stopPropagation()"
    />`;

    const input = cell.querySelector('input');
    input.focus();
    input.select();

    let committed = false;

    async function commit() {
      if (committed) return;
      committed = true;
      const newVal = input.value.trim();
      const body = {
        override_calories:     item.override_calories     ?? null,
        override_protein:      item.override_protein      ?? null,
        override_carbs:        item.override_carbs        ?? null,
        override_fat:          item.override_fat          ?? null,
        override_serving_size: item.override_serving_size ?? null,
        admin_review_status:   item.admin_review_status,
      };
      body[fieldMap[field]] = newVal !== '' ? (isText ? newVal : parseInt(newVal)) : null;

      const res = await apiFetch(`/api/admin/menu-items/${id}`, { method: 'PUT', body: JSON.stringify(body) });
      if (!res || !res.ok) { cell.innerHTML = original; alert('Save failed.'); return; }
      const updated = await res.json();
      const idx = allItems.findIndex(i => i.id === id);
      if (idx !== -1) { allItems[idx] = { ...allItems[idx], ...updated }; updateRow(allItems[idx]); }
      await loadStats();
    }

    function cancel() {
      if (committed) return;
      cell.innerHTML = original;
    }

    input.addEventListener('keydown', e => {
      if (e.key === 'Enter')  { e.preventDefault(); commit(); }
      if (e.key === 'Escape') { e.preventDefault(); committed = true; cancel(); }
    });
    input.addEventListener('blur', () => setTimeout(cancel, 150));
  }

  async function saveItem(id) {
    const cal     = document.getElementById(`edit-cal-${id}`).value;
    const pro     = document.getElementById(`edit-pro-${id}`).value;
    const carb    = document.getElementById(`edit-carb-${id}`).value;
    const fat     = document.getElementById(`edit-fat-${id}`).value;
    const serving = document.getElementById(`edit-serving-${id}`).value;
    const status  = document.getElementById(`edit-status-${id}`).value;

    const body = {
      override_calories:     cal     !== '' ? parseInt(cal)  : null,
      override_protein:      pro     !== '' ? parseInt(pro)  : null,
      override_carbs:        carb    !== '' ? parseInt(carb) : null,
      override_fat:          fat     !== '' ? parseInt(fat)  : null,
      override_serving_size: serving !== '' ? serving        : null,
      admin_review_status:   status,
    };

    const res = await apiFetch(`/api/admin/menu-items/${id}`, { method: 'PUT', body: JSON.stringify(body) });
    if (!res || !res.ok) { alert('Save failed.'); return; }
    const updated = await res.json();

    const idx = allItems.findIndex(i => i.id === id);
    if (idx !== -1) { allItems[idx] = { ...allItems[idx], ...updated }; updateRow(allItems[idx]); }

    const successEl = document.getElementById(`save-success-${id}`);
    successEl.classList.add('show');
    setTimeout(() => successEl.classList.remove('show'), 2000);
    await loadStats();
  }

  async function clearOverrides(id) {
    if (!confirm('Clear all overrides and revert to scraped values?')) return;
    const res = await apiFetch(`/api/admin/menu-items/${id}/overrides`, { method: 'DELETE' });
    if (!res || !res.ok) { alert('Failed.'); return; }
    const updated = await res.json();

    const idx = allItems.findIndex(i => i.id === id);
    if (idx !== -1) { allItems[idx] = { ...allItems[idx], ...updated }; updateRow(allItems[idx]); }

    document.getElementById(`edit-row-${id}`).style.display = 'none';
    editingId = null;
    await loadStats();
  }

  function updateRow(item) {
    const row = document.getElementById(`row-${item.id}`);
    if (!row) return;
    const tempDiv = document.createElement('tbody');
    tempDiv.innerHTML = renderItemRow(item);
    row.outerHTML = tempDiv.querySelector(`#row-${item.id}`).outerHTML;
    const editRow = document.getElementById(`edit-row-${item.id}`);
    if (editRow) {
      const newEditRow = tempDiv.querySelector(`#edit-row-${item.id}`);
      if (newEditRow) editRow.outerHTML = newEditRow.outerHTML;
    }
  }