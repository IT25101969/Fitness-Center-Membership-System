/* ============================================================
   MEMBER PORTAL — Premium JS
   ============================================================ */

/* ── SECTION SWITCH ── */
function showSec(id, btn) {
  document.querySelectorAll('.mp-sec').forEach(s => s.classList.remove('active'));
  var target = document.getElementById('sec-' + id);
  if (target) target.classList.add('active');
  document.querySelectorAll('.mp-side .si').forEach(b => b.classList.remove('active'));
  if (btn) btn.classList.add('active');
  if (id === 'checkin') renderCalendar();
  if (id === 'achieve') animateBadges();
  if (id === 'overview' && typeof animateRings === 'function') animateRings();
}

/* ── SIDEBAR COLLAPSE ── */
const sidebar = document.querySelector('.mp-side');
const toggleBtn = document.getElementById('sidebarToggle');
if (toggleBtn) {
  toggleBtn.addEventListener('click', () => {
    sidebar.classList.toggle('collapsed');
    toggleBtn.querySelector('i').className = sidebar.classList.contains('collapsed')
      ? 'bi bi-chevron-right' : 'bi bi-chevron-left';
  });
}

/* ── FAB ── */
const fabBtn = document.getElementById('fabBtn');
const fabActions = document.getElementById('fabActions');
if (fabBtn) {
  fabBtn.addEventListener('click', () => {
    fabBtn.classList.toggle('open');
    fabActions.classList.toggle('open');
  });
}

/* ── CHARTS ── */
var cc = { acc: '#C8F03D', acc2: 'rgba(200,240,61,0.15)', blu: '#60a5fa', red: '#f87171', yel: '#fbbf24', grn: '#34d399' };
if (typeof Chart !== 'undefined') {
  Chart.defaults.color = '#888';
  Chart.defaults.borderColor = 'rgba(255,255,255,0.06)';
}

function initCharts() {
  if (document.getElementById('weightChart')) {
    new Chart(document.getElementById('weightChart'), {
      type: 'line',
      data: { labels: ['W1','W2','W3','W4','W5','W6'], datasets: [{ label: 'Weight (kg)', data: [82,81,80,79.5,78.5,78], borderColor: cc.acc, backgroundColor: cc.acc2, fill: true, tension: .4, pointRadius: 4 }] },
      options: { responsive: true, plugins: { legend: { display: false } } }
    });
  }
  if (document.getElementById('activityChart')) {
    new Chart(document.getElementById('activityChart'), {
      type: 'bar',
      data: { labels: ['Mon','Tue','Wed','Thu','Fri','Sat','Sun'], datasets: [{ label: 'Active Min', data: [45,60,0,45,60,90,0], backgroundColor: cc.blu, borderRadius: 6 }] },
      options: { responsive: true, plugins: { legend: { display: false } } }
    });
  }
  if (document.getElementById('macroChart')) {
    new Chart(document.getElementById('macroChart'), {
      type: 'doughnut',
      data: { labels: ['Protein','Carbs','Fat'], datasets: [{ data: [160,220,65], backgroundColor: [cc.acc, cc.blu, cc.red], borderWidth: 0, borderRadius: 4 }] },
      options: { responsive: true, cutout: '70%', plugins: { legend: { position: 'bottom', labels: { font: { size: 11 }, padding: 12 } } } }
    });
  }
  if (document.getElementById('weeklyChart')) {
    new Chart(document.getElementById('weeklyChart'), {
      type: 'bar',
      data: { labels: ['Mon','Tue','Wed','Thu','Fri','Sat','Sun'], datasets: [
        { label: 'Calories', data: [420,600,0,480,550,800,0], backgroundColor: cc.acc2, borderColor: cc.acc, borderWidth: 1, borderRadius: 4 }
      ]},
      options: { responsive: true, plugins: { legend: { display: false } } }
    });
  }
}
initCharts();

/* ── MODALS ── */
function openModal(id) { document.getElementById(id).classList.add('active'); }
function closeModal(id) { document.getElementById(id).classList.remove('active'); }
document.querySelectorAll('.modal-overlay').forEach(m => {
  m.addEventListener('click', e => { if (e.target === m) m.classList.remove('active'); });
});

/* ── TOAST ── */
function showToast(msg, type) {
  const t = document.getElementById('toastMsg');
  t.querySelector('span').innerText = msg;
  t.style.background = type === 'error' ? '#f87171' : '#34d399';
  t.classList.add('show');
  setTimeout(() => t.classList.remove('show'), 3000);
}

