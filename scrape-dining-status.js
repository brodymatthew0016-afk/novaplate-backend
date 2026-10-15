require('dotenv').config();
const { Pool } = require('pg');
const ical = require('node-ical');

const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
  ssl: { rejectUnauthorized: false }
});

// Extracted directly from the loadHalls([...]) call embedded in
// open-now.html's page source. The site itself determines open/closed
// by checking whether "now" falls inside an event on each hall's public
// Google Calendar — we do the same thing directly against that calendar.
const HALL_CALENDARS = {
  'Café Nova': 'aqhuvmluuelqpt6v2fmmv14h5o@group.calendar.google.com',
  'Donahue Hall': 'q0qu1r1orcc3cebe6d046adtn8@group.calendar.google.com',
  'Dougherty Hall': '85ukpjhd8a90dsmu5lnl2t93gk@group.calendar.google.com',
  // Connelly Center houses multiple venues; using Nova Noodle Company's
  // calendar as the representative status per user decision.
  'Connelly Center': '921737glfilku8man2unra3q6c@group.calendar.google.com',
  'Holy Grounds at Drosdick Hall': '69bhpt1s5f7rttqkcssc3jlts8@group.calendar.google.com',
  'Holy Grounds at Falvey': 'o3iuqndl1keeomct734q8320os@group.calendar.google.com',
  'Holy Grounds @ Bartley Hall': 't0pb4sov6v676snr837u5un950@group.calendar.google.com',
  'Law School Cafe': 'mj88gbgamipgeqb1k86vjh6jgg@group.calendar.google.com',
  'Legal Grounds': '425su4sk6mqjv1heu6ki3v0504@group.calendar.google.com',
  'Nova Noodle Company': '921737glfilku8man2unra3q6c@group.calendar.google.com',
  '2nd Storey Market': '0ierrtetsvb0mfl3jt347pgvm0@group.calendar.google.com',
  'St. Augustine Cafe': 'earlns6lqjuht547040sn5dsf0@group.calendar.google.com',
  "St. Mary's Dining Hall": 'l6pa6m32m61nsaj4uk6t0mnacg@group.calendar.google.com',
  'The Recovery Room': 'h0vovcfgevl55jjft0a4ars5gs@group.calendar.google.com',
  'The Court at Donahue': 'qe81pj9vbnkl13pj53d03jbo00@group.calendar.google.com',
  'The Curley Exchange': 't0hir438dqguv13q04dgh9bn9k@group.calendar.google.com',
  'Holy Grounds at the Commons': 'doovskkio83cort59c8jbtfpug@group.calendar.google.com',
  'Ground State at Mendel Hall': 'f65dd5d985aaae0397e449fc908479dd2dff41035e236e9dd2ecebd6242f338e@group.calendar.google.com',
  'Holy Grounds Express @ Donahue Market': '5983f41ebdefc4019eeaa2bc280b1a4cce5a5641361e0bc59432bb996372d5a1@group.calendar.google.com',
};

// How many days of hours to store. The API computes open/closed from these
// stored windows, so this only needs to cover the gap between syncs (with
// plenty of slack in case a sync fails).
const DAYS_AHEAD = 7;

// Fetches a hall's public Google Calendar and returns every open window
// from the start of today (Eastern) through DAYS_AHEAD days out.
async function getHallWindows(calendarId) {
  const url = `https://calendar.google.com/calendar/ical/${encodeURIComponent(calendarId)}/public/basic.ics`;
  const data = await ical.async.fromURL(url);

  const now = new Date();

  // "Today" must be Villanova's calendar day (Eastern), not the server's
  // local day — on GitHub Actions (UTC) these differ by 4-5 hours, which
  // would otherwise clip early-morning/late-night events out of the
  // search. Compute the actual UTC offset for Eastern time right now
  // (handles EDT/-4 vs EST/-5 automatically).
  const offsetParts = new Intl.DateTimeFormat('en-US', {
    timeZone: 'America/New_York',
    timeZoneName: 'shortOffset',
  }).formatToParts(now);
  const offsetLabel = offsetParts.find(p => p.type === 'timeZoneName').value; // e.g. "GMT-4"
  const offsetHours = parseInt(offsetLabel.replace('GMT', ''), 10) || -5; // fallback EST
  const offsetStr = `${offsetHours <= 0 ? '-' : '+'}${String(Math.abs(offsetHours)).padStart(2, '0')}:00`;

  const easternDateStr = now.toLocaleDateString('en-CA', { timeZone: 'America/New_York' }); // YYYY-MM-DD
  const windowStart = new Date(`${easternDateStr}T00:00:00${offsetStr}`);
  const windowEnd = new Date(windowStart.getTime() + DAYS_AHEAD * 24 * 60 * 60 * 1000);

  const windows = [];

  for (const key in data) {
    const ev = data[key];
    if (ev.type !== 'VEVENT') continue;
    const label = ev.summary || null;

    if (ev.rrule) {
      // Recurring event — expand its occurrences in the window, skipping
      // any dates the calendar has cancelled (EXDATE).
      const durationMs = new Date(ev.end).getTime() - new Date(ev.start).getTime();
      const excluded = new Set(Object.values(ev.exdate || {}).map(d => new Date(d).getTime()));
      for (const occStart of ev.rrule.between(windowStart, windowEnd, true)) {
        if (excluded.has(occStart.getTime())) continue;
        windows.push({ opensAt: occStart, closesAt: new Date(occStart.getTime() + durationMs), label });
      }
    } else {
      const start = new Date(ev.start);
      const end = new Date(ev.end);
      if (end >= windowStart && start <= windowEnd) {
        windows.push({ opensAt: start, closesAt: end, label });
      }
    }
  }

  return windows;
}

// Replaces a hall's stored hours with a fresh set, in one transaction so the
// API never sees a half-written schedule.
async function saveHallWindows(client, diningHallId, windows) {
  await client.query('BEGIN');
  try {
    await client.query('DELETE FROM dining_hall_hours WHERE dining_hall_id = $1', [diningHallId]);
    for (const w of windows) {
      await client.query(
        'INSERT INTO dining_hall_hours (dining_hall_id, opens_at, closes_at, label) VALUES ($1, $2, $3, $4)',
        [diningHallId, w.opensAt, w.closesAt, w.label]
      );
    }
    // status_updated_at now means "hours last synced" — the API uses it to
    // know this hall's status should be computed from dining_hall_hours.
    await client.query(
      'UPDATE dining_halls SET status_updated_at = CURRENT_TIMESTAMP WHERE id = $1',
      [diningHallId]
    );
    await client.query('COMMIT');
  } catch (err) {
    await client.query('ROLLBACK');
    throw err;
  }
}

async function main() {
  const client = await pool.connect();
  try {
    const hallsResult = await client.query('SELECT id, name FROM dining_halls');

    for (const hall of hallsResult.rows) {
      const calendarId = HALL_CALENDARS[hall.name];
      if (!calendarId) {
        console.log(`Skipping ${hall.name}: no calendar ID configured in HALL_CALENDARS`);
        continue;
      }

      try {
        // Fetch first; only touch the DB if the calendar loaded, so a
        // Google hiccup never wipes a hall's existing hours.
        const windows = await getHallWindows(calendarId);
        await saveHallWindows(client, hall.id, windows);
        console.log(`  ${hall.name}: saved ${windows.length} open window(s)`);
      } catch (err) {
        console.error(`  Error syncing ${hall.name}:`, err.message);
      }
    }
  } finally {
    client.release();
    await pool.end();
  }

  console.log('\nDone.');
}

main().catch(err => {
  console.error('Fatal error:', err);
  process.exit(1);
});