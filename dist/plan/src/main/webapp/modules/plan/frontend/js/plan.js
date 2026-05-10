/* ================================================================
   PLAN MODULE — JavaScript Utilities
   APEX FITNESS · Fitness Center Membership System
   ================================================================
   Client-side helpers for membership plan management.
   ================================================================ */

(function () {
  'use strict';

  /* ── Delete Confirmation ── */
  window.confirmDelete = function (url, name) {
    var nameEl = document.getElementById('deleteTargetName');
    var btn    = document.getElementById('confirmDeleteBtn');
    if (nameEl) nameEl.textContent = name;
    if (btn) {
      btn.onclick = function () { window.location.href = url; };
    }
    var modal = document.getElementById('deleteModal');
    if (modal && typeof bootstrap !== 'undefined') {
      new bootstrap.Modal(modal).show();
    }
  };

  /* ── Plan Form Validation ── */
  function initPlanFormValidation() {
    var form = document.getElementById('planForm');
    if (!form) return;
    form.addEventListener('submit', function (e) {
      var name  = document.getElementById('planName');
      var price = document.getElementById('price');
      var dur   = document.getElementById('durationDays');

      if (name && !name.value.trim()) {
        e.preventDefault();
        name.focus();
        return;
      }
      if (price && (isNaN(price.value) || Number(price.value) < 0)) {
        e.preventDefault();
        price.focus();
        return;
      }
      if (dur && (isNaN(dur.value) || Number(dur.value) < 1)) {
        e.preventDefault();
        dur.focus();
        return;
      }
    });
  }

  /* ── Auto-dismiss Alerts ── */
  function initAlertDismiss() {
    var alerts = document.querySelectorAll('[data-auto-dismiss]');
    alerts.forEach(function (alert) {
      setTimeout(function () {
        alert.style.transition = 'opacity 0.4s, transform 0.4s';
        alert.style.opacity = '0';
        alert.style.transform = 'translateY(-10px)';
        setTimeout(function () { alert.remove(); }, 400);
      }, 4000);
    });
  }

  /* ── Initialise on DOM Ready ── */
  document.addEventListener('DOMContentLoaded', function () {
    initPlanFormValidation();
    initAlertDismiss();
  });

})();
