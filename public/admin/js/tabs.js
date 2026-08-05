// ---- TABS ----

  function switchTab(tab) {
    document.querySelectorAll('.tab-btn').forEach((btn, i) => {
      btn.classList.toggle('active',
        (i === 0 && tab === 'nutrition') ||
        (i === 1 && tab === 'fixed') ||
        (i === 2 && tab === 'daily') ||
        (i === 3 && tab === 'health') ||
        (i === 4 && tab === 'users')
      );
    });
    document.getElementById('tab-nutrition').classList.toggle('active', tab === 'nutrition');
    document.getElementById('tab-fixed').classList.toggle('active', tab === 'fixed');
    document.getElementById('tab-daily').classList.toggle('active', tab === 'daily');
    document.getElementById('tab-health').classList.toggle('active', tab === 'health');
    document.getElementById('tab-users').classList.toggle('active', tab === 'users');
    if (tab === 'fixed') loadFixedMenusTab();
    if (tab === 'daily') loadDailyMenuTab();
    if (tab === 'health') loadSystemHealth();
    if (tab === 'users') loadUsers();
  }