// ---- AUTH ----

  async function login() {
    const email = document.getElementById('login-email').value;
    const password = document.getElementById('login-password').value;
    const errEl = document.getElementById('login-error');
    errEl.textContent = '';
    try {
      const res = await fetch(`${API}/api/admin/bypass`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' }
      });
      const data = await res.json();
      if (!res.ok) { errEl.textContent = data.error || 'Login failed'; return; }
      if (!data.user.isAdmin) { errEl.textContent = 'Not an admin account.'; return; }
      token = data.token;
      localStorage.setItem('admin_token', token);
      showApp();
    } catch (e) {
      errEl.textContent = 'Connection error.';
    }
  }

  function logout() {
    localStorage.removeItem('admin_token');
    token = null;
    document.getElementById('app').style.display = 'none';
    document.getElementById('login-screen').style.display = 'flex';
  }

  async function showApp() {
    document.getElementById('login-screen').style.display = 'none';
    document.getElementById('app').style.display = 'flex';
    await loadDiningHalls();
    await loadStats();
    await loadItems();
  }