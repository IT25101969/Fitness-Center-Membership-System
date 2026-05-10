<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Gym Settings — FCMS</title>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.min.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/admin-dashboard.css">
<c:set var="pageTitle" value="Settings"/>
<style>
/* ── Settings Page Styles ── */
.settings-page { max-width: 1100px; margin: 0 auto; }
.settings-header { margin-bottom: 2rem; }
.settings-header h1 { font-family: var(--font-display); font-size: 1.9rem; letter-spacing: 2px; margin: 0; }
.settings-header h1 span { color: var(--accent); }
.settings-header p { color: var(--gray); font-size: .85rem; margin-top: .3rem; }

/* Tab Pills */
.stab-bar { display: flex; gap: .5rem; flex-wrap: wrap; margin-bottom: 2rem; border-bottom: 1px solid var(--border); padding-bottom: 1rem; }
.stab { display: flex; align-items: center; gap: .45rem; padding: .5rem 1.1rem; border-radius: 8px; font-size: .82rem; font-weight: 600; letter-spacing: .5px; cursor: pointer; border: 1px solid transparent; color: rgba(255,255,255,.5); transition: all .2s; background: none; }
.stab i { font-size: .95rem; }
.stab:hover { color: rgba(255,255,255,.85); background: rgba(255,255,255,.05); }
.stab.active { color: var(--accent); background: rgba(var(--accent-rgb),.1); border-color: rgba(var(--accent-rgb),.25); }

/* Tab Panels */
.stab-panel { display: none; animation: fadeUp .3s ease; }
.stab-panel.active { display: block; }

/* Settings Cards */
.scard { background: var(--card); border: 1px solid var(--border); border-radius: var(--radius); padding: 1.75rem; margin-bottom: 1.5rem; }
.scard-title { font-family: var(--font-display); font-size: 1rem; letter-spacing: 1px; margin-bottom: 1.4rem; display: flex; align-items: center; gap: .5rem; }
.scard-title i { color: var(--accent); font-size: 1.1rem; }