/* ── RENEW ── */
const basePrice = 4500;
function selDur(btn, mos) {
  document.querySelectorAll('.m-dur-btn').forEach(b => b.classList.remove('active'));
  btn.classList.add('active');
  const disc = mos == 3 ? 0.9 : mos == 6 ? 0.85 : mos == 12 ? 0.75 : 1;
  document.getElementById('rn-total').innerText = 'Rs.' + Math.round(basePrice * mos * disc).toLocaleString();
}
function selPay(btn) {
  btn.closest('.pay-grid').querySelectorAll('.pay-btn').forEach(b => b.classList.remove('active'));
  btn.classList.add('active');
}
function confirmRenew(btn) {
  btn.disabled = true; btn.querySelector('.btn-loader').style.display = 'inline-block';
  fetch(window._ctx + '/member-profile', { method:'POST', headers:{'Content-Type':'application/x-www-form-urlencoded'}, body:'action=renew' })
    .then(r => r.json()).then(d => {
      btn.disabled = false; btn.querySelector('.btn-loader').style.display = 'none';
      if (d.success) { closeModal('renewModal'); showToast('Membership Renewed!'); }
    }).catch(() => { btn.disabled = false; btn.querySelector('.btn-loader').style.display = 'none'; showToast('Error renewing.','error'); });
}
function confirmUpgrade(btn) {
  btn.disabled = true; btn.querySelector('.btn-loader').style.display = 'inline-block';
  fetch(window._ctx + '/member-profile', { method:'POST', headers:{'Content-Type':'application/x-www-form-urlencoded'}, body:'action=upgrade' })
    .then(r => r.json()).then(d => {
      btn.disabled = false; btn.querySelector('.btn-loader').style.display = 'none';
      if (d.success) { closeModal('upgradeModal'); showToast('Upgraded to Premium!'); }
    }).catch(() => { btn.disabled = false; btn.querySelector('.btn-loader').style.display = 'none'; showToast('Error.','error'); });
}

/* ── CHECKOUT ── */
function openCheckout(name, price) {
  document.getElementById('co-prod-name').innerText = name;
  document.getElementById('co-prod-price').innerText = 'Rs. ' + price.toLocaleString();
  document.getElementById('co-total').innerText = 'Rs. ' + (price + 500).toLocaleString();
  openModal('checkoutModal');
}
function selCheckoutPay(btn) {
  document.querySelectorAll('#checkoutModal .pay-btn').forEach(b => b.classList.remove('active'));
  btn.classList.add('active');
  document.getElementById('card-details').style.display = btn.innerText.trim() === 'Card' ? 'block' : 'none';
}
function processCheckout(btn) {
  btn.disabled = true; btn.querySelector('.btn-loader').style.display = 'inline-block';
  setTimeout(() => {
    btn.disabled = false; btn.querySelector('.btn-loader').style.display = 'none';
    closeModal('checkoutModal'); showToast('Payment successful! Order placed.');
  }, 1500);
}

/* ── BIND RENEW / UPGRADE BUTTONS ── */
document.querySelectorAll('button').forEach(btn => {
  if (btn.innerText.includes('Renew Now')) btn.onclick = () => openModal('renewModal');
  if (btn.innerText.includes('Upgrade')) btn.onclick = () => openModal('upgradeModal');
});

/* ── WATER TRACKER ── */
let waterCount = 5;
function updateWaterDisplay() {
  var liters = waterCount * 250 / 1000;
  var el = document.getElementById('waterCount');
  if (el) el.innerText = liters.toFixed(2);
  var pct = Math.round((liters / 2.0) * 100);
  var pctEl = document.getElementById('waterPctDisplay');
  if (pctEl) pctEl.innerText = pct + '%';
  var bar = document.getElementById('waterBar');
  if (bar) bar.style.width = Math.min(pct, 100) + '%';
  if (typeof ApexState !== 'undefined') ApexState.set('waterIntakeL', parseFloat(liters.toFixed(1)));
}
function toggleGlass(el) {
  el.classList.toggle('filled');
  waterCount = document.querySelectorAll('.water-glass.filled').length;
  updateWaterDisplay();
}
function addGlass() {
  const grid = document.querySelector('.water-grid');
  if (!grid) return;
  const g = document.createElement('div');
  g.className = 'water-glass filled';
  g.onclick = function() { toggleGlass(this); };
  // Insert before the action buttons container
  var actions = grid.querySelector('.water-actions');
  if (actions) grid.insertBefore(g, actions);
  else grid.insertBefore(g, grid.lastElementChild);
  waterCount++;
  updateWaterDisplay();
}
function removeGlass() {
  var glasses = document.querySelectorAll('.water-glass');
  if (glasses.length === 0) return;
  var last = glasses[glasses.length - 1];
  if (last.classList.contains('filled')) waterCount--;
  last.remove();
  updateWaterDisplay();
}

