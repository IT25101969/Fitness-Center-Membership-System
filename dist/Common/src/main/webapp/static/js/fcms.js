/**
 * FCMS — Client-Side Validation & Interactive UI
 * Antigravity Software | v1.0
 */

// ============================================================
// MEMBER FORM — Premium Field Toggle
// ============================================================
(function () {
  const typeRadios = document.querySelectorAll('input[name="type"]');
  const premiumSection = document.getElementById('premiumSection');

  function togglePremiumFields() {
    const selectedType = document.querySelector('input[name="type"]:checked');
    if (!premiumSection) return;
    if (selectedType && selectedType.value === 'PREMIUM') {
      premiumSection.style.display = 'block';
      premiumSection.querySelectorAll('input, select').forEach(el => el.removeAttribute('disabled'));
    } else {
      premiumSection.style.display = 'none';
      premiumSection.querySelectorAll('input, select').forEach(el => el.setAttribute('disabled', 'disabled'));
    }
  }

  typeRadios.forEach(r => r.addEventListener('change', togglePremiumFields));
  togglePremiumFields(); // Run on page load
})();

// ============================================================
// FORM VALIDATION — Member Registration Form
// ============================================================
(function () {
  const form = document.getElementById('memberForm');
  if (!form) return;

  form.addEventListener('submit', function (e) {
    let valid = true;
    clearErrors();

    const name = form.querySelector('#name');
    const email = form.querySelector('#email');
    const phone = form.querySelector('#phone');
    const planId = form.querySelector('#planId');

    if (!name || name.value.trim().length < 2) {
      showError(name, 'Full name must be at least 2 characters.');
      valid = false;
    }

    if (!email || !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email.value.trim())) {
      showError(email, 'Please enter a valid email address.');
      valid = false;
    }

    if (!phone || !/^\d{10}$/.test(phone.value.trim())) {
      showError(phone, 'Phone number must be exactly 10 digits.');
      valid = false;
    }

    if (!planId || planId.value === '') {
      showError(planId, 'Please select a membership plan.');
      valid = false;
    }

    if (!valid) e.preventDefault();
  });
})();

// ============================================================
// FORM VALIDATION — Plan Form
// ============================================================
(function () {
  const form = document.getElementById('planForm');
  if (!form) return;

  form.addEventListener('submit', function (e) {
    let valid = true;
    clearErrors();

    const planName = form.querySelector('#planName');
    const price = form.querySelector('#price');
    const durationDays = form.querySelector('#durationDays');

    if (!planName || planName.value.trim() === '') {
      showError(planName, 'Plan name is required.');
      valid = false;
    }

    if (!price || isNaN(price.value) || parseFloat(price.value) < 0) {
      showError(price, 'Price must be a valid non-negative number.');
      valid = false;
    }

    if (!durationDays || isNaN(durationDays.value) || parseInt(durationDays.value) <= 0) {
      showError(durationDays, 'Duration must be a positive integer.');
      valid = false;
    }

    if (!valid) e.preventDefault();
  });
})();

// ============================================================
// TABLE SEARCH FILTER
// ============================================================
(function () {
  const searchInput = document.getElementById('tableSearch');
  const filterSelect = document.getElementById('statusFilter');
  const planFilter = document.getElementById('planFilter');
  const tableBody = document.getElementById('memberTableBody');

  function filterTable() {
    if (!tableBody) return;
    const searchTerm = searchInput ? searchInput.value.toLowerCase() : '';
    const status = filterSelect ? filterSelect.value.toLowerCase() : '';
    const plan = planFilter ? planFilter.value.toLowerCase() : '';

    const rows = tableBody.querySelectorAll('tr');
    rows.forEach(row => {
      const text = row.textContent.toLowerCase();
      const matchSearch = !searchTerm || text.includes(searchTerm);
      const matchStatus = !status || text.includes(status);
      const matchPlan = !plan || text.includes(plan);
      row.style.display = matchSearch && matchStatus && matchPlan ? '' : 'none';
    });
    updatePagination();
  }

  if (searchInput) searchInput.addEventListener('input', filterTable);
  if (filterSelect) filterSelect.addEventListener('change', filterTable);
  if (planFilter) planFilter.addEventListener('change', filterTable);
})();

// ============================================================
// CLIENT-SIDE PAGINATION
// ============================================================
let currentPage = 1;
const rowsPerPage = 10;

function updatePagination() {
  const tableBody = document.getElementById('memberTableBody');
  if (!tableBody) return;

  const rows = Array.from(tableBody.querySelectorAll('tr')).filter(r => r.style.display !== 'none');
  const totalPages = Math.max(1, Math.ceil(rows.length / rowsPerPage));
  if (currentPage > totalPages) currentPage = 1;

  rows.forEach((row, idx) => {
    row.style.display = (idx >= (currentPage - 1) * rowsPerPage && idx < currentPage * rowsPerPage) ? '' : 'none';
  });

  renderPaginationControls(totalPages);
}

function renderPaginationControls(totalPages) {
  const container = document.getElementById('paginationContainer');
  if (!container) return;
  container.innerHTML = '';

  for (let i = 1; i <= totalPages; i++) {
    const btn = document.createElement('button');
    btn.textContent = i;
    btn.className = 'page-btn' + (i === currentPage ? ' active' : '');
    btn.addEventListener('click', function () {
      currentPage = i;
      updatePagination();
    });
    container.appendChild(btn);
  }
}

document.addEventListener('DOMContentLoaded', function () {
  updatePagination();

  // Auto-dismiss flash alerts after 4 seconds
  const alerts = document.querySelectorAll('.fcms-alert[data-auto-dismiss]');
  alerts.forEach(alert => {
    setTimeout(() => {
      alert.style.opacity = '0';
      alert.style.transition = 'opacity 0.5s ease';
      setTimeout(() => alert.remove(), 500);
    }, 4000);
  });
});

