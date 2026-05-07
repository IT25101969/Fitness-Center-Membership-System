/* ============================================================
   APEX FITNESS — Landing JS  (Pro Edition — Advanced Scroll)
   ============================================================ */

/* ── 0. PRELOADER ────────────────────────────────── */
(function () {
  const loader = document.getElementById('preloader');
  const bar    = document.getElementById('preloaderBar');
  const pct    = document.getElementById('preloaderPct');
  if (!loader) return;
  // Skip if already hidden or if inline script already started (bar has width)
  if (loader.classList.contains('hidden')) return;
  if (bar && bar.style.width && parseFloat(bar.style.width) > 0) return;

  let prog = 0;
  const interval = setInterval(() => {
    prog += Math.random() * 18 + 4;
    if (prog >= 100) { prog = 100; clearInterval(interval); }
    bar.style.width = prog + '%';
    pct.textContent = Math.round(prog) + '%';
    if (prog >= 100) {
      setTimeout(() => loader.classList.add('hidden'), 350);
    }
  }, 60);
})();

/* ── 1. PARTICLE CANVAS ─────────────────────────── */
(function () {
  const canvas = document.getElementById('particleCanvas');
  if (!canvas) return;
  const ctx = canvas.getContext('2d');
  let W, H, particles = [];
  function resize() { W = canvas.width = window.innerWidth; H = canvas.height = window.innerHeight; }
  resize();
  window.addEventListener('resize', resize, { passive: true });
  function rand(a, b) { return Math.random() * (b - a) + a; }
  function makeParticle() {
    return { x: rand(0,W), y: rand(0,H), r: rand(0.6,2.2), vx: rand(-0.15,0.15), vy: rand(-0.5,-0.15), alpha: rand(0.08,0.45), pulse: rand(0,Math.PI*2) };
  }
  for (let i = 0; i < 90; i++) particles.push(makeParticle());
  function draw() {
    ctx.clearRect(0,0,W,H);
    particles.forEach(p => {
      p.pulse += 0.02;
      const a = p.alpha * (0.7 + 0.3 * Math.sin(p.pulse));
      ctx.beginPath(); ctx.arc(p.x, p.y, p.r, 0, Math.PI*2);
      ctx.fillStyle = `rgba(200,240,61,${a})`; ctx.fill();
      p.x += p.vx; p.y += p.vy;
      if (p.y < -4) Object.assign(p, makeParticle(), { y: H+4 });
      if (p.x < -4) p.x = W+4; if (p.x > W+4) p.x = -4;
    });
    requestAnimationFrame(draw);
  }
  draw();
})();

/* ── 2. SCROLL PROGRESS BAR ──────────────────────── */
(function () {
  const bar = document.createElement('div');
  bar.id = 'scrollBar';
  document.body.prepend(bar);
  window.addEventListener('scroll', () => {
    const pct = window.scrollY / (document.body.scrollHeight - window.innerHeight) * 100;
    bar.style.width = Math.min(pct,100) + '%';
  }, { passive: true });
})();

/* ── 3. CUSTOM CURSOR ────────────────────────────── */
(function () {
  const dot  = document.getElementById('cursorDot');
  const ring = document.getElementById('cursorRing');
  if (!dot || !ring) return;
  let rx = 0, ry = 0, dx = 0, dy = 0;
  document.addEventListener('mousemove', e => {
    dx = e.clientX; dy = e.clientY;
    dot.style.left  = dx + 'px'; dot.style.top  = dy + 'px';
  });
  (function animRing() {
    rx += (dx - rx) * 0.12; ry += (dy - ry) * 0.12;
    ring.style.left = rx + 'px'; ring.style.top = ry + 'px';
    requestAnimationFrame(animRing);
  })();
  document.querySelectorAll('a,button,.goal-card,.service-card,.class-card,.price-card,.faq-q,.fab-item,.trainer-card').forEach(el => {
    el.addEventListener('mouseenter', () => { dot.classList.add('is-hovering'); ring.classList.add('is-hovering'); });
    el.addEventListener('mouseleave', () => { dot.classList.remove('is-hovering'); ring.classList.remove('is-hovering'); });
  });
})();