/* ── REST TIMER ── */
let timerInterval = null, timerSeconds = 60, timerMax = 60;
function setTimerPreset(btn, secs) {
  document.querySelectorAll('.timer-preset').forEach(b => b.classList.remove('active'));
  btn.classList.add('active');
  stopTimer();
  timerMax = timerSeconds = secs;
  updateTimerDisplay();
}
function updateTimerDisplay() {
  const m = Math.floor(timerSeconds / 60), s = timerSeconds % 60;
  document.getElementById('timerDisplay').innerText = (m > 0 ? m + ':' : '') + String(s).padStart(2, '0');
  const pct = timerSeconds / timerMax;
  const offset = 502 * (1 - pct);
  const ring = document.getElementById('timerRing');
  if (ring) ring.style.strokeDashoffset = offset;
}
function startTimer() {
  if (timerInterval) return;
  timerInterval = setInterval(() => {
    if (timerSeconds <= 0) { stopTimer(); showToast('Rest complete! Time to go! 💪'); return; }
    timerSeconds--;
    updateTimerDisplay();
  }, 1000);
  document.getElementById('timerStartBtn').innerText = 'Pause';
  document.getElementById('timerStartBtn').onclick = pauseTimer;
}
function pauseTimer() {
  clearInterval(timerInterval); timerInterval = null;
  document.getElementById('timerStartBtn').innerText = 'Resume';
  document.getElementById('timerStartBtn').onclick = startTimer;
}
function stopTimer() {
  clearInterval(timerInterval); timerInterval = null;
  timerSeconds = timerMax;
  updateTimerDisplay();
  const startBtn = document.getElementById('timerStartBtn');
  if (startBtn) { startBtn.innerText = 'Start'; startBtn.onclick = startTimer; }
}

/* ── ATTENDANCE CALENDAR ── */
function renderCalendar() {
  const grid = document.getElementById('attendanceGrid');
  if (!grid || grid.dataset.rendered) return;
  grid.dataset.rendered = '1';
  const now = new Date();
  const y = now.getFullYear(), mo = now.getMonth();
  const days = new Date(y, mo + 1, 0).getDate();
  const firstDay = new Date(y, mo, 1).getDay();
  const attended = [1,3,5,8,10,12,13,15,17,19,20,22,23];
  const today = now.getDate();
  for (let i = 0; i < firstDay; i++) {
    const empty = document.createElement('div');
    empty.className = 'cal-day empty'; grid.appendChild(empty);
  }
  for (let d = 1; d <= days; d++) {
    const cell = document.createElement('div');
    cell.className = 'cal-day' + (d === today ? ' today' : attended.includes(d) && d < today ? ' checked' : d < today ? ' missed' : '');
    cell.innerText = d; grid.appendChild(cell);
  }
}

/* ── BADGES ANIMATION ── */
function animateBadges() {
  document.querySelectorAll('.badge-item.unlocked').forEach((b, i) => {
    b.style.opacity = '0'; b.style.transform = 'scale(0.8)';
    setTimeout(() => {
      b.style.transition = 'all .35s ease';
      b.style.opacity = '1'; b.style.transform = 'scale(1)';
    }, i * 80);
  });
}

/* ── CHAT ── */
function sendChat() {
  const input = document.getElementById('chatInput');
  const msgs = document.getElementById('chatMessages');
  if (!input || !msgs || !input.value.trim()) return;
  const msg = document.createElement('div');
  msg.className = 'chat-msg sent';
  msg.innerHTML = input.value + '<div class="chat-time">Just now</div>';
  msgs.appendChild(msg);
  msgs.scrollTop = msgs.scrollHeight;
  input.value = '';
  setTimeout(() => {
    const reply = document.createElement('div');
    reply.className = 'chat-msg received';
    const replies = ['Great work today! 💪','Keep pushing, you\'re doing amazing!','Remember to hydrate after your workout.','I\'ll update your plan for next week.'];
    reply.innerHTML = replies[Math.floor(Math.random() * replies.length)] + '<div class="chat-time">Trainer · Just now</div>';
    msgs.appendChild(reply);
    msgs.scrollTop = msgs.scrollHeight;
  }, 1000);
}
const chatInput = document.getElementById('chatInput');
if (chatInput) chatInput.addEventListener('keydown', e => { if (e.key === 'Enter') sendChat(); });

/* ── TOGGLE SWITCH ── */
function toggleSwitch(el) { el.classList.toggle('on'); }

/* ── GROCERY CHECKLIST ── */
function toggleGrocery(el) {
  el.classList.toggle('checked');
  el.closest('.grocery-item').classList.toggle('checked');
}

