// ---- USERS ----

  let usersDebounceTimer = null;

  function debounceLoadUsers() {
    clearTimeout(usersDebounceTimer);
    usersDebounceTimer = setTimeout(loadUsers, 300);
  }

  async function loadUsers() {
    const tbody = document.getElementById('users-tbody');
    tbody.innerHTML = '<tr><td colspan="7" class="loading">Loading...</td></tr>';
    const search = document.getElementById('users-search-input').value.trim();
    const qs = search ? `?search=${encodeURIComponent(search)}` : '';
    const res = await apiFetch(`/api/admin/users${qs}`);
    if (!res) return;
    const users = await res.json();
    renderUsersTable(users);
  }

  function renderUsersTable(users) {
    const tbody = document.getElementById('users-tbody');
    document.getElementById('users-count-label').textContent = `${users.length} user${users.length === 1 ? '' : 's'}`;
    if (users.length === 0) {
      tbody.innerHTML = '<tr><td colspan="7" class="empty">No users found.</td></tr>';
      return;
    }
    tbody.innerHTML = users.map(u => `
      <tr id="user-row-${u.id}">
        <td>${escHtml(u.email)}</td>
        <td>${u.daily_calorie_goal ?? '—'}</td>
        <td>${u.meal_log_count}</td>
        <td>${timeAgo(u.last_logged_at)}</td>
        <td>${new Date(u.created_at).toLocaleDateString()}</td>
        <td><span class="badge ${u.is_admin ? 'badge-true' : 'badge-false'}">${u.is_admin ? 'True' : 'False'}</span></td>
        <td><button class="btn-toggle-admin" onclick="toggleAdmin(${u.id}, ${!u.is_admin})">${u.is_admin ? 'Revoke Admin' : 'Make Admin'}</button></td>
      </tr>
    `).join('');
  }

  async function toggleAdmin(id, newValue) {
    const res = await apiFetch(`/api/admin/users/${id}/admin`, {
      method: 'PATCH',
      body: JSON.stringify({ is_admin: newValue })
    });
    if (!res) return;
    const data = await res.json();
    if (!res.ok) { alert(data.error || 'Failed to update user.'); return; }
    loadUsers();
  }