/* ── 4. GYM STATUS INDICATOR ─────────────────────── */
window.FCMS_HOURS = window.FCMS_HOURS || { weekdayOpen: 300, weekdayClose: 1380, weekendOpen: 360, weekendClose: 1380 };
(function () {
  var el = document.getElementById('gymStatus');
  var txt = document.getElementById('gymStatusText');
  if (!el || !txt) return;
  function formatTime(mins) {
    var hr = Math.floor(mins / 60), mn = mins % 60, ampm = hr >= 12 ? 'PM' : 'AM';
    hr = hr % 12 || 12;
    return hr + ':' + (mn < 10 ? '0' : '') + mn + ' ' + ampm;
  }
  function update() {
    var now = new Date();
    var h = now.getHours(), m = now.getMinutes();
    var mins = h * 60 + m;
    var day = now.getDay();
    var isWeekend = (day === 0 || day === 6);
    var OPEN  = isWeekend ? window.FCMS_HOURS.weekendOpen  : window.FCMS_HOURS.weekdayOpen;
    var CLOSE = isWeekend ? window.FCMS_HOURS.weekendClose : window.FCMS_HOURS.weekdayClose;
    var isOpen = mins >= OPEN && mins < CLOSE;
    el.className = 'gym-status ' + (isOpen ? 'open' : 'closed');
    if (isOpen) {
      var rem = CLOSE - mins;
      txt.textContent = rem <= 60 ? ('Closes in ' + rem + 'm') : 'Open Now';
    } else {
      txt.textContent = 'Closed';
    }
  }
  update(); setInterval(update, 60000);
  window.FCMS_updateNavStatus = update;
})();

/* ── 5. NAVBAR SCROLL ────────────────────────────── */
const nav = document.getElementById('navbar');
let lastY = 0;
window.addEventListener('scroll', () => {
  const y = window.scrollY;
  nav.classList.toggle('scrolled', y > 60);
  if (y > 300) {
    nav.style.transform = y > lastY ? 'translateY(-100%)' : 'translateY(0)';
  } else {
    nav.style.transform = 'translateY(0)';
  }
  lastY = y;
}, { passive: true });

/* ── 6. SECTION PROGRESS DOTS ────────────────────── */
(function () {
  const container = document.getElementById('sectionProgress');
  if (!container) return;
  const sects = [...document.querySelectorAll('section[id]')];
  sects.forEach(s => {
    const d = document.createElement('div');
    d.className = 'spd-dot';
    d.dataset.label = s.id.replace(/-/g,' ').toUpperCase();
    d.addEventListener('click', () => {
      const top = s.getBoundingClientRect().top + window.scrollY - 70;
      window.scrollTo({ top, behavior: 'smooth' });
    });
    container.appendChild(d);
  });
  const dots = container.querySelectorAll('.spd-dot');
  function updateDots() {
    const mid = window.scrollY + window.innerHeight / 2;
    let active = 0;
    sects.forEach((s, i) => { if (s.offsetTop <= mid) active = i; });
    dots.forEach((d, i) => d.classList.toggle('active', i === active));
  }
  window.addEventListener('scroll', updateDots, { passive: true });
  updateDots();
})();

/* ── 7. SCROLL REVEAL ────────────────────────────── */
const revealObserver = new IntersectionObserver((entries) => {
  entries.forEach(entry => {
    if (!entry.isIntersecting) return;
    const el = entry.target;
    el.classList.add('visible');
    el.querySelectorAll('.stagger-child').forEach((child, i) => {
      setTimeout(() => child.classList.add('visible'), i * 100);
    });
    revealObserver.unobserve(el);
  });
}, { threshold: 0.1, rootMargin: '0px 0px -60px 0px' });
document.querySelectorAll('.reveal,.reveal-left,.reveal-right,.reveal-up,.reveal-scale')
  .forEach(el => revealObserver.observe(el));

/* ── 8. STAT COUNTER ─────────────────────────────── */
function runCounter(el) {
  const target = +el.dataset.target; if (!target) return;
  const duration = 2000, frameTime = 1000/60, totalFrames = duration/frameTime;
  let frame = 0;
  const timer = setInterval(() => {
    frame++;
    const progress = 1 - Math.pow(1 - frame / totalFrames, 3);
    el.textContent = Math.round(target * progress).toLocaleString();
    if (frame >= totalFrames) { el.textContent = target.toLocaleString(); clearInterval(timer); }
  }, frameTime);
}
const counterObs = new IntersectionObserver(entries => {
  entries.forEach(e => { if (e.isIntersecting) { runCounter(e.target); counterObs.unobserve(e.target); } });
}, { threshold: 0.6 });
document.querySelectorAll('.stat-num[data-target]').forEach(el => counterObs.observe(el));

/* ── 9. SMOOTH SCROLL ANCHORS ────────────────────── */
document.querySelectorAll('a[href^="#"]').forEach(a => {
  a.addEventListener('click', e => {
    const target = document.querySelector(a.getAttribute('href'));
    if (!target) return;
    e.preventDefault();
    window.scrollTo({ top: target.getBoundingClientRect().top + window.scrollY - 70, behavior: 'smooth' });
  });
});

/* ── 10. PARALLAX ────────────────────────────────── */
const heroImg = document.querySelector('.hero-img');
window.addEventListener('scroll', () => {
  if (heroImg) heroImg.style.transform = `scale(1.05) translateY(${window.scrollY * 0.25}px)`;
  document.querySelectorAll('.parallax-bg').forEach(bg => {
    const offset = -bg.closest('section').getBoundingClientRect().top * 0.3;
    bg.style.transform = `translateY(${offset}px)`;
  });
}, { passive: true });