/* ── MOTIVATIONAL QUOTES ── */
const quotes = [
  { text: "The only bad workout is the one that didn't happen.", author: "Unknown" },
  { text: "Train insane or remain the same.", author: "Jadah Sellner" },
  { text: "Your body can stand almost anything. It's your mind you have to convince.", author: "Unknown" },
  { text: "Strength does not come from the physical capacity. It comes from an indomitable will.", author: "Gandhi" },
  { text: "No pain, no gain. Shut up and train.", author: "Unknown" }
];
let qIdx = 0;
function rotateQuote() {
  qIdx = (qIdx + 1) % quotes.length;
  const qt = document.getElementById('quoteText');
  const qa = document.getElementById('quoteAuthor');
  if (qt) qt.innerText = '"' + quotes[qIdx].text + '"';
  if (qa) qa.innerText = '— ' + quotes[qIdx].author;
}
setInterval(rotateQuote, 8000);

/* ── PROMO CODE ── (see duplicate below, kept for reference) */

/* ── CHECK-IN SIMULATION ── */
function doCheckIn() {
  const btn = document.getElementById('checkInBtn');
  if (!btn) return;
  btn.innerText = 'Scanning...'; btn.disabled = true;
  setTimeout(() => {
    btn.innerText = '✓ Checked In!';
    btn.style.background = '#34d399'; btn.style.color = '#000';
    showToast('Welcome back! Enjoy your workout 💪');
    const entry = document.querySelector('.tl-vert');
    if (entry) {
      const now = new Date();
      const el = document.createElement('div');
      el.className = 'tl-entry';
      el.innerHTML = '<div class="tl-entry-time">Today · ' + now.toLocaleTimeString([], {hour:'2-digit',minute:'2-digit'}) + '</div><div class="tl-entry-text">✓ Checked in at Apex Fitness — Colombo</div>';
      entry.prepend(el);
    }
  }, 1500);
}

/* ── INVOICE MODAL ── */
function openInvoice(num, date, amount) {
  document.getElementById('inv-num').innerText = num;
  document.getElementById('inv-date').innerText = date;
  document.getElementById('inv-amount').innerText = amount;
  openModal('invoiceModal');
}

/* -- PHOTO UPLOAD -- */
function handlePhotoUpload(input) {
  if (!input.files || !input.files[0]) return;
  const file = input.files[0];
  if (!file.type.startsWith('image/')) { alert('Please select an image file.'); return; }
  const reader = new FileReader();
  reader.onload = function(e) {
    const url = e.target.result;
    localStorage.setItem('memberPhoto', url);
    applyPhotoEverywhere(url);
    if (typeof showToast === 'function') showToast('Profile photo updated!');
  };
  reader.readAsDataURL(file);
}
function applyPhotoEverywhere(url) {
  const targets = [
    { img: 'ovAvatarImg', init: 'ovAvatarInitial' },
    { img: 'profPhotoImg', init: 'profInitial' },
    { img: 'editProfImg', init: 'editProfInitial' }
  ];
  targets.forEach(t => {
    const imgEl = document.getElementById(t.img);
    const initEl = document.getElementById(t.init);
    if (imgEl) { imgEl.src = url; imgEl.style.display = 'block'; }
    if (initEl) { initEl.style.display = 'none'; }
  });
}
(function loadSavedPhoto() {
  const saved = localStorage.getItem('memberPhoto');
  if (saved) applyPhotoEverywhere(saved);
})();

/* -- SAVE PROFILE -- */
function saveProfile() {
  const name = document.getElementById('editName').value.trim();
  const email = document.getElementById('editEmail').value.trim();
  const phone = document.getElementById('editPhone').value.trim();
  if (!name || !email) { alert('Name and email are required.'); return; }
  closeModal('editProfileModal');
  showToast('Profile updated successfully!');
}


