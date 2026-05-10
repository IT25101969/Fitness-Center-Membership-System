/* ============================================================
   APEX STATE — Centralized Dashboard State Manager
   Single source of truth for all cross-tab data.
   ============================================================ */

(function() {
  'use strict';

  var STORAGE_KEY = 'apexDashState';
  var listeners = [];

  /* ── Default State ── */
  var defaults = {
    workoutsThisWeek: 3,
    workoutsGoal: 5,
    totalCalBurned: 1320,
    totalTimeMins: 260,
    waterIntakeL: 1.25,
    waterGoalL: 3.0,
    sleepHrs: 7.25,
    sleepGoalHrs: 8,
    weight: 78,
    weightGoal: 75,
    bodyFat: 18,
    bodyFatGoal: 15,
    stepsToday: 5600,
    stepsGoal: 10000,
    streak: 7,
    xp: 1250,
    weeklyGoalPct: 68,
    completedWorkouts: [
      { name: 'Upper Body Power', time: '07:15 AM', day: 'Today', dur: '55 min', kcal: 420, exercises: 6 },
      { name: 'HIIT Cardio Blast', time: '06:30 AM', day: 'Yesterday', dur: '32 min', kcal: 380, exercises: 4 },
      { name: 'Leg Day Destroyer', time: '17:00', day: 'Mon, 28th', dur: '48 min', kcal: 350, exercises: 5 }
    ],
    weeklyCalories: [420, 600, 0, 480, 550, 800, 0],
    weeklyVolume: [2400, 0, 3100, 2800, 0, 4200, 0],
    weeklyActiveMins: [45, 60, 0, 45, 60, 90, 0]
  };

  /* ── Load / Save ── */
  var state = {};

  function loadState() {
    try {
      var saved = localStorage.getItem(STORAGE_KEY);
      if (saved) {
        state = JSON.parse(saved);
        // Merge missing keys from defaults
        for (var k in defaults) {
          if (!(k in state)) state[k] = defaults[k];
        }
        // Ensure sleepHrs is always numeric (fix for older corrupted string values)
        if (typeof state.sleepHrs === 'string') state.sleepHrs = defaults.sleepHrs;
      } else {
        state = JSON.parse(JSON.stringify(defaults));
      }
    } catch(e) {
      state = JSON.parse(JSON.stringify(defaults));
    }
  }

  function saveState() {
    try { localStorage.setItem(STORAGE_KEY, JSON.stringify(state)); } catch(e) {}
  }

  /* ── Pub / Sub ── */
  function notify(key) {
    for (var i = 0; i < listeners.length; i++) {
      try { listeners[i](key, state); } catch(e) {}
    }
    updateBindings(key);
  }

  /* ── Data Binding Engine ── */
  var formatters = {
    workoutsThisWeek: function(v) { return v + '/' + state.workoutsGoal; },
    totalCalBurned: function(v) { return v.toLocaleString(); },
    totalTimeMins: function(v) {
      var h = Math.floor(v / 60), m = v % 60;
      return h > 0 ? h + 'h ' + m + 'm' : m + 'm';
    },
    waterIntakeL: function(v) { return v.toFixed(1); },
    sleepHrs: function(v) {
      var h = Math.floor(v), m = Math.round((v - h) * 60);
      return h + 'h ' + (m > 0 ? m + 'm' : '00m');
    },
    weight: function(v) { return v; },
    bodyFat: function(v) { return v; },
    stepsToday: function(v) { return v.toLocaleString(); },
    streak: function(v) { return v; },
    xp: function(v) { return v.toLocaleString(); },
    weeklyGoalPct: function(v) { return v + '%'; }
  };

  function updateBindings(key) {
    var els;
    if (key) {
      els = document.querySelectorAll('[data-bind="' + key + '"]');
    } else {
      els = document.querySelectorAll('[data-bind]');
    }
    for (var i = 0; i < els.length; i++) {
      var el = els[i];
      var k = el.getAttribute('data-bind');
      if (k in state) {
        var val = state[k];
        var fmt = formatters[k];
        el.textContent = fmt ? fmt(val) : val;
      }
    }
    // Update progress bars
    updateProgressBars();
  }

  function updateProgressBars() {
    // Water bar in Health
    var waterPct = Math.min(100, Math.round((state.waterIntakeL / state.waterGoalL) * 100));
    setBar('waterBar', waterPct);
    setText('waterPctDisplay', waterPct + '%');

    // Sleep quality bar
    var sleepPct = Math.min(100, Math.round((state.sleepHrs / state.sleepGoalHrs) * 100));
    setBar('sleepQualBar', sleepPct);
    setText('sleepQualPct', sleepPct + '%');

    // Goals section progress bars
    setBar('goalBarWeight', calcGoalPct('weight', 'weightGoal', true));
    setBar('goalBarWorkout', Math.round((state.workoutsThisWeek / state.workoutsGoal) * 100));
    setBar('goalBarHydration', Math.round((state.waterIntakeL / state.waterGoalL) * 100));
    setBar('goalBarSleep', sleepPct);
    setBar('goalBarSteps', Math.round((state.stepsToday / state.stepsGoal) * 100));
    setBar('goalBarBf', calcGoalPct('bodyFat', 'bodyFatGoal', true));

    // Goals percentage badges
    setText('goalPctWeight', calcGoalPct('weight', 'weightGoal', true) + '%');
    setText('goalPctWorkout', Math.round((state.workoutsThisWeek / state.workoutsGoal) * 100) + '%');
    setText('goalPctHydration', Math.round((state.waterIntakeL / state.waterGoalL) * 100) + '%');
    setText('goalPctSleep', sleepPct + '%');
    setText('goalPctSteps', Math.round((state.stepsToday / state.stepsGoal) * 100) + '%');
    setText('goalPctBf', calcGoalPct('bodyFat', 'bodyFatGoal', true) + '%');

    // Weekly goal pct in Workouts
    var wkPct = Math.round((state.workoutsThisWeek / state.workoutsGoal) * 100);
    state.weeklyGoalPct = wkPct;

    // Overview activity rings
    updateOverviewRings();
  }

  function calcGoalPct(currentKey, goalKey, inverse) {
    var c = state[currentKey], g = state[goalKey];
    if (inverse && c > g) {
      // For weight/bf: progress = how much lost vs total to lose
      var start = currentKey === 'weight' ? 82 : 22; // starting points
      var totalToLose = start - g;
      var lost = start - c;
      return totalToLose > 0 ? Math.min(100, Math.max(0, Math.round((lost / totalToLose) * 100))) : 0;
    }
    return g > 0 ? Math.min(100, Math.round((c / g) * 100)) : 0;
  }

  function updateOverviewRings() {
    // Move ring = calories (target 600)
    var calPct = Math.min(100, Math.round((state.totalCalBurned / 2000) * 100));
    setText('ovCalVal', state.totalCalBurned > 0 ? state.totalCalBurned : '0');
    // Streak
    setText('ovStreakVal', state.streak);
  }

  function setBar(id, pct) {
    var el = document.getElementById(id);
    if (el) el.style.width = Math.min(100, Math.max(0, pct)) + '%';
  }
  function setText(id, val) {
    var el = document.getElementById(id);
    if (el) el.textContent = val;
  }

  /* ── Actions ── */
  function completeWorkout(planName, kcal, timeMins, exerciseCount) {
    state.workoutsThisWeek = Math.min(state.workoutsThisWeek + 1, 7);
    state.totalCalBurned += kcal;
    state.totalTimeMins += timeMins;
    state.xp += Math.round(kcal * 0.5 + timeMins * 2);

    // Add to completed workouts
    var now = new Date();
    var timeStr = now.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });
    state.completedWorkouts.unshift({
      name: planName,
      time: timeStr,
      day: 'Today',
      dur: timeMins + ' min',
      kcal: kcal,
      exercises: exerciseCount || 0
    });
    if (state.completedWorkouts.length > 10) state.completedWorkouts.pop();

    // Update weekly arrays for today's day index
    var dow = now.getDay();
    var dayIdx = dow === 0 ? 6 : dow - 1; // Mon=0 ... Sun=6
    state.weeklyCalories[dayIdx] = (state.weeklyCalories[dayIdx] || 0) + kcal;
    state.weeklyActiveMins[dayIdx] = (state.weeklyActiveMins[dayIdx] || 0) + timeMins;

    saveState();
    notify('workoutsThisWeek');
    notify('totalCalBurned');
    notify('totalTimeMins');
    notify('xp');
    notify('weeklyGoalPct');

    // Rebuild workout timeline
    rebuildWorkoutTimeline();
  }

  function setMetric(key, val) {
    state[key] = val;
    saveState();
    notify(key);
  }

  function getMetric(key) {
    return state[key];
  }

  function getState() {
    return state;
  }

  function resetState() {
    state = JSON.parse(JSON.stringify(defaults));
    saveState();
    updateBindings();
  }

  /* ── Rebuild dynamic UIs ── */
  function rebuildWorkoutTimeline() {
    var tl = document.getElementById('workoutTimeline');
    if (!tl) return;
    var html = '';
    var list = state.completedWorkouts;
    for (var i = 0; i < Math.min(list.length, 5); i++) {
      var w = list[i];
      html += '<div class="tl-entry"><div class="tl-entry-time">' + w.day + ' · ' + w.time
        + '</div><div class="tl-entry-text"><strong>' + w.name + '</strong> — '
        + w.dur + ' · ' + w.kcal + ' kcal · ' + w.exercises + ' exercises</div></div>';
    }
    tl.innerHTML = html;
  }

  /* ── Init ── */
  loadState();

  /* ── Public API ── */
  window.ApexState = {
    get: getMetric,
    set: setMetric,
    getState: getState,
    completeWorkout: completeWorkout,
    on: function(fn) { listeners.push(fn); },
    updateUI: function() { updateBindings(); rebuildWorkoutTimeline(); },
    reset: resetState,
    _formatters: formatters
  };

})();