/* ── 11. ACTIVE NAV LINK ─────────────────────────── */
const sections = document.querySelectorAll('section[id]');
const navLinks = document.querySelectorAll('.nav-links a');
const navHighlight = () => {
  let current = '';
  const scrollMid = window.scrollY + window.innerHeight / 2;
  sections.forEach(s => { if (s.offsetTop <= scrollMid) current = s.id; });
  navLinks.forEach(a => a.classList.toggle('nav-active', a.getAttribute('href') === '#' + current));
};
window.addEventListener('scroll', navHighlight, { passive: true }); navHighlight();

/* ── 12. LOGIN DROPDOWN ──────────────────────────── */
const loginDropBtn = document.getElementById('loginDropBtn');
const loginDropMenu = document.getElementById('loginDropMenu');
if (loginDropBtn && loginDropMenu) {
  loginDropBtn.addEventListener('click', e => {
    e.stopPropagation();
    loginDropMenu.classList.toggle('open');
  });
  document.addEventListener('click', () => { loginDropMenu.classList.remove('open'); });
  loginDropMenu.addEventListener('click', e => e.stopPropagation());
}

/* ── 13. HAMBURGER MOBILE MENU ───────────────────── */
const hamburger = document.getElementById('hamburger');
hamburger?.addEventListener('click', () => {
  const existing = document.querySelector('.mobile-menu');
  if (existing) {
    existing.style.opacity = '0'; existing.style.transform = 'translateY(-10px)';
    setTimeout(() => existing.remove(), 300);
    hamburger.innerHTML = '<i class="bi bi-list"></i>'; return;
  }
  const menu = document.createElement('div'); menu.className = 'mobile-menu';
  menu.style.cssText = `position:fixed;top:65px;left:0;right:0;bottom:0;background:rgba(8,8,8,0.97);
    backdrop-filter:blur(24px);z-index:998;display:flex;flex-direction:column;
    align-items:center;justify-content:center;gap:1.8rem;opacity:0;transform:translateY(-10px);
    transition:opacity .3s ease,transform .3s ease;`;
  const brand = document.createElement('div');
  brand.innerHTML = '<span style="font-family:\'Bebas Neue\',sans-serif;font-size:2rem;letter-spacing:3px;color:#fff;">APEX</span><span style="font-family:\'Bebas Neue\',sans-serif;font-size:2rem;letter-spacing:3px;color:#C8F03D;">FITNESS</span>';
  brand.style.marginBottom = '1rem'; menu.appendChild(brand);
  ['#about','#services','#classes','#nutrition','#pricing','#testimonials','#faq'].forEach(href => {
    const a = document.createElement('a'); a.href = href;
    a.textContent = href.replace('#','').toUpperCase();
    a.style.cssText = `font-family:'Bebas Neue',sans-serif;font-size:2.2rem;letter-spacing:3px;color:rgba(255,255,255,.85);transition:color .2s,letter-spacing .2s;`;
    a.addEventListener('mouseenter', () => { a.style.color='#C8F03D'; a.style.letterSpacing='4px'; });
    a.addEventListener('mouseleave', () => { a.style.color='rgba(255,255,255,.85)'; a.style.letterSpacing='3px'; });
    a.addEventListener('click', () => { menu.style.opacity='0'; setTimeout(()=>menu.remove(),300); hamburger.innerHTML='<i class="bi bi-list"></i>'; });
    menu.appendChild(a);
  });

  // ── Dynamic auth link in mobile menu ──
  var divider = document.createElement('div');
  divider.style.cssText = 'width:40px;height:1px;background:rgba(255,255,255,.12);margin:.5rem 0;';
  menu.appendChild(divider);

  var member = window.__fcmsMember;
  if (member && member.loggedIn) {
    // Logged in — show name, dashboard link, and logout
    var nameEl = document.createElement('div');
    nameEl.style.cssText = 'font-size:.85rem;color:rgba(200,240,61,.8);font-weight:600;letter-spacing:1px;';
    nameEl.textContent = 'Hello, ' + (member.name ? member.name.split(' ')[0] : 'Member') + '!';
    menu.appendChild(nameEl);

    var dashLink = document.createElement('a');
    dashLink.href = 'member-profile';
    dashLink.innerHTML = '<i class="bi bi-speedometer2" style="margin-right:.5rem;"></i>MY DASHBOARD';
    dashLink.style.cssText = `font-family:'Bebas Neue',sans-serif;font-size:1.6rem;letter-spacing:2px;color:#C8F03D;transition:opacity .2s;`;
    dashLink.addEventListener('click', () => { menu.style.opacity='0'; setTimeout(()=>menu.remove(),300); hamburger.innerHTML='<i class="bi bi-list"></i>'; });
    menu.appendChild(dashLink);

    var logoutLink = document.createElement('a');
    logoutLink.href = 'logout';
    logoutLink.innerHTML = '<i class="bi bi-box-arrow-right" style="margin-right:.5rem;"></i>LOGOUT';
    logoutLink.style.cssText = `font-family:'Bebas Neue',sans-serif;font-size:1.4rem;letter-spacing:2px;color:#f87171;transition:opacity .2s;`;
    menu.appendChild(logoutLink);
  } else {
    // Guest — show login and join now
    var loginLink = document.createElement('a');
    loginLink.href = 'member-login';
    loginLink.innerHTML = '<i class="bi bi-box-arrow-in-right" style="margin-right:.5rem;"></i>LOGIN';
    loginLink.style.cssText = `font-family:'Bebas Neue',sans-serif;font-size:1.8rem;letter-spacing:3px;color:#C8F03D;transition:opacity .2s;`;
    menu.appendChild(loginLink);

    var joinLink = document.createElement('a');
    joinLink.href = 'member-register';
    joinLink.innerHTML = '<i class="bi bi-person-plus" style="margin-right:.5rem;"></i>JOIN NOW';
    joinLink.style.cssText = `font-family:'Bebas Neue',sans-serif;font-size:1.4rem;letter-spacing:2px;color:rgba(255,255,255,.7);transition:opacity .2s;`;
    menu.appendChild(joinLink);
  }

  document.body.appendChild(menu);
  requestAnimationFrame(() => { menu.style.opacity='1'; menu.style.transform='translateY(0)'; });
  hamburger.innerHTML = '<i class="bi bi-x-lg"></i>';
});