/* Field grid */
.sf-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 1.1rem; }
.sf-grid.cols3 { grid-template-columns: 1fr 1fr 1fr; }
.sf-grid.cols1 { grid-template-columns: 1fr; }
.sf { display: flex; flex-direction: column; gap: .35rem; }
.sf label { font-size: .72rem; color: var(--gray); text-transform: uppercase; letter-spacing: .5px; font-weight: 600; }
.sf input, .sf select, .sf textarea {
  padding: .6rem .9rem; background: rgba(255,255,255,.05); border: 1px solid var(--border);
  border-radius: 8px; color: #fff; font-family: var(--font); font-size: .875rem; transition: border-color .2s, background .2s;
}
.sf input:focus, .sf select:focus, .sf textarea:focus { outline: none; border-color: var(--accent); background: rgba(var(--accent-rgb),.05); }
.sf input[readonly] { opacity: .5; cursor: not-allowed; }
.sf select option { background: #1a1a1a; }
.sf-hint { font-size: .7rem; color: var(--gray2); margin-top: .2rem; }

/* Toggle switch */
.stoggle-row { display: flex; align-items: center; justify-content: space-between; padding: .9rem 0; border-bottom: 1px solid rgba(255,255,255,.05); }
.stoggle-row:last-child { border-bottom: none; }
.stoggle-info { flex: 1; }
.stoggle-info strong { font-size: .875rem; display: block; }
.stoggle-info span { font-size: .75rem; color: var(--gray); }
.stoggle { position: relative; width: 44px; height: 24px; flex-shrink: 0; }
.stoggle input { opacity: 0; width: 0; height: 0; }
.stoggle-slider { position: absolute; inset: 0; background: rgba(255,255,255,.12); border-radius: 24px; cursor: pointer; transition: .3s; }
.stoggle-slider::before { content: ''; position: absolute; width: 18px; height: 18px; left: 3px; bottom: 3px; background: #fff; border-radius: 50%; transition: .3s; }
.stoggle input:checked + .stoggle-slider { background: var(--accent); }
.stoggle input:checked + .stoggle-slider::before { transform: translateX(20px); background: #000; }

/* Save bar */
.save-bar { display: flex; align-items: center; justify-content: flex-end; gap: 1rem; padding: 1.25rem 1.75rem; background: var(--card); border: 1px solid var(--border); border-radius: var(--radius); margin-top: 1.5rem; }
.save-bar .unsaved-pill { font-size: .78rem; color: #fbbf24; display: flex; align-items: center; gap: .4rem; opacity: 0; transition: opacity .3s; }
.save-bar .unsaved-pill.show { opacity: 1; }
.btn-save { display: flex; align-items: center; gap: .5rem; padding: .65rem 1.75rem; background: var(--accent); color: #000; font-weight: 700; font-size: .875rem; border: none; border-radius: 8px; cursor: pointer; transition: all .2s; letter-spacing: .5px; }
.btn-save:hover { transform: translateY(-1px); box-shadow: 0 4px 16px rgba(var(--accent-rgb),.35); }
.btn-save:active { transform: translateY(0); }
.btn-reset { background: transparent; border: 1px solid var(--border); color: rgba(255,255,255,.5); padding: .6rem 1.2rem; border-radius: 8px; font-size: .82rem; cursor: pointer; transition: all .2s; }
.btn-reset:hover { border-color: rgba(255,255,255,.2); color: rgba(255,255,255,.8); }

/* Alert flash */
.flash-alert { display: flex; align-items: center; gap: .75rem; padding: .9rem 1.25rem; border-radius: 10px; margin-bottom: 1.5rem; font-size: .875rem; font-weight: 500; animation: fadeUp .4s ease; }
.flash-success { background: rgba(52,211,153,.1); border: 1px solid rgba(52,211,153,.3); color: #34d399; }
.flash-error { background: rgba(248,113,113,.1); border: 1px solid rgba(248,113,113,.3); color: #f87171; }
.flash-alert i { font-size: 1.1rem; }

/* Password strength */
.pw-strength { height: 3px; border-radius: 2px; margin-top: .4rem; background: rgba(255,255,255,.08); overflow: hidden; }
.pw-strength-fill { height: 100%; border-radius: 2px; transition: width .4s, background .4s; width: 0%; }

@media (max-width:768px) { .sf-grid, .sf-grid.cols3 { grid-template-columns: 1fr; } .stab-bar { gap: .35rem; } }
</style>
</head>
<body>

<jsp:include page="navbar.jsp"/>

<div class="admin-layout">
<jsp:include page="admin-sidebar.jsp"/>
<main class="admin-content">
<div class="settings-page">

  <!-- Header -->
  <div class="settings-header">
    <h1>GYM <span>SETTINGS</span></h1>
    <p>Manage your gym details, hours, social links, notifications and admin profile.</p>
  </div>

  <!-- Flash messages -->
  <c:if test="${not empty successMsg}">
    <div class="flash-alert flash-success">
      <i class="bi bi-check-circle-fill"></i> ${successMsg}
    </div>
  </c:if>
  <c:if test="${not empty errorMsg}">
    <div class="flash-alert flash-error">
      <i class="bi bi-exclamation-circle-fill"></i> ${errorMsg}
    </div>
  </c:if>

  <!-- Tab Bar -->
  <div class="stab-bar">
    <button class="stab active" onclick="showTab('branch',this)" type="button"><i class="bi bi-building"></i> Branch</button>
    <button class="stab" onclick="showTab('hours',this)" type="button"><i class="bi bi-clock"></i> Hours</button>
    <button class="stab" onclick="showTab('social',this)" type="button"><i class="bi bi-share"></i> Social &amp; Web</button>
    <button class="stab" onclick="showTab('business',this)" type="button"><i class="bi bi-briefcase"></i> Business</button>
    <button class="stab" onclick="showTab('notifications',this)" type="button"><i class="bi bi-bell"></i> Notifications</button>
    <button class="stab" onclick="showTab('features',this)" type="button"><i class="bi bi-toggles"></i> Features</button>
    <button class="stab" onclick="showTab('admin',this)" type="button"><i class="bi bi-person-lock"></i> Admin Profile</button>
  </div>

  <!-- Single form wraps all panels -->
  <form method="POST" action="${pageContext.request.contextPath}/settings" id="settingsForm" novalidate>

    <!-- ── BRANCH ── -->
    <div class="stab-panel active" id="tab-branch">
      <div class="scard">
        <div class="scard-title"><i class="bi bi-building"></i> BRANCH DETAILS</div>
        <div class="sf-grid">
          <div class="sf">
            <label for="gymName">Gym Name</label>
            <input id="gymName" name="gymName" type="text" value="${settings.gymName}" required>
          </div>
          <div class="sf">
            <label for="tagline">Tagline / Slogan</label>
            <input id="tagline" name="tagline" type="text" value="${settings.tagline}">
          </div>
          <div class="sf" style="grid-column:1/-1">
            <label for="address">Address</label>
            <input id="address" name="address" type="text" value="${settings.address}">
          </div>
          <div class="sf">
            <label for="phone">Phone Number</label>
            <input id="phone" name="phone" type="tel" value="${settings.phone}">
          </div>
          <div class="sf">
            <label for="email">Contact Email</label>
            <input id="email" name="email" type="email" value="${settings.email}">
          </div>
        </div>
      </div>
    </div>

    <!-- ── HOURS ── -->
    <div class="stab-panel" id="tab-hours">
      <div class="scard">
        <div class="scard-title"><i class="bi bi-clock-history"></i> OPENING HOURS</div>
        <div class="sf-grid cols1">
          <div class="sf">
            <label for="hoursWeekdays">Weekdays (Mon – Fri)</label>
            <input id="hoursWeekdays" name="hoursWeekdays" type="text" value="${settings.hoursWeekdays}" placeholder="e.g. 5:00 AM – 11:00 PM">
          </div>
          <div class="sf">
            <label for="hoursWeekends">Weekends (Sat – Sun)</label>
            <input id="hoursWeekends" name="hoursWeekends" type="text" value="${settings.hoursWeekends}" placeholder="e.g. 6:00 AM – 10:00 PM">
          </div>
          <div class="sf">
            <label for="hoursHolidays">Public Holidays</label>
            <input id="hoursHolidays" name="hoursHolidays" type="text" value="${settings.hoursHolidays}" placeholder="e.g. 7:00 AM – 8:00 PM">
          </div>
        </div>
      </div>
    </div>

    <!-- ── SOCIAL ── -->
    <div class="stab-panel" id="tab-social">
      <div class="scard">
        <div class="scard-title"><i class="bi bi-share-fill"></i> SOCIAL &amp; WEB PRESENCE</div>
        <div class="sf-grid">
          <div class="sf">
            <label for="instagram"><i class="bi bi-instagram" style="color:#e1306c"></i> Instagram</label>
            <input id="instagram" name="instagram" type="text" value="${settings.instagram}">
          </div>
          <div class="sf">
            <label for="facebook"><i class="bi bi-facebook" style="color:#1877f2"></i> Facebook</label>
            <input id="facebook" name="facebook" type="text" value="${settings.facebook}">
          </div>
          <div class="sf">
            <label for="whatsapp"><i class="bi bi-whatsapp" style="color:#25d366"></i> WhatsApp</label>
            <input id="whatsapp" name="whatsapp" type="tel" value="${settings.whatsapp}">
          </div>
          <div class="sf">
            <label for="website"><i class="bi bi-globe2"></i> Website URL</label>
            <input id="website" name="website" type="url" value="${settings.website}">
          </div>
          <div class="sf" style="grid-column:1/-1">
            <label for="mapsLink"><i class="bi bi-geo-alt-fill" style="color:#ea4335"></i> Google Maps Link</label>
            <input id="mapsLink" name="mapsLink" type="url" value="${settings.mapsLink}">
          </div>
        </div>
      </div>
    </div>

    <!-- ── BUSINESS ── -->
    <div class="stab-panel" id="tab-business">
      <div class="scard">
        <div class="scard-title"><i class="bi bi-briefcase-fill"></i> BUSINESS CONFIGURATION</div>
        <div class="sf-grid cols3">
          <div class="sf">
            <label for="currency">Currency</label>
            <select id="currency" name="currency">
              <option value="LKR" ${settings.currency=='LKR'?'selected':''}>LKR – Sri Lankan Rupee</option>
              <option value="USD" ${settings.currency=='USD'?'selected':''}>USD – US Dollar</option>
              <option value="EUR" ${settings.currency=='EUR'?'selected':''}>EUR – Euro</option>
              <option value="GBP" ${settings.currency=='GBP'?'selected':''}>GBP – British Pound</option>
              <option value="INR" ${settings.currency=='INR'?'selected':''}>INR – Indian Rupee</option>
            </select>
          </div>
          <div class="sf">
            <label for="timezone">Timezone</label>
            <select id="timezone" name="timezone">
              <option value="Asia/Colombo" ${settings.timezone=='Asia/Colombo'?'selected':''}>Asia/Colombo (GMT+5:30)</option>
              <option value="Asia/Kolkata" ${settings.timezone=='Asia/Kolkata'?'selected':''}>Asia/Kolkata (GMT+5:30)</option>
              <option value="Asia/Dubai" ${settings.timezone=='Asia/Dubai'?'selected':''}>Asia/Dubai (GMT+4)</option>
              <option value="Europe/London" ${settings.timezone=='Europe/London'?'selected':''}>Europe/London (GMT+0)</option>
              <option value="America/New_York" ${settings.timezone=='America/New_York'?'selected':''}>America/New York</option>
            </select>
          </div>
          <div class="sf">
            <label for="language">Language</label>
            <select id="language" name="language">
              <option value="en" ${settings.language=='en'?'selected':''}>English</option>
              <option value="si" ${settings.language=='si'?'selected':''}>Sinhala</option>
              <option value="ta" ${settings.language=='ta'?'selected':''}>Tamil</option>
            </select>
          </div>
        </div>
      </div>
    </div>

    <!-- ── NOTIFICATIONS ── -->
    <div class="stab-panel" id="tab-notifications">
      <div class="scard">
        <div class="scard-title"><i class="bi bi-bell-fill"></i> NOTIFICATION PREFERENCES</div>
        <div class="stoggle-row">
          <div class="stoggle-info">
            <strong>Email Notifications</strong>
            <span>Receive system alerts and member updates via email</span>
          </div>
          <label class="stoggle">
            <input type="checkbox" name="emailNotifications" ${settings.emailNotifications?'checked':''}>
            <span class="stoggle-slider"></span>
          </label>
        </div>
        <div class="stoggle-row">
          <div class="stoggle-info">
            <strong>SMS Notifications</strong>
            <span>Receive critical alerts via SMS to admin phone</span>
          </div>
          <label class="stoggle">
            <input type="checkbox" name="smsNotifications" ${settings.smsNotifications?'checked':''}>
            <span class="stoggle-slider"></span>
          </label>
        </div>
        <div class="stoggle-row">
          <div class="stoggle-info">
            <strong>Membership Expiry Alerts</strong>
            <span>Alert when memberships are about to expire</span>
          </div>
          <label class="stoggle">
            <input type="checkbox" name="expiryAlerts" id="expiryAlertsToggle" ${settings.expiryAlerts?'checked':''}>
            <span class="stoggle-slider"></span>
          </label>
        </div>
        <div class="stoggle-row" id="expiryDaysRow" style="${settings.expiryAlerts?'':'opacity:.4;pointer-events:none'}">
          <div class="stoggle-info">
            <strong>Alert Advance Days</strong>
            <span>How many days before expiry to send the alert</span>
          </div>
          <div style="width:100px">
            <input type="number" name="expiryAlertDays" id="expiryAlertDays" min="1" max="30"
                   value="${settings.expiryAlertDays}" style="width:100%;text-align:center;">
          </div>
        </div>
      </div>
    </div>

    <!-- ── FEATURES ── -->
    <div class="stab-panel" id="tab-features">
      <div class="scard">
        <div class="scard-title"><i class="bi bi-toggles"></i> FEATURE FLAGS</div>
        <div class="stoggle-row">
          <div class="stoggle-info">
            <strong>Online Booking</strong>
            <span>Allow members to book classes via the member portal</span>
          </div>
          <label class="stoggle">
            <input type="checkbox" name="onlineBooking" ${settings.onlineBooking?'checked':''}>
            <span class="stoggle-slider"></span>
          </label>
        </div>
        <div class="stoggle-row">
          <div class="stoggle-info">
            <strong>Member Portal</strong>
            <span>Enable the self-service member dashboard</span>
          </div>
          <label class="stoggle">
            <input type="checkbox" name="memberPortal" ${settings.memberPortal?'checked':''}>
            <span class="stoggle-slider"></span>
          </label>
        </div>
        <div class="stoggle-row">
          <div class="stoggle-info">
            <strong>Public Class Schedule</strong>
            <span>Show class schedule to non-logged-in visitors</span>
          </div>
          <label class="stoggle">
            <input type="checkbox" name="publicSchedule" ${settings.publicSchedule?'checked':''}>
            <span class="stoggle-slider"></span>
          </label>
        </div>
      </div>
    </div>

    <!-- ── ADMIN PROFILE ── -->
    <div class="stab-panel" id="tab-admin">
      <div class="scard">
        <div class="scard-title"><i class="bi bi-person-lock"></i> ADMIN PROFILE &amp; PASSWORD</div>
        <div class="sf-grid cols1">
          <div class="sf">
            <label for="adminUsername">Admin Username</label>
            <input id="adminUsername" name="adminUsername" type="text" value="${settings.adminUsername}" readonly>
            <span class="sf-hint">Username cannot be changed. Contact your system administrator.</span>
          </div>
          <div class="sf">
            <label for="currentPassword">Current Password</label>
            <input id="currentPassword" name="currentPassword" type="password" placeholder="Enter current password" autocomplete="current-password">
          </div>
          <div class="sf">
            <label for="newPassword">New Password</label>
            <input id="newPassword" name="newPassword" type="password" placeholder="Enter new password" autocomplete="new-password">
            <div class="pw-strength"><div class="pw-strength-fill" id="pwStrengthBar"></div></div>
            <span class="sf-hint" id="pwStrengthLabel">Password strength will appear here</span>
          </div>
          <div class="sf">
            <label for="confirmPassword">Confirm New Password</label>
            <input id="confirmPassword" name="confirmPassword" type="password" placeholder="Confirm new password" autocomplete="new-password">
            <span class="sf-hint" id="pwMatchHint"></span>
          </div>
        </div>
      </div>
    </div>

    <!-- Save Bar -->
    <div class="save-bar">
      <span class="unsaved-pill" id="unsavedPill"><i class="bi bi-circle-fill" style="font-size:.5rem"></i> Unsaved changes</span>
      <button type="button" class="btn-reset" onclick="resetForm()">Reset</button>
      <button type="submit" class="btn-save" id="saveBtn">
        <i class="bi bi-check-lg"></i> Save Settings
      </button>
    </div>

  </form>

</div>
</main>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/static/js/fcms.js"></script>
<script>
// ── Tab switching ──────────────────────────────────────────
function showTab(name, btn) {
  document.querySelectorAll('.stab-panel').forEach(p => p.classList.remove('active'));
  document.querySelectorAll('.stab').forEach(b => b.classList.remove('active'));
  document.getElementById('tab-' + name).classList.add('active');
  if (btn) btn.classList.add('active');
}

// Auto-open tab if there's a password error
<c:if test="${not empty errorMsg}">
showTab('admin', document.querySelector('.stab:last-child'));
</c:if>

// ── Unsaved indicator ─────────────────────────────────────
const pill = document.getElementById('unsavedPill');
document.getElementById('settingsForm').addEventListener('change', () => pill.classList.add('show'));
document.getElementById('settingsForm').addEventListener('input',  () => pill.classList.add('show'));

// ── Reset form ────────────────────────────────────────────
function resetForm() {
  document.getElementById('settingsForm').reset();
  pill.classList.remove('show');
}

// ── Expiry alert toggle linkage ───────────────────────────
document.getElementById('expiryAlertsToggle').addEventListener('change', function() {
  const row = document.getElementById('expiryDaysRow');
  row.style.opacity = this.checked ? '1' : '.4';
  row.style.pointerEvents = this.checked ? '' : 'none';
});

// ── Password strength meter ───────────────────────────────
const pwInput  = document.getElementById('newPassword');
const pwBar    = document.getElementById('pwStrengthBar');
const pwLabel  = document.getElementById('pwStrengthLabel');
const pwMatch  = document.getElementById('pwMatchHint');
const pwConf   = document.getElementById('confirmPassword');

pwInput.addEventListener('input', function() {
  const v = this.value;
  let score = 0;
  if (v.length >= 8) score++;
  if (/[A-Z]/.test(v)) score++;
  if (/[0-9]/.test(v)) score++;
  if (/[^A-Za-z0-9]/.test(v)) score++;
  const map = [
    { w: '0%',   color: 'transparent', label: 'Enter a password' },
    { w: '25%',  color: '#f87171',     label: 'Weak' },
    { w: '50%',  color: '#fbbf24',     label: 'Fair' },
    { w: '75%',  color: '#60a5fa',     label: 'Good' },
    { w: '100%', color: 'var(--accent)', label: 'Strong' },
  ];
  const m = map[score] || map[0];
  pwBar.style.width = m.w;
  pwBar.style.background = m.color;
  pwLabel.textContent = m.label;
  checkMatch();
});

pwConf.addEventListener('input', checkMatch);

function checkMatch() {
  if (!pwConf.value) { pwMatch.textContent = ''; return; }
  if (pwInput.value === pwConf.value) {
    pwMatch.textContent = '✓ Passwords match';
    pwMatch.style.color = 'var(--accent)';
  } else {
    pwMatch.textContent = '✗ Passwords do not match';
    pwMatch.style.color = '#f87171';
  }
}

// ── Save button loading state ─────────────────────────────
document.getElementById('settingsForm').addEventListener('submit', function() {
  const btn = document.getElementById('saveBtn');
  btn.innerHTML = '<i class="bi bi-hourglass-split"></i> Saving…';
  btn.disabled = true;
});

// ── Auto-dismiss flash messages ───────────────────────────
document.querySelectorAll('.flash-alert').forEach(el => {
  setTimeout(() => {
    el.style.transition = 'opacity .5s';
    el.style.opacity = '0';
    setTimeout(() => el.remove(), 500);
  }, 5000);
});
</script>
</body>
</html>