/* -- OVERVIEW GREETING + CLOCK -- */
(function initOverviewClock() {
  function updateGreeting() {
    const h = new Date().getHours();
    let g = 'Good Evening';
    if (h < 12) g = 'Good Morning';
    else if (h < 17) g = 'Good Afternoon';
    const el = document.getElementById('ovGreeting');
    if (el) el.textContent = g;
  }
  function updateDateTime() {
    const now = new Date();
    const opts = { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' };
    const dateEl = document.getElementById('ovDate');
    const timeEl = document.getElementById('ovTime');
    if (dateEl) dateEl.textContent = now.toLocaleDateString('en-US', opts);
    if (timeEl) timeEl.textContent = now.toLocaleTimeString('en-US', { hour: '2-digit', minute: '2-digit' });
  }
  updateGreeting();
  updateDateTime();
  setInterval(updateDateTime, 30000);
})();

/* -- ACTIVITY RINGS ANIMATION -- */
function animateRings() {
  const rings = [
    { id: 'ringMove',  target: 60,  total: 251 },
    { id: 'ringEx',    target: 80,  total: 251 },
    { id: 'ringStand', target: 100, total: 251 },
    { id: 'ringCal',   target: 50,  total: 251 }
  ];
  rings.forEach((r, i) => {
    const el = document.getElementById(r.id);
    if (!el) return;
    el.style.strokeDashoffset = r.total;
    setTimeout(() => { el.style.strokeDashoffset = r.target; }, i * 150 + 300);
  });
}
// Trigger ring animation when overview is shown
window.addEventListener('load', () => setTimeout(animateRings, 400));

/* -- CLASS BOOKING -- */
function bookClass(btn, name) {
  btn.classList.remove('book');
  btn.classList.add('booked');
  btn.textContent = '✓ Booked!';
  btn.disabled = true;
  showToast(name + ' booked successfully! 🎉');
  // Add to my bookings
  const list = document.getElementById('myBookings');
  if (list) {
    const item = document.createElement('div');
    item.className = 'neon-card';
    item.style.cssText = 'display:flex;align-items:center;gap:1rem;padding:1rem 1.5rem';
    item.innerHTML = `<div style="width:42px;height:42px;border-radius:12px;background:rgba(200,240,61,.1);display:flex;align-items:center;justify-content:center;color:var(--accent);font-size:1.1rem"><i class="bi bi-check-circle-fill"></i></div><div style="flex:1"><div style="font-weight:700;font-size:.9rem">${name}</div><div style="font-size:.72rem;color:var(--gray)">Just booked · Upcoming session</div></div><span class="pay-status paid" style="font-size:.65rem">BOOKED</span>`;
    list.prepend(item);
  }
}

/* -- CLASS FILTER -- */
function filterClasses(type, pill) {
  document.querySelectorAll('.sec-classes .pill, #sec-classes .pill').forEach(p => {
    p.classList.remove('pill-accent');
    p.style.border = '1px solid var(--border)';
  });
  pill.classList.add('pill-accent');
  pill.style.border = '';
  document.querySelectorAll('#classGrid .class-card').forEach(c => {
    c.style.display = (type === 'all' || c.dataset.type === type) ? '' : 'none';
  });
}


/* -- PROMO CODE -- */
function applyPromo() {
  const inp = document.getElementById('promoInput');
  if (!inp) return;
  const code = inp.value.trim().toUpperCase();
  if (!code) { inp.style.borderColor = '#f87171'; setTimeout(() => inp.style.borderColor = '', 2000); return; }
  inp.value = '';
  inp.placeholder = 'Code applied!';
  inp.style.borderColor = 'var(--accent)';
  showToast('Promo code ' + code + ' applied! 15% discount on next billing.');
  setTimeout(() => { inp.placeholder = 'Enter code e.g. APEX20'; inp.style.borderColor = ''; }, 4000);
}

/* ══════════════════════════════════════════════════════════
   WORKOUT SESSION ENGINE
   ══════════════════════════════════════════════════════════ */
var WS_PLANS = {
  upper: { name:'Upper Body Power', exercises:[
    {name:'Barbell Bench Press',sets:4,reps:'8-10',muscle:'Chest',tip:'Keep shoulder blades pinched. Control the bar down slowly.'},
    {name:'Incline Dumbbell Press',sets:3,reps:'10-12',muscle:'Upper Chest',tip:'30° incline. Squeeze at the top.'},
    {name:'Overhead Press',sets:4,reps:'6-8',muscle:'Shoulders',tip:'Brace your core. Push straight overhead.'},
    {name:'Cable Lateral Raise',sets:3,reps:'12-15',muscle:'Side Delts',tip:'Light weight, feel the contraction.'},
    {name:'Tricep Dips',sets:3,reps:'10-12',muscle:'Triceps',tip:'Lean slightly forward for chest emphasis.'},
    {name:'Barbell Curl',sets:3,reps:'10-12',muscle:'Biceps',tip:'No swinging. Squeeze at the top.'}
  ]},
  legs: { name:'Leg Day Destroyer', exercises:[
    {name:'Barbell Squat',sets:4,reps:'6-8',muscle:'Quads/Glutes',tip:'Break at the hips first. Depth below parallel.'},
    {name:'Romanian Deadlift',sets:4,reps:'8-10',muscle:'Hamstrings',tip:'Hinge at hips. Feel the hamstring stretch.'},
    {name:'Leg Press',sets:3,reps:'10-12',muscle:'Quads',tip:'Feet shoulder-width. Full range of motion.'},
    {name:'Walking Lunges',sets:3,reps:'12 each',muscle:'Glutes/Quads',tip:'Long steps. Keep torso upright.'},
    {name:'Calf Raises',sets:4,reps:'15-20',muscle:'Calves',tip:'Pause at the top. Slow negatives.'}
  ]},
  hiit: { name:'HIIT Cardio Blast', exercises:[
    {name:'Burpees',sets:4,reps:'45 sec',muscle:'Full Body',tip:'Explosive jump. Chest to the ground.'},
    {name:'Mountain Climbers',sets:4,reps:'45 sec',muscle:'Core/Cardio',tip:'Drive knees to chest rapidly.'},
    {name:'Jump Squats',sets:4,reps:'45 sec',muscle:'Legs/Power',tip:'Land softly. Explode up each rep.'},
    {name:'Battle Ropes',sets:4,reps:'30 sec',muscle:'Arms/Core',tip:'Alternate waves. Keep core tight.'}
  ]},
  core: { name:'Core & Abs Focus', exercises:[
    {name:'Hanging Leg Raises',sets:4,reps:'12-15',muscle:'Lower Abs',tip:'No swinging. Curl the pelvis.'},
    {name:'Cable Woodchops',sets:3,reps:'12 each',muscle:'Obliques',tip:'Rotate through the core, not arms.'},
    {name:'Ab Wheel Rollout',sets:3,reps:'10-12',muscle:'Full Core',tip:'Squeeze abs. Do not arch your back.'},
    {name:'Plank Hold',sets:3,reps:'60 sec',muscle:'Core Stability',tip:'Flat back. Squeeze everything tight.'},
    {name:'Russian Twists',sets:3,reps:'20 total',muscle:'Obliques',tip:'Lean back slightly. Controlled rotation.'}
  ]},
  full: { name:'Full Body Strength', exercises:[
    {name:'Deadlift',sets:4,reps:'5',muscle:'Posterior Chain',tip:'Hip hinge. Flat back. Drive through heels.'},
    {name:'Bench Press',sets:4,reps:'6-8',muscle:'Chest',tip:'Arch slightly. Retract scapula.'},
    {name:'Pull-Ups',sets:4,reps:'8-10',muscle:'Back',tip:'Full hang to chin over bar.'},
    {name:'Barbell Row',sets:3,reps:'8-10',muscle:'Back',tip:'45° torso. Pull to lower chest.'},
    {name:'Overhead Press',sets:3,reps:'8-10',muscle:'Shoulders',tip:'Strict press. No leg drive.'},
    {name:'Barbell Squat',sets:4,reps:'6-8',muscle:'Legs',tip:'Break at hips. Below parallel.'},
    {name:'Dumbbell Lunges',sets:3,reps:'10 each',muscle:'Legs',tip:'Controlled steps. Upright torso.'},
    {name:'Farmer Walks',sets:3,reps:'40m',muscle:'Grip/Core',tip:'Heavy weight. Tight core. Walk tall.'}
  ]},
  yoga: { name:'Yoga & Flexibility', exercises:[
    {name:'Sun Salutation Flow',sets:3,reps:'5 cycles',muscle:'Full Body',tip:'Breathe with each movement transition.'},
    {name:'Warrior II Hold',sets:3,reps:'45 sec each',muscle:'Legs/Core',tip:'Front knee over ankle. Gaze over hand.'},
    {name:'Pigeon Pose',sets:2,reps:'60 sec each',muscle:'Hips',tip:'Sink into the stretch slowly. Relax.'},
    {name:'Downward Dog',sets:3,reps:'45 sec',muscle:'Hamstrings/Shoulders',tip:'Press heels toward floor. Flat back.'},
    {name:'Cobra Stretch',sets:3,reps:'30 sec',muscle:'Spine/Core',tip:'Gentle backbend. Open the chest.'},
    {name:'Savasana',sets:1,reps:'3 min',muscle:'Recovery',tip:'Close your eyes. Deep, slow breaths.'}
  ]}
};

var wsState = { plan:null, exIdx:0, setIdx:0, setsDone:0, kcal:0, volume:0, timerSec:0, timerInt:null, restInt:null, restSec:60, restMax:60 };

function openWorkoutSession(planKey) {
  var plan = WS_PLANS[planKey];
  if (!plan) { showToast('Workout not found','error'); return; }
  wsState = { plan:plan, exIdx:0, setIdx:0, setsDone:0, kcal:0, volume:0, timerSec:0, timerInt:null, restInt:null, restSec:60, restMax:60 };
  document.getElementById('wsPlanName').textContent = plan.name;
  document.getElementById('wsExTotal').textContent = plan.exercises.length;
  document.getElementById('wsOverlay').classList.add('active');
  document.body.style.overflow = 'hidden';
  wsStartMainTimer();
  wsRenderExercise();
  wsRenderExList();
  wsUpdateProgress();
}

function wsStartMainTimer() {
  clearInterval(wsState.timerInt);
  wsState.timerInt = setInterval(function() {
    wsState.timerSec++;
    var m = Math.floor(wsState.timerSec/60), s = wsState.timerSec%60;
    document.getElementById('wsMainTimer').textContent = String(m).padStart(2,'0')+':'+String(s).padStart(2,'0');
    document.getElementById('wsTimeStat').textContent = m+'m';
  },1000);
}

function wsRenderExList() {
  var html = '';
  wsState.plan.exercises.forEach(function(ex,i) {
    var cls = i < wsState.exIdx ? 'done' : i === wsState.exIdx ? 'current' : '';
    var icon = i < wsState.exIdx ? '<i class="bi bi-check-circle-fill"></i>' : '<span>'+(i+1)+'</span>';
    html += '<div class="ws-ex-item '+cls+'" onclick="wsGoToExercise('+i+')">' + icon + '<div class="ws-ex-item-info"><div class="ws-ex-item-name">'+ex.name+'</div><div class="ws-ex-item-meta">'+ex.sets+'×'+ex.reps+' · '+ex.muscle+'</div></div></div>';
  });
  document.getElementById('wsExList').innerHTML = html;
}

function wsRenderExercise() {
  var ex = wsState.plan.exercises[wsState.exIdx];
  if (!ex) return;
  wsState.setIdx = 0;
  document.getElementById('wsExNum').textContent = 'Exercise '+(wsState.exIdx+1)+' of '+wsState.plan.exercises.length;
  document.getElementById('wsExName').textContent = ex.name;
  document.getElementById('wsExTarget').textContent = ex.sets+' sets × '+ex.reps+' reps';
  document.getElementById('wsExMuscle').innerHTML = '<i class="bi bi-lightning-fill"></i> '+ex.muscle;
  document.getElementById('wsTip').textContent = ex.tip;
  // Render sets
  var html = '';
  for (var i = 0; i < ex.sets; i++) {
    html += '<div class="ws-set-row" id="wsSet'+i+'"><span class="ws-set-num">'+(i+1)+'</span><span class="ws-set-target">'+ex.reps+'</span><input type="number" class="ws-set-input" placeholder="—" id="wsReps'+i+'"><input type="number" class="ws-set-input" placeholder="kg" id="wsWeight'+i+'"><span class="ws-set-status" id="wsSetSt'+i+'"><i class="bi bi-circle"></i></span></div>';
  }
  document.getElementById('wsSetsBody').innerHTML = html;
  // Next exercise preview
  var next = wsState.plan.exercises[wsState.exIdx+1];
  if (next) { document.getElementById('wsNextEx').style.display = ''; document.getElementById('wsNextName').textContent = next.name; document.getElementById('wsNextMeta').textContent = next.sets+'×'+next.reps; }
  else { document.getElementById('wsNextEx').style.display = 'none'; }
  // Hide rest panel
  document.getElementById('wsRestPanel').style.display = 'none';
}

function wsCompleteCurrentSet() {
  var ex = wsState.plan.exercises[wsState.exIdx];
  if (wsState.setIdx >= ex.sets) return;
  var st = document.getElementById('wsSetSt'+wsState.setIdx);
  var row = document.getElementById('wsSet'+wsState.setIdx);
  var w = parseFloat(document.getElementById('wsWeight'+wsState.setIdx).value) || 0;
  var r = parseInt(document.getElementById('wsReps'+wsState.setIdx).value) || 10;
  if (st) st.innerHTML = '<i class="bi bi-check-circle-fill" style="color:var(--accent)"></i>';
  if (row) row.classList.add('completed');
  wsState.setsDone++;
  wsState.kcal += Math.round(8 + Math.random()*12);
  wsState.volume += w * r;
  wsState.setIdx++;
  document.getElementById('wsSetsDone').textContent = wsState.setsDone;
  document.getElementById('wsKcal').textContent = wsState.kcal;
  document.getElementById('wsKcalStat').textContent = wsState.kcal;
  document.getElementById('wsTotalSets').textContent = wsState.setsDone;
  document.getElementById('wsVolume').textContent = wsState.volume;
  if (wsState.setIdx >= ex.sets) {
    // Exercise complete → move to next
    setTimeout(function() { wsNextExercise(); }, 600);
  }
  wsUpdateProgress();
}

function wsNextExercise() {
  wsState.exIdx++;
  if (wsState.exIdx >= wsState.plan.exercises.length) { wsFinish(); return; }
  wsRenderExercise();
  wsRenderExList();
  wsUpdateProgress();
}

function wsSkipExercise() { wsNextExercise(); }

function wsGoToExercise(idx) {
  if (idx >= wsState.plan.exercises.length) return;
  wsState.exIdx = idx;
  wsRenderExercise();
  wsRenderExList();
  wsUpdateProgress();
}

function wsUpdateProgress() {
  var total = wsState.plan.exercises.length;
  var pct = Math.round((wsState.exIdx / total) * 100);
  document.getElementById('wsProgFill').style.width = pct+'%';
  document.getElementById('wsProgPct').textContent = pct+'% Complete';
  document.getElementById('wsExDone').textContent = wsState.exIdx;
  document.getElementById('wsRingPct').textContent = pct+'%';
  var ring = document.getElementById('wsProgressRing');
  if (ring) ring.style.strokeDashoffset = 427 - (427 * pct / 100);
}

function wsStartRest() { document.getElementById('wsRestPanel').style.display = ''; }
function wsStopRest() { clearInterval(wsState.restInt); wsState.restInt = null; document.getElementById('wsRestPanel').style.display = 'none'; wsState.restSec = wsState.restMax; document.getElementById('wsRestSecs').textContent = wsState.restSec; }
function wsSetRest(s) {
  wsState.restMax = s; wsState.restSec = s;
  document.getElementById('wsRestSecs').textContent = s;
  document.querySelectorAll('.ws-rest-presets button').forEach(function(b){b.classList.remove('active');});
  event.target.classList.add('active');
  var ring = document.getElementById('wsRestRing');
  if (ring) ring.style.strokeDashoffset = 0;
}
function wsToggleRest() {
  var btn = document.getElementById('wsRestStartBtn');
  if (wsState.restInt) { clearInterval(wsState.restInt); wsState.restInt = null; btn.innerHTML = '<i class="bi bi-play-fill"></i> Resume'; return; }
  btn.innerHTML = '<i class="bi bi-pause-fill"></i> Pause';
  wsState.restInt = setInterval(function() {
    wsState.restSec--;
    document.getElementById('wsRestSecs').textContent = wsState.restSec;
    var ring = document.getElementById('wsRestRing');
    if (ring) ring.style.strokeDashoffset = 377 * (1 - wsState.restSec / wsState.restMax);
    if (wsState.restSec <= 0) { wsStopRest(); showToast('Rest complete! Go! 💪'); }
  }, 1000);
}

function endWorkoutSession() { wsFinish(); }

function wsFinish() {
  clearInterval(wsState.timerInt);
  clearInterval(wsState.restInt);
  document.getElementById('wsOverlay').classList.remove('active');
  // Show summary
  var m = Math.floor(wsState.timerSec/60), s = wsState.timerSec%60;
  document.getElementById('wsSumPlanName').textContent = wsState.plan.name;
  document.getElementById('wsSumTime').textContent = m+'m '+s+'s';
  document.getElementById('wsSumExercises').textContent = wsState.exIdx+'/'+wsState.plan.exercises.length;
  document.getElementById('wsSumSets').textContent = wsState.setsDone;
  document.getElementById('wsSumKcal').textContent = wsState.kcal;
  var pct = Math.round((wsState.exIdx / wsState.plan.exercises.length)*100);
  document.getElementById('wsSumProgFill').style.width = pct+'%';
  document.getElementById('wsSumProgPct').textContent = pct+'%';
  document.getElementById('wsSummary').classList.add('active');
  // Sync to ApexState
  if (typeof ApexState !== 'undefined') {
    ApexState.completeWorkout(wsState.plan.name, wsState.kcal, m, wsState.plan.exercises.length);
  }
}

function closeSummary() {
  document.getElementById('wsSummary').classList.remove('active');
  document.body.style.overflow = '';
  // Refresh all bindings after closing summary
  if (typeof ApexState !== 'undefined') ApexState.updateUI();
}

/* ── EXPLICIT WINDOW ASSIGNMENTS ── */
/* Ensure all functions are accessible from inline onclick handlers */
window.showSec = showSec;
window.openModal = openModal;
window.closeModal = closeModal;
window.showToast = showToast;
window.openWorkoutSession = openWorkoutSession;
window.wsCompleteCurrentSet = wsCompleteCurrentSet;
window.wsSkipExercise = wsSkipExercise;
window.wsGoToExercise = wsGoToExercise;
window.wsStartRest = wsStartRest;
window.wsStopRest = wsStopRest;
window.wsSetRest = wsSetRest;
window.wsToggleRest = wsToggleRest;
window.endWorkoutSession = endWorkoutSession;
window.closeSummary = closeSummary;
window.openCheckout = openCheckout;
window.toggleSwitch = toggleSwitch;
window.toggleGlass = toggleGlass;
window.addGlass = addGlass;
window.removeGlass = removeGlass;
window.handlePhotoUpload = handlePhotoUpload;
window.saveProfile = saveProfile;
window.openInvoice = openInvoice;
window.bookClass = bookClass;
window.filterClasses = filterClasses;
window.applyPromo = applyPromo;
window.doCheckIn = doCheckIn;
window.selDur = selDur;
window.selPay = selPay;
window.confirmRenew = confirmRenew;
window.confirmUpgrade = confirmUpgrade;
window.selCheckoutPay = selCheckoutPay;
window.processCheckout = processCheckout;
window.sendChat = sendChat;
window.toggleGrocery = toggleGrocery;
window.animateRings = animateRings;