/* ── 14. CARD 3D TILT ────────────────────────────── */
document.querySelectorAll('.service-card,.class-card').forEach(card => {
  card.addEventListener('mousemove', e => {
    const rect = card.getBoundingClientRect();
    const x = ((e.clientX - rect.left) / rect.width - 0.5) * 12;
    const y = ((e.clientY - rect.top) / rect.height - 0.5) * -12;
    const isFeatured = card.classList.contains('featured');
    const baseScale = isFeatured ? 1.04 : 1.02;
    card.style.transform = `perspective(800px) rotateY(${x}deg) rotateX(${y}deg) translateY(-6px) scale(${baseScale})`;
    card.style.transition = 'transform 0.05s linear';
  });
  card.addEventListener('mouseleave', () => {
    card.style.transition = 'transform .5s cubic-bezier(.4,0,.2,1)';
    card.style.transform = card.classList.contains('featured') ? 'scale(1.04)' : '';
  });
});

/* ── 15. MOUSE GLOW ON SERVICE CARDS ─────────────── */
document.querySelectorAll('.service-card').forEach(card => {
  let glowEl = document.createElement('div'); glowEl.className = 'card-glow';
  card.appendChild(glowEl);
  card.addEventListener('mousemove', e => {
    const r = card.getBoundingClientRect();
    const mx = ((e.clientX - r.left) / r.width * 100).toFixed(1);
    const my = ((e.clientY - r.top) / r.height * 100).toFixed(1);
    card.style.setProperty('--mx', mx + '%');
    card.style.setProperty('--my', my + '%');
  });
});

/* ── 16. FAQ ACCORDION ───────────────────────────── */
document.querySelectorAll('[data-faq]').forEach(item => {
  item.querySelector('.faq-q')?.addEventListener('click', () => {
    const isOpen = item.classList.contains('open');
    document.querySelectorAll('[data-faq].open').forEach(o => o.classList.remove('open'));
    if (!isOpen) item.classList.add('open');
  });
});

/* ── 17. FLOATING ACTION BUTTON ──────────────────── */
(function () {
  const fabMain = document.getElementById('fabMain');
  const fabMenu = document.getElementById('fabMenu');
  const fabIcon = document.getElementById('fabIcon');
  const fabScrollTop = document.getElementById('fabScrollTop');
  if (!fabMain || !fabMenu) return;
  let isOpen = false;
  fabMain.addEventListener('click', () => {
    isOpen = !isOpen;
    fabMain.classList.toggle('open', isOpen);
    fabMenu.classList.toggle('open', isOpen);
    fabIcon.className = isOpen ? 'bi bi-x-lg' : 'bi bi-plus-lg';
  });
  fabScrollTop?.addEventListener('click', () => {
    window.scrollTo({ top: 0, behavior: 'smooth' });
    isOpen = false; fabMain.classList.remove('open'); fabMenu.classList.remove('open');
    fabIcon.className = 'bi bi-plus-lg';
  });
  // Close on anchor clicks inside fab
  fabMenu.querySelectorAll('a[href^="#"]').forEach(a => {
    a.addEventListener('click', () => {
      isOpen = false; fabMain.classList.remove('open'); fabMenu.classList.remove('open');
      fabIcon.className = 'bi bi-plus-lg';
    });
  });
  // Show FAB only after scrolling 300px
  const fabWrap = document.getElementById('fabWrap');
  if (fabWrap) {
    fabWrap.style.opacity = '0'; fabWrap.style.transition = 'opacity .4s ease';
    window.addEventListener('scroll', () => {
      fabWrap.style.opacity = window.scrollY > 300 ? '1' : '0';
      fabWrap.style.pointerEvents = window.scrollY > 300 ? 'all' : 'none';
    }, { passive: true });
  }
})();

