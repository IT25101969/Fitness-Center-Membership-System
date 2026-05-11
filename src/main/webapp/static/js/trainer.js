/* ================================================================
   TRAINER MODULE — JavaScript Utilities
   APEX FITNESS · Fitness Center Membership System
   ================================================================
   Client-side helpers for trainer management CRUD operations.
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

  /* ── Trainer Search/Filter ── */
  function initTrainerSearch() {
    var input = document.getElementById('trainerSearch');
    if (!input) return;
    input.addEventListener('input', function () {
      var q = input.value.toLowerCase();
      var rows = document.querySelectorAll('.trainer-table tbody tr, .trainer-card');
      rows.forEach(function (row) {
        var text = row.textContent.toLowerCase();
        row.style.display = text.includes(q) ? '' : 'none';
      });
    });
  }

  /* ── Form Validation ── */
  function initTrainerFormValidation() {
    var form = document.getElementById('trainerForm');
    if (!form) return;
    form.addEventListener('submit', function (e) {
      var name  = document.getElementById('trainerName');
      var email = document.getElementById('trainerEmail');
      if (name && !name.value.trim()) {
        e.preventDefault();
        name.focus();
        return;
      }
      if (email && !email.value.trim()) {
        e.preventDefault();
        email.focus();
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
    initTrainerSearch();
    initTrainerFormValidation();
    initAlertDismiss();
  });

})();
