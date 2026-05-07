/* ================================================================
   BOOKING MODULE — JavaScript Utilities
   APEX FITNESS · Fitness Center Membership System
   ================================================================
   Client-side helpers for attendance check-in and class enrollment.
   ================================================================ */

(function () {
  'use strict';

  /* ── Live Clock ── */
  function initLiveClock() {
    var el = document.querySelector('.live-clock-time');
    if (!el) return;
    function tick() {
      var now = new Date();
      var h = now.getHours();
      var m = now.getMinutes();
      var s = now.getSeconds();
      var ampm = h >= 12 ? 'PM' : 'AM';
      h = h % 12 || 12;
      el.textContent =
        String(h).padStart(2, '0') + ':' +
        String(m).padStart(2, '0') + ':' +
        String(s).padStart(2, '0') + ' ' + ampm;
    }
    tick();
    setInterval(tick, 1000);
  }

  /* ── Animated Counter ── */
  function initCounters() {
    var counters = document.querySelectorAll('[data-count]');
    counters.forEach(function (el) {
      var target = parseInt(el.getAttribute('data-count'), 10) || 0;
      var current = 0;
      var step = Math.ceil(target / 30);
      var timer = setInterval(function () {
        current += step;
        if (current >= target) {
          current = target;
          clearInterval(timer);
        }
        el.textContent = current;
      }, 30);
    });
  }

  /* ── Member ID Lookup (stub) ── */
  function initMemberLookup() {
    var input = document.getElementById('memberIdInput');
    var display = document.getElementById('memberNameDisplay');
    if (!input || !display) return;
    input.addEventListener('input', function () {
      var val = input.value.trim();
      if (val.length >= 3) {
        display.textContent = 'Looking up member…';
        display.style.color = 'rgba(200,240,61,0.6)';
      } else {
        display.textContent = '';
      }
    });
  }

  /* ── Initialise on DOM Ready ── */
  document.addEventListener('DOMContentLoaded', function () {
    initLiveClock();
    initCounters();
    initMemberLookup();
  });

})();