/* ── 18. TEXT REVEAL ─────────────────────────────── */
document.querySelectorAll('.section-title').forEach(t => t.classList.add('text-reveal-mask'));
const textRevealObs = new IntersectionObserver(entries => {
  entries.forEach(e => { if (e.isIntersecting) { e.target.classList.add('text-revealed'); textRevealObs.unobserve(e.target); } });
}, { threshold: 0.2, rootMargin: '0px 0px -50px 0px' });
document.querySelectorAll('.text-reveal-mask').forEach(el => textRevealObs.observe(el));

/* ── 19. SMOOTH SCROLL SKEW (velocity-based) ─────── */
let scrollPos = 0, lastScrollTime = Date.now();
const skewTargets = document.querySelectorAll('.service-card,.class-card,.about-img-wrap,.nutrition-img');
let ticking = false;
window.addEventListener('scroll', () => {
  if (!ticking) {
    requestAnimationFrame(() => {
      const now = Date.now(), elapsed = Math.max(now - lastScrollTime, 1);
      const delta = window.scrollY - scrollPos;
      const velocity = Math.max(Math.min(delta * 0.08, 6), -6);
      skewTargets.forEach(el => {
        if (!el.matches(':hover')) {
          const isFeatured = el.classList.contains('featured');
          el.style.transform = isFeatured ? `scale(1.04) skewY(${velocity}deg)` : `skewY(${velocity}deg)`;
          el.style.transition = 'transform 0.12s cubic-bezier(0.1,0.5,0.3,1)';
        }
      });
      if (Math.abs(delta) < 2) {
        skewTargets.forEach(el => {
          if (!el.matches(':hover')) {
            const isFeatured = el.classList.contains('featured');
            el.style.transform = isFeatured ? 'scale(1.04) skewY(0deg)' : 'skewY(0deg)';
            el.style.transition = 'transform 0.5s cubic-bezier(0.1,0.5,0.3,1)';
          }
        });
      }
      scrollPos = window.scrollY; lastScrollTime = now; ticking = false;
    });
    ticking = true;
  }
}, { passive: true });

/* ── 20. GOAL CARD SELECTOR & QUIZ ──────────────── */
document.querySelectorAll('.goal-card').forEach(card => {
  card.addEventListener('click', () => {
    document.querySelectorAll('.goal-card').forEach(c => c.classList.remove('active'));
    card.classList.add('active');
  });
});
const startQuizBtn = document.getElementById('startQuizBtn');
const quizContainer = document.getElementById('programQuiz');
const goalGrid = document.querySelector('.goal-grid');
const quizSteps = document.querySelectorAll('.quiz-step');
const qBtns = document.querySelectorAll('.q-btn');
const btnRestartQuiz = document.getElementById('btnRestartQuiz');
let currentStep = 0, scores = { strength:0, cardio:0, flex:0, bulk:0 };
if (startQuizBtn && quizContainer) {
  startQuizBtn.addEventListener('click', () => {
    goalGrid.style.display = 'none'; quizContainer.style.display = 'block';
    startQuizBtn.style.display = 'none'; currentStep = 0;
    scores = { strength:0, cardio:0, flex:0, bulk:0 }; showStep(0);
  });
}
function showStep(index) {
  quizSteps.forEach((step, i) => {
    step.style.display = i === index ? 'block' : 'none';
    if (i === index) { step.style.animation='none'; void step.offsetWidth; step.style.animation='fadeUp 0.4s ease both'; }
  });
}
qBtns.forEach(btn => {
  btn.addEventListener('click', () => {
    const key = btn.dataset.score; if (scores[key] !== undefined) scores[key]++;
    currentStep++; if (currentStep < 3) showStep(currentStep); else finishQuiz();
  });
});
function finishQuiz() {
  showStep(3); goalGrid.style.display = 'grid';
  let maxScore = -1, winningGoal = 'cardio';
  for (let key in scores) { if (scores[key] > maxScore) { maxScore = scores[key]; winningGoal = key; } }
  document.querySelectorAll('.goal-card').forEach(c => {
    c.classList.remove('active');
    if (c.dataset.goal === winningGoal) {
      c.classList.add('active');
      setTimeout(() => window.scrollTo({ top: c.getBoundingClientRect().top + window.scrollY - 150, behavior: 'smooth' }), 300);
    }
  });
}
btnRestartQuiz?.addEventListener('click', () => { goalGrid.style.display='none'; currentStep=0; scores={strength:0,cardio:0,flex:0,bulk:0}; showStep(0); });

