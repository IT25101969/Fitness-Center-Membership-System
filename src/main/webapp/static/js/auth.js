/* ================================================================
   AUTH MODULE — JavaScript Utilities
   APEX FITNESS · Fitness Center Membership System
   ================================================================
   Client-side helpers for login, registration, and authentication
   forms within the auth module.
   ================================================================ */

(function () {
  'use strict';

  /* ── Password Visibility Toggle ── */
  function initPasswordToggle() {
    var toggleBtn = document.getElementById('togglePw');
    var pwInput   = document.getElementById('password');
    var pwIcon    = document.getElementById('pwIcon');
    if (!toggleBtn || !pwInput) return;
    toggleBtn.addEventListener('click', function () {
      var show = pwInput.type === 'password';
      pwInput.type = show ? 'text' : 'password';
      if (pwIcon) {
        pwIcon.className = show ? 'bi bi-eye-slash-fill' : 'bi bi-eye-fill';
      }
    });
  }

  /* ── Form Submission Loading State ── */
  function initFormLoading() {
    var form = document.getElementById('loginForm');
    if (!form) return;
    form.addEventListener('submit', function () {
      var btn = form.querySelector('button[type="submit"]');
      if (btn) {
        btn.innerHTML = '<i class="bi bi-arrow-clockwise" style="animation:spin .8s linear infinite"></i> Signing in…';
        btn.disabled = true;
      }
    });
  }

  /* ── Input Validation Feedback ── */
  function initValidation() {
    var inputs = document.querySelectorAll('.auth-field input');
    inputs.forEach(function (input) {
      input.addEventListener('blur', function () {
        if (input.required && !input.value.trim()) {
          input.style.borderColor = 'rgba(248,113,113,0.5)';
        } else {
          input.style.borderColor = '';
        }
      });
    });
  }

  /* ── Initialise on DOM Ready ── */
  document.addEventListener('DOMContentLoaded', function () {
    initPasswordToggle();
    initFormLoading();
    initValidation();
  });

})();