// ============================================================
// DELETE CONFIRMATION MODAL
// ============================================================
function confirmDelete(url, entityName) {
  const modal = document.getElementById('deleteModal');
  if (!modal) {
    if (confirm('Are you sure you want to delete ' + entityName + '? This action cannot be undone.')) {
      window.location.href = url;
    }
    return;
  }
  document.getElementById('deleteModalLabel').textContent = 'Delete ' + entityName;
  document.getElementById('deleteTargetName').textContent = entityName;
  document.getElementById('confirmDeleteBtn').onclick = function () { window.location.href = url; };
  const bsModal = new bootstrap.Modal(modal);
  bsModal.show();
}

// ============================================================
// ATTENDANCE — Member ID Auto-Lookup via API
// ============================================================
(function () {
  const memberIdInput = document.getElementById('memberIdInput');
  const memberNameDisplay = document.getElementById('memberNameDisplay');
  if (!memberIdInput || !memberNameDisplay) return;

  let lookupTimer = null;

  memberIdInput.addEventListener('input', function () {
    clearTimeout(lookupTimer);
    const id = memberIdInput.value.trim().toUpperCase();
    if (!id) { memberNameDisplay.textContent = ''; return; }

    lookupTimer = setTimeout(function () {
      const ctx = document.querySelector('meta[name="ctx-path"]');
      const basePath = ctx ? ctx.content : '';
      fetch(basePath + '/api/member?id=' + encodeURIComponent(id))
        .then(r => r.json())
        .then(data => {
          if (data.found) {
            memberNameDisplay.innerHTML =
              '<i class="bi bi-check-circle-fill" style="color:var(--success-green);margin-right:4px;"></i>' +
              data.name + ' &mdash; ' + data.plan +
              ' <span style="color:' + (data.status === 'ACTIVE' ? 'var(--success-green)' : 'var(--accent-red)') + '">' +
              data.status + '</span>';
          } else {
            memberNameDisplay.innerHTML =
              '<i class="bi bi-exclamation-circle-fill" style="color:var(--accent-red);margin-right:4px;"></i>' +
              'Member not found';
          }
        })
        .catch(() => { memberNameDisplay.textContent = ''; });
    }, 400);
  });
})();


// ============================================================
// CLASS SCHEDULE — Modal Data Population
// ============================================================
function showClassModal(classId, className, trainerName, schedule, capacity, enrolled, status) {
  const modal = document.getElementById('classDetailModal');
  if (!modal) return;

  document.getElementById('modalClassName').textContent = className || '';
  document.getElementById('modalTrainer').textContent = trainerName || 'TBA';
  document.getElementById('modalSchedule').textContent = schedule || '';
  document.getElementById('modalStatus').textContent = status || '';

  const pct = capacity > 0 ? Math.round((enrolled / capacity) * 100) : 0;
  const bar = document.getElementById('modalCapacityBar');
  if (bar) {
    bar.style.width = pct + '%';
    bar.className = 'capacity-fill ' + (pct < 70 ? 'bg-success' : pct <= 90 ? 'bg-warning' : 'bg-danger');
    bar.textContent = pct + '%';
  }
  document.getElementById('modalEnrolled').textContent = enrolled + ' / ' + capacity;

  const enrollForm = document.getElementById('enrollClassId');
  if (enrollForm) enrollForm.value = classId;

  const bsModal = new bootstrap.Modal(modal);
  bsModal.show();
}

// ============================================================
// UTILITY — Helper functions
// ============================================================
function showError(field, message) {
  if (!field) return;
  field.classList.add('is-invalid');
  let feedback = field.nextElementSibling;
  if (!feedback || !feedback.classList.contains('invalid-feedback')) {
    feedback = document.createElement('div');
    feedback.className = 'invalid-feedback';
    field.parentNode.insertBefore(feedback, field.nextSibling);
  }
  feedback.textContent = message;
}

function clearErrors() {
  document.querySelectorAll('.is-invalid').forEach(el => el.classList.remove('is-invalid'));
  document.querySelectorAll('.invalid-feedback').forEach(el => el.remove());
}

// ============================================================
// LIVE CLOCK
// ============================================================
(function () {
  const clocks = document.querySelectorAll('.live-clock-time');
  if (!clocks.length) return;
  function tick() {
    const now = new Date();
    const t = now.toLocaleTimeString('en-US', { hour: '2-digit', minute: '2-digit', second: '2-digit', hour12: true });
    clocks.forEach(c => c.textContent = t);
  }
  tick();
  setInterval(tick, 1000);
})();

// ============================================================
// ANIMATED STAT COUNTERS (dashboard .stat-value elements)
// ============================================================
(function () {
  const els = document.querySelectorAll('.stat-value[data-count]');
  if (!els.length) return;
  const obs = new IntersectionObserver(entries => {
    entries.forEach(e => {
      if (!e.isIntersecting) return;
      const el = e.target;
      const target = +el.dataset.count;
      const prefix = el.dataset.prefix || '';
      const suffix = el.dataset.suffix || '';
      const duration = 1400;
      const step = target / (duration / 16);
      let cur = 0;
      const timer = setInterval(() => {
        cur += step;
        if (cur >= target) {
          el.textContent = prefix + target.toLocaleString() + suffix;
          clearInterval(timer);
        } else {
          el.textContent = prefix + Math.floor(cur).toLocaleString() + suffix;
        }
      }, 16);
      obs.unobserve(el);
    });
  }, { threshold: 0.5 });
  els.forEach(el => obs.observe(el));
})();