/* ── 21. BMI CALCULATOR ──────────────────────────── */
document.getElementById('bmiCalcBtn')?.addEventListener('click', () => {
  const h = parseFloat(document.getElementById('bmiHeight')?.value);
  const w = parseFloat(document.getElementById('bmiWeight')?.value);
  if (!h || !w || h < 50 || h > 300 || w < 10 || w > 500) {
    ['bmiHeight','bmiWeight'].forEach(id => { const el=document.getElementById(id); if(el){el.style.borderColor='#f87171';setTimeout(()=>el.style.borderColor='',1500);} }); return;
  }
  const bmi = w / ((h/100)**2);
  const scoreEl = document.getElementById('bmiScore');
  const catEl = document.getElementById('bmiCategory');
  const result = document.getElementById('bmiResult');
  const marker = document.getElementById('bmiMarker');
  const tip = document.getElementById('bmiTip');
  scoreEl.textContent = bmi.toFixed(1);
  result.style.display = 'block'; result.style.animation = 'none'; void result.offsetWidth; result.style.animation = 'fadeUp .4s ease both';
  let cat, color, pct;
  if (bmi < 16) { cat='Severely Underweight'; color='#93c5fd'; pct=5; }
  else if (bmi < 18.5) { cat='Underweight'; color='#60a5fa'; pct=(bmi-16)/2.5*18+2; }
  else if (bmi < 25) { cat='Normal Weight ✓'; color='#C8F03D'; pct=20+(bmi-18.5)/6.5*30; }
  else if (bmi < 30) { cat='Overweight'; color='#fbbf24'; pct=50+(bmi-25)/5*28; }
  else { cat='Obese'; color='#f87171'; pct=Math.min(78+(bmi-30)/10*18,95); }
  const advice = {'Severely Underweight':'Our nutrition coaches and strength programs can help you build healthy weight safely.','Underweight':'Consider our strength training + nutrition coaching combo to build lean mass.','Normal Weight ✓':"Great foundation! Our Standard plan helps you maintain and keep improving.",'Overweight':'Our HIIT + nutrition coaching program is perfect for your transformation goals.','Obese':'Our certified trainers build safe, progressive plans tailored to your starting point.'}[cat]||'';
  catEl.textContent = cat; catEl.style.color = color;
  if (marker) marker.style.left = pct + '%';
  if (tip) tip.textContent = advice;
});

/* ── 22. CALORIE BURN CALCULATOR ─────────────────── */
let selectedMet = 8;
document.querySelectorAll('.cal-activity-btn').forEach(btn => {
  btn.addEventListener('click', () => {
    document.querySelectorAll('.cal-activity-btn').forEach(b => b.classList.remove('active'));
    btn.classList.add('active'); selectedMet = parseFloat(btn.dataset.met);
  });
});
document.getElementById('calBtn')?.addEventListener('click', () => {
  const weight = parseFloat(document.getElementById('calWeight')?.value);
  const duration = parseFloat(document.getElementById('calDuration')?.value);
  if (!weight || !duration || weight < 30 || duration < 5) {
    ['calWeight','calDuration'].forEach(id=>{const el=document.getElementById(id);if(el){el.style.borderColor='#f87171';setTimeout(()=>el.style.borderColor='',1500);}}); return;
  }
  const kcal = Math.round(selectedMet * weight * (duration/60));
  const resultEl = document.getElementById('calResult');
  const calNumEl = document.getElementById('calNum');
  resultEl.style.display = 'block'; resultEl.style.animation='none'; void resultEl.offsetWidth; resultEl.style.animation='fadeUp .4s ease both';
  let frame = 0; const totalFrames = 60;
  const timer = setInterval(() => {
    frame++;
    const p = 1 - Math.pow(1 - frame/totalFrames, 3);
    calNumEl.textContent = Math.round(kcal * p).toLocaleString();
    if (frame >= totalFrames) { calNumEl.textContent = kcal.toLocaleString(); clearInterval(timer); }
  }, 1000/60);
  const foods = [{max:150,name:'1 banana'},{max:250,name:'1 bowl of rice'},{max:350,name:'1 slice of pizza'},{max:500,name:'1 burger'},{max:700,name:'2 slices of pizza'},{max:900,name:'a large meal'},{max:Infinity,name:"a full day's snacks"}];
  const food = foods.find(f => kcal <= f.max);
  const calFoodEl = document.getElementById('calFoodEq');
  const calWalkEl = document.getElementById('calWalkEq');
  const calBarEl  = document.getElementById('calBarFill');
  if (calFoodEl) calFoodEl.textContent = food ? food.name : "a full day's snacks";
  if (calWalkEl) calWalkEl.textContent = Math.round(kcal/4);
  if (calBarEl)  calBarEl.style.width = Math.min((kcal/1000)*100, 100) + '%';
});

