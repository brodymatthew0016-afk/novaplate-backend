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

function formatTime(d) {
  return d.toLocaleTimeString('en-US', { hour: 'numeric', minute: '2-digit' });
}

// Checks a single hall's calendar and returns whether it's open right now,
// a human-readable status string, and (when closed) the next time it opens.
async function getHallStatus(calendarId) {
  const url = `https://calendar.google.com/calendar/ical/${encodeURIComponent(calendarId)}/public/basic.ics`;
  const data = await ical.async.fromURL(url);

  const now = new Date();
  const startOfDay = new Date(now); startOfDay.setHours(0, 0, 0, 0);
  const endOfDay = new Date(now); endOfDay.setHours(23, 59, 59, 999);

  // How far ahead to look for the next opening if the hall is closed now.
  const lookaheadEnd = new Date(now.getTime() + 7 * 24 * 60 * 60 * 1000);

  let match = null;
  let nextStart = null; // earliest future occurrence start, across all events

  for (const key in data) {
    const ev = data[key];
    if (ev.type !== 'VEVENT') continue;

    if (ev.rrule) {
      // Recurring event — expand occurrences from today through the
      // lookahead window and check each one.
      const durationMs = new Date(ev.end).getTime() - new Date(ev.start).getTime();
      const occurrences = ev.rrule.between(startOfDay, lookaheadEnd, true);
      for (const occStart of occurrences) {
        const occEnd = new Date(occStart.getTime() + durationMs);
        if (!match && now >= occStart && now <= occEnd) {
          match = { start: occStart, end: occEnd, summary: ev.summary };
        } else if (occStart > now && (!nextStart || occStart < nextStart)) {
          nextStart = occStart;
        }
      }
    } else {
      const start = new Date(ev.start);
      const end = new Date(ev.end);
      if (!match && now >= start && now <= end) {
        match = { start, end, summary: ev.summary };
      } else if (start > now && start <= lookaheadEnd && (!nextStart || start < nextStart)) {
        nextStart = start;
      }
    }
  }

  if (!match) {
    return { isOpen: false, statusText: 'Closed', nextOpenAt: nextStart };
  }

  const label = match.summary || 'Open';
  return {
    isOpen: true,
    statusText: `${label}: ${formatTime(match.start)} - ${formatTime(match.end)}`,
    nextOpenAt: null,
  };
}

async function upsertHallStatus(client, diningHallId, isOpen, statusText, nextOpenAt) {
  await client.query(
    `UPDATE dining_halls
     SET is_open = $2,
         status_text = $3,
         status_updated_at = CURRENT_TIMESTAMP,
         next_open_at = $4
     WHERE id = $1`,
    [diningHallId, isOpen, statusText, nextOpenAt]
  );
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
        const { isOpen, statusText, nextOpenAt } = await getHallStatus(calendarId);
        await upsertHallStatus(client, hall.id, isOpen, statusText, nextOpenAt);
        const suffix = !isOpen && nextOpenAt ? ` — next open ${formatTime(nextOpenAt)}` : '';
        console.log(`  ${hall.name}: ${isOpen ? 'OPEN' : 'CLOSED'} — "${statusText}"${suffix}`);
      } catch (err) {
        console.error(`  Error checking ${hall.name}:`, err.message);
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