// ---- SYSTEM HEALTH ----

  async function loadSystemHealth() {
    const grid = document.getElementById('health-grid');
    grid.innerHTML = '<div class="loading" style="padding: 20px;">Loading...</div>';
    const res = await apiFetch('/api/admin/system-health');
    if (!res) return;
    const halls = await res.json();
    renderHealthCards(halls);
  }

  function renderHealthCards(halls) {
    const grid = document.getElementById('health-grid');
    if (halls.length === 0) {
      grid.innerHTML = '<div class="empty" style="padding: 20px;">No dining halls found.</div>';
      return;
    }

    grid.innerHTML = halls.map(h => {
      const statusMins = h.status_updated_at ? (Date.now() - new Date(h.status_updated_at).getTime()) / 60000 : Infinity;
      const hasTodayItems = Number(h.today_item_count) > 0;

      // Green: status pinged in the last 20 min AND today's menu is populated.
      // Yellow: status is a bit stale (20min-2hr) or menu missing but hall not open yet.
      // Red: status hasn't updated in 2+ hours, or hall is open with no menu scheduled today.
      let level = 'ok';
      if (statusMins > 120 || (h.is_open && !hasTodayItems)) level = 'stale';
      else if (statusMins > 20 || !hasTodayItems) level = 'warn';

      return `
        <div class="health-card ${level}">
          <div class="health-card-header">
            <h4>${escHtml(h.name)}</h4>
            <div class="status-dot ${level}"></div>
          </div>
          <div class="health-row"><span>Open now</span><span>${h.is_open ? 'Yes' : 'No'}</span></div>
          <div class="health-row"><span>Status text</span><span>${escHtml(h.status_text)}</span></div>
          <div class="health-row"><span>Status pinged</span><span>${timeAgo(h.status_updated_at)}</span></div>
          <div class="health-row"><span>Items scheduled today</span><span>${h.today_item_count}</span></div>
          <div class="health-row"><span>Menu last updated</span><span>${timeAgo(h.last_scheduled_at)}</span></div>
        </div>
      `;
    }).join('');
  }