/* ── 23. NEWSLETTER ──────────────────────────────── */
document.querySelector('.newsletter button')?.addEventListener('click', () => {
  const input = document.querySelector('.newsletter input');
  if (!input) return;
  if (/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(input.value)) {
    input.value = '✓ You\'re subscribed!'; input.disabled = true;
  } else {
    input.style.borderColor = '#f87171'; input.placeholder = 'Enter a valid email';
    setTimeout(() => { input.style.borderColor=''; input.placeholder='Your email'; }, 2000);
  }
});

/* ── 24. SECTION GLOW OBSERVER ───────────────────── */
const sectionGlowObs = new IntersectionObserver(entries => {
  entries.forEach(e => { if (e.isIntersecting) e.target.classList.add('section-active'); else e.target.classList.remove('section-active'); });
}, { threshold: 0.3 });
document.querySelectorAll('section').forEach(s => sectionGlowObs.observe(s));

/* -- 25. MAP SECTION � GOOGLE MAPS & LIVE STATUS --- */
(function () {
  var MAP_URLS = {
    satellite: 'https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d992.6553786527538!2d79.85066541522705!3d6.916744343738265!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x3ae25927de0c97a5%3A0x5e5f2c6f3f0d1e2a!2s28%20St%20Michaels%20Rd%2C%20Colombo%2000300%2C%20Sri%20Lanka!5e1!3m2!1sen!2sus!4v1700000000000!5m2!1sen!2sus',
    street:    'https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d992.6553786527538!2d79.85066541522705!3d6.916744343738265!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x3ae25927de0c97a5%3A0x5e5f2c6f3f0d1e2a!2s28%20St%20Michaels%20Rd%2C%20Colombo%2000300%2C%20Sri%20Lanka!5e0!3m2!1sen!2sus!4v1700000000000!5m2!1sen!2sus',
    neighbourhood: 'https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3961.3107765!2d79.84823!3d6.9155!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x3ae25927de0c97a5%3A0x5e5f2c6f3f0d1e2a!2s28%20St%20Michaels%20Rd%2C%20Colombo%2000300!5e0!3m2!1sen!2sus!4v1700000000001!5m2!1sen!2sus'
  };

  window.switchMap = function(mode) {
    var iframe = document.getElementById('googleMapIframe');
    if (!iframe) return;
    iframe.style.opacity = '0';
    iframe.style.transition = 'opacity 0.3s';
    setTimeout(function() {
      iframe.src = MAP_URLS[mode] || MAP_URLS.satellite;
      iframe.style.opacity = '1';
    }, 300);
    document.querySelectorAll('.map-toggle-btn').forEach(function(b) { b.classList.remove('active'); });
    var btnIds = { satellite: 'mapBtnSatellite', street: 'mapBtnStreet', neighbourhood: 'mapBtnNeighbour' };
    var activeBtn = document.getElementById(btnIds[mode]);
    if (activeBtn) activeBtn.classList.add('active');
  };

  function formatTimeMap(mins) {
    var hr = Math.floor(mins / 60), mn = mins % 60, ampm = hr >= 12 ? 'PM' : 'AM';
    hr = hr % 12 || 12;
    return hr + ':' + (mn < 10 ? '0' : '') + mn + ' ' + ampm;
  }
  function updateMapStatus() {
    var statusEl  = document.getElementById('mapLiveStatus');
    var labelEl   = document.getElementById('mapStatusLabel');
    var timeEl    = document.getElementById('mapLiveTime');
    var floatStat = document.getElementById('mapFloatStatus');
    if (!statusEl || !labelEl) return;
    var now  = new Date();
    var mins = now.getHours() * 60 + now.getMinutes();
    var day  = now.getDay();
    var isWeekend = (day === 0 || day === 6);
    var H = window.FCMS_HOURS || { weekdayOpen: 300, weekdayClose: 1380, weekendOpen: 360, weekendClose: 1380 };
    var OPEN  = isWeekend ? H.weekendOpen  : H.weekdayOpen;
    var CLOSE = isWeekend ? H.weekendClose : H.weekdayClose;
    var isOpen = mins >= OPEN && mins < CLOSE;
    statusEl.classList.remove('open', 'closed');
    statusEl.classList.add(isOpen ? 'open' : 'closed');
    labelEl.textContent = isOpen ? 'Gym is Open Now' : 'Currently Closed';
    if (timeEl) {
      if (isOpen) {
        var rem = CLOSE - mins;
        timeEl.textContent = rem <= 60 ? ('Closes in ' + rem + 'm') : ('Closes at ' + formatTimeMap(CLOSE));
      } else {
        timeEl.textContent = 'Opens at ' + formatTimeMap(OPEN);
      }
    }
    if (floatStat) {
      floatStat.textContent = isOpen ? 'Open' : 'Closed';
      floatStat.classList.toggle('closed', !isOpen);
    }
  }
  updateMapStatus();
  setInterval(updateMapStatus, 60000);
  window.FCMS_updateMapStatus = updateMapStatus;

  document.querySelectorAll('.map-transport-btn').forEach(function(btn) {
    btn.addEventListener('click', function() {
      document.querySelectorAll('.map-transport-btn').forEach(function(b) { b.classList.remove('active'); });
      btn.classList.add('active');
    });
  });
})();

/* -- NEWSLETTER SUBSCRIBE -- */
function subscribeNewsletter() {
  const inp = document.getElementById('footerEmail');
  if (!inp) return;
  const val = inp.value.trim();
  if (!val || !val.includes('@')) {
    inp.style.borderColor = '#f87171';
    setTimeout(() => inp.style.borderColor = '', 2000);
    return;
  }
  inp.value = '';
  inp.placeholder = 'You are subscribed!';
  inp.style.color = '#C8F03D';
  setTimeout(() => { inp.placeholder = 'Your email address'; inp.style.color = '#fff'; }, 4000);
}


/* ============================================================
   RECOVERY & SPA — Animated Stat Counters
   ============================================================ */
(function () {
  function animateRecoveryStats() {
    const nums = document.querySelectorAll('.rec-stat-num[data-target]');
    if (!nums.length) return;
    const observer = new IntersectionObserver((entries) => {
      entries.forEach(entry => {
        if (!entry.isIntersecting) return;
        const el = entry.target;
        const target = parseInt(el.dataset.target, 10);
        const duration = 1800;
        const start = performance.now();
        function tick(now) {
          const progress = Math.min((now - start) / duration, 1);
          const eased = 1 - Math.pow(1 - progress, 3);
          el.textContent = Math.round(eased * target);
          if (progress < 1) requestAnimationFrame(tick);
        }
        requestAnimationFrame(tick);
        observer.unobserve(el);
      });
    }, { threshold: 0.4 });
    nums.forEach(el => observer.observe(el));
  }
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', animateRecoveryStats);
  } else {
    animateRecoveryStats();
  }
})();

/* ── 22. PLAN MATCH QUIZ ─────────────────────────────── */
(function() {
  var startBtn    = document.getElementById('startQuizBtn');
  var quizBox     = document.getElementById('programQuiz');
  var restartBtn  = document.getElementById('btnRestartQuiz');
  var steps       = [
    document.getElementById('quizStep1'),
    document.getElementById('quizStep2'),
    document.getElementById('quizStep3')
  ];
  var resultStep  = document.getElementById('quizResult');
  if (!startBtn || !quizBox) return;

  var scores      = { strength: 0, cardio: 0, flex: 0, bulk: 0 };
  var currentStep = 0;

  /* Show quiz box on button click */
  startBtn.addEventListener('click', function() {
    resetQuiz();
    quizBox.style.display = 'block';
    startBtn.style.display = 'none';
    quizBox.scrollIntoView({ behavior: 'smooth', block: 'center' });
  });

  /* Attach click handlers to all quiz answer buttons */
  document.querySelectorAll('.q-btn').forEach(function(btn) {
    btn.addEventListener('click', function() {
      var sc = btn.getAttribute('data-score');
      if (sc && scores.hasOwnProperty(sc)) scores[sc]++;
      nextStep();
    });
  });

  /* Restart button */
  if (restartBtn) {
    restartBtn.addEventListener('click', function() {
      resetQuiz();
    });
  }

  function nextStep() {
    if (currentStep < steps.length) {
      if (steps[currentStep]) steps[currentStep].style.display = 'none';
      currentStep++;
    }
    if (currentStep < steps.length) {
      if (steps[currentStep]) steps[currentStep].style.display = 'block';
    } else {
      showResult();
    }
  }

  function showResult() {
    if (resultStep) resultStep.style.display = 'block';
    /* Highlight the matching goal card */
    var best = Object.keys(scores).reduce(function(a, b) {
      return scores[a] >= scores[b] ? a : b;
    });
    document.querySelectorAll('.goal-card').forEach(function(card) {
      card.classList.remove('active');
    });
    var matched = document.querySelector('.goal-card[data-goal="' + best + '"]');
    if (matched) {
      matched.classList.add('active');
      setTimeout(function() {
        matched.scrollIntoView({ behavior: 'smooth', block: 'center' });
      }, 400);
    }
  }

  function resetQuiz() {
    scores = { strength: 0, cardio: 0, flex: 0, bulk: 0 };
    currentStep = 0;
    steps.forEach(function(s, i) {
      if (s) s.style.display = i === 0 ? 'block' : 'none';
    });
    if (resultStep) resultStep.style.display = 'none';
    /* Reset button highlighting */
    document.querySelectorAll('.q-btn').forEach(function(b) {
      b.style.background = '';
      b.style.borderColor = '';
      b.style.color = '';
    });
  }
})();

