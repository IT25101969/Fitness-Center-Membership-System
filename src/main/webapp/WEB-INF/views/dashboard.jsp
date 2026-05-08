<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard — FCMS</title>
    <meta name="description" content="Fitness Center Membership System admin dashboard.">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css?t=<%= new java.util.Date().getTime() %>">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/admin-dashboard.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <c:set var="pageTitle" value="Dashboard"/>
    <style>
        .dash-main {
            padding: 0;
            min-height: calc(100vh - var(--navbar-h));
            animation: fadeIn .6s ease;
        }
        /* 4-column stat grid */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 1.25rem;
            margin-bottom: 2rem;
        }
        /* Bottom two-column panels */
        .panels-grid {
            display: grid;
            grid-template-columns: 3fr 2fr;
            gap: 1.25rem;
        }
        /* Welcome banner */
        .welcome-banner {
            position: relative;
            border-radius: var(--radius);
            overflow: hidden;
            margin-bottom: 2rem;
            background: linear-gradient(135deg, #0f1a00, var(--dark2));
            border: 1px solid rgba(var(--accent-rgb), .15);
        }
        .welcome-inner {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 2rem 2.5rem;
            position: relative;
            z-index: 1;
        }
        .welcome-banner::before {
            content: '';
            position: absolute;
            top: -60%; right: -10%;
            width: 400px; height: 400px;
            background: radial-gradient(circle, rgba(var(--accent-rgb), .08) 0%, transparent 70%);
            pointer-events: none;
        }
        .welcome-title {
            font-family: var(--font-display);
            font-size: 2.4rem;
            letter-spacing: 2px;
            line-height: 1.1;
            margin-bottom: 0;
        }
        .welcome-sub {
            color: var(--gray);
            font-size: .88rem;
        }
        .welcome-actions {
            display: flex;
            gap: .75rem;
        }
        /* Quick links bar */
        .quick-links {
            display: flex;
            gap: .75rem;
            margin-bottom: 2rem;
            flex-wrap: wrap;
        }
        .quick-link {
            display: flex;
            align-items: center;
            gap: .5rem;
            padding: .55rem 1.1rem;
            border-radius: 50px;
            background: var(--card);
            border: 1px solid var(--border);
            font-size: .82rem;
            font-weight: 500;
            color: rgba(255,255,255,.6);
            transition: all .25s;
        }
        .quick-link:hover {
            border-color: var(--accent);
            color: var(--accent);
            background: rgba(var(--accent-rgb), .06);
            transform: translateY(-1px);
        }
        .quick-link i { font-size: .9rem; }
        /* Panel header */
        .panel-header {
            padding: 1rem 1.25rem;
            border-bottom: 1px solid var(--border);
            display: flex;
            align-items: center;
            justify-content: space-between;
        }
        .panel-title {
            margin: 0;
            font-family: var(--font-display);
            font-size: 1.15rem;
            letter-spacing: 1px;
        }
        .panel-title i { color: var(--accent); margin-right: .5rem; }
        .panel-link {
            font-size: .8rem;
            color: var(--accent);
            display: flex;
            align-items: center;
            gap: .3rem;
            transition: opacity .2s;
        }
        .panel-link:hover { opacity: .75; }
        /* Class row inside panel */
        .class-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: .75rem 1rem;
            background: rgba(255,255,255,.02);
            border-radius: var(--radius-sm);
            border: 1px solid var(--border);
            transition: border-color .2s;
        }
        .class-row:hover { border-color: rgba(var(--accent-rgb), .2); }
        .class-name { font-weight: 600; font-size: .9rem; }
        .class-meta {
            font-size: .75rem;
            color: var(--gray);
            margin-top: .15rem;
            display: flex;
            gap: .8rem;
        }
        .class-meta i { color: var(--accent); }
        /* Responsive */
        @media (max-width: 992px) {
            .stats-grid { grid-template-columns: repeat(2, 1fr); }
            .panels-grid { grid-template-columns: 1fr; }
            .dash-main { padding: 1.5rem 1rem 3rem; }
        }
        @media (max-width: 600px) {
            .stats-grid { grid-template-columns: 1fr; }
            .welcome-inner { flex-direction: column; gap: 1rem; align-items: flex-start; }
        }
    </style>
</head>
<body>

<jsp:include page="navbar.jsp"/>

<div class="admin-layout">
<jsp:include page="admin-sidebar.jsp"/>
<main class="admin-content">

<!-- SECTION: Overview -->
<div class="dash-section active-section" id="sec-overview">

    <!-- ── Welcome Banner ─────────────────────────────── -->
    <div class="welcome-banner fade-in">
        <div class="welcome-inner">
            <div>
                <h1 class="welcome-title">DASHBOARD <span style="color:var(--accent);">OVERVIEW</span></h1>
            </div>
            <div class="welcome-actions">
                <a href="${pageContext.request.contextPath}/members/new" class="btn-fcms-primary">
                    <i class="bi bi-person-plus-fill"></i> Add Member
                </a>
                <a href="${pageContext.request.contextPath}/classes" class="btn-fcms-primary"
                   style="background:transparent;border:1px solid var(--accent);color:var(--accent);">
                    <i class="bi bi-calendar-plus"></i> View Classes
                </a>
            </div>
        </div>
    </div>



    <!-- ── Stats Grid (4 columns) ─────────────────────── -->
    <div class="stats-grid">
        <div class="stat-card card-members fade-in">
            <div class="stat-icon blue"><i class="bi bi-people-fill"></i></div>
            <div class="stat-value" data-count="${totalMembers}">${totalMembers}</div>
            <div class="stat-label">TOTAL MEMBERS</div>
            <div style="margin-top:.6rem;font-size:.78rem;color:var(--success);">
                <i class="bi bi-circle-fill" style="font-size:.4rem;vertical-align:middle;"></i>
                ${activeMembers} Active
            </div>
        </div>
        <div class="stat-card card-plans fade-in" style="animation-delay:.1s;">
            <div class="stat-icon green"><i class="bi bi-card-checklist"></i></div>
            <div class="stat-value" data-count="${totalPlans}">${totalPlans}</div>
            <div class="stat-label">ACTIVE PLANS</div>
            <div style="margin-top:.6rem;font-size:.78rem;color:var(--text-dim);">Basic, Standard, Premium</div>
        </div>
        <div class="stat-card card-classes fade-in" style="animation-delay:.2s;">
            <div class="stat-icon blue" style="background:rgba(96,165,250,.1);color:#60a5fa;">
                <i class="bi bi-calendar-check"></i>
            </div>
            <div class="stat-value" data-count="${todayCheckIns}">${todayCheckIns}</div>
            <div class="stat-label">CHECK-INS TODAY</div>
            <div style="margin-top:.6rem;font-size:.78rem;color:var(--text-dim);">
                <i class="bi bi-clock"></i> ${totalClasses} total classes
            </div>
        </div>
        <div class="stat-card card-revenue fade-in" style="animation-delay:.3s;">
            <div class="stat-icon red"><i class="bi bi-cash-stack"></i></div>
            <div class="stat-value">Rs.<fmt:formatNumber value="${monthlyRevenue}" pattern="#,###"/></div>
            <div class="stat-label">MONTHLY REVENUE</div>
            <div style="margin-top:.6rem;font-size:.78rem;color:var(--text-dim);">From active members</div>
        </div>
    </div>

    <!-- ── Bottom Panels (Members + Classes) ──────────── -->
    <div class="panels-grid">

        <!-- Recent Members -->
        <div class="fcms-table-wrapper fade-in" style="animation-delay:.35s;">
            <div class="panel-header">
                <h5 class="panel-title">
                    <i class="bi bi-people-fill"></i>RECENT MEMBERS
                </h5>
                <a href="${pageContext.request.contextPath}/members" class="panel-link">
                    View all <i class="bi bi-arrow-right"></i>
                </a>
            </div>
            <table class="fcms-table">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Name</th>
                        <th>Plan</th>
                        <th>Join Date</th>
                        <th>Status</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="m" items="${recentMembers}">
                        <tr>
                            <td><code>${m.id}</code></td>
                            <td>
                                <div style="display:flex;align-items:center;gap:.6rem;">
                                    <div class="fcms-avatar" style="width:30px;height:30px;font-size:.72rem;">
                                        ${m.name.substring(0,1)}
                                    </div>
                                    <span style="font-weight:500;">${m.name}</span>
                                </div>
                            </td>
                            <td>
                                <span class="badge-status badge-${m.type.toLowerCase()}">${m.planName}</span>
                            </td>
                            <td style="font-size:.82rem;color:var(--gray);">${m.joinDate}</td>
                            <td>
                                <span class="badge-status ${m.status == 'ACTIVE' ? 'badge-active' : 'badge-inactive'}">
                                    <i class="bi bi-circle-fill" style="font-size:.35rem;"></i>
                                    ${m.status}
                                </span>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty recentMembers}">
                        <tr>
                            <td colspan="5" style="text-align:center;padding:2.5rem;color:var(--gray);">
                                <i class="bi bi-inbox" style="font-size:2rem;display:block;margin-bottom:.5rem;"></i>
                                No members yet.
                                <a href="${pageContext.request.contextPath}/members/new" style="color:var(--accent);">Add the first one</a>.
                            </td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>

        <!-- Today's Classes -->
        <div class="fcms-table-wrapper fade-in" style="animation-delay:.45s;">
            <div class="panel-header">
                <h5 class="panel-title">
                    <i class="bi bi-calendar-check"></i>TODAY'S CLASSES
                </h5>
                <a href="${pageContext.request.contextPath}/classes" class="panel-link">
                    Full schedule <i class="bi bi-arrow-right"></i>
                </a>
            </div>
            <div style="padding:1rem;display:flex;flex-direction:column;gap:.75rem;">
                <c:forEach var="fc" items="${todayClasses}">
                    <div>
                        <div class="class-row">
                            <div>
                                <div class="class-name">${fc.className}</div>
                                <div class="class-meta">
                                    <span><i class="bi bi-clock"></i> ${fc.scheduleTime}</span>
                                    <span><i class="bi bi-people"></i> ${fc.enrolled}/${fc.capacity}</span>
                                </div>
                            </div>
                            <span class="badge-status ${fc.status == 'FULL' ? 'badge-full' : 'badge-open'}">${fc.status}</span>
                        </div>
                        <div class="capacity-bar" style="margin-top:.5rem;">
                            <div class="capacity-fill ${fc.capacityColorClass}" style="width:${fc.capacityPercent}%;"></div>
                        </div>
                    </div>
                </c:forEach>
                <c:if test="${empty todayClasses}">
                    <div style="text-align:center;padding:3rem 1rem;color:var(--gray);">
                        <i class="bi bi-calendar-x" style="font-size:2.5rem;display:block;margin-bottom:.75rem;color:var(--gray2);"></i>
                        No classes scheduled today.
                    </div>
                </c:if>
            </div>
        </div>

    </div>
</div><!-- end sec-overview -->

<!-- SECTION: Analytics -->
<div class="dash-section" id="sec-analytics">
  <div class="sec-header"><h2>ANALYTICS <span>& REPORTS</span></h2></div>
  <div class="chart-grid">
    <div class="chart-panel"><h4><i class="bi bi-graph-up"></i>REVENUE TREND (6 Months)</h4><canvas id="revenueChart" height="220"></canvas></div>
    <div class="chart-panel"><h4><i class="bi bi-pie-chart-fill"></i>PLAN DISTRIBUTION</h4><canvas id="planChart" height="220"></canvas></div>
  </div>
  <div class="chart-grid">
    <div class="chart-panel"><h4><i class="bi bi-bar-chart-fill"></i>CLASS POPULARITY</h4><canvas id="classChart" height="200"></canvas></div>
    <div class="chart-panel"><h4><i class="bi bi-activity"></i>RECENT ACTIVITY</h4>
      <div class="activity-feed">
        <div class="af-item"><div class="af-dot green"></div><div><div class="af-text">New member <b>Kasun P.</b> registered</div><div class="af-time">2 mins ago</div></div></div>
        <div class="af-item"><div class="af-dot blue"></div><div><div class="af-text">HIIT class booking — 3 new spots filled</div><div class="af-time">15 mins ago</div></div></div>
        <div class="af-item"><div class="af-dot yellow"></div><div><div class="af-text">Membership renewal: <b>Priya J.</b></div><div class="af-time">1 hour ago</div></div></div>
        <div class="af-item"><div class="af-dot red"></div><div><div class="af-text">2 memberships expiring this week</div><div class="af-time">3 hours ago</div></div></div>
        <div class="af-item"><div class="af-dot green"></div><div><div class="af-text">Monthly revenue target reached: <b>Rs.125,000</b></div><div class="af-time">Yesterday</div></div></div>
      </div>
    </div>
  </div>
</div>

<!-- SECTION: Notifications -->
<div class="dash-section" id="sec-notifications">
  <div class="sec-header"><h2>NOTIFICATIONS <span>& ALERTS</span></h2></div>
  <div class="notif-list">
    <div class="notif-item"><div class="notif-icon" style="background:rgba(var(--accent-rgb),.1);color:var(--accent)"><i class="bi bi-person-plus-fill"></i></div><div><div style="font-weight:600;font-size:.9rem">New Member Registration</div><div style="font-size:.8rem;color:var(--gray);margin-top:.2rem">A new member just registered via the website. Review their details.</div><div style="font-size:.7rem;color:var(--gray2);margin-top:.3rem">2 minutes ago</div></div></div>
    <div class="notif-item"><div class="notif-icon" style="background:rgba(251,191,36,.1);color:#fbbf24"><i class="bi bi-exclamation-triangle-fill"></i></div><div><div style="font-weight:600;font-size:.9rem">5 Memberships Expiring Soon</div><div style="font-size:.8rem;color:var(--gray);margin-top:.2rem">Members with expiring plans in the next 7 days need renewal follow-up.</div><div style="font-size:.7rem;color:var(--gray2);margin-top:.3rem">1 hour ago</div></div></div>
    <div class="notif-item"><div class="notif-icon" style="background:rgba(96,165,250,.1);color:#60a5fa"><i class="bi bi-calendar-check-fill"></i></div><div><div style="font-weight:600;font-size:.9rem">Yoga Class at Full Capacity</div><div style="font-size:.8rem;color:var(--gray);margin-top:.2rem">Morning Yoga (9:00 AM) is fully booked. Consider adding another session.</div><div style="font-size:.7rem;color:var(--gray2);margin-top:.3rem">3 hours ago</div></div></div>
    <div class="notif-item"><div class="notif-icon" style="background:rgba(248,113,113,.1);color:#f87171"><i class="bi bi-shield-exclamation"></i></div><div><div style="font-weight:600;font-size:.9rem">System Backup Completed</div><div style="font-size:.8rem;color:var(--gray);margin-top:.2rem">Daily data backup was completed successfully at 3:00 AM.</div><div style="font-size:.7rem;color:var(--gray2);margin-top:.3rem">Today, 3:00 AM</div></div></div>
  </div>
</div>


<!-- SECTION: Settings removed — use /settings instead -->


<!-- SECTION: Classes Management -->
<div class="dash-section" id="sec-classes">
<style>
.cm-header{display:flex;align-items:center;justify-content:space-between;flex-wrap:wrap;gap:1rem;margin-bottom:1.5rem}
.cm-add-btn{display:flex;align-items:center;gap:.4rem;padding:.6rem 1.2rem;border-radius:10px;border:none;background:var(--accent);color:#000;font-size:.8rem;font-weight:700;cursor:pointer;transition:all .2s}.cm-add-btn:hover{box-shadow:0 4px 20px rgba(200,240,61,.3);transform:scale(1.03)}
.cm-grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(320px,1fr));gap:1.25rem}
.cm-card{background:var(--card);border:1px solid var(--border);border-radius:14px;overflow:hidden;transition:border-color .2s}.cm-card:hover{border-color:rgba(var(--accent-rgb),.3)}
.cm-card-top{display:flex;align-items:center;justify-content:space-between;padding:.8rem 1rem;border-bottom:1px solid var(--border);background:rgba(255,255,255,.02)}
.cm-card-name{font-weight:700;font-size:.9rem;display:flex;align-items:center;gap:.5rem}
.cm-card-name i{color:var(--accent);font-size:.9rem}
.cm-card-actions{display:flex;gap:.4rem}
.cm-card-actions button{background:none;border:1px solid var(--border);border-radius:6px;color:var(--gray);font-size:.7rem;padding:.3rem .6rem;cursor:pointer;transition:all .2s;display:flex;align-items:center;gap:.25rem}
.cm-card-actions button:hover{border-color:var(--accent);color:var(--accent)}
.cm-card-actions .cm-del:hover{border-color:#f87171;color:#f87171}
.cm-card-body{padding:1rem}
.cm-detail{display:flex;gap:.8rem;flex-wrap:wrap;margin-bottom:.6rem}
.cm-detail span{font-size:.72rem;color:var(--gray);display:flex;align-items:center;gap:.25rem}
.cm-detail i{color:rgba(var(--accent-rgb),.7);font-size:.75rem}
.cm-card-sched{font-size:.72rem;color:rgba(255,255,255,.4);padding-top:.6rem;border-top:1px solid var(--border)}.cm-card-sched strong{color:var(--text)}
.cm-card-cat{font-size:.6rem;font-weight:700;letter-spacing:1.5px;text-transform:uppercase;color:var(--accent);padding:.15rem .5rem;background:rgba(var(--accent-rgb),.1);border:1px solid rgba(var(--accent-rgb),.2);border-radius:20px}
.cm-card-desc{font-size:.72rem;color:var(--gray);line-height:1.5;margin-bottom:.6rem;display:-webkit-box;-webkit-line-clamp:2;-webkit-box-orient:vertical;overflow:hidden}
/* Modal */
.cm-modal-bg{position:fixed;inset:0;background:rgba(0,0,0,.7);z-index:9000;display:none;align-items:center;justify-content:center;backdrop-filter:blur(6px)}.cm-modal-bg.open{display:flex}
.cm-modal{background:#111;border:1px solid var(--border);border-radius:18px;width:520px;max-width:94vw;max-height:90vh;overflow-y:auto;padding:2rem;animation:fadeIn .3s ease}
.cm-modal h2{font-family:var(--font-display);font-size:1.5rem;letter-spacing:2px;margin-bottom:1.2rem;display:flex;align-items:center;gap:.5rem}.cm-modal h2 span{color:var(--accent)}
.cm-field{margin-bottom:1rem}.cm-field label{display:block;font-size:.72rem;font-weight:700;letter-spacing:1px;text-transform:uppercase;color:var(--gray);margin-bottom:.35rem}
.cm-field input,.cm-field select,.cm-field textarea{width:100%;padding:.6rem .8rem;border-radius:8px;border:1px solid var(--border);background:rgba(255,255,255,.04);color:#fff;font-size:.82rem;font-family:inherit;outline:none;transition:border-color .2s}
.cm-field input:focus,.cm-field select:focus,.cm-field textarea:focus{border-color:rgba(var(--accent-rgb),.4)}
.cm-field textarea{resize:vertical;min-height:60px}
.cm-field select{cursor:pointer}
.cm-field-row{display:grid;grid-template-columns:1fr 1fr;gap:.8rem}
.cm-submit{width:100%;padding:.7rem;border-radius:10px;border:none;background:var(--accent);color:#000;font-size:.82rem;font-weight:800;cursor:pointer;margin-top:.5rem;transition:all .2s;letter-spacing:.3px}.cm-submit:hover{box-shadow:0 4px 20px rgba(200,240,61,.3)}
.cm-cancel{width:100%;padding:.55rem;border-radius:8px;border:1px solid var(--border);background:none;color:var(--gray);font-size:.75rem;cursor:pointer;margin-top:.5rem;transition:all .2s}.cm-cancel:hover{border-color:#f87171;color:#f87171}
.cm-empty{text-align:center;padding:3rem;color:var(--gray)}.cm-empty i{font-size:2.5rem;display:block;margin-bottom:.8rem;opacity:.3}
.cm-search{position:relative;max-width:360px}.cm-search i{position:absolute;left:1rem;top:50%;transform:translateY(-50%);color:rgba(255,255,255,.3)}
.cm-search input{width:100%;padding:.6rem 1rem .6rem 2.6rem;border-radius:10px;border:1px solid var(--border);background:rgba(255,255,255,.04);color:#fff;font-size:.82rem;outline:none}.cm-search input:focus{border-color:rgba(var(--accent-rgb),.4)}
.cm-stats{display:grid;grid-template-columns:repeat(3,1fr);gap:1rem;margin-bottom:1.5rem}
.cm-stat{background:var(--card);border:1px solid var(--border);border-radius:12px;padding:1rem;text-align:center}.cm-stat-val{font-family:var(--font-display);font-size:1.6rem;color:var(--accent)}.cm-stat-lbl{font-size:.6rem;color:var(--gray);text-transform:uppercase;letter-spacing:1.5px;margin-top:.1rem}
</style>

<div class="sec-header"><h2>CLASS <span>MANAGEMENT</span></h2></div>

<div class="cm-stats" id="cmStats"></div>

<div class="cm-header">
  <div class="cm-search"><i class="bi bi-search"></i><input type="text" id="cmSearch" placeholder="Search classes..." oninput="cmFilter()"></div>
  <button class="cm-add-btn" onclick="cmOpenModal()"><i class="bi bi-plus-circle-fill"></i> Add New Class</button>
</div>

<div class="cm-grid" id="cmGrid"></div>

<!-- Add/Edit Modal -->
<div class="cm-modal-bg" id="cmModalBg">
  <div class="cm-modal">
    <h2 id="cmModalTitle"><i class="bi bi-calendar-plus"></i> ADD <span>CLASS</span></h2>
    <input type="hidden" id="cmEditIdx" value="-1">
    <div class="cm-field"><label>Class Name</label><input type="text" id="cmName" placeholder="e.g. HIIT Blast"></div>
    <div class="cm-field-row">
      <div class="cm-field"><label>Category</label><select id="cmCat"><option>High Intensity</option><option>Strength</option><option>Mind & Body</option><option>Cardio</option><option>Combat</option><option>Core & Flex</option><option>CrossFit</option><option>Dance</option><option>Functional</option></select></div>
      <div class="cm-field"><label>Level</label><select id="cmLevel"><option>All Levels</option><option>Beginner+</option><option>Intermediate</option><option>Advanced</option></select></div>
    </div>
    <div class="cm-field"><label>Trainer</label><input type="text" id="cmTrainer" placeholder="e.g. Coach Marcus"></div>
    <div class="cm-field-row">
      <div class="cm-field"><label>Schedule</label><input type="text" id="cmSchedule" placeholder="e.g. Mon, Wed, Fri"></div>
      <div class="cm-field"><label>Time</label><input type="text" id="cmTime" placeholder="e.g. 6:00 AM & 6:00 PM"></div>
    </div>
    <div class="cm-field-row">
      <div class="cm-field"><label>Duration (min)</label><input type="number" id="cmDuration" placeholder="45" min="10" max="120"></div>
      <div class="cm-field"><label>Capacity (spots)</label><input type="number" id="cmCapacity" placeholder="20" min="1" max="100"></div>
    </div>
    <div class="cm-field"><label>Calories Burned</label><input type="text" id="cmCalories" placeholder="e.g. 600+ kcal"></div>
    <div class="cm-field"><label>Description</label><textarea id="cmDesc" placeholder="Brief description of the class..."></textarea></div>
    <button class="cm-submit" onclick="cmSave()"><i class="bi bi-check2-circle"></i> Save Class</button>
    <button class="cm-cancel" onclick="cmCloseModal()">Cancel</button>
  </div>
</div>

<script>
var CM_KEY='apex_admin_classes';
var CM_DEFAULT=[
  {name:'HIIT BLAST',cat:'High Intensity',level:'All Levels',trainer:'Coach Marcus',schedule:'Mon, Wed, Fri',time:'6:00 AM & 6:00 PM',duration:45,capacity:20,calories:'600+ kcal',desc:'Explosive intervals that torch calories and build endurance.',day:'mwf',img:'/static/images/workout-class.png'},
  {name:'POWER LIFT',cat:'Strength',level:'Intermediate',trainer:'Coach Daniel',schedule:'Tue, Thu, Sat',time:'7:00 AM & 5:00 PM',duration:60,capacity:15,calories:'400+ kcal',desc:'Structured barbell and dumbbell training focusing on compound lifts.',day:'tts',img:'/static/images/gym-interior.png'},
  {name:'FLOW YOGA',cat:'Mind & Body',level:'All Levels',trainer:'Coach Priya',schedule:'Daily',time:'7:30 AM & 7:00 PM',duration:60,capacity:25,calories:'200+ kcal',desc:'Vinyasa-style sequences to improve flexibility, balance and inner calm.',day:'daily',img:'/static/images/trainer.png'},
  {name:'SPIN CYCLE',cat:'Cardio',level:'All Levels',trainer:'Coach Nadia',schedule:'Mon, Wed, Fri',time:'7:00 AM & 6:30 PM',duration:45,capacity:20,calories:'500+ kcal',desc:'High-energy indoor cycling with rhythm-based choreography.',day:'mwf',img:'/static/images/hero.png'},
  {name:'BOXING FIT',cat:'Combat',level:'Beginner+',trainer:'Coach Ashan',schedule:'Tue, Thu, Sat',time:'6:00 PM',duration:50,capacity:16,calories:'550+ kcal',desc:'Learn proper boxing technique while getting a full-body workout.',day:'tts',img:'/static/images/gym-interior.png'},
  {name:'PILATES CORE',cat:'Core & Flex',level:'All Levels',trainer:'Coach Tara',schedule:'Sat & Sun',time:'9:00 AM',duration:55,capacity:18,calories:'300+ kcal',desc:'Mat-based Pilates focusing on deep core activation and posture.',day:'weekend',img:'/static/images/workout-class.png'},
  {name:'CROSSFIT WOD',cat:'CrossFit',level:'Advanced',trainer:'Coach Kasun',schedule:'Mon, Wed, Fri',time:'5:30 AM & 5:30 PM',duration:60,capacity:14,calories:'700+ kcal',desc:'Workout of the Day combining Olympic lifts, gymnastics and conditioning.',day:'mwf',img:'/static/images/trainer.png'},
  {name:'ZUMBA DANCE',cat:'Dance',level:'All Levels',trainer:'Coach Shanaya',schedule:'Tue, Thu, Sat',time:'6:00 PM',duration:50,capacity:25,calories:'450+ kcal',desc:'Dance your way to fitness with Latin-inspired choreography.',day:'tts',img:'/static/images/hero.png'},
  {name:'FUNCTIONAL FIT',cat:'Functional',level:'Beginner+',trainer:'Coach Ravi',schedule:'Daily',time:'8:00 AM & 4:30 PM',duration:50,capacity:18,calories:'480+ kcal',desc:'Build real-world strength with kettlebells, TRX, and battle ropes.',day:'daily',img:'/static/images/gym-interior.png'}
];

function cmGetClasses(){try{var d=JSON.parse(localStorage.getItem(CM_KEY));return d&&d.length?d:CM_DEFAULT;}catch(e){return CM_DEFAULT;}}
function cmSaveClasses(list){localStorage.setItem(CM_KEY,JSON.stringify(list));}

function cmGuessDay(sched){
  var s=sched.toLowerCase();
  if(s.indexOf('daily')>=0) return 'daily';
  if(s.indexOf('sat')>=0 && s.indexOf('sun')>=0 && s.indexOf('mon')<0) return 'weekend';
  if(s.indexOf('mon')>=0) return 'mwf';
  if(s.indexOf('tue')>=0) return 'tts';
  return 'daily';
}

function cmRenderStats(){
  var classes=cmGetClasses();
  var cats={};classes.forEach(function(c){cats[c.cat]=true;});
  document.getElementById('cmStats').innerHTML=
    '<div class="cm-stat"><div class="cm-stat-val">'+classes.length+'</div><div class="cm-stat-lbl">Total Classes</div></div>'+
    '<div class="cm-stat"><div class="cm-stat-val">'+Object.keys(cats).length+'</div><div class="cm-stat-lbl">Categories</div></div>'+
    '<div class="cm-stat"><div class="cm-stat-val">'+classes.reduce(function(s,c){return s+c.capacity;},0)+'</div><div class="cm-stat-lbl">Total Spots</div></div>';
}

function cmRender(list){
  var g=document.getElementById('cmGrid');
  if(!list||!list.length){g.innerHTML='<div class="cm-empty"><i class="bi bi-calendar-x"></i><div>No classes found</div></div>';return;}
  g.innerHTML=list.map(function(c,i){
    return '<div class="cm-card"><div class="cm-card-top"><div class="cm-card-name"><i class="bi bi-calendar3"></i>'+c.name+'</div><div class="cm-card-actions"><span class="cm-card-cat">'+c.cat+'</span><button onclick="cmEdit('+i+')"><i class="bi bi-pencil"></i> Edit</button><button class="cm-del" onclick="cmDelete('+i+')"><i class="bi bi-trash3"></i></button></div></div><div class="cm-card-body"><div class="cm-card-desc">'+c.desc+'</div><div class="cm-detail"><span><i class="bi bi-clock"></i> '+c.duration+' min</span><span><i class="bi bi-people"></i> '+c.capacity+' spots</span><span><i class="bi bi-fire"></i> '+c.calories+'</span><span><i class="bi bi-bar-chart-steps"></i> '+c.level+'</span></div><div class="cm-card-sched"><strong>'+c.schedule+'</strong> · '+c.time+' · '+c.trainer+'</div></div></div>';
  }).join('');
}

function cmFilter(){
  var q=(document.getElementById('cmSearch').value||'').toLowerCase();
  var all=cmGetClasses();
  var list=q?all.filter(function(c){return c.name.toLowerCase().indexOf(q)>=0||c.cat.toLowerCase().indexOf(q)>=0||c.trainer.toLowerCase().indexOf(q)>=0;}):all;
  cmRender(list);
}

function cmOpenModal(idx){
  document.getElementById('cmModalBg').classList.add('open');
  if(typeof idx==='number'){
    var c=cmGetClasses()[idx];
    document.getElementById('cmModalTitle').innerHTML='<i class="bi bi-pencil-square"></i> EDIT <span>CLASS</span>';
    document.getElementById('cmEditIdx').value=idx;
    document.getElementById('cmName').value=c.name;
    document.getElementById('cmCat').value=c.cat;
    document.getElementById('cmLevel').value=c.level;
    document.getElementById('cmTrainer').value=c.trainer;
    document.getElementById('cmSchedule').value=c.schedule;
    document.getElementById('cmTime').value=c.time;
    document.getElementById('cmDuration').value=c.duration;
    document.getElementById('cmCapacity').value=c.capacity;
    document.getElementById('cmCalories').value=c.calories;
    document.getElementById('cmDesc').value=c.desc;
  } else {
    document.getElementById('cmModalTitle').innerHTML='<i class="bi bi-calendar-plus"></i> ADD <span>CLASS</span>';
    document.getElementById('cmEditIdx').value=-1;
    ['cmName','cmTrainer','cmSchedule','cmTime','cmDuration','cmCapacity','cmCalories','cmDesc'].forEach(function(id){document.getElementById(id).value='';});
    document.getElementById('cmCat').selectedIndex=0;document.getElementById('cmLevel').selectedIndex=0;
  }
}

function cmCloseModal(){document.getElementById('cmModalBg').classList.remove('open');}

function cmSave(){
  var name=document.getElementById('cmName').value.trim();
  if(!name){alert('Class name is required.');return;}
  var cls={
    name:name.toUpperCase(),cat:document.getElementById('cmCat').value,level:document.getElementById('cmLevel').value,
    trainer:document.getElementById('cmTrainer').value.trim()||'TBD',
    schedule:document.getElementById('cmSchedule').value.trim()||'TBD',time:document.getElementById('cmTime').value.trim()||'TBD',
    duration:parseInt(document.getElementById('cmDuration').value)||45,capacity:parseInt(document.getElementById('cmCapacity').value)||20,
    calories:document.getElementById('cmCalories').value.trim()||'400+ kcal',desc:document.getElementById('cmDesc').value.trim()||'',
    img:'/static/images/workout-class.png'
  };
  cls.day=cmGuessDay(cls.schedule);
  var all=cmGetClasses();var idx=parseInt(document.getElementById('cmEditIdx').value);
  if(idx>=0){all[idx]=cls;}else{all.push(cls);}
  cmSaveClasses(all);cmCloseModal();cmRenderStats();cmFilter();
}

function cmEdit(i){cmOpenModal(i);}
function cmDelete(i){
  if(!confirm('Delete this class?'))return;
  var all=cmGetClasses();all.splice(i,1);cmSaveClasses(all);cmRenderStats();cmFilter();
}

document.addEventListener('DOMContentLoaded',function(){
  // Init classes if first time
  if(!localStorage.getItem(CM_KEY)){cmSaveClasses(CM_DEFAULT);}
  cmRenderStats();cmRender(cmGetClasses());
});
</script>
</div>

<!-- SECTION: Exercise Management -->
<div class="dash-section" id="sec-exercises">
<style>
/* ── Exercise Management ── */
.ex-header{display:flex;align-items:center;justify-content:space-between;flex-wrap:wrap;gap:1rem;margin-bottom:1.5rem}
.ex-add-btn{display:flex;align-items:center;gap:.4rem;padding:.6rem 1.2rem;border-radius:10px;border:none;background:var(--accent);color:#000;font-size:.8rem;font-weight:700;cursor:pointer;transition:all .2s;letter-spacing:.3px}.ex-add-btn:hover{box-shadow:0 4px 20px rgba(200,240,61,.3);transform:scale(1.03)}
.ex-grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(340px,1fr));gap:1.25rem}
.ex-card{background:var(--card);border:1px solid var(--border);border-radius:14px;overflow:hidden;transition:border-color .25s}.ex-card:hover{border-color:rgba(var(--accent-rgb),.3)}
.ex-card-top{display:flex;align-items:center;justify-content:space-between;padding:.8rem 1rem;border-bottom:1px solid var(--border);background:rgba(255,255,255,.02)}
.ex-card-name{font-weight:700;font-size:.88rem;display:flex;align-items:center;gap:.5rem;min-width:0}.ex-card-name i{color:var(--accent);font-size:.85rem;flex-shrink:0}.ex-card-name span{white-space:nowrap;overflow:hidden;text-overflow:ellipsis}
.ex-card-actions{display:flex;gap:.4rem;flex-shrink:0}
.ex-card-actions button{background:none;border:1px solid var(--border);border-radius:6px;color:var(--gray);font-size:.68rem;padding:.3rem .55rem;cursor:pointer;transition:all .2s;display:flex;align-items:center;gap:.2rem}
.ex-card-actions button:hover{border-color:var(--accent);color:var(--accent)}
.ex-card-actions .ex-del:hover{border-color:#f87171;color:#f87171}
.ex-card-body{padding:1rem}
.ex-card-desc{font-size:.72rem;color:var(--gray);line-height:1.6;display:-webkit-box;-webkit-line-clamp:2;-webkit-box-orient:vertical;overflow:hidden;margin-bottom:.7rem}
.ex-card-meta{display:flex;gap:.5rem;flex-wrap:wrap;align-items:center;margin-bottom:.7rem}
.ex-card-foot{display:flex;gap:.4rem;flex-wrap:wrap;align-items:center;padding-top:.7rem;border-top:1px solid var(--border)}
/* Muscle badges */
.ex-muscle{display:inline-flex;align-items:center;padding:.18rem .5rem;border-radius:20px;font-size:.55rem;font-weight:800;letter-spacing:1.5px;text-transform:uppercase}
.ex-muscle.abs{background:rgba(248,113,113,.1);border:1px solid rgba(248,113,113,.25);color:#f87171}
.ex-muscle.arms{background:rgba(96,165,250,.1);border:1px solid rgba(96,165,250,.25);color:#60a5fa}
.ex-muscle.back{background:rgba(167,139,250,.1);border:1px solid rgba(167,139,250,.25);color:#a78bfa}
.ex-muscle.chest{background:rgba(251,191,36,.1);border:1px solid rgba(251,191,36,.25);color:#fbbf24}
.ex-muscle.glutes{background:rgba(244,114,182,.1);border:1px solid rgba(244,114,182,.25);color:#f472b6}
.ex-muscle.legs{background:rgba(52,211,153,.1);border:1px solid rgba(52,211,153,.25);color:#34d399}
.ex-muscle.shoulders{background:rgba(45,212,191,.1);border:1px solid rgba(45,212,191,.25);color:#2dd4bf}
.ex-equip{display:inline-flex;align-items:center;gap:.2rem;padding:.15rem .45rem;border-radius:6px;font-size:.6rem;font-weight:600;background:rgba(255,255,255,.05);color:rgba(255,255,255,.5)}
.ex-style{display:inline-flex;padding:.12rem .4rem;border-radius:6px;font-size:.55rem;font-weight:700;background:rgba(var(--accent-rgb),.08);color:var(--accent);letter-spacing:.5px;text-transform:uppercase}
.ex-cat{font-size:.68rem;color:var(--gray);display:flex;align-items:center;gap:.25rem}.ex-cat i{color:rgba(var(--accent-rgb),.6);font-size:.72rem}
/* Stats */
.ex-stats{display:grid;grid-template-columns:repeat(4,1fr);gap:1rem;margin-bottom:1.5rem}
.ex-stat{background:var(--card);border:1px solid var(--border);border-radius:12px;padding:1rem;text-align:center;position:relative;overflow:hidden}
.ex-stat::after{content:'';position:absolute;top:0;left:0;right:0;height:2px;background:linear-gradient(90deg,transparent,var(--accent),transparent);opacity:.2}
.ex-stat-val{font-family:var(--font-display);font-size:1.6rem;color:var(--accent)}.ex-stat-lbl{font-size:.6rem;color:var(--gray);text-transform:uppercase;letter-spacing:1.5px;margin-top:.1rem}
/* Search */
.ex-search{position:relative;max-width:360px}.ex-search i{position:absolute;left:1rem;top:50%;transform:translateY(-50%);color:rgba(255,255,255,.3)}
.ex-search input{width:100%;padding:.6rem 1rem .6rem 2.6rem;border-radius:10px;border:1px solid var(--border);background:rgba(255,255,255,.04);color:#fff;font-size:.82rem;outline:none}.ex-search input:focus{border-color:rgba(var(--accent-rgb),.4)}
/* Filters */
.ex-filters{display:flex;align-items:center;gap:.5rem;margin-bottom:1rem;flex-wrap:wrap}
.ex-filter-label{font-size:.65rem;font-weight:700;letter-spacing:2px;text-transform:uppercase;color:var(--gray);margin-right:.3rem}
.ex-fbtn{padding:.4rem 1rem;border-radius:50px;border:1px solid var(--border);background:transparent;color:var(--gray);font-size:.7rem;font-weight:700;cursor:pointer;transition:all .25s}
.ex-fbtn:hover{border-color:rgba(var(--accent-rgb),.3);color:#fff}
.ex-fbtn.active{background:var(--accent);color:#000;border-color:var(--accent);box-shadow:0 4px 20px rgba(200,240,61,.15)}
/* Modal */
.ex-modal-bg{position:fixed;inset:0;background:rgba(0,0,0,.7);z-index:9000;display:none;align-items:center;justify-content:center;backdrop-filter:blur(6px)}.ex-modal-bg.open{display:flex}
.ex-modal{background:#111;border:1px solid var(--border);border-radius:18px;width:540px;max-width:94vw;max-height:90vh;overflow-y:auto;padding:2rem;animation:fadeIn .3s ease}
.ex-modal h2{font-family:var(--font-display);font-size:1.5rem;letter-spacing:2px;margin-bottom:1.2rem;display:flex;align-items:center;gap:.5rem}.ex-modal h2 span{color:var(--accent)}
.ex-field{margin-bottom:1rem}.ex-field label{display:block;font-size:.72rem;font-weight:700;letter-spacing:1px;text-transform:uppercase;color:var(--gray);margin-bottom:.35rem}
.ex-field input,.ex-field select,.ex-field textarea{width:100%;padding:.6rem .8rem;border-radius:8px;border:1px solid var(--border);background:rgba(255,255,255,.04);color:#fff;font-size:.82rem;font-family:inherit;outline:none;transition:border-color .2s}
.ex-field input:focus,.ex-field select:focus,.ex-field textarea:focus{border-color:rgba(var(--accent-rgb),.4)}
.ex-field textarea{resize:vertical;min-height:60px}.ex-field select{cursor:pointer}
.ex-field-row{display:grid;grid-template-columns:1fr 1fr;gap:.8rem}
.ex-submit{width:100%;padding:.7rem;border-radius:10px;border:none;background:var(--accent);color:#000;font-size:.82rem;font-weight:800;cursor:pointer;margin-top:.5rem;transition:all .2s;letter-spacing:.3px}.ex-submit:hover{box-shadow:0 4px 20px rgba(200,240,61,.3)}
.ex-cancel{width:100%;padding:.55rem;border-radius:8px;border:1px solid var(--border);background:none;color:var(--gray);font-size:.75rem;cursor:pointer;margin-top:.5rem;transition:all .2s}.ex-cancel:hover{border-color:#f87171;color:#f87171}
.ex-empty{text-align:center;padding:3rem;color:var(--gray);grid-column:1/-1}.ex-empty i{font-size:2.5rem;display:block;margin-bottom:.8rem;opacity:.3}
@media(max-width:768px){.ex-stats{grid-template-columns:repeat(2,1fr)}.ex-grid{grid-template-columns:1fr}}
</style>

<div class="sec-header" style="display:flex;align-items:center;justify-content:space-between;flex-wrap:wrap;gap:1rem">
  <h2>EXERCISE <span>MANAGEMENT</span></h2>
  <div style="display:flex;align-items:center;gap:.5rem;font-size:.8rem;color:rgba(255,255,255,.45)">
    <i class="bi bi-info-circle"></i> Manage your exercise library — changes sync to the public Exercise page
  </div>
</div>

<div class="ex-stats" id="exStats"></div>

<div class="ex-header">
  <div class="ex-search"><i class="bi bi-search"></i><input type="text" id="exSearch" placeholder="Search exercises, muscles, equipment..." oninput="exFilter()"></div>
  <button class="ex-add-btn" onclick="exOpenModal()"><i class="bi bi-plus-circle-fill"></i> Add New Exercise</button>
</div>

<div class="ex-filters" id="exFilters">
  <span class="ex-filter-label">Muscle:</span>
  <button class="ex-fbtn active" onclick="exFilterMuscle('all',this)">All</button>
  <button class="ex-fbtn" onclick="exFilterMuscle('abs',this)">Abs</button>
  <button class="ex-fbtn" onclick="exFilterMuscle('arms',this)">Arms</button>
  <button class="ex-fbtn" onclick="exFilterMuscle('back',this)">Back</button>
  <button class="ex-fbtn" onclick="exFilterMuscle('chest',this)">Chest</button>
  <button class="ex-fbtn" onclick="exFilterMuscle('glutes',this)">Glutes</button>
  <button class="ex-fbtn" onclick="exFilterMuscle('legs',this)">Legs</button>
  <button class="ex-fbtn" onclick="exFilterMuscle('shoulders',this)">Shoulders</button>
</div>

<div class="ex-grid" id="exGrid"></div>

<!-- Add/Edit Modal -->
<div class="ex-modal-bg" id="exModalBg">
  <div class="ex-modal">
    <h2 id="exModalTitle"><i class="bi bi-activity"></i> ADD <span>EXERCISE</span></h2>
    <input type="hidden" id="exEditIdx" value="-1">
    <div class="ex-field"><label>Exercise Name</label><input type="text" id="exName" placeholder="e.g. Bench Press"></div>
    <div class="ex-field-row">
      <div class="ex-field"><label>Muscle Group</label><select id="exMuscle"><option value="abs">Abs</option><option value="arms">Arms</option><option value="back">Back</option><option value="chest">Chest</option><option value="glutes">Glutes</option><option value="legs">Legs</option><option value="shoulders">Shoulders</option></select></div>
      <div class="ex-field"><label>Equipment</label><select id="exEquip"><option>bodyweight</option><option>dumbbell</option><option>barbell</option><option>cable</option><option>machine</option><option>kettlebell</option><option>resistance band</option><option>other</option></select></div>
    </div>
    <div class="ex-field-row">
      <div class="ex-field"><label>Category</label><select id="exCategory"><option>Focus</option><option>Goals</option><option>Strength</option><option>Cardio</option><option>Flexibility</option><option>Recovery</option></select></div>
      <div class="ex-field"><label>Training Styles</label><input type="text" id="exStyles" placeholder="e.g. Core, HIIT, Bodybuilding"></div>
    </div>
    <div class="ex-field"><label>Description</label><textarea id="exDesc" placeholder="Describe the exercise, proper form, and benefits..."></textarea></div>

    <!-- ── Image Upload Section ── -->
    <div class="ex-field" id="exImgSection">
      <label><i class="bi bi-image" style="color:var(--accent);margin-right:.3rem"></i> Exercise Image</label>
      <div id="exImgPreviewWrap" style="display:none;margin-bottom:.5rem">
        <div style="position:relative;border-radius:10px;overflow:hidden;border:1px solid var(--border)">
          <img id="exImgPreview" src="" alt="Exercise" style="width:100%;height:160px;object-fit:cover;display:block">
          <div style="position:absolute;inset:0;background:rgba(0,0,0,.5);display:flex;align-items:center;justify-content:center;gap:.5rem;opacity:0;transition:opacity .2s" onmouseenter="this.style.opacity=1" onmouseleave="this.style.opacity=0">
            <button type="button" onclick="document.getElementById('exImgFile').click()" style="padding:.35rem .7rem;border-radius:6px;border:none;background:rgba(96,165,250,.9);color:#fff;font-size:.68rem;font-weight:700;cursor:pointer;display:flex;align-items:center;gap:.2rem"><i class="bi bi-arrow-repeat"></i> Replace</button>
            <button type="button" onclick="exDeleteImg()" style="padding:.35rem .7rem;border-radius:6px;border:none;background:rgba(239,68,68,.9);color:#fff;font-size:.68rem;font-weight:700;cursor:pointer;display:flex;align-items:center;gap:.2rem"><i class="bi bi-trash3"></i> Remove</button>
          </div>
        </div>
      </div>
      <div id="exImgDropZone" style="border:2px dashed rgba(255,255,255,.1);border-radius:10px;padding:1.2rem;text-align:center;cursor:pointer;transition:all .25s" onclick="document.getElementById('exImgFile').click()" onmouseenter="this.style.borderColor='var(--accent)'" onmouseleave="this.style.borderColor='rgba(255,255,255,.1)'">
        <i class="bi bi-cloud-arrow-up-fill" style="font-size:1.5rem;color:rgba(255,255,255,.15);display:block;margin-bottom:.3rem"></i>
        <div style="font-size:.72rem;color:var(--gray)"><b style="color:var(--accent)">Click to upload</b> or drag & drop</div>
        <div style="font-size:.58rem;color:rgba(255,255,255,.15);margin-top:.2rem">JPEG, PNG, WebP — max 5 MB</div>
      </div>
      <input type="file" id="exImgFile" accept="image/*" style="display:none" onchange="exUploadImg(this)">
      <div id="exImgStatus" style="font-size:.68rem;margin-top:.35rem;min-height:1rem"></div>
    </div>

    <button class="ex-submit" onclick="exSave()"><i class="bi bi-check2-circle"></i> Save Exercise</button>
    <button class="ex-cancel" onclick="exCloseModal()">Cancel</button>
  </div>
</div>

<script>
var EX_KEY='apex_admin_exercises';
var EX_DEFAULT=[
  {name:'90 Degree Alternate Heel Touch',muscle:'abs',equip:'bodyweight',category:'Focus',styles:'Core,HIIT,Bodybuilding',desc:'Trains controlled side bending for core control and oblique activation.'},
  {name:'90 Degree Heel Touch',muscle:'abs',equip:'bodyweight',category:'Focus',styles:'Core,HIIT,Bodybuilding',desc:'Builds controlled side-to-side core tension, helping improve oblique definition.'},
  {name:'Abdominal Air Bike',muscle:'abs',equip:'bodyweight',category:'Goals',styles:'Cardio,HIIT,CrossFit',desc:'Bodyweight core exercise combining controlled rotation and cycling motion.'},
  {name:'Alternate Heel Touchers',muscle:'abs',equip:'bodyweight',category:'Goals',styles:'Core,Endurance,HIIT',desc:'Simple core exercise that builds control and endurance for oblique muscles.'},
  {name:'Alternate Leg Raise',muscle:'abs',equip:'bodyweight',category:'Goals',styles:'Core,Endurance,HIIT',desc:'Controlled core exercise that builds strength and stability in the lower abs.'},
  {name:'Barbell Bench Press',muscle:'chest',equip:'barbell',category:'Strength',styles:'Strength,Bodybuilding',desc:'Fundamental compound lift for chest development and upper body pressing power.'},
  {name:'Dumbbell Curl',muscle:'arms',equip:'dumbbell',category:'Strength',styles:'Bodybuilding,Strength',desc:'Classic isolation exercise targeting the biceps for arm size and strength.'},
  {name:'Lat Pulldown',muscle:'back',equip:'cable',category:'Strength',styles:'Bodybuilding,Strength',desc:'Cable-based pulling exercise to build width in the latissimus dorsi.'},
  {name:'Barbell Squat',muscle:'legs',equip:'barbell',category:'Strength',styles:'Strength,CrossFit',desc:'King of compound exercises for lower body development and functional strength.'},
  {name:'Hip Thrust',muscle:'glutes',equip:'barbell',category:'Strength',styles:'Bodybuilding,Strength',desc:'Most effective glute isolation exercise for hip extension power.'},
  {name:'Overhead Press',muscle:'shoulders',equip:'barbell',category:'Strength',styles:'Strength,CrossFit',desc:'Fundamental pressing movement for shoulder development and overhead stability.'},
  {name:'Cable Lateral Raise',muscle:'shoulders',equip:'cable',category:'Focus',styles:'Bodybuilding',desc:'Cable variation for constant tension on the lateral deltoid throughout the movement.'},
  {name:'Pull-Up',muscle:'back',equip:'bodyweight',category:'Strength',styles:'CrossFit,Bodybuilding,HIIT',desc:'Classic compound bodyweight exercise for back width and upper body pulling strength.'},
  {name:'Tricep Pushdown',muscle:'arms',equip:'cable',category:'Focus',styles:'Bodybuilding',desc:'Isolation cable exercise for tricep definition and lockout strength.'},
  {name:'Bulgarian Split Squat',muscle:'legs',equip:'dumbbell',category:'Goals',styles:'Bodybuilding,Strength',desc:'Unilateral leg exercise for building balanced quad and glute strength.'},
  {name:'Glute Bridge',muscle:'glutes',equip:'bodyweight',category:'Goals',styles:'Core,Bodybuilding',desc:'Bodyweight glute activation exercise excellent as warm-up or high-rep finisher.'},
  {name:'Chest Fly',muscle:'chest',equip:'dumbbell',category:'Focus',styles:'Bodybuilding',desc:'Isolation movement to stretch and contract the pectoral muscles through a wide range of motion.'},
  {name:'Deadlift',muscle:'back',equip:'barbell',category:'Strength',styles:'Strength,CrossFit',desc:'Full-body posterior chain compound exercise. Builds total-body strength and muscle mass.'},
  {name:'Plank',muscle:'abs',equip:'bodyweight',category:'Goals',styles:'Core,Endurance',desc:'Isometric core exercise that builds stability and endurance throughout the entire midsection.'},
  {name:'Mountain Climbers',muscle:'abs',equip:'bodyweight',category:'Cardio',styles:'HIIT,Cardio,Core',desc:'Dynamic bodyweight exercise combining core stability with cardiovascular conditioning.'},
  {name:'Leg Press',muscle:'legs',equip:'machine',category:'Strength',styles:'Bodybuilding,Strength',desc:'Machine-based compound exercise for safe heavy quad and glute loading.'},
  {name:'Hammer Curl',muscle:'arms',equip:'dumbbell',category:'Focus',styles:'Bodybuilding',desc:'Neutral grip curl variation targeting the brachialis and forearms for arm thickness.'},
  {name:'Incline Bench Press',muscle:'chest',equip:'barbell',category:'Strength',styles:'Strength,Bodybuilding',desc:'Upper chest focused compound press for balanced pectoral development.'},
  {name:'Face Pull',muscle:'shoulders',equip:'cable',category:'Goals',styles:'Bodybuilding,Core',desc:'Rear delt and upper back corrective exercise for shoulder health and posture.'},
  {name:'Kettlebell Swing',muscle:'glutes',equip:'kettlebell',category:'Cardio',styles:'HIIT,CrossFit,Cardio',desc:'Explosive hip hinge exercise that builds power, endurance and posterior chain strength.'},
  {name:'Lateral Lunge',muscle:'legs',equip:'bodyweight',category:'Flexibility',styles:'Core,Endurance',desc:'Lateral movement pattern that builds inner thigh flexibility and hip mobility.'}
];

var MUSCLE_LABELS={abs:'Abs',arms:'Arms',back:'Back',chest:'Chest',glutes:'Glutes',legs:'Legs',shoulders:'Shoulders'};
var exActiveFilter='all';

function exGetAll(){try{var d=JSON.parse(localStorage.getItem(EX_KEY));return d&&d.length?d:EX_DEFAULT;}catch(e){return EX_DEFAULT;}}
function exSaveAll(list){localStorage.setItem(EX_KEY,JSON.stringify(list));}

function exRenderStats(){
  var all=exGetAll(),muscles={},equips={},styles={};
  all.forEach(function(e){muscles[e.muscle]=true;equips[e.equip]=true;(e.styles||'').split(',').forEach(function(s){if(s.trim())styles[s.trim()]=true;});});
  document.getElementById('exStats').innerHTML=
    '<div class="ex-stat"><div class="ex-stat-val">'+all.length+'</div><div class="ex-stat-lbl">Total Exercises</div></div>'+
    '<div class="ex-stat"><div class="ex-stat-val" style="color:#60a5fa">'+Object.keys(muscles).length+'</div><div class="ex-stat-lbl">Muscle Groups</div></div>'+
    '<div class="ex-stat"><div class="ex-stat-val" style="color:#a78bfa">'+Object.keys(equips).length+'</div><div class="ex-stat-lbl">Equipment Types</div></div>'+
    '<div class="ex-stat"><div class="ex-stat-val" style="color:#34d399">'+Object.keys(styles).length+'</div><div class="ex-stat-lbl">Training Styles</div></div>';
}

function exRender(list){
  var g=document.getElementById('exGrid');
  if(!list||!list.length){g.innerHTML='<div class="ex-empty"><i class="bi bi-activity"></i><div>No exercises found</div><div style="font-size:.72rem;margin-top:.3rem;opacity:.5">Try a different search or add a new exercise</div></div>';return;}
  g.innerHTML=list.map(function(e,i){
    var stylesHtml=(e.styles||'').split(',').map(function(s){return s.trim()?'<span class="ex-style">'+s.trim()+'</span>':'';}).join('');
    return '<div class="ex-card" data-muscle="'+e.muscle+'">'+
      '<div class="ex-card-top">'+
        '<div class="ex-card-name"><i class="bi bi-activity"></i><span>'+e.name+'</span></div>'+
        '<div class="ex-card-actions">'+
          '<span class="ex-muscle '+e.muscle+'">'+(MUSCLE_LABELS[e.muscle]||e.muscle)+'</span>'+
          '<button onclick="exEdit('+i+')"><i class="bi bi-pencil"></i> Edit</button>'+
          '<button class="ex-del" onclick="exDelete('+i+')"><i class="bi bi-trash3"></i></button>'+
        '</div>'+
      '</div>'+
      '<div class="ex-card-body">'+
        '<div class="ex-card-desc">'+e.desc+'</div>'+
        '<div class="ex-card-meta">'+
          '<span class="ex-equip"><i class="bi bi-gear"></i> '+e.equip+'</span>'+
          '<span class="ex-cat"><i class="bi bi-folder2-open"></i> '+e.category+'</span>'+
        '</div>'+
        '<div class="ex-card-foot">'+stylesHtml+'</div>'+
      '</div></div>';
  }).join('');
}

function exFilter(){
  var q=(document.getElementById('exSearch').value||'').toLowerCase();
  var all=exGetAll();
  var list=all.filter(function(e){
    var matchQ=!q||e.name.toLowerCase().indexOf(q)>=0||e.muscle.toLowerCase().indexOf(q)>=0||e.equip.toLowerCase().indexOf(q)>=0||e.desc.toLowerCase().indexOf(q)>=0;
    var matchM=exActiveFilter==='all'||e.muscle===exActiveFilter;
    return matchQ&&matchM;
  });
  exRender(list);
}

function exFilterMuscle(m,btn){
  document.querySelectorAll('.ex-fbtn').forEach(function(b){b.classList.remove('active');});
  btn.classList.add('active');
  exActiveFilter=m;
  exFilter();
}

function exOpenModal(idx){
  document.getElementById('exModalBg').classList.add('open');
  if(typeof idx==='number'){
    var e=exGetAll()[idx];
    document.getElementById('exModalTitle').innerHTML='<i class="bi bi-pencil-square"></i> EDIT <span>EXERCISE</span>';
    document.getElementById('exEditIdx').value=idx;
    document.getElementById('exName').value=e.name;
    document.getElementById('exMuscle').value=e.muscle;
    document.getElementById('exEquip').value=e.equip;
    document.getElementById('exCategory').value=e.category;
    document.getElementById('exStyles').value=e.styles;
    document.getElementById('exDesc').value=e.desc;
  } else {
    document.getElementById('exModalTitle').innerHTML='<i class="bi bi-activity"></i> ADD <span>EXERCISE</span>';
    document.getElementById('exEditIdx').value=-1;
    ['exName','exStyles','exDesc'].forEach(function(id){document.getElementById(id).value='';});
    document.getElementById('exMuscle').selectedIndex=0;document.getElementById('exEquip').selectedIndex=0;document.getElementById('exCategory').selectedIndex=0;
  }
  // Load image for this exercise
  exLoadImg();
}
function exCloseModal(){document.getElementById('exModalBg').classList.remove('open');}

function exSave(){
  var name=document.getElementById('exName').value.trim();
  if(!name){alert('Exercise name is required.');return;}
  var ex={
    name:name,muscle:document.getElementById('exMuscle').value,
    equip:document.getElementById('exEquip').value,category:document.getElementById('exCategory').value,
    styles:document.getElementById('exStyles').value.trim()||'',desc:document.getElementById('exDesc').value.trim()||''
  };
  var all=exGetAll(),idx=parseInt(document.getElementById('exEditIdx').value);
  if(idx>=0){all[idx]=ex;}else{all.push(ex);}
  exSaveAll(all);exCloseModal();exRenderStats();exFilter();
}

function exEdit(i){exOpenModal(i);}
function exDelete(i){
  if(!confirm('Delete this exercise? This will remove it from the library.'))return;
  var all=exGetAll();all.splice(i,1);exSaveAll(all);exRenderStats();exFilter();
}

/* ── Image Upload Functions ── */
var EX_IMG_API = '${pageContext.request.contextPath}/api/exercise-images';

function exSlugId(name){
  return (name||'').toLowerCase().replace(/[^a-z0-9]+/g,'-').replace(/(^-|-$)/g,'');
}

function exLoadImg(){
  var name=document.getElementById('exName').value.trim();
  var slug=exSlugId(name);
  var previewWrap=document.getElementById('exImgPreviewWrap');
  var dropZone=document.getElementById('exImgDropZone');
  var status=document.getElementById('exImgStatus');
  status.textContent='';
  if(!slug || parseInt(document.getElementById('exEditIdx').value)<0){
    previewWrap.style.display='none';
    dropZone.style.display='';
    return;
  }
  var url=EX_IMG_API+'?id='+encodeURIComponent(slug)+'&t='+Date.now();
  var img=new Image();
  img.onload=function(){
    document.getElementById('exImgPreview').src=url;
    previewWrap.style.display='';
    dropZone.style.display='none';
  };
  img.onerror=function(){
    previewWrap.style.display='none';
    dropZone.style.display='';
  };
  img.src=url;
}

function exUploadImg(input){
  if(!input.files||!input.files[0])return;
  var file=input.files[0];
  if(!file.type.startsWith('image/')){exSetImgStatus('Select an image file','#f87171');return;}
  if(file.size>5*1024*1024){exSetImgStatus('Image must be under 5 MB','#f87171');return;}
  var name=document.getElementById('exName').value.trim();
  if(!name){exSetImgStatus('Enter the exercise name first','#fbbf24');return;}
  var slug=exSlugId(name);
  exSetImgStatus('Uploading…','rgba(255,255,255,.5)');
  var fd=new FormData();
  fd.append('image',file);
  fetch(EX_IMG_API+'?id='+encodeURIComponent(slug),{method:'POST',body:fd})
    .then(function(r){return r.json();})
    .then(function(d){
      if(d.success){
        exSetImgStatus('Image uploaded!','var(--accent)');
        document.getElementById('exImgPreview').src=EX_IMG_API+'?id='+encodeURIComponent(slug)+'&t='+Date.now();
        document.getElementById('exImgPreviewWrap').style.display='';
        document.getElementById('exImgDropZone').style.display='none';
        setTimeout(function(){exSetImgStatus('','');},3000);
      } else {
        exSetImgStatus(d.message||'Upload failed','#f87171');
      }
    })
    .catch(function(err){exSetImgStatus('Upload error: '+err.message,'#f87171');});
  input.value='';
}

function exDeleteImg(){
  if(!confirm('Remove this exercise image?'))return;
  var name=document.getElementById('exName').value.trim();
  var slug=exSlugId(name);
  exSetImgStatus('Removing…','rgba(255,255,255,.5)');
  fetch(EX_IMG_API+'-delete?id='+encodeURIComponent(slug),{method:'POST'})
    .then(function(r){return r.json();})
    .then(function(d){
      if(d.success){
        exSetImgStatus('Image removed','var(--accent)');
        document.getElementById('exImgPreviewWrap').style.display='none';
        document.getElementById('exImgDropZone').style.display='';
        setTimeout(function(){exSetImgStatus('','');},3000);
      } else {exSetImgStatus(d.message||'Failed','#f87171');}
    })
    .catch(function(err){exSetImgStatus('Error: '+err.message,'#f87171');});
}

function exSetImgStatus(msg,color){
  var el=document.getElementById('exImgStatus');
  el.textContent=msg;el.style.color=color||'';
}

// Drag & drop support
document.addEventListener('DOMContentLoaded',function(){
  var dz=document.getElementById('exImgDropZone');
  if(dz){
    ['dragover','dragenter'].forEach(function(e){dz.addEventListener(e,function(ev){ev.preventDefault();dz.style.borderColor='var(--accent)';dz.style.background='rgba(200,240,61,.04)';});});
    ['dragleave','dragend'].forEach(function(e){dz.addEventListener(e,function(){dz.style.borderColor='rgba(255,255,255,.1)';dz.style.background='';});});
    dz.addEventListener('drop',function(ev){ev.preventDefault();dz.style.borderColor='rgba(255,255,255,.1)';dz.style.background='';if(ev.dataTransfer.files.length){document.getElementById('exImgFile').files=ev.dataTransfer.files;exUploadImg(document.getElementById('exImgFile'));}});
  }
});

document.addEventListener('DOMContentLoaded',function(){
  if(!localStorage.getItem(EX_KEY)){exSaveAll(EX_DEFAULT);}
  exRenderStats();exRender(exGetAll());
});
</script>
</div>

<!-- SECTION: Supplements Management -->
<div class="dash-section" id="sec-supplements">
<style>
/* ── Supplements Management — Professional Layout ── */
.sm-header{display:flex;align-items:center;justify-content:space-between;flex-wrap:wrap;gap:1rem;margin-bottom:1.5rem}
.sm-add-btn{display:flex;align-items:center;gap:.4rem;padding:.6rem 1.2rem;border-radius:10px;border:none;background:var(--accent);color:#000;font-size:.8rem;font-weight:700;cursor:pointer;transition:all .2s;letter-spacing:.3px}.sm-add-btn:hover{box-shadow:0 4px 20px rgba(200,240,61,.3);transform:scale(1.03)}
.sm-grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(340px,1fr));gap:1.25rem}
/* Card — mirrors cm-card */
.sm-card{background:var(--card);border:1px solid var(--border);border-radius:14px;overflow:hidden;transition:border-color .25s}.sm-card:hover{border-color:rgba(var(--accent-rgb),.3)}
.sm-card-top{display:flex;align-items:center;justify-content:space-between;padding:.8rem 1rem;border-bottom:1px solid var(--border);background:rgba(255,255,255,.02)}
.sm-card-name{font-weight:700;font-size:.9rem;display:flex;align-items:center;gap:.5rem}.sm-card-name i{color:var(--accent);font-size:.85rem}
.sm-card-actions{display:flex;gap:.4rem}
.sm-card-actions button{background:none;border:1px solid var(--border);border-radius:6px;color:var(--gray);font-size:.7rem;padding:.3rem .6rem;cursor:pointer;transition:all .2s;display:flex;align-items:center;gap:.25rem}
.sm-card-actions button:hover{border-color:var(--accent);color:var(--accent)}
.sm-card-actions .sm-del:hover{border-color:#f87171;color:#f87171}
.sm-card-body{padding:1rem;display:flex;gap:.9rem}
.sm-card-thumb{width:70px;height:70px;border-radius:10px;background:rgba(255,255,255,.03);border:1px solid var(--border);overflow:hidden;flex-shrink:0;display:flex;align-items:center;justify-content:center}.sm-card-thumb img{max-width:100%;max-height:100%;object-fit:contain}
.sm-card-info{flex:1;min-width:0}
.sm-card-brand{font-size:.6rem;color:var(--gray);text-transform:uppercase;letter-spacing:1.8px;font-weight:700;margin-bottom:.15rem}
.sm-card-pname{font-weight:700;font-size:.88rem;margin-bottom:.35rem;white-space:nowrap;overflow:hidden;text-overflow:ellipsis}
.sm-card-desc{font-size:.72rem;color:var(--gray);line-height:1.5;display:-webkit-box;-webkit-line-clamp:2;-webkit-box-orient:vertical;overflow:hidden;margin-bottom:.6rem}
.sm-card-foot{display:flex;gap:.8rem;flex-wrap:wrap;align-items:center;padding-top:.7rem;border-top:1px solid var(--border);font-size:.72rem;color:var(--gray)}
.sm-card-foot span{display:flex;align-items:center;gap:.25rem}.sm-card-foot i{color:rgba(var(--accent-rgb),.7);font-size:.75rem}
.sm-card-price{font-family:var(--font-display);font-size:1rem;color:var(--accent);letter-spacing:.5px}
/* Category badges */
.sm-cat-badge{font-size:.55rem;font-weight:800;letter-spacing:1.5px;text-transform:uppercase;padding:.2rem .55rem;border-radius:20px;white-space:nowrap}
.sm-cat-badge.protein{background:rgba(200,240,61,.1);border:1px solid rgba(200,240,61,.25);color:var(--accent)}
.sm-cat-badge.creatine{background:rgba(96,165,250,.1);border:1px solid rgba(96,165,250,.25);color:#60a5fa}
.sm-cat-badge.preworkout{background:rgba(248,113,113,.1);border:1px solid rgba(248,113,113,.25);color:#f87171}
.sm-cat-badge.bcaa{background:rgba(167,139,250,.1);border:1px solid rgba(167,139,250,.25);color:#a78bfa}
.sm-cat-badge.vitamins{background:rgba(52,211,153,.1);border:1px solid rgba(52,211,153,.25);color:#34d399}
.sm-cat-badge.gainer{background:rgba(251,191,36,.1);border:1px solid rgba(251,191,36,.25);color:#fbbf24}
.sm-cat-badge.burner{background:rgba(251,146,60,.1);border:1px solid rgba(251,146,60,.25);color:#fb923c}
/* Modal */
.sm-modal-bg{position:fixed;inset:0;background:rgba(0,0,0,.7);z-index:9000;display:none;align-items:center;justify-content:center;backdrop-filter:blur(6px)}.sm-modal-bg.open{display:flex}
.sm-modal{background:#111;border:1px solid var(--border);border-radius:18px;width:540px;max-width:94vw;max-height:90vh;overflow-y:auto;padding:2rem;animation:fadeIn .3s ease}
.sm-modal h2{font-family:var(--font-display);font-size:1.5rem;letter-spacing:2px;margin-bottom:1.2rem;display:flex;align-items:center;gap:.5rem}.sm-modal h2 span{color:var(--accent)}
.sm-field{margin-bottom:1rem}.sm-field label{display:block;font-size:.72rem;font-weight:700;letter-spacing:1px;text-transform:uppercase;color:var(--gray);margin-bottom:.35rem}
.sm-field input,.sm-field select,.sm-field textarea{width:100%;padding:.6rem .8rem;border-radius:8px;border:1px solid var(--border);background:rgba(255,255,255,.04);color:#fff;font-size:.82rem;font-family:inherit;outline:none;transition:border-color .2s}
.sm-field input:focus,.sm-field select:focus,.sm-field textarea:focus{border-color:rgba(var(--accent-rgb),.4)}
.sm-field textarea{resize:vertical;min-height:60px}.sm-field select{cursor:pointer}
.sm-field-row{display:grid;grid-template-columns:1fr 1fr;gap:.8rem}
.sm-submit{width:100%;padding:.7rem;border-radius:10px;border:none;background:var(--accent);color:#000;font-size:.82rem;font-weight:800;cursor:pointer;margin-top:.5rem;transition:all .2s;letter-spacing:.3px}.sm-submit:hover{box-shadow:0 4px 20px rgba(200,240,61,.3)}
.sm-cancel{width:100%;padding:.55rem;border-radius:8px;border:1px solid var(--border);background:none;color:var(--gray);font-size:.75rem;cursor:pointer;margin-top:.5rem;transition:all .2s}.sm-cancel:hover{border-color:#f87171;color:#f87171}
/* Search */
.sm-search{position:relative;max-width:360px}.sm-search i{position:absolute;left:1rem;top:50%;transform:translateY(-50%);color:rgba(255,255,255,.3)}
.sm-search input{width:100%;padding:.6rem 1rem .6rem 2.6rem;border-radius:10px;border:1px solid var(--border);background:rgba(255,255,255,.04);color:#fff;font-size:.82rem;outline:none}.sm-search input:focus{border-color:rgba(var(--accent-rgb),.4)}
/* Stats */
.sm-stats{display:grid;grid-template-columns:repeat(4,1fr);gap:1rem;margin-bottom:1.5rem}
.sm-stat{background:var(--card);border:1px solid var(--border);border-radius:12px;padding:1rem;text-align:center;position:relative;overflow:hidden}
.sm-stat::after{content:'';position:absolute;top:0;left:0;right:0;height:2px;background:linear-gradient(90deg,transparent,var(--accent),transparent);opacity:.2}
.sm-stat-val{font-family:var(--font-display);font-size:1.6rem;color:var(--accent)}.sm-stat-lbl{font-size:.6rem;color:var(--gray);text-transform:uppercase;letter-spacing:1.5px;margin-top:.1rem}
.sm-empty{text-align:center;padding:3rem;color:var(--gray)}.sm-empty i{font-size:2.5rem;display:block;margin-bottom:.8rem;opacity:.3}
/* Image Preview in Modal */
.sm-img-row{display:flex;align-items:center;gap:1rem;margin-bottom:1rem}
.sm-img-preview{width:72px;height:72px;border-radius:10px;border:1px solid var(--border);overflow:hidden;display:flex;align-items:center;justify-content:center;background:rgba(255,255,255,.03);flex-shrink:0}.sm-img-preview img{max-width:100%;max-height:100%;object-fit:contain}
.sm-img-hint{font-size:.68rem;color:var(--gray);line-height:1.5}
/* Upload Zone */
.sm-upload-zone{border:2px dashed var(--border);border-radius:12px;padding:1.5rem;text-align:center;cursor:pointer;transition:all .25s;background:rgba(255,255,255,.02);position:relative;margin-bottom:1rem}
.sm-upload-zone:hover,.sm-upload-zone.dragover{border-color:rgba(var(--accent-rgb),.5);background:rgba(var(--accent-rgb),.04)}
.sm-upload-zone.has-file{border-color:rgba(52,211,153,.4);background:rgba(52,211,153,.04)}
.sm-upload-icon{font-size:2rem;color:var(--gray);margin-bottom:.4rem;transition:color .2s}.sm-upload-zone:hover .sm-upload-icon{color:var(--accent)}
.sm-upload-text{font-size:.78rem;color:var(--gray);font-weight:600;margin-bottom:.15rem}
.sm-upload-sub{font-size:.65rem;color:rgba(255,255,255,.3)}
.sm-upload-file-input{position:absolute;inset:0;opacity:0;cursor:pointer}
.sm-upload-preview{display:flex;align-items:center;gap:1rem;padding:.8rem;background:rgba(255,255,255,.03);border:1px solid var(--border);border-radius:10px;margin-top:.8rem}
.sm-upload-preview img{width:60px;height:60px;object-fit:contain;border-radius:8px;background:rgba(255,255,255,.03)}
.sm-upload-preview-info{flex:1;min-width:0}
.sm-upload-preview-name{font-size:.78rem;font-weight:600;white-space:nowrap;overflow:hidden;text-overflow:ellipsis}
.sm-upload-preview-size{font-size:.65rem;color:var(--gray);margin-top:.1rem}
.sm-upload-remove{background:none;border:1px solid rgba(248,113,113,.3);color:#f87171;border-radius:6px;padding:.25rem .5rem;font-size:.65rem;cursor:pointer;transition:all .2s;display:flex;align-items:center;gap:.2rem;flex-shrink:0}.sm-upload-remove:hover{background:rgba(248,113,113,.1);border-color:#f87171}
.sm-or-divider{display:flex;align-items:center;gap:.8rem;margin-bottom:1rem;font-size:.65rem;color:var(--gray);font-weight:700;letter-spacing:2px;text-transform:uppercase}
.sm-or-divider::before,.sm-or-divider::after{content:'';flex:1;height:1px;background:var(--border)}
/* Responsive */
@media(max-width:768px){.sm-stats{grid-template-columns:repeat(2,1fr)}.sm-grid{grid-template-columns:1fr}}
</style>

<div class="sec-header" style="display:flex;align-items:center;justify-content:space-between;flex-wrap:wrap;gap:1rem">
  <h2>SUPPLEMENT <span>MANAGEMENT</span></h2>
  <div style="display:flex;align-items:center;gap:.5rem;font-size:.8rem;color:rgba(255,255,255,.45)">
    <i class="bi bi-info-circle"></i> Manage your product catalog — changes sync to the Supplements page instantly
  </div>
</div>

<div class="sm-stats" id="smStats"></div>

<div class="sm-header">
  <div class="sm-search"><i class="bi bi-search"></i><input type="text" id="smSearch" placeholder="Search products, brands, categories..." oninput="smFilter()"></div>
  <button class="sm-add-btn" onclick="smOpenModal()"><i class="bi bi-plus-circle-fill"></i> Add New Product</button>
</div>

<div class="sm-grid" id="smGrid"></div>

<!-- Add/Edit Modal -->
<div class="sm-modal-bg" id="smModalBg">
  <div class="sm-modal">
    <h2 id="smModalTitle"><i class="bi bi-capsule"></i> ADD <span>PRODUCT</span></h2>
    <input type="hidden" id="smEditIdx" value="-1">
    <div class="sm-field"><label>Product Name</label><input type="text" id="smName" placeholder="e.g. Nitro Tech Whey Protein"></div>
    <div class="sm-field-row">
      <div class="sm-field"><label>Brand</label><input type="text" id="smBrand" placeholder="e.g. MuscleTech"></div>
      <div class="sm-field"><label>Category</label><select id="smCat"><option value="protein">Protein</option><option value="creatine">Creatine</option><option value="preworkout">Pre-Workout</option><option value="bcaa">BCAA</option><option value="gainer">Mass Gainer</option><option value="vitamins">Vitamins</option><option value="burner">Fat Burner</option></select></div>
    </div>
    <div class="sm-field"><label>Price (Rs.)</label><input type="number" id="smPrice" placeholder="15000" min="0"></div>
    <div class="sm-field"><label>Product Image</label></div>
    <div class="sm-upload-zone" id="smUploadZone" onclick="document.getElementById('smFileInput').click()" ondragover="event.preventDefault();this.classList.add('dragover')" ondragleave="this.classList.remove('dragover')" ondrop="event.preventDefault();this.classList.remove('dragover');smHandleDrop(event)">
      <input type="file" id="smFileInput" accept="image/*" class="sm-upload-file-input" onchange="smHandleFile(this)" style="display:none">
      <div class="sm-upload-icon"><i class="bi bi-cloud-arrow-up"></i></div>
      <div class="sm-upload-text">Click to upload or drag & drop</div>
      <div class="sm-upload-sub">PNG, JPG, WEBP up to 5MB — transparent PNGs recommended</div>
    </div>
    <div id="smUploadPreview" style="display:none"></div>
    <div class="sm-or-divider"><span>or paste image URL</span></div>
    <div class="sm-field"><input type="text" id="smImg" placeholder="https://example.com/product-image.png" oninput="smPreviewImg()"></div>
    <div class="sm-img-row">
      <div class="sm-img-preview" id="smImgPreview"><i class="bi bi-image" style="color:var(--gray);font-size:1.4rem"></i></div>
      <div class="sm-img-hint"><i class="bi bi-lightbulb" style="color:var(--accent)"></i> Upload takes priority over URL. Use transparent PNG images for best results.</div>
    </div>
    <div class="sm-field"><label>Description</label><textarea id="smDesc" placeholder="Brief product description highlighting key benefits..."></textarea></div>
    <button class="sm-submit" onclick="smSave()"><i class="bi bi-check2-circle"></i> Save Product</button>
    <button class="sm-cancel" onclick="smCloseModal()">Cancel</button>
  </div>
</div>

<script>
var SM_KEY='apex_admin_supplements';
var smUploadedBase64='';
var SM_DEFAULT=[
  {name:'Nitro Tech Whey Protein',brand:'MuscleTech',cat:'protein',price:15000,img:'https://fitnessisland.lk/cdn/shop/files/image-removebg-preview_19_b6335e67-cb44-4e3c-aa33-0e5f7e0d6a5d_1024x1024.png',desc:'30g protein per serving. Advanced whey isolate for lean muscle and recovery.'},
  {name:'Critical Whey Protein',brand:'Applied Nutrition',cat:'protein',price:14500,img:'https://fitnessisland.lk/cdn/shop/files/image-removebg-preview_15_ebae186e-6a80-49ad-9d7b-d4faeeadb1a0_1024x1024.png',desc:'24g protein per serving. Premium blend for everyday muscle support.'},
  {name:'100% Whey Professional',brand:'Scitec Nutrition',cat:'protein',price:16000,img:'https://fitnessisland.lk/cdn/shop/files/5146_0f4b0454aca7_1024x1024.webp',desc:'22g protein with amino acids. European quality whey concentrate blend.'},
  {name:'ISO100 Hydrolyzed Isolate',brand:'Dymatize',cat:'protein',price:18000,img:'https://fitnessisland.lk/cdn/shop/files/DymatizeISO100_1024x1024.png',desc:'25g hydrolyzed whey isolate. Ultra-fast absorption for serious athletes.'},
  {name:'Gold Standard 100% Whey',brand:'Optimum Nutrition',cat:'protein',price:20000,img:'https://fitnessisland.lk/cdn/shop/files/extremegold_1024x1024.jpg',desc:'24g protein. The world\'s best-selling whey protein for over 20 years.'},
  {name:'ISO HD Isolate Protein',brand:'BPI Sports',cat:'protein',price:16500,img:'https://fitnessisland.lk/cdn/shop/files/image-removebg-preview_22_2830b01d-d93f-40a7-a2d0-ae6a34c53586_1024x1024.png',desc:'25g pure isolate. Zero sugar, ultra-clean formula for lean gains.'},
  {name:'Platinum Creatine Monohydrate',brand:'MuscleTech',cat:'creatine',price:3200,img:'https://fitnessisland.lk/cdn/shop/files/NitroTechwheyGold2.27KG_1024x1024.png',desc:'5g pure creatine per serving. Enhances strength, power, and recovery.'},
  {name:'C4 Original Pre-Workout',brand:'Cellucor',cat:'preworkout',price:5500,img:'https://fitnessisland.lk/cdn/shop/files/MusclemedsCarnivore4lbs_1024x1024.png',desc:'Explosive energy, heightened focus to crush every workout session.'},
  {name:'Xtend BCAA Recovery',brand:'Scivation',cat:'bcaa',price:6800,img:'https://fitnessisland.lk/cdn/shop/files/image-removebg-preview_19_b6335e67-cb44-4e3c-aa33-0e5f7e0d6a5d_1024x1024.png',desc:'7g BCAAs per serving. Intra-workout hydration and muscle recovery.'},
  {name:'Serious Mass Weight Gainer',brand:'Optimum Nutrition',cat:'gainer',price:12500,img:'https://fitnessisland.lk/cdn/shop/files/image-removebg-preview_15_ebae186e-6a80-49ad-9d7b-d4faeeadb1a0_1024x1024.png',desc:'1,250 calories per serving. High-protein mass gainer for hard gainers.'},
  {name:'Animal Pak Multivitamin',brand:'Universal Nutrition',cat:'vitamins',price:7200,img:'https://fitnessisland.lk/cdn/shop/files/DymatizeISO100_1024x1024.png',desc:'Complete vitamin & mineral stack for peak athletic performance.'},
  {name:'Hydroxycut Hardcore Elite',brand:'MuscleTech',cat:'burner',price:4800,img:'https://fitnessisland.lk/cdn/shop/files/MusclemedsCarnivore4lbs_1024x1024.png',desc:'Thermogenic fat burner with green coffee extract. Boost metabolism fast.'}
];

var CAT_LABELS={protein:'Protein',creatine:'Creatine',preworkout:'Pre-Workout',bcaa:'BCAA',gainer:'Mass Gainer',vitamins:'Vitamins',burner:'Fat Burner'};

function smGetAll(){try{var d=JSON.parse(localStorage.getItem(SM_KEY));return d&&d.length?d:SM_DEFAULT;}catch(e){return SM_DEFAULT;}}
function smSaveAll(list){localStorage.setItem(SM_KEY,JSON.stringify(list));}
function smFmt(n){return'Rs. '+n.toLocaleString();}

function smRenderStats(){
  var all=smGetAll(),cats={},brands={},total=0;
  all.forEach(function(p){cats[p.cat]=true;brands[p.brand]=true;total+=p.price;});
  document.getElementById('smStats').innerHTML=
    '<div class="sm-stat"><div class="sm-stat-val">'+all.length+'</div><div class="sm-stat-lbl">Total Products</div></div>'+
    '<div class="sm-stat"><div class="sm-stat-val">'+Object.keys(cats).length+'</div><div class="sm-stat-lbl">Categories</div></div>'+
    '<div class="sm-stat"><div class="sm-stat-val">'+Object.keys(brands).length+'</div><div class="sm-stat-lbl">Brands</div></div>'+
    '<div class="sm-stat"><div class="sm-stat-val">'+smFmt(Math.round(total/all.length))+'</div><div class="sm-stat-lbl">Avg. Price</div></div>';
}

function smRender(list){
  var g=document.getElementById('smGrid');
  if(!list||!list.length){g.innerHTML='<div class="sm-empty"><i class="bi bi-capsule"></i><div>No products found</div><div style="font-size:.72rem;margin-top:.3rem;opacity:.5">Try a different search or add a new product</div></div>';return;}
  g.innerHTML=list.map(function(p,i){
    return '<div class="sm-card">'+
      '<div class="sm-card-top">'+
        '<div class="sm-card-name"><i class="bi bi-capsule"></i>'+p.name+'</div>'+
        '<div class="sm-card-actions">'+
          '<span class="sm-cat-badge '+p.cat+'">'+(CAT_LABELS[p.cat]||p.cat)+'</span>'+
          '<button onclick="smEdit('+i+')"><i class="bi bi-pencil"></i> Edit</button>'+
          '<button class="sm-del" onclick="smDelete('+i+')"><i class="bi bi-trash3"></i></button>'+
        '</div>'+
      '</div>'+
      '<div class="sm-card-body">'+
        '<div class="sm-card-thumb"><img src="'+p.img+'" alt="'+p.name+'" onerror="this.src=\'data:image/svg+xml;utf8,<svg xmlns=http://www.w3.org/2000/svg width=40 height=40><text x=8 y=28 font-size=24>💊</text></svg>\'"></div>'+
        '<div class="sm-card-info">'+
          '<div class="sm-card-brand">'+p.brand+'</div>'+
          '<div class="sm-card-pname">'+p.name+'</div>'+
          '<div class="sm-card-desc">'+p.desc+'</div>'+
        '</div>'+
      '</div>'+
      '<div class="sm-card-foot" style="margin:0 1rem .8rem;padding-top:.6rem">'+
        '<span class="sm-card-price">'+smFmt(p.price)+'</span>'+
        '<span><i class="bi bi-building"></i> '+p.brand+'</span>'+
        '<span><i class="bi bi-tag"></i> '+(CAT_LABELS[p.cat]||p.cat)+'</span>'+
      '</div>'+
    '</div>';
  }).join('');
}

function smFilter(){
  var q=(document.getElementById('smSearch').value||'').toLowerCase();
  var all=smGetAll();
  var list=q?all.filter(function(p){return p.name.toLowerCase().indexOf(q)>=0||p.brand.toLowerCase().indexOf(q)>=0||(CAT_LABELS[p.cat]||'').toLowerCase().indexOf(q)>=0||p.desc.toLowerCase().indexOf(q)>=0;}):all;
  smRender(list);
}

function smHandleFile(input){
  var file=input.files[0];if(!file)return;
  if(file.size>5*1024*1024){alert('Image too large. Max 5MB.');input.value='';return;}
  var reader=new FileReader();
  reader.onload=function(e){
    smUploadedBase64=e.target.result;
    document.getElementById('smUploadZone').classList.add('has-file');
    var sizeKb=Math.round(file.size/1024);
    document.getElementById('smUploadPreview').style.display='block';
    document.getElementById('smUploadPreview').innerHTML='<div class="sm-upload-preview"><img src="'+smUploadedBase64+'"><div class="sm-upload-preview-info"><div class="sm-upload-preview-name">'+file.name+'</div><div class="sm-upload-preview-size">'+sizeKb+' KB · '+file.type+'</div></div><button class="sm-upload-remove" onclick="event.stopPropagation();smRemoveUpload()"><i class="bi bi-x-lg"></i> Remove</button></div>';
    // Also update the small preview
    document.getElementById('smImgPreview').innerHTML='<img src="'+smUploadedBase64+'">';
  };
  reader.readAsDataURL(file);
}

function smHandleDrop(e){
  var files=e.dataTransfer.files;
  if(files.length>0){
    document.getElementById('smFileInput').files=files;
    smHandleFile(document.getElementById('smFileInput'));
  }
}

function smRemoveUpload(){
  smUploadedBase64='';
  document.getElementById('smFileInput').value='';
  document.getElementById('smUploadZone').classList.remove('has-file');
  document.getElementById('smUploadPreview').style.display='none';
  document.getElementById('smUploadPreview').innerHTML='';
  smPreviewImg();
}

function smPreviewImg(){
  var url=document.getElementById('smImg').value.trim();
  var el=document.getElementById('smImgPreview');
  if(smUploadedBase64){el.innerHTML='<img src="'+smUploadedBase64+'">';return;}
  if(url){el.innerHTML='<img src="'+url+'" onerror="this.parentNode.innerHTML=\'<i class=\\\'bi bi-exclamation-triangle\\\' style=\\\'color:#f87171;font-size:1.2rem\\\'></i>\'">';}
  else{el.innerHTML='<i class="bi bi-image" style="color:var(--gray);font-size:1.4rem"></i>';}
}

function smOpenModal(idx){
  document.getElementById('smModalBg').classList.add('open');
  if(typeof idx==='number'){
    var p=smGetAll()[idx];
    document.getElementById('smModalTitle').innerHTML='<i class="bi bi-pencil-square"></i> EDIT <span>PRODUCT</span>';
    document.getElementById('smEditIdx').value=idx;
    document.getElementById('smName').value=p.name;
    document.getElementById('smBrand').value=p.brand;
    document.getElementById('smCat').value=p.cat;
    document.getElementById('smPrice').value=p.price;
    document.getElementById('smDesc').value=p.desc;
    smUploadedBase64='';
    document.getElementById('smUploadZone').classList.remove('has-file');
    document.getElementById('smUploadPreview').style.display='none';
    document.getElementById('smUploadPreview').innerHTML='';
    document.getElementById('smFileInput').value='';
    if(p.img && p.img.startsWith('data:')){
      smUploadedBase64=p.img;
      document.getElementById('smImg').value='';
      var sizeKb=Math.round(p.img.length*0.75/1024);
      document.getElementById('smUploadZone').classList.add('has-file');
      document.getElementById('smUploadPreview').style.display='block';
      document.getElementById('smUploadPreview').innerHTML='<div class="sm-upload-preview"><img src="'+smUploadedBase64+'"><div class="sm-upload-preview-info"><div class="sm-upload-preview-name">Uploaded Image</div><div class="sm-upload-preview-size">~'+sizeKb+' KB</div></div><button class="sm-upload-remove" onclick="event.stopPropagation();smRemoveUpload()"><i class="bi bi-x-lg"></i> Remove</button></div>';
    } else {
      document.getElementById('smImg').value=p.img||'';
    }
    smPreviewImg();
  } else {
    document.getElementById('smModalTitle').innerHTML='<i class="bi bi-capsule"></i> ADD <span>PRODUCT</span>';
    document.getElementById('smEditIdx').value=-1;
    ['smName','smBrand','smPrice','smImg','smDesc'].forEach(function(id){document.getElementById(id).value='';});
    document.getElementById('smCat').selectedIndex=0;
    document.getElementById('smImgPreview').innerHTML='<i class="bi bi-image" style="color:var(--gray);font-size:1.4rem"></i>';
    smUploadedBase64='';
    document.getElementById('smUploadZone').classList.remove('has-file');
    document.getElementById('smUploadPreview').style.display='none';
    document.getElementById('smUploadPreview').innerHTML='';
    document.getElementById('smFileInput').value='';
  }
}
function smCloseModal(){document.getElementById('smModalBg').classList.remove('open');}

function smSave(){
  var name=document.getElementById('smName').value.trim();
  if(!name){alert('Product name is required.');return;}
  var prod={
    name:name,brand:document.getElementById('smBrand').value.trim()||'Unknown',
    cat:document.getElementById('smCat').value,price:parseInt(document.getElementById('smPrice').value)||0,
    img:smUploadedBase64||document.getElementById('smImg').value.trim()||'',desc:document.getElementById('smDesc').value.trim()||''
  };
  var all=smGetAll(),idx=parseInt(document.getElementById('smEditIdx').value);
  if(idx>=0){all[idx]=prod;}else{all.push(prod);}
  smSaveAll(all);smCloseModal();smRenderStats();smFilter();
}

function smEdit(i){smOpenModal(i);}
function smDelete(i){
  if(!confirm('Delete this product? This will remove it from the Supplements & Nutrition storefront.'))return;
  var all=smGetAll();all.splice(i,1);smSaveAll(all);smRenderStats();smFilter();
}

document.addEventListener('DOMContentLoaded',function(){
  if(!localStorage.getItem(SM_KEY)){smSaveAll(SM_DEFAULT);}
  smRenderStats();smRender(smGetAll());
});
</script>
</div>

<!-- SECTION: Trainer Management -->
<div class="dash-section" id="sec-trainers">
<style>
.tr-header{display:flex;align-items:center;justify-content:space-between;flex-wrap:wrap;gap:1rem;margin-bottom:1.5rem}
.tr-add-btn{display:flex;align-items:center;gap:.4rem;padding:.6rem 1.2rem;border-radius:10px;border:none;background:var(--accent);color:#000;font-size:.8rem;font-weight:700;cursor:pointer;transition:all .2s;letter-spacing:.3px}.tr-add-btn:hover{box-shadow:0 4px 20px rgba(200,240,61,.3);transform:scale(1.03)}
.tr-grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(360px,1fr));gap:1.25rem}
.tr-card{background:var(--card);border:1px solid var(--border);border-radius:14px;overflow:hidden;transition:border-color .25s}.tr-card:hover{border-color:rgba(var(--accent-rgb),.3)}
.tr-card-top{display:flex;align-items:center;justify-content:space-between;padding:.8rem 1rem;border-bottom:1px solid var(--border);background:rgba(255,255,255,.02)}
.tr-card-name{font-weight:700;font-size:.88rem;display:flex;align-items:center;gap:.6rem;min-width:0}
.tr-card-avatar{width:36px;height:36px;border-radius:10px;background:linear-gradient(135deg,rgba(var(--accent-rgb),.2),rgba(var(--accent-rgb),.05));display:flex;align-items:center;justify-content:center;font-weight:800;color:var(--accent);font-size:.85rem;flex-shrink:0;border:1px solid rgba(var(--accent-rgb),.15)}
.tr-card-name-text{white-space:nowrap;overflow:hidden;text-overflow:ellipsis}
.tr-card-actions{display:flex;gap:.4rem;flex-shrink:0}
.tr-card-actions button{background:none;border:1px solid var(--border);border-radius:6px;color:var(--gray);font-size:.68rem;padding:.3rem .55rem;cursor:pointer;transition:all .2s;display:flex;align-items:center;gap:.2rem}
.tr-card-actions button:hover{border-color:var(--accent);color:var(--accent)}
.tr-card-actions .tr-del:hover{border-color:#f87171;color:#f87171}
.tr-card-body{padding:1rem}
.tr-card-info{display:grid;grid-template-columns:1fr 1fr;gap:.5rem;margin-bottom:.8rem}
.tr-info-item{display:flex;align-items:center;gap:.4rem;font-size:.72rem;color:var(--gray)}.tr-info-item i{color:rgba(var(--accent-rgb),.5);font-size:.8rem;width:16px}.tr-info-item strong{color:#fff;font-weight:600}
.tr-card-foot{display:flex;gap:.4rem;flex-wrap:wrap;padding-top:.7rem;border-top:1px solid var(--border)}
.tr-spec{display:inline-flex;align-items:center;padding:.18rem .5rem;border-radius:20px;font-size:.55rem;font-weight:800;letter-spacing:1.5px;text-transform:uppercase}
.tr-spec.strength{background:rgba(248,113,113,.1);border:1px solid rgba(248,113,113,.25);color:#f87171}
.tr-spec.cardio{background:rgba(96,165,250,.1);border:1px solid rgba(96,165,250,.25);color:#60a5fa}
.tr-spec.yoga{background:rgba(167,139,250,.1);border:1px solid rgba(167,139,250,.25);color:#a78bfa}
.tr-spec.hiit{background:rgba(251,191,36,.1);border:1px solid rgba(251,191,36,.25);color:#fbbf24}
.tr-spec.crossfit{background:rgba(244,114,182,.1);border:1px solid rgba(244,114,182,.25);color:#f472b6}
.tr-spec.dance{background:rgba(52,211,153,.1);border:1px solid rgba(52,211,153,.25);color:#34d399}
.tr-spec.boxing{background:rgba(45,212,191,.1);border:1px solid rgba(45,212,191,.25);color:#2dd4bf}
.tr-spec.pilates{background:rgba(251,146,60,.1);border:1px solid rgba(251,146,60,.25);color:#fb923c}
.tr-spec.functional{background:rgba(200,240,61,.08);border:1px solid rgba(200,240,61,.2);color:var(--accent)}
.tr-cert{display:inline-flex;align-items:center;gap:.2rem;padding:.12rem .4rem;border-radius:6px;font-size:.55rem;font-weight:700;background:rgba(var(--accent-rgb),.08);color:var(--accent);letter-spacing:.5px;text-transform:uppercase}
.tr-status{display:inline-flex;align-items:center;gap:.25rem;padding:.15rem .5rem;border-radius:20px;font-size:.6rem;font-weight:700;background:rgba(52,211,153,.1);color:#34d399;border:1px solid rgba(52,211,153,.2)}
.tr-stats{display:grid;grid-template-columns:repeat(4,1fr);gap:1rem;margin-bottom:1.5rem}
.tr-stat{background:var(--card);border:1px solid var(--border);border-radius:12px;padding:1rem;text-align:center;position:relative;overflow:hidden}
.tr-stat::after{content:'';position:absolute;top:0;left:0;right:0;height:2px;background:linear-gradient(90deg,transparent,var(--accent),transparent);opacity:.2}
.tr-stat-val{font-family:var(--font-display);font-size:1.6rem;color:var(--accent)}.tr-stat-lbl{font-size:.6rem;color:var(--gray);text-transform:uppercase;letter-spacing:1.5px;margin-top:.1rem}
.tr-search{position:relative;max-width:360px}.tr-search i{position:absolute;left:1rem;top:50%;transform:translateY(-50%);color:rgba(255,255,255,.3)}
.tr-search input{width:100%;padding:.6rem 1rem .6rem 2.6rem;border-radius:10px;border:1px solid var(--border);background:rgba(255,255,255,.04);color:#fff;font-size:.82rem;outline:none}.tr-search input:focus{border-color:rgba(var(--accent-rgb),.4)}
.tr-filters{display:flex;align-items:center;gap:.5rem;margin-bottom:1rem;flex-wrap:wrap}
.tr-filter-label{font-size:.65rem;font-weight:700;letter-spacing:2px;text-transform:uppercase;color:var(--gray);margin-right:.3rem}
.tr-fbtn{padding:.4rem 1rem;border-radius:50px;border:1px solid var(--border);background:transparent;color:var(--gray);font-size:.7rem;font-weight:700;cursor:pointer;transition:all .25s}
.tr-fbtn:hover{border-color:rgba(var(--accent-rgb),.3);color:#fff}
.tr-fbtn.active{background:var(--accent);color:#000;border-color:var(--accent);box-shadow:0 4px 20px rgba(200,240,61,.15)}
.tr-modal-bg{position:fixed;inset:0;background:rgba(0,0,0,.7);z-index:9000;display:none;align-items:center;justify-content:center;backdrop-filter:blur(6px)}.tr-modal-bg.open{display:flex}
.tr-modal{background:#111;border:1px solid var(--border);border-radius:18px;width:540px;max-width:94vw;max-height:90vh;overflow-y:auto;padding:2rem;animation:fadeIn .3s ease}
.tr-modal h2{font-family:var(--font-display);font-size:1.5rem;letter-spacing:2px;margin-bottom:1.2rem;display:flex;align-items:center;gap:.5rem}.tr-modal h2 span{color:var(--accent)}
.tr-field{margin-bottom:1rem}.tr-field label{display:block;font-size:.72rem;font-weight:700;letter-spacing:1px;text-transform:uppercase;color:var(--gray);margin-bottom:.35rem}
.tr-field input{width:100%;padding:.6rem .8rem;border-radius:8px;border:1px solid var(--border);background:rgba(255,255,255,.04);color:#fff;font-size:.82rem;font-family:inherit;outline:none;transition:border-color .2s}
.tr-field input:focus{border-color:rgba(var(--accent-rgb),.4)}
.tr-field-row{display:grid;grid-template-columns:1fr 1fr;gap:.8rem}
.tr-submit{width:100%;padding:.7rem;border-radius:10px;border:none;background:var(--accent);color:#000;font-size:.82rem;font-weight:800;cursor:pointer;margin-top:.5rem;transition:all .2s;letter-spacing:.3px}.tr-submit:hover{box-shadow:0 4px 20px rgba(200,240,61,.3)}
.tr-cancel{width:100%;padding:.55rem;border-radius:8px;border:1px solid var(--border);background:none;color:var(--gray);font-size:.75rem;cursor:pointer;margin-top:.5rem;transition:all .2s}.tr-cancel:hover{border-color:#f87171;color:#f87171}
.tr-empty{text-align:center;padding:3rem;color:var(--gray);grid-column:1/-1}.tr-empty i{font-size:2.5rem;display:block;margin-bottom:.8rem;opacity:.3}
.tr-del-modal-bg{position:fixed;inset:0;background:rgba(0,0,0,.7);z-index:9100;display:none;align-items:center;justify-content:center;backdrop-filter:blur(6px)}.tr-del-modal-bg.open{display:flex}
.tr-del-modal{background:#111;border:1px solid var(--border);border-radius:18px;width:420px;max-width:94vw;padding:2rem;text-align:center;animation:fadeIn .3s ease}
.tr-del-icon{font-size:2.5rem;color:#f87171;margin-bottom:.8rem}
.tr-del-modal h3{font-family:var(--font-display);font-size:1.3rem;letter-spacing:2px;margin-bottom:.5rem}
.tr-del-modal p{color:var(--gray);font-size:.82rem;margin-bottom:1.5rem}.tr-del-modal p strong{color:#fff}
.tr-del-btns{display:flex;gap:.8rem;justify-content:center}
.tr-del-cancel{padding:.5rem 1.2rem;border-radius:8px;border:1px solid var(--border);background:none;color:var(--gray);font-size:.78rem;cursor:pointer;transition:all .2s}.tr-del-cancel:hover{border-color:#fff;color:#fff}
.tr-del-confirm{padding:.5rem 1.2rem;border-radius:8px;border:none;background:#f87171;color:#000;font-size:.78rem;font-weight:700;cursor:pointer;transition:all .2s}.tr-del-confirm:hover{box-shadow:0 4px 20px rgba(248,113,113,.3)}
@media(max-width:768px){.tr-stats{grid-template-columns:repeat(2,1fr)}.tr-grid{grid-template-columns:1fr}}
</style>

<div class="sec-header" style="display:flex;align-items:center;justify-content:space-between;flex-wrap:wrap;gap:1rem">
  <h2>TRAINER <span>MANAGEMENT</span></h2>
  <div style="display:flex;align-items:center;gap:.5rem;font-size:.8rem;color:rgba(255,255,255,.45)"><i class="bi bi-info-circle"></i> Manage fitness trainers — assigned to classes and programs</div>
</div>
<div class="tr-stats" id="trStats"></div>
<div class="tr-header">
  <div class="tr-search"><i class="bi bi-search"></i><input type="text" id="trSearch" placeholder="Search trainers, specializations..." oninput="trFilter()"></div>
  <button class="tr-add-btn" onclick="trOpenModal()"><i class="bi bi-person-plus-fill"></i> Add Trainer</button>
</div>
<div class="tr-filters" id="trFilters"><span class="tr-filter-label">Specialization:</span><button class="tr-fbtn active" onclick="trSetFilter('all',this)">All</button></div>
<div class="tr-grid" id="trGrid"></div>

<div class="tr-modal-bg" id="trModal"><div class="tr-modal">
  <h2><i class="bi bi-person-badge-fill"></i> <span id="trModalTitle">ADD TRAINER</span></h2>
  <input type="hidden" id="trEditIdx" value="-1">
  <div class="tr-field"><label>Full Name</label><input type="text" id="trName" placeholder="e.g. Ashan Jayawardena"></div>
  <div class="tr-field-row"><div class="tr-field"><label>Email</label><input type="email" id="trEmail" placeholder="e.g. ashan@fcms.lk"></div><div class="tr-field"><label>Phone</label><input type="text" id="trPhone" placeholder="e.g. 0771001001"></div></div>
  <div class="tr-field-row"><div class="tr-field"><label>Specialization</label><input type="text" id="trSpec" placeholder="e.g. Strength Training|Bodybuilding"></div><div class="tr-field"><label>Certifications</label><input type="text" id="trCerts" placeholder="e.g. NSCA Certified|CPR Certified"></div></div>
  <button class="tr-submit" onclick="trSave()"><i class="bi bi-check-circle-fill"></i> Save Trainer</button>
  <button class="tr-cancel" onclick="trCloseModal()">Cancel</button>
</div></div>

<div class="tr-del-modal-bg" id="trDelModal"><div class="tr-del-modal">
  <div class="tr-del-icon"><i class="bi bi-exclamation-triangle-fill"></i></div>
  <h3>DELETE TRAINER</h3>
  <p>Are you sure you want to remove <strong id="trDelName"></strong>? This action cannot be undone.</p>
  <div class="tr-del-btns"><button class="tr-del-cancel" onclick="trCloseDelModal()">Cancel</button><button class="tr-del-confirm" onclick="trConfirmDel()"><i class="bi bi-trash3"></i> Delete</button></div>
</div></div>

<script>
var TR_KEY='fcms_trainers';
var TR_DEFAULT=[
  {name:'Ashan Jayawardena',email:'ashan.j@fcms.lk',phone:'0771001001',spec:'Strength Training|Bodybuilding',certs:'NSCA Certified|CPR Certified'},
  {name:'Kasun Bandara',email:'kasun.b@fcms.lk',phone:'0772002002',spec:'Cardio|HIIT',certs:'ACE Certified|CPR Certified'},
  {name:'Nadeesha Perera',email:'nadeesha.p@fcms.lk',phone:'0773003003',spec:'Zumba|Dance Fitness',certs:'Zumba Instructor|ACE Certified'},
  {name:'Priya Wickramasinghe',email:'priya.w@fcms.lk',phone:'0774004004',spec:'Yoga|Pilates',certs:'RYT-200|CPR Certified'},
  {name:'Ravi Fernando',email:'ravi.f@fcms.lk',phone:'0775005005',spec:'CrossFit|Functional',certs:'CrossFit L2|First Aid'},
  {name:'Shanaya De Silva',email:'shanaya.d@fcms.lk',phone:'0776006006',spec:'Boxing|HIIT',certs:'ISSA Certified|CPR Certified'}
];
var trDelIdx=-1,trCurrentFilter='all';
function trGetAll(){try{return JSON.parse(localStorage.getItem(TR_KEY))||[];}catch(e){return[];}}
function trSaveAll(a){localStorage.setItem(TR_KEY,JSON.stringify(a));}
var TR_SPEC_MAP={'strength training':'strength','bodybuilding':'strength','strength':'strength','cardio':'cardio','hiit':'hiit','yoga':'yoga','pilates':'pilates','crossfit':'crossfit','functional':'functional','zumba':'dance','dance fitness':'dance','dance':'dance','boxing':'boxing'};
function trSpecClass(s){return TR_SPEC_MAP[s.toLowerCase().trim()]||'functional';}
function trRenderStats(){
  var all=trGetAll(),specs={};all.forEach(function(t){(t.spec||'').split('|').forEach(function(s){if(s.trim())specs[s.trim()]=1;});});
  document.getElementById('trStats').innerHTML='<div class="tr-stat"><div class="tr-stat-val">'+all.length+'</div><div class="tr-stat-lbl">Total Trainers</div></div><div class="tr-stat"><div class="tr-stat-val" style="color:#60a5fa">'+Object.keys(specs).length+'</div><div class="tr-stat-lbl">Specializations</div></div><div class="tr-stat"><div class="tr-stat-val" style="color:#34d399">'+all.length+'</div><div class="tr-stat-lbl">Active</div></div><div class="tr-stat"><div class="tr-stat-val" style="color:#a78bfa">9</div><div class="tr-stat-lbl">Classes Covered</div></div>';
  var fb='<span class="tr-filter-label">Specialization:</span><button class="tr-fbtn'+(trCurrentFilter==='all'?' active':'')+'" onclick="trSetFilter(\'all\',this)">All</button>';
  var seen={};all.forEach(function(t){(t.spec||'').split('|').forEach(function(s){s=s.trim();if(s&&!seen[s]){seen[s]=1;fb+='<button class="tr-fbtn'+(trCurrentFilter===s?' active':'')+'" onclick="trSetFilter(\''+s.replace(/'/g,"\\'")+'\',this)">'+s+'</button>';}});});
  document.getElementById('trFilters').innerHTML=fb;
}
function trRender(list){
  if(!list.length){document.getElementById('trGrid').innerHTML='<div class="tr-empty"><i class="bi bi-person-badge"></i><div style="font-size:1rem;font-weight:600;margin-bottom:.3rem">No trainers found</div><div>Add your first trainer to get started</div></div>';return;}
  var all=trGetAll(),html='';
  list.forEach(function(t,i){
    var ri=-1;for(var x=0;x<all.length;x++){if(all[x].name===t.name&&all[x].email===t.email){ri=x;break;}}
    var specs=(t.spec||'').split('|').map(function(s){return s.trim();}).filter(Boolean);
    var certs=(t.certs||'').split('|').map(function(s){return s.trim();}).filter(Boolean);
    html+='<div class="tr-card" data-spec="'+(t.spec||'')+'" data-name="'+(t.name||'')+'" style="animation:fadeIn .4s ease '+(i*0.05)+'s both">';
    html+='<div class="tr-card-top"><div class="tr-card-name"><div class="tr-card-avatar">'+(t.name?t.name.charAt(0):'?')+'</div><div><div class="tr-card-name-text">'+t.name+'</div><div style="font-size:.65rem;color:var(--gray);font-weight:400">'+t.email+'</div></div></div>';
    html+='<div class="tr-card-actions"><span class="tr-status"><i class="bi bi-circle-fill" style="font-size:.4rem"></i> Active</span><button onclick="trEdit('+ri+')"><i class="bi bi-pencil"></i> Edit</button><button class="tr-del" onclick="trOpenDel('+ri+')"><i class="bi bi-trash3"></i></button></div></div>';
    html+='<div class="tr-card-body"><div class="tr-card-info"><div class="tr-info-item"><i class="bi bi-telephone-fill"></i> <strong>'+t.phone+'</strong></div><div class="tr-info-item"><i class="bi bi-hash"></i> ID: <strong>T'+(ri+1).toString().padStart(3,'0')+'</strong></div></div>';
    html+='<div class="tr-card-foot">';specs.forEach(function(s){html+='<span class="tr-spec '+trSpecClass(s)+'">'+s+'</span>';});
    certs.forEach(function(c){html+='<span class="tr-cert"><i class="bi bi-patch-check-fill"></i> '+c+'</span>';});
    html+='</div></div></div>';
  });
  document.getElementById('trGrid').innerHTML=html;
}
function trFilter(){var q=(document.getElementById('trSearch').value||'').toLowerCase();var list=trGetAll().filter(function(t){return(!q||(t.name||'').toLowerCase().indexOf(q)>=0||(t.email||'').toLowerCase().indexOf(q)>=0||(t.spec||'').toLowerCase().indexOf(q)>=0)&&(trCurrentFilter==='all'||(t.spec||'').toLowerCase().indexOf(trCurrentFilter.toLowerCase())>=0);});trRender(list);}
function trSetFilter(s,b){trCurrentFilter=s;document.querySelectorAll('.tr-fbtn').forEach(function(x){x.classList.remove('active');});b.classList.add('active');trFilter();}
function trOpenModal(){document.getElementById('trEditIdx').value='-1';document.getElementById('trModalTitle').textContent='ADD TRAINER';['trName','trEmail','trPhone','trSpec','trCerts'].forEach(function(id){document.getElementById(id).value='';});document.getElementById('trModal').classList.add('open');}
function trCloseModal(){document.getElementById('trModal').classList.remove('open');}
function trEdit(i){var t=trGetAll()[i];if(!t)return;document.getElementById('trEditIdx').value=i;document.getElementById('trModalTitle').textContent='EDIT TRAINER';document.getElementById('trName').value=t.name||'';document.getElementById('trEmail').value=t.email||'';document.getElementById('trPhone').value=t.phone||'';document.getElementById('trSpec').value=t.spec||'';document.getElementById('trCerts').value=t.certs||'';document.getElementById('trModal').classList.add('open');}
function trSave(){var n=document.getElementById('trName').value.trim();if(!n){alert('Please enter a trainer name.');return;}var o={name:n,email:document.getElementById('trEmail').value.trim(),phone:document.getElementById('trPhone').value.trim(),spec:document.getElementById('trSpec').value.trim(),certs:document.getElementById('trCerts').value.trim()};var all=trGetAll(),idx=parseInt(document.getElementById('trEditIdx').value);if(idx>=0&&idx<all.length)all[idx]=o;else all.push(o);trSaveAll(all);trCloseModal();trRenderStats();trRender(trGetAll());}
function trOpenDel(i){trDelIdx=i;document.getElementById('trDelName').textContent=(trGetAll()[i]||{}).name||'';document.getElementById('trDelModal').classList.add('open');}
function trCloseDelModal(){document.getElementById('trDelModal').classList.remove('open');trDelIdx=-1;}
function trConfirmDel(){if(trDelIdx<0)return;var a=trGetAll();a.splice(trDelIdx,1);trSaveAll(a);trCloseDelModal();trRenderStats();trRender(trGetAll());}
document.addEventListener('DOMContentLoaded',function(){if(!localStorage.getItem(TR_KEY))trSaveAll(TR_DEFAULT);trRenderStats();trRender(trGetAll());});
</script>
</div>

<!-- SECTION: Attendance Check-In -->
<div class="dash-section" id="sec-attendance">
<style>
.att-layout{display:grid;grid-template-columns:380px 1fr;gap:1.5rem;align-items:start}
.att-checkin{background:var(--card);border:1px solid var(--border);border-radius:14px;padding:1.5rem;position:relative;overflow:hidden}
.att-checkin::before{content:'';position:absolute;top:0;left:0;right:0;height:2px;background:linear-gradient(90deg,var(--accent),transparent);opacity:.4}
.att-checkin-title{font-family:var(--font-display);font-size:1.2rem;letter-spacing:2px;margin-bottom:1.2rem;display:flex;align-items:center;gap:.5rem}.att-checkin-title i{color:var(--accent)}
.att-label{font-size:.65rem;font-weight:700;letter-spacing:1.5px;text-transform:uppercase;color:var(--gray);margin-bottom:.4rem;display:block}
.att-input-row{display:flex;gap:.6rem;margin-bottom:.8rem}
.att-input{flex:1;padding:.6rem .9rem;border-radius:10px;border:1px solid var(--border);background:rgba(255,255,255,.04);color:#fff;font-size:.82rem;font-family:inherit;outline:none;transition:border-color .2s}.att-input:focus{border-color:rgba(var(--accent-rgb),.4)}
.att-checkin-btn{display:flex;align-items:center;gap:.4rem;padding:.6rem 1.2rem;border-radius:10px;border:none;background:var(--accent);color:#000;font-size:.8rem;font-weight:700;cursor:pointer;transition:all .2s;white-space:nowrap}.att-checkin-btn:hover{box-shadow:0 4px 20px rgba(200,240,61,.3);transform:scale(1.03)}
.att-hint{font-size:.72rem;color:var(--gray);min-height:1.2em;margin-bottom:.5rem}
.att-divider{border-top:1px solid var(--border);margin:.8rem 0;padding-top:.8rem}
.att-today-row{display:flex;align-items:center;justify-content:space-between;margin-bottom:.8rem}
.att-today-date{font-size:.78rem;color:var(--gray);display:flex;align-items:center;gap:.4rem}.att-today-date i{color:rgba(var(--accent-rgb),.5)}
.att-clock{display:inline-flex;align-items:center;gap:.35rem;padding:.3rem .7rem;border-radius:20px;font-size:.75rem;font-weight:700;font-family:monospace;background:rgba(var(--accent-rgb),.08);color:var(--accent);border:1px solid rgba(var(--accent-rgb),.15)}
.att-clock i{font-size:.55rem;animation:attPulse 1.5s infinite}
@keyframes attPulse{0%,100%{opacity:1}50%{opacity:.3}}
.att-count{text-align:center;margin-top:.6rem}
.att-count-val{font-family:var(--font-display);font-size:2.5rem;color:var(--accent);line-height:1}
.att-count-lbl{font-size:.58rem;font-weight:700;text-transform:uppercase;letter-spacing:2px;color:var(--gray);margin-top:.1rem}
.att-sparkline{display:flex;align-items:flex-end;gap:3px;height:40px;margin-top:.8rem}
.att-spark-bar{flex:1;background:rgba(var(--accent-rgb),.15);border-radius:3px 3px 0 0;transition:height .4s ease}.att-spark-bar:hover{background:rgba(var(--accent-rgb),.35)}.att-spark-bar.today{background:var(--accent);border-radius:3px}
.att-datepicker{background:var(--card);border:1px solid var(--border);border-radius:14px;padding:1.2rem;margin-top:1rem}
.att-datepicker-title{font-size:.72rem;font-weight:700;letter-spacing:1px;text-transform:uppercase;color:var(--gray);margin-bottom:.6rem}
.att-date-row{display:flex;gap:.5rem}
.att-date-input{flex:1;padding:.55rem .8rem;border-radius:10px;border:1px solid var(--border);background:rgba(255,255,255,.04);color:#fff;font-size:.8rem;font-family:inherit;outline:none;color-scheme:dark}.att-date-input:focus{border-color:rgba(var(--accent-rgb),.4)}
.att-date-btn{padding:.55rem .8rem;border-radius:10px;border:none;background:var(--accent);color:#000;font-size:.85rem;cursor:pointer;transition:all .2s}.att-date-btn:hover{box-shadow:0 4px 20px rgba(200,240,61,.3)}
.att-list{background:var(--card);border:1px solid var(--border);border-radius:14px;overflow:hidden}
.att-list-header{display:flex;align-items:center;justify-content:space-between;padding:.8rem 1.2rem;border-bottom:1px solid var(--border);background:rgba(255,255,255,.02)}
.att-list-title{font-weight:700;font-size:.9rem;display:flex;align-items:center;gap:.5rem}.att-list-title i{color:var(--accent)}
.att-list-badge{padding:.2rem .6rem;border-radius:20px;font-size:.65rem;font-weight:700;background:rgba(var(--accent-rgb),.08);color:var(--accent);border:1px solid rgba(var(--accent-rgb),.15)}
.att-item{display:flex;align-items:center;gap:.8rem;padding:.7rem 1.2rem;border-bottom:1px solid var(--border);transition:background .2s}.att-item:last-child{border-bottom:none}.att-item:hover{background:rgba(255,255,255,.02)}
.att-item-avatar{width:36px;height:36px;border-radius:10px;background:linear-gradient(135deg,rgba(var(--accent-rgb),.2),rgba(var(--accent-rgb),.05));display:flex;align-items:center;justify-content:center;font-weight:800;color:var(--accent);font-size:.82rem;flex-shrink:0;border:1px solid rgba(var(--accent-rgb),.15)}
.att-item-info{flex:1;min-width:0}
.att-item-name{font-weight:600;font-size:.84rem}
.att-item-meta{display:flex;gap:.8rem;font-size:.68rem;color:var(--gray);margin-top:.1rem}.att-item-meta i{font-size:.6rem;color:rgba(var(--accent-rgb),.4)}
.att-item-time{display:flex;align-items:center;gap:.3rem;padding:.15rem .5rem;border-radius:6px;font-size:.65rem;font-weight:600;background:rgba(255,255,255,.04);color:rgba(255,255,255,.6)}
.att-empty{text-align:center;padding:3rem;color:var(--gray)}.att-empty i{font-size:2.5rem;display:block;margin-bottom:.8rem;opacity:.25}
.att-stats{display:grid;grid-template-columns:repeat(4,1fr);gap:1rem;margin-bottom:1.5rem}
.att-stat{background:var(--card);border:1px solid var(--border);border-radius:12px;padding:1rem;text-align:center;position:relative;overflow:hidden}
.att-stat::after{content:'';position:absolute;top:0;left:0;right:0;height:2px;background:linear-gradient(90deg,transparent,var(--accent),transparent);opacity:.2}
.att-stat-val{font-family:var(--font-display);font-size:1.6rem;color:var(--accent)}.att-stat-lbl{font-size:.6rem;color:var(--gray);text-transform:uppercase;letter-spacing:1.5px;margin-top:.1rem}
@media(max-width:900px){.att-layout{grid-template-columns:1fr}}
</style>

<div class="sec-header" style="display:flex;align-items:center;justify-content:space-between;flex-wrap:wrap;gap:1rem">
  <h2>ATTENDANCE <span>CHECK-IN</span></h2>
  <div style="display:flex;align-items:center;gap:.5rem;font-size:.8rem;color:rgba(255,255,255,.45)"><i class="bi bi-info-circle"></i> Record member attendance and track daily gym check-ins</div>
</div>

<div class="att-stats" id="attStats"></div>

<div class="att-layout">
  <!-- Left Column -->
  <div>
    <div class="att-checkin">
      <div class="att-checkin-title"><i class="bi bi-person-check-fill"></i> RECORD CHECK-IN</div>
      <label class="att-label">Member ID</label>
      <div class="att-input-row">
        <input type="text" class="att-input" id="attMemberId" placeholder="e.g. M001" autocomplete="off">
        <button class="att-checkin-btn" onclick="attCheckIn()"><i class="bi bi-box-arrow-in-right"></i> Check In</button>
      </div>
      <div class="att-hint" id="attHint"></div>
      <div class="att-divider"></div>
      <div class="att-today-row">
        <div class="att-today-date"><i class="bi bi-calendar-event"></i> <span id="attTodayDate"></span></div>
        <div class="att-clock"><i class="bi bi-circle-fill"></i> <span id="attClock">--:--:-- AM</span></div>
      </div>
      <div class="att-count"><div class="att-count-val" id="attCountVal">0</div><div class="att-count-lbl">Check-Ins Today</div></div>
      <div style="margin-top:1rem;padding-top:.8rem;border-top:1px solid var(--border)">
        <div style="font-size:.6rem;font-weight:700;letter-spacing:1.5px;text-transform:uppercase;color:var(--gray);margin-bottom:.5rem">Last 7 Days Activity</div>
        <div class="att-sparkline" id="attSparkline"></div>
        <div style="display:flex;justify-content:space-between;margin-top:.3rem"><span style="font-size:.55rem;color:var(--gray)" id="attSparkStart">—</span><span style="font-size:.55rem;color:var(--accent)">Today</span></div>
      </div>
    </div>
    <div class="att-datepicker">
      <div class="att-datepicker-title"><i class="bi bi-calendar-range" style="color:rgba(var(--accent-rgb),.5)"></i> View Different Date</div>
      <div class="att-date-row"><input type="date" class="att-date-input" id="attDatePicker"><button class="att-date-btn" onclick="attLoadDate()"><i class="bi bi-search"></i></button></div>
    </div>
  </div>
  <!-- Right Column -->
  <div class="att-list" id="attListCard">
    <div class="att-list-header"><div class="att-list-title"><i class="bi bi-list-check"></i> Attendance — <span id="attListDate">Today</span></div><span class="att-list-badge" id="attListBadge">0 record(s)</span></div>
    <div id="attListBody"><div class="att-empty"><i class="bi bi-calendar-x"></i><div style="font-size:1rem;font-weight:600;margin-bottom:.3rem">No check-ins recorded</div><div style="font-size:.8rem">Check in a member to see records here</div></div></div>
  </div>
</div>

<script>
var ATT_KEY='fcms_attendance';
function attGetAll(){try{return JSON.parse(localStorage.getItem(ATT_KEY))||[];}catch(e){return[];}}
function attSaveAll(a){localStorage.setItem(ATT_KEY,JSON.stringify(a));}
function attToday(){var d=new Date();return d.getFullYear()+'-'+(d.getMonth()+1).toString().padStart(2,'0')+'-'+d.getDate().toString().padStart(2,'0');}
function attNow(){var d=new Date(),h=d.getHours(),m=d.getMinutes(),ap=h>=12?'PM':'AM';h=h%12||12;return h+':'+m.toString().padStart(2,'0')+' '+ap;}

function attUpdateClock(){var d=new Date(),h=d.getHours(),m=d.getMinutes(),s=d.getSeconds(),ap=h>=12?'PM':'AM';h=h%12||12;document.getElementById('attClock').textContent=h.toString().padStart(2,'0')+':'+m.toString().padStart(2,'0')+':'+s.toString().padStart(2,'0')+' '+ap;}
setInterval(attUpdateClock,1000);

function attGetForDate(date){return attGetAll().filter(function(r){return r.date===date;});}

function attRenderStats(){
  var today=attToday(),todayRecs=attGetForDate(today);
  var all=attGetAll(),weekTotal=0;
  for(var i=0;i<7;i++){var d=new Date();d.setDate(d.getDate()-i);var ds=d.getFullYear()+'-'+(d.getMonth()+1).toString().padStart(2,'0')+'-'+d.getDate().toString().padStart(2,'0');weekTotal+=attGetForDate(ds).length;}
  var html='<div class="att-stat"><div class="att-stat-val">'+todayRecs.length+'</div><div class="att-stat-lbl">Check-Ins Today</div></div>';
  html+='<div class="att-stat"><div class="att-stat-val" style="color:#60a5fa">'+weekTotal+'</div><div class="att-stat-lbl">This Week</div></div>';
  html+='<div class="att-stat"><div class="att-stat-val" style="color:#34d399">'+all.length+'</div><div class="att-stat-lbl">Total Records</div></div>';
  var peak='--';if(todayRecs.length){var hrs={};todayRecs.forEach(function(r){var h=(r.time||'').split(':')[0];hrs[h]=(hrs[h]||0)+1;});var mx=0;for(var k in hrs){if(hrs[k]>mx){mx=hrs[k];peak=k;}}}
  html+='<div class="att-stat"><div class="att-stat-val" style="color:#a78bfa">'+(peak!=='--'?peak+':00':'--')+'</div><div class="att-stat-lbl">Peak Hour</div></div>';
  document.getElementById('attStats').innerHTML=html;
  document.getElementById('attCountVal').textContent=todayRecs.length;
  document.getElementById('attTodayDate').textContent=today;
}

function attRenderList(date){
  var recs=attGetForDate(date);
  document.getElementById('attListDate').textContent=date;
  document.getElementById('attListBadge').textContent=recs.length+' record(s)';
  if(!recs.length){document.getElementById('attListBody').innerHTML='<div class="att-empty"><i class="bi bi-calendar-x"></i><div style="font-size:1rem;font-weight:600;margin-bottom:.3rem">No check-ins recorded</div><div style="font-size:.8rem">No attendance data for '+date+'</div></div>';return;}
  var html='';
  recs.forEach(function(r,i){
    html+='<div class="att-item" style="animation:fadeIn .35s ease '+(i*0.04)+'s both"><div class="att-item-avatar">'+(r.name?r.name.charAt(0):'?')+'</div><div class="att-item-info"><div class="att-item-name">'+r.name+'</div><div class="att-item-meta"><span><i class="bi bi-person"></i> '+r.memberId+'</span><span><i class="bi bi-clock"></i> '+r.time+'</span></div></div><div class="att-item-time"><i class="bi bi-clock-history"></i> '+r.time+'</div></div>';
  });
  document.getElementById('attListBody').innerHTML=html;
}

function attRenderSparkline(){
  var bars=[],labels=[];
  for(var i=6;i>=0;i--){var d=new Date();d.setDate(d.getDate()-i);var ds=d.getFullYear()+'-'+(d.getMonth()+1).toString().padStart(2,'0')+'-'+d.getDate().toString().padStart(2,'0');bars.push(attGetForDate(ds).length);if(i===6)labels.push((d.getMonth()+1)+'/'+d.getDate());}
  var max=Math.max.apply(null,bars)||1;
  var html='';bars.forEach(function(v,i){var h=Math.max(4,(v/max)*40);html+='<div class="att-spark-bar'+(i===6?' today':'')+'" style="height:'+h+'px" title="'+v+' check-ins"></div>';});
  document.getElementById('attSparkline').innerHTML=html;
  document.getElementById('attSparkStart').textContent=labels[0]||'—';
}

function attCheckIn(){
  var mid=document.getElementById('attMemberId').value.trim();
  if(!mid){alert('Please enter a Member ID.');return;}
  var all=attGetAll();
  all.push({memberId:mid,name:'Member '+mid,date:attToday(),time:attNow(),id:'ATT-'+(all.length+1).toString().padStart(4,'0')});
  attSaveAll(all);
  document.getElementById('attMemberId').value='';
  document.getElementById('attHint').innerHTML='<i class="bi bi-check-circle-fill" style="color:#34d399;margin-right:.3rem"></i> <strong style="color:#34d399">'+mid+'</strong> checked in successfully!';
  setTimeout(function(){document.getElementById('attHint').textContent='';},3000);
  attRenderStats();attRenderList(attToday());attRenderSparkline();
}

function attLoadDate(){
  var d=document.getElementById('attDatePicker').value;
  if(d)attRenderList(d);
}

document.getElementById('attMemberId').addEventListener('input',function(){
  var v=this.value.trim();
  if(v.length>=2){document.getElementById('attHint').innerHTML='<i class="bi bi-arrow-right" style="color:var(--accent);margin-right:.3rem"></i> Press Check In for <strong style="color:var(--accent)">'+v+'</strong>';}
  else{document.getElementById('attHint').textContent='';}
});

document.addEventListener('DOMContentLoaded',function(){
  document.getElementById('attDatePicker').value=attToday();
  attUpdateClock();attRenderStats();attRenderList(attToday());attRenderSparkline();
});
</script>
</div>

<!-- SECTION: Members Management -->
<div class="dash-section" id="sec-members">
<style>
.mbr-stats{display:grid;grid-template-columns:repeat(4,1fr);gap:1rem;margin-bottom:1.5rem}
.mbr-stat{background:var(--card);border:1px solid var(--border);border-radius:12px;padding:1rem;text-align:center;position:relative;overflow:hidden}
.mbr-stat::after{content:'';position:absolute;top:0;left:0;right:0;height:2px;background:linear-gradient(90deg,transparent,var(--accent),transparent);opacity:.2}
.mbr-stat-val{font-family:var(--font-display);font-size:1.6rem;color:var(--accent)}.mbr-stat-lbl{font-size:.6rem;color:var(--gray);text-transform:uppercase;letter-spacing:1.5px;margin-top:.1rem}
.mbr-filters{display:flex;gap:.6rem;align-items:center;flex-wrap:wrap;margin-bottom:1.2rem}
.mbr-search-wrap{flex:1;min-width:220px;position:relative}.mbr-search-wrap i{position:absolute;left:.8rem;top:50%;transform:translateY(-50%);color:var(--gray);font-size:.85rem}
.mbr-search{width:100%;padding:.55rem .8rem .55rem 2.2rem;border-radius:10px;border:1px solid var(--border);background:rgba(255,255,255,.04);color:#fff;font-size:.8rem;font-family:var(--font-body);outline:none}.mbr-search:focus{border-color:rgba(var(--accent-rgb),.4)}
.mbr-select{padding:.5rem .8rem;border-radius:10px;border:1px solid var(--border);background:var(--card);color:#fff;font-size:.76rem;font-family:var(--font-body);outline:none;cursor:pointer;min-width:130px}.mbr-select:focus{border-color:rgba(var(--accent-rgb),.4)}
.mbr-tbl-wrap{background:var(--card);border:1px solid var(--border);border-radius:14px;overflow:hidden}
.mbr-tbl-hdr{display:flex;align-items:center;justify-content:space-between;padding:.7rem 1.2rem;border-bottom:1px solid var(--border);background:rgba(255,255,255,.02)}
.mbr-tbl-title{font-weight:700;font-size:.85rem;display:flex;align-items:center;gap:.5rem}.mbr-tbl-title i{color:var(--accent)}
.mbr-tbl-badge{padding:.18rem .5rem;border-radius:20px;font-size:.6rem;font-weight:700;background:rgba(var(--accent-rgb),.08);color:var(--accent);border:1px solid rgba(var(--accent-rgb),.15)}
.mbr-tbl{width:100%;border-collapse:collapse}
.mbr-tbl th{font-size:.58rem;font-weight:700;letter-spacing:1.5px;text-transform:uppercase;color:var(--gray);padding:.55rem 1rem;border-bottom:1px solid var(--border);text-align:left;white-space:nowrap}
.mbr-tbl td{padding:.55rem 1rem;border-bottom:1px solid var(--border);font-size:.78rem;vertical-align:middle}
.mbr-tbl tr:last-child td{border-bottom:none}.mbr-tbl tr:hover td{background:rgba(255,255,255,.015)}
.mbr-id{color:var(--accent);font-family:monospace;font-size:.72rem;font-weight:700}
.mbr-av{width:30px;height:30px;border-radius:8px;background:linear-gradient(135deg,rgba(var(--accent-rgb),.2),rgba(var(--accent-rgb),.05));display:inline-flex;align-items:center;justify-content:center;font-weight:800;color:var(--accent);font-size:.7rem;border:1px solid rgba(var(--accent-rgb),.15);flex-shrink:0}
.mbr-name-cell{display:flex;align-items:center;gap:.5rem}
.mbr-badge{display:inline-flex;align-items:center;gap:.2rem;padding:.12rem .45rem;border-radius:20px;font-size:.55rem;font-weight:700;letter-spacing:.5px;text-transform:uppercase;white-space:nowrap;border:1px solid}
.mbr-badge-standard{background:rgba(var(--accent-rgb),.08);color:var(--accent);border-color:rgba(var(--accent-rgb),.2)}
.mbr-badge-premium{background:rgba(251,191,36,.08);color:#fbbf24;border-color:rgba(251,191,36,.2)}
.mbr-badge-basic{background:rgba(96,165,250,.08);color:#60a5fa;border-color:rgba(96,165,250,.2)}
.mbr-badge-trial{background:rgba(167,139,250,.08);color:#a78bfa;border-color:rgba(167,139,250,.2)}
.mbr-badge-active{background:rgba(52,211,153,.08);color:#34d399;border-color:rgba(52,211,153,.2)}
.mbr-badge-inactive{background:rgba(248,113,113,.08);color:#f87171;border-color:rgba(248,113,113,.2)}
.mbr-badge-expired{background:rgba(251,191,36,.08);color:#fbbf24;border-color:rgba(251,191,36,.2)}
.mbr-acts{display:flex;gap:.3rem;justify-content:center}
.mbr-acts button{background:none;border:1px solid var(--border);border-radius:6px;color:var(--gray);font-size:.65rem;padding:.22rem .4rem;cursor:pointer;transition:all .2s;display:flex;align-items:center;gap:.15rem}
.mbr-acts button:hover{border-color:var(--accent);color:var(--accent)}.mbr-acts .mbr-del-btn:hover{border-color:#f87171;color:#f87171}
.mbr-add-btn{display:flex;align-items:center;gap:.4rem;padding:.55rem 1rem;border-radius:10px;border:none;background:var(--accent);color:#000;font-size:.78rem;font-weight:700;cursor:pointer;transition:all .2s;letter-spacing:.3px}.mbr-add-btn:hover{box-shadow:0 4px 20px rgba(200,240,61,.3);transform:scale(1.03)}
.mbr-modal-bg{position:fixed;inset:0;background:rgba(0,0,0,.7);z-index:9000;display:none;align-items:center;justify-content:center;backdrop-filter:blur(6px)}.mbr-modal-bg.open{display:flex}
.mbr-modal{background:#111;border:1px solid var(--border);border-radius:18px;width:560px;max-width:94vw;max-height:90vh;overflow-y:auto;padding:2rem;animation:fadeIn .3s ease}
.mbr-modal h2{font-family:var(--font-display);font-size:1.4rem;letter-spacing:2px;margin-bottom:1.2rem;display:flex;align-items:center;gap:.5rem}.mbr-modal h2 span{color:var(--accent)}
.mbr-field{margin-bottom:.8rem}.mbr-field label{display:block;font-size:.68rem;font-weight:700;letter-spacing:1px;text-transform:uppercase;color:var(--gray);margin-bottom:.3rem}
.mbr-field input,.mbr-field select{width:100%;padding:.55rem .8rem;border-radius:8px;border:1px solid var(--border);background:rgba(255,255,255,.04);color:#fff;font-size:.8rem;font-family:inherit;outline:none}.mbr-field input:focus,.mbr-field select:focus{border-color:rgba(var(--accent-rgb),.4)}
.mbr-field-row{display:grid;grid-template-columns:1fr 1fr;gap:.8rem}
.mbr-submit{width:100%;padding:.65rem;border-radius:10px;border:none;background:var(--accent);color:#000;font-size:.8rem;font-weight:800;cursor:pointer;margin-top:.5rem}.mbr-submit:hover{box-shadow:0 4px 20px rgba(200,240,61,.3)}
.mbr-cancel{width:100%;padding:.5rem;border-radius:8px;border:1px solid var(--border);background:none;color:var(--gray);font-size:.72rem;cursor:pointer;margin-top:.5rem}.mbr-cancel:hover{border-color:#f87171;color:#f87171}
.mbr-empty{text-align:center;padding:3rem;color:var(--gray)}.mbr-empty i{font-size:2.5rem;display:block;margin-bottom:.8rem;opacity:.25}
.mbr-del-modal-bg{position:fixed;inset:0;background:rgba(0,0,0,.7);z-index:9100;display:none;align-items:center;justify-content:center;backdrop-filter:blur(6px)}.mbr-del-modal-bg.open{display:flex}
.mbr-del-modal{background:#111;border:1px solid var(--border);border-radius:18px;width:420px;max-width:94vw;padding:2rem;text-align:center;animation:fadeIn .3s ease}
@media(max-width:768px){.mbr-stats{grid-template-columns:repeat(2,1fr)}}
</style>

<div class="sec-header" style="display:flex;align-items:center;justify-content:space-between;flex-wrap:wrap;gap:1rem">
  <h2>MEMBER <span>MANAGEMENT</span></h2>
  <button class="mbr-add-btn" onclick="mbrOpenModal()"><i class="bi bi-person-plus-fill"></i> Add Member</button>
</div>
<div class="mbr-stats" id="mbrStats"></div>
<div class="mbr-filters">
  <div class="mbr-search-wrap"><i class="bi bi-search"></i><input type="text" class="mbr-search" id="mbrSearch" placeholder="Search by name, email, ID…"></div>
  <select class="mbr-select" id="mbrStatusFilter"><option value="">All Statuses</option><option value="ACTIVE">Active</option><option value="INACTIVE">Inactive</option><option value="EXPIRED">Expired</option></select>
  <select class="mbr-select" id="mbrPlanFilter"><option value="">All Types</option><option value="STANDARD">Standard</option><option value="PREMIUM">Premium</option><option value="BASIC">Basic</option><option value="TRIAL">Trial</option></select>
</div>
<div class="mbr-tbl-wrap">
  <div class="mbr-tbl-hdr"><div class="mbr-tbl-title"><i class="bi bi-people-fill"></i> Members Registry</div><span class="mbr-tbl-badge" id="mbrCount">0 member(s)</span></div>
  <div style="overflow-x:auto"><table class="mbr-tbl"><thead><tr><th>ID</th><th>Name</th><th>Email</th><th>Phone</th><th>Plan</th><th>Join Date</th><th>Type</th><th>Status</th><th style="text-align:center">Actions</th></tr></thead><tbody id="mbrBody"></tbody></table></div>
</div>

<div class="mbr-modal-bg" id="mbrModal"><div class="mbr-modal">
  <h2><i class="bi bi-person-plus-fill" style="color:var(--accent)"></i> <span id="mbrModalTitle">ADD MEMBER</span></h2>
  <input type="hidden" id="mbrEditIdx" value="-1">
  <div class="mbr-field-row">
    <div class="mbr-field"><label>Member ID</label><input type="text" id="mbrId" placeholder="e.g. M001"></div>
    <div class="mbr-field"><label>Full Name</label><input type="text" id="mbrName" placeholder="e.g. John Doe"></div>
  </div>
  <div class="mbr-field-row">
    <div class="mbr-field"><label>Email</label><input type="email" id="mbrEmail" placeholder="e.g. john@mail.com"></div>
    <div class="mbr-field"><label>Phone</label><input type="text" id="mbrPhone" placeholder="e.g. 0771234567"></div>
  </div>
  <div class="mbr-field-row">
    <div class="mbr-field"><label>Plan Name</label><input type="text" id="mbrPlan" placeholder="e.g. Standard Monthly"></div>
    <div class="mbr-field"><label>Join Date</label><input type="date" id="mbrDate"></div>
  </div>
  <div class="mbr-field-row">
    <div class="mbr-field"><label>Type</label><select id="mbrType"><option value="STANDARD">Standard</option><option value="PREMIUM">Premium</option><option value="BASIC">Basic</option><option value="TRIAL">Trial</option></select></div>
    <div class="mbr-field"><label>Status</label><select id="mbrStatus"><option value="ACTIVE">Active</option><option value="INACTIVE">Inactive</option><option value="EXPIRED">Expired</option></select></div>
  </div>
  <button class="mbr-submit" onclick="mbrSave()"><i class="bi bi-check-circle-fill"></i> Save Member</button>
  <button class="mbr-cancel" onclick="mbrCloseModal()">Cancel</button>
</div></div>

<div class="mbr-del-modal-bg" id="mbrDelModal"><div class="mbr-del-modal">
  <div style="font-size:2.5rem;color:#f87171;margin-bottom:.8rem"><i class="bi bi-exclamation-triangle-fill"></i></div>
  <h3 style="font-family:var(--font-display);font-size:1.3rem;letter-spacing:2px;margin-bottom:.5rem">DELETE MEMBER</h3>
  <p style="color:var(--gray);font-size:.82rem;margin-bottom:1.5rem">Remove <strong id="mbrDelName" style="color:#fff"></strong>? This cannot be undone.</p>
  <div style="display:flex;gap:.8rem;justify-content:center">
    <button onclick="mbrCloseDelModal()" style="padding:.5rem 1.2rem;border-radius:8px;border:1px solid var(--border);background:none;color:var(--gray);cursor:pointer">Cancel</button>
    <button onclick="mbrConfirmDel()" style="padding:.5rem 1.2rem;border-radius:8px;border:none;background:#f87171;color:#000;font-weight:700;cursor:pointer"><i class="bi bi-trash3"></i> Delete</button>
  </div>
</div></div>

<script>
var MBR_KEY='fcms_members';
var MBR_DEFAULT=[
  {id:'M001',name:'John Doe',email:'john.doe@mail.com',phone:'0771234567',plan:'Standard Monthly',date:'2025-01-15',type:'STANDARD',status:'ACTIVE'},
  {id:'M002',name:'Sarah Perera',email:'sarah.perera@gmail.com',phone:'0779876543',plan:'Premium Monthly',date:'2025-02-01',type:'PREMIUM',status:'ACTIVE'},
  {id:'M003',name:'Kasun Silva',email:'kasun.silva@gmail.com',phone:'0701122334',plan:'Basic Monthly',date:'2025-03-10',type:'BASIC',status:'ACTIVE'},
  {id:'M004',name:'Nimasha Fernando',email:'nimasha@mail.com',phone:'0762233445',plan:'Standard Monthly',date:'2025-04-05',type:'STANDARD',status:'INACTIVE'},
  {id:'M005',name:'Lakshan Wijesinghe',email:'lakshan@mail.com',phone:'0753344556',plan:'Premium Monthly',date:'2025-04-20',type:'PREMIUM',status:'ACTIVE'},
  {id:'M006',name:'Dinesh Rajapakse',email:'dinesh.r@mail.com',phone:'0741122339',plan:'7-Day Free Trial',date:'2026-04-22',type:'TRIAL',status:'ACTIVE'},
  {id:'M007',name:'Priya Jayasuriya',email:'priya.j@mail.com',phone:'0782233448',plan:'Standard Monthly',date:'2026-04-22',type:'STANDARD',status:'ACTIVE'}
];
var mbrDelIdx=-1;
function mbrGetAll(){try{return JSON.parse(localStorage.getItem(MBR_KEY))||[];}catch(e){return[];}}
function mbrSaveAll(a){localStorage.setItem(MBR_KEY,JSON.stringify(a));}
function mbrTypeClass(t){t=(t||'').toUpperCase();if(t==='PREMIUM')return'premium';if(t==='BASIC')return'basic';if(t==='TRIAL')return'trial';return'standard';}
function mbrStatusClass(s){s=(s||'').toUpperCase();if(s==='ACTIVE')return'active';if(s==='EXPIRED')return'expired';return'inactive';}
function mbrRenderStats(){
  var all=mbrGetAll(),ac=0,pr=0,tr=0;
  all.forEach(function(m){if(m.status==='ACTIVE')ac++;if(m.type==='PREMIUM')pr++;if(m.type==='TRIAL')tr++;});
  document.getElementById('mbrStats').innerHTML='<div class="mbr-stat"><div class="mbr-stat-val">'+all.length+'</div><div class="mbr-stat-lbl">Total Members</div></div><div class="mbr-stat"><div class="mbr-stat-val" style="color:#34d399">'+ac+'</div><div class="mbr-stat-lbl">Active</div></div><div class="mbr-stat"><div class="mbr-stat-val" style="color:#fbbf24">'+pr+'</div><div class="mbr-stat-lbl">Premium</div></div><div class="mbr-stat"><div class="mbr-stat-val" style="color:#a78bfa">'+tr+'</div><div class="mbr-stat-lbl">Trial</div></div>';
  document.getElementById('mbrCount').textContent=all.length+' member(s)';
}
function mbrRender(){
  var all=mbrGetAll(),q=(document.getElementById('mbrSearch').value||'').toLowerCase(),sf=document.getElementById('mbrStatusFilter').value,pf=document.getElementById('mbrPlanFilter').value;
  var filtered=all.filter(function(m){
    var text=(m.id+m.name+m.email+m.phone+m.plan).toLowerCase();
    return(!q||text.indexOf(q)>=0)&&(!sf||m.status===sf)&&(!pf||m.type===pf);
  });
  if(!filtered.length){document.getElementById('mbrBody').innerHTML='<tr><td colspan="9"><div class="mbr-empty"><i class="bi bi-inbox"></i><div style="font-size:1rem;font-weight:600;margin-bottom:.3rem">No Members Found</div><div style="font-size:.8rem">Click "Add Member" to add your first member</div></div></td></tr>';return;}
  var html='';
  filtered.forEach(function(m,fi){
    var oi=all.indexOf(m);
    html+='<tr style="animation:fadeIn .3s ease '+(fi*0.03)+'s both">';
    html+='<td><span class="mbr-id">'+m.id+'</span></td>';
    html+='<td><div class="mbr-name-cell"><div class="mbr-av">'+(m.name||'?').charAt(0)+'</div><span style="font-weight:600;font-size:.8rem">'+m.name+'</span></div></td>';
    html+='<td style="color:var(--gray);font-size:.76rem">'+m.email+'</td>';
    html+='<td style="font-size:.76rem">'+m.phone+'</td>';
    html+='<td><span class="mbr-badge mbr-badge-'+mbrTypeClass(m.type)+'">'+m.plan+'</span></td>';
    html+='<td style="font-size:.74rem;color:var(--gray)">'+m.date+'</td>';
    var tc=mbrTypeClass(m.type),tIcon=tc==='premium'?'gem':tc==='trial'?'clock':'shield-check';
    html+='<td><span class="mbr-badge mbr-badge-'+tc+'"><i class="bi bi-'+tIcon+'" style="font-size:.45rem"></i> '+m.type+'</span></td>';
    var sc=mbrStatusClass(m.status);
    html+='<td><span class="mbr-badge mbr-badge-'+sc+'"><i class="bi bi-circle-fill" style="font-size:.3rem"></i> '+m.status+'</span></td>';
    html+='<td><div class="mbr-acts"><button onclick="mbrEdit('+oi+')"><i class="bi bi-pencil"></i></button><button class="mbr-del-btn" onclick="mbrOpenDel('+oi+')"><i class="bi bi-trash3"></i></button></div></td>';
    html+='</tr>';
  });
  document.getElementById('mbrBody').innerHTML=html;
}
function mbrOpenModal(){document.getElementById('mbrEditIdx').value='-1';document.getElementById('mbrModalTitle').textContent='ADD MEMBER';['mbrId','mbrName','mbrEmail','mbrPhone','mbrPlan','mbrDate'].forEach(function(id){document.getElementById(id).value='';});document.getElementById('mbrType').value='STANDARD';document.getElementById('mbrStatus').value='ACTIVE';document.getElementById('mbrModal').classList.add('open');}
function mbrCloseModal(){document.getElementById('mbrModal').classList.remove('open');}
function mbrEdit(i){var m=mbrGetAll()[i];if(!m)return;document.getElementById('mbrEditIdx').value=i;document.getElementById('mbrModalTitle').textContent='EDIT MEMBER';document.getElementById('mbrId').value=m.id||'';document.getElementById('mbrName').value=m.name||'';document.getElementById('mbrEmail').value=m.email||'';document.getElementById('mbrPhone').value=m.phone||'';document.getElementById('mbrPlan').value=m.plan||'';document.getElementById('mbrDate').value=m.date||'';document.getElementById('mbrType').value=m.type||'STANDARD';document.getElementById('mbrStatus').value=m.status||'ACTIVE';document.getElementById('mbrModal').classList.add('open');}
function mbrSave(){var n=document.getElementById('mbrName').value.trim();if(!n){alert('Please enter a name.');return;}var o={id:document.getElementById('mbrId').value.trim()||('M'+(Date.now()%10000)),name:n,email:document.getElementById('mbrEmail').value.trim(),phone:document.getElementById('mbrPhone').value.trim(),plan:document.getElementById('mbrPlan').value.trim()||'Standard Monthly',date:document.getElementById('mbrDate').value||new Date().toISOString().slice(0,10),type:document.getElementById('mbrType').value,status:document.getElementById('mbrStatus').value};var all=mbrGetAll(),idx=parseInt(document.getElementById('mbrEditIdx').value);if(idx>=0&&idx<all.length)all[idx]=o;else all.push(o);mbrSaveAll(all);mbrCloseModal();mbrRenderStats();mbrRender();}
function mbrOpenDel(i){mbrDelIdx=i;document.getElementById('mbrDelName').textContent=(mbrGetAll()[i]||{}).name||'';document.getElementById('mbrDelModal').classList.add('open');}
function mbrCloseDelModal(){document.getElementById('mbrDelModal').classList.remove('open');mbrDelIdx=-1;}
function mbrConfirmDel(){if(mbrDelIdx<0)return;var a=mbrGetAll();a.splice(mbrDelIdx,1);mbrSaveAll(a);mbrCloseDelModal();mbrRenderStats();mbrRender();}
document.addEventListener('DOMContentLoaded',function(){if(!localStorage.getItem(MBR_KEY))mbrSaveAll(MBR_DEFAULT);mbrRenderStats();mbrRender();document.getElementById('mbrSearch').addEventListener('input',mbrRender);document.getElementById('mbrStatusFilter').addEventListener('change',mbrRender);document.getElementById('mbrPlanFilter').addEventListener('change',mbrRender);});
</script>
</div>

<!-- SECTION: Membership Plans -->
<div class="dash-section" id="sec-plans">
<style>
.pln-grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(300px,1fr));gap:1.25rem}
.pln-card{background:var(--card);border:1px solid var(--border);border-radius:14px;overflow:hidden;transition:all .25s}.pln-card:hover{border-color:rgba(var(--accent-rgb),.3);transform:translateY(-2px)}
.pln-card-head{padding:1.3rem 1.2rem;text-align:center;border-bottom:1px solid var(--border);position:relative}.pln-card-head::before{content:'';position:absolute;top:0;left:0;right:0;height:3px}
.pln-card-head.free::before{background:linear-gradient(90deg,#6b7280,#9ca3af)}.pln-card-head.basic::before{background:linear-gradient(90deg,#60a5fa,#3b82f6)}.pln-card-head.standard::before{background:linear-gradient(90deg,var(--accent),#a3e635)}.pln-card-head.premium::before{background:linear-gradient(90deg,#fbbf24,#f59e0b)}
.pln-icon{width:44px;height:44px;border-radius:10px;display:inline-flex;align-items:center;justify-content:center;font-size:1.2rem;margin-bottom:.5rem;border:1px solid var(--border)}
.pln-card-head.free .pln-icon{background:rgba(107,114,128,.1);color:#9ca3af}.pln-card-head.basic .pln-icon{background:rgba(96,165,250,.1);color:#60a5fa}.pln-card-head.standard .pln-icon{background:rgba(var(--accent-rgb),.1);color:var(--accent)}.pln-card-head.premium .pln-icon{background:rgba(251,191,36,.1);color:#fbbf24}
.pln-name{font-family:var(--font-display);font-size:1.2rem;letter-spacing:3px}.pln-price{font-family:var(--font-display);font-size:1.8rem;margin:.15rem 0}.pln-price small{font-family:var(--font-body);font-size:.65rem;color:var(--gray);letter-spacing:0;font-weight:400}.pln-dur{font-size:.68rem;color:var(--gray)}
.pln-body{padding:1rem 1.2rem}
.pln-access{display:inline-flex;align-items:center;gap:.3rem;padding:.18rem .5rem;border-radius:20px;font-size:.58rem;font-weight:700;letter-spacing:1px;text-transform:uppercase;margin-bottom:.7rem}
.pln-access.unlimited{background:rgba(52,211,153,.1);color:#34d399;border:1px solid rgba(52,211,153,.2)}.pln-access.limited{background:rgba(251,191,36,.1);color:#fbbf24;border:1px solid rgba(251,191,36,.2)}
.pln-feat{display:flex;align-items:center;gap:.4rem;padding:.3rem 0;font-size:.75rem;color:rgba(255,255,255,.7)}.pln-feat i{color:var(--accent);font-size:.65rem}
.pln-foot{display:flex;align-items:center;justify-content:space-between;padding:.7rem 1.2rem;border-top:1px solid var(--border);background:rgba(255,255,255,.015)}
.pln-members{display:flex;align-items:center;gap:.4rem;font-size:.72rem;color:var(--gray)}.pln-members i{color:var(--accent)}
.pln-actions{display:flex;gap:.4rem}
.pln-actions button{background:none;border:1px solid var(--border);border-radius:6px;color:var(--gray);font-size:.68rem;padding:.3rem .55rem;cursor:pointer;transition:all .2s;display:flex;align-items:center;gap:.2rem}
.pln-actions button:hover{border-color:var(--accent);color:var(--accent)}.pln-actions .pln-del:hover{border-color:#f87171;color:#f87171}
.pln-stats{display:grid;grid-template-columns:repeat(4,1fr);gap:1rem;margin-bottom:1.5rem}
.pln-stat{background:var(--card);border:1px solid var(--border);border-radius:12px;padding:1rem;text-align:center;position:relative;overflow:hidden}
.pln-stat::after{content:'';position:absolute;top:0;left:0;right:0;height:2px;background:linear-gradient(90deg,transparent,var(--accent),transparent);opacity:.2}
.pln-stat-val{font-family:var(--font-display);font-size:1.6rem;color:var(--accent)}.pln-stat-lbl{font-size:.6rem;color:var(--gray);text-transform:uppercase;letter-spacing:1.5px;margin-top:.1rem}
.pln-add-btn{display:flex;align-items:center;gap:.4rem;padding:.6rem 1.2rem;border-radius:10px;border:none;background:var(--accent);color:#000;font-size:.8rem;font-weight:700;cursor:pointer;transition:all .2s;letter-spacing:.3px}.pln-add-btn:hover{box-shadow:0 4px 20px rgba(200,240,61,.3);transform:scale(1.03)}
.pln-modal-bg{position:fixed;inset:0;background:rgba(0,0,0,.7);z-index:9000;display:none;align-items:center;justify-content:center;backdrop-filter:blur(6px)}.pln-modal-bg.open{display:flex}
.pln-modal{background:#111;border:1px solid var(--border);border-radius:18px;width:540px;max-width:94vw;max-height:90vh;overflow-y:auto;padding:2rem;animation:fadeIn .3s ease}
.pln-modal h2{font-family:var(--font-display);font-size:1.5rem;letter-spacing:2px;margin-bottom:1.2rem;display:flex;align-items:center;gap:.5rem}.pln-modal h2 span{color:var(--accent)}
.pln-field{margin-bottom:1rem}.pln-field label{display:block;font-size:.72rem;font-weight:700;letter-spacing:1px;text-transform:uppercase;color:var(--gray);margin-bottom:.35rem}
.pln-field input,.pln-field select{width:100%;padding:.6rem .8rem;border-radius:8px;border:1px solid var(--border);background:rgba(255,255,255,.04);color:#fff;font-size:.82rem;font-family:inherit;outline:none}.pln-field input:focus,.pln-field select:focus{border-color:rgba(var(--accent-rgb),.4)}
.pln-field-row{display:grid;grid-template-columns:1fr 1fr;gap:.8rem}
.pln-submit{width:100%;padding:.7rem;border-radius:10px;border:none;background:var(--accent);color:#000;font-size:.82rem;font-weight:800;cursor:pointer;margin-top:.5rem}.pln-submit:hover{box-shadow:0 4px 20px rgba(200,240,61,.3)}
.pln-cancel{width:100%;padding:.55rem;border-radius:8px;border:1px solid var(--border);background:none;color:var(--gray);font-size:.75rem;cursor:pointer;margin-top:.5rem}.pln-cancel:hover{border-color:#f87171;color:#f87171}
.pln-del-modal-bg{position:fixed;inset:0;background:rgba(0,0,0,.7);z-index:9100;display:none;align-items:center;justify-content:center;backdrop-filter:blur(6px)}.pln-del-modal-bg.open{display:flex}
.pln-del-modal{background:#111;border:1px solid var(--border);border-radius:18px;width:420px;max-width:94vw;padding:2rem;text-align:center;animation:fadeIn .3s ease}
.pln-del-modal h3{font-family:var(--font-display);font-size:1.3rem;letter-spacing:2px;margin-bottom:.5rem}
.pln-del-modal p{color:var(--gray);font-size:.82rem;margin-bottom:1.5rem}.pln-del-modal p strong{color:#fff}
.pln-empty{text-align:center;padding:3rem;color:var(--gray);grid-column:1/-1}.pln-empty i{font-size:2.5rem;display:block;margin-bottom:.8rem;opacity:.25}
@media(max-width:768px){.pln-stats{grid-template-columns:repeat(2,1fr)}.pln-grid{grid-template-columns:1fr}}
</style>

<div class="sec-header" style="display:flex;align-items:center;justify-content:space-between;flex-wrap:wrap;gap:1rem">
  <h2>MEMBERSHIP <span>PLANS</span></h2>
  <button class="pln-add-btn" onclick="plnOpenModal()"><i class="bi bi-plus-circle-fill"></i> Add New Plan</button>
</div>
<div class="pln-stats" id="plnStats"></div>
<div class="pln-grid" id="plnGrid"></div>

<div class="pln-modal-bg" id="plnModal"><div class="pln-modal">
  <h2><i class="bi bi-card-checklist" style="color:var(--accent)"></i> <span id="plnModalTitle">ADD PLAN</span></h2>
  <input type="hidden" id="plnEditIdx" value="-1">
  <div class="pln-field"><label>Plan Name</label><input type="text" id="plnName" placeholder="e.g. Premium Monthly"></div>
  <div class="pln-field-row">
    <div class="pln-field"><label>Price (Rs.)</label><input type="number" id="plnPrice" placeholder="e.g. 5000" min="0"></div>
    <div class="pln-field"><label>Duration (Days)</label><input type="number" id="plnDuration" placeholder="e.g. 30" min="1"></div>
  </div>
  <div class="pln-field-row">
    <div class="pln-field"><label>Class Access</label><select id="plnAccess"><option value="LIMITED">LIMITED</option><option value="UNLIMITED">UNLIMITED</option></select></div>
    <div class="pln-field"><label>Members Enrolled</label><input type="number" id="plnMembers" placeholder="e.g. 5" min="0"></div>
  </div>
  <div class="pln-field"><label>Features (pipe-separated)</label><input type="text" id="plnFeatures" placeholder="e.g. Gym Access|Locker|Shower|Sauna"></div>
  <button class="pln-submit" onclick="plnSave()"><i class="bi bi-check-circle-fill"></i> Save Plan</button>
  <button class="pln-cancel" onclick="plnCloseModal()">Cancel</button>
</div></div>

<div class="pln-del-modal-bg" id="plnDelModal"><div class="pln-del-modal">
  <div style="font-size:2.5rem;color:#f87171;margin-bottom:.8rem"><i class="bi bi-exclamation-triangle-fill"></i></div>
  <h3>DELETE PLAN</h3>
  <p>Remove <strong id="plnDelName"></strong>? This cannot be undone.</p>
  <div style="display:flex;gap:.8rem;justify-content:center">
    <button onclick="plnCloseDelModal()" style="padding:.5rem 1.2rem;border-radius:8px;border:1px solid var(--border);background:none;color:var(--gray);cursor:pointer">Cancel</button>
    <button onclick="plnConfirmDel()" style="padding:.5rem 1.2rem;border-radius:8px;border:none;background:#f87171;color:#000;font-weight:700;cursor:pointer"><i class="bi bi-trash3"></i> Delete</button>
  </div>
</div></div>

<script>
var PLN_KEY='fcms_plans';
var PLN_DEFAULT=[
  {name:'Free Trial',price:0,duration:7,access:'LIMITED',features:'Gym Access|Locker',members:5},
  {name:'Basic Monthly',price:2500,duration:30,access:'LIMITED',features:'Gym Access|Locker|Shower',members:1},
  {name:'Standard Monthly',price:4500,duration:30,access:'UNLIMITED',features:'Gym Access|Locker|Shower|Group Classes|Sauna',members:3},
  {name:'Premium Monthly',price:7500,duration:30,access:'UNLIMITED',features:'Gym Access|Locker|Shower|All Classes|Sauna|Personal Trainer|Nutrition Advice',members:2}
];
var plnDelIdx=-1;
function plnGetAll(){try{return JSON.parse(localStorage.getItem(PLN_KEY))||[];}catch(e){return[];}}
function plnSaveAll(a){localStorage.setItem(PLN_KEY,JSON.stringify(a));}
function plnTierClass(n){n=(n||'').toLowerCase();if(n.indexOf('free')>=0||n.indexOf('trial')>=0)return'free';if(n.indexOf('basic')>=0)return'basic';if(n.indexOf('premium')>=0||n.indexOf('gold')>=0||n.indexOf('vip')>=0)return'premium';return'standard';}
function plnTierIcon(t){return t==='free'?'gift':t==='basic'?'star':t==='premium'?'gem':'award';}
function plnRenderStats(){
  var all=plnGetAll(),totalMem=0,maxP=0;
  all.forEach(function(p){totalMem+=(p.members||0);if((p.price||0)>maxP)maxP=p.price;});
  document.getElementById('plnStats').innerHTML='<div class="pln-stat"><div class="pln-stat-val">'+all.length+'</div><div class="pln-stat-lbl">Total Plans</div></div><div class="pln-stat"><div class="pln-stat-val" style="color:#60a5fa">'+totalMem+'</div><div class="pln-stat-lbl">Total Enrolled</div></div><div class="pln-stat"><div class="pln-stat-val" style="color:#34d399">Rs.'+maxP.toLocaleString()+'</div><div class="pln-stat-lbl">Highest Plan</div></div><div class="pln-stat"><div class="pln-stat-val" style="color:#a78bfa">'+all.length+'</div><div class="pln-stat-lbl">Active Tiers</div></div>';
}
function plnRender(list){
  if(!list.length){document.getElementById('plnGrid').innerHTML='<div class="pln-empty"><i class="bi bi-card-list"></i><div style="font-size:1rem;font-weight:600;margin-bottom:.3rem">No Plans Yet</div><div>Click "Add New Plan" to create your first plan</div></div>';return;}
  var html='';
  list.forEach(function(p,i){
    var tc=plnTierClass(p.name),feats=(p.features||'').split('|').filter(Boolean);
    html+='<div class="pln-card" style="animation:fadeIn .4s ease '+(i*0.06)+'s both"><div class="pln-card-head '+tc+'"><div class="pln-icon"><i class="bi bi-'+plnTierIcon(tc)+'"></i></div><div class="pln-name">'+p.name+'</div><div class="pln-price">Rs.'+((p.price||0).toLocaleString())+' <small>/month</small></div><div class="pln-dur">'+(p.duration||30)+' days</div></div>';
    html+='<div class="pln-body"><div class="pln-access '+(p.access==='UNLIMITED'?'unlimited':'limited')+'"><i class="bi bi-'+(p.access==='UNLIMITED'?'infinity':'dash-circle')+'"></i> '+(p.access||'LIMITED')+' Classes</div>';
    feats.forEach(function(f){html+='<div class="pln-feat"><i class="bi bi-check-circle-fill"></i> '+f.trim()+'</div>';});
    html+='</div><div class="pln-foot"><div class="pln-members"><i class="bi bi-people-fill"></i> <strong>'+(p.members||0)+'</strong>&nbsp;member(s)</div><div class="pln-actions"><button onclick="plnEdit('+i+')"><i class="bi bi-pencil"></i> Edit</button><button class="pln-del" onclick="plnOpenDel('+i+')"><i class="bi bi-trash3"></i></button></div></div></div>';
  });
  document.getElementById('plnGrid').innerHTML=html;
}
function plnOpenModal(){document.getElementById('plnEditIdx').value='-1';document.getElementById('plnModalTitle').textContent='ADD PLAN';['plnName','plnPrice','plnDuration','plnFeatures','plnMembers'].forEach(function(id){document.getElementById(id).value='';});document.getElementById('plnAccess').value='LIMITED';document.getElementById('plnModal').classList.add('open');}
function plnCloseModal(){document.getElementById('plnModal').classList.remove('open');}
function plnEdit(i){var p=plnGetAll()[i];if(!p)return;document.getElementById('plnEditIdx').value=i;document.getElementById('plnModalTitle').textContent='EDIT PLAN';document.getElementById('plnName').value=p.name||'';document.getElementById('plnPrice').value=p.price||0;document.getElementById('plnDuration').value=p.duration||30;document.getElementById('plnAccess').value=p.access||'LIMITED';document.getElementById('plnFeatures').value=p.features||'';document.getElementById('plnMembers').value=p.members||0;document.getElementById('plnModal').classList.add('open');}
function plnSave(){var n=document.getElementById('plnName').value.trim();if(!n){alert('Please enter a plan name.');return;}var o={name:n,price:parseFloat(document.getElementById('plnPrice').value)||0,duration:parseInt(document.getElementById('plnDuration').value)||30,access:document.getElementById('plnAccess').value,features:document.getElementById('plnFeatures').value.trim(),members:parseInt(document.getElementById('plnMembers').value)||0};var all=plnGetAll(),idx=parseInt(document.getElementById('plnEditIdx').value);if(idx>=0&&idx<all.length)all[idx]=o;else all.push(o);plnSaveAll(all);plnCloseModal();plnRenderStats();plnRender(plnGetAll());}
function plnOpenDel(i){plnDelIdx=i;document.getElementById('plnDelName').textContent=(plnGetAll()[i]||{}).name||'';document.getElementById('plnDelModal').classList.add('open');}
function plnCloseDelModal(){document.getElementById('plnDelModal').classList.remove('open');plnDelIdx=-1;}
function plnConfirmDel(){if(plnDelIdx<0)return;var a=plnGetAll();a.splice(plnDelIdx,1);plnSaveAll(a);plnCloseDelModal();plnRenderStats();plnRender(plnGetAll());}
document.addEventListener('DOMContentLoaded',function(){if(!localStorage.getItem(PLN_KEY))plnSaveAll(PLN_DEFAULT);plnRenderStats();plnRender(plnGetAll());});
</script>
</div>

<!-- SECTION: Nutrition / Meal Plans -->
<div class="dash-section" id="sec-nutrition">
<style>
.nut-stats{display:grid;grid-template-columns:repeat(4,1fr);gap:1rem;margin-bottom:1.5rem}
.nut-stat{background:var(--card);border:1px solid var(--border);border-radius:12px;padding:1rem;text-align:center;position:relative;overflow:hidden}
.nut-stat::after{content:'';position:absolute;top:0;left:0;right:0;height:2px;background:linear-gradient(90deg,transparent,var(--accent),transparent);opacity:.2}
.nut-stat-val{font-family:var(--font-display);font-size:1.6rem;color:var(--accent)}.nut-stat-lbl{font-size:.6rem;color:var(--gray);text-transform:uppercase;letter-spacing:1.5px;margin-top:.1rem}
.nut-filters{display:flex;gap:.6rem;align-items:center;flex-wrap:wrap;margin-bottom:1.2rem}
.nut-search-wrap{flex:1;min-width:220px;position:relative}.nut-search-wrap i{position:absolute;left:.8rem;top:50%;transform:translateY(-50%);color:var(--gray);font-size:.85rem}
.nut-search{width:100%;padding:.55rem .8rem .55rem 2.2rem;border-radius:10px;border:1px solid var(--border);background:rgba(255,255,255,.04);color:#fff;font-size:.8rem;font-family:var(--font-body);outline:none}.nut-search:focus{border-color:rgba(var(--accent-rgb),.4)}
.nut-select{padding:.5rem .8rem;border-radius:10px;border:1px solid var(--border);background:var(--card);color:#fff;font-size:.76rem;font-family:var(--font-body);outline:none;cursor:pointer;min-width:130px}.nut-select:focus{border-color:rgba(var(--accent-rgb),.4)}
.nut-grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(320px,1fr));gap:1.2rem}
.nut-card{background:var(--card);border:1px solid var(--border);border-radius:14px;overflow:hidden;transition:all .25s}.nut-card:hover{border-color:rgba(var(--accent-rgb),.3);transform:translateY(-2px)}
.nut-card-top{padding:1.2rem;border-bottom:1px solid var(--border);position:relative}
.nut-card-top::before{content:'';position:absolute;top:0;left:0;right:0;height:3px}
.nut-card-top.bulking::before{background:linear-gradient(90deg,#fbbf24,#f59e0b)}
.nut-card-top.cutting::before{background:linear-gradient(90deg,#f87171,#ef4444)}
.nut-card-top.maintenance::before{background:linear-gradient(90deg,var(--accent),#a3e635)}
.nut-card-top.vegan::before{background:linear-gradient(90deg,#34d399,#10b981)}
.nut-card-top.keto::before{background:linear-gradient(90deg,#a78bfa,#8b5cf6)}
.nut-card-top.general::before{background:linear-gradient(90deg,#60a5fa,#3b82f6)}
.nut-card-name{font-family:var(--font-display);font-size:1.1rem;letter-spacing:1px;margin-bottom:.3rem}
.nut-card-desc{font-size:.72rem;color:var(--gray);line-height:1.4}
.nut-card-type{display:inline-flex;align-items:center;gap:.2rem;padding:.12rem .45rem;border-radius:20px;font-size:.55rem;font-weight:700;letter-spacing:.5px;text-transform:uppercase;border:1px solid;margin-top:.5rem}
.nut-type-bulking{background:rgba(251,191,36,.08);color:#fbbf24;border-color:rgba(251,191,36,.2)}
.nut-type-cutting{background:rgba(248,113,113,.08);color:#f87171;border-color:rgba(248,113,113,.2)}
.nut-type-maintenance{background:rgba(var(--accent-rgb),.08);color:var(--accent);border-color:rgba(var(--accent-rgb),.2)}
.nut-type-vegan{background:rgba(52,211,153,.08);color:#34d399;border-color:rgba(52,211,153,.2)}
.nut-type-keto{background:rgba(167,139,250,.08);color:#a78bfa;border-color:rgba(167,139,250,.2)}
.nut-type-general{background:rgba(96,165,250,.08);color:#60a5fa;border-color:rgba(96,165,250,.2)}
.nut-card-body{padding:1rem 1.2rem}
.nut-macros{display:grid;grid-template-columns:repeat(3,1fr);gap:.6rem;margin-bottom:.8rem}
.nut-macro{background:rgba(255,255,255,.03);border-radius:8px;padding:.5rem;text-align:center}.nut-macro-val{font-family:var(--font-display);font-size:.95rem;color:var(--accent)}.nut-macro-lbl{font-size:.55rem;color:var(--gray);text-transform:uppercase;letter-spacing:1px}
.nut-meals{border-top:1px solid var(--border);padding-top:.7rem}
.nut-meal{display:flex;align-items:center;gap:.5rem;padding:.3rem 0;font-size:.72rem}
.nut-meal-dot{width:6px;height:6px;border-radius:50%;background:var(--accent);flex-shrink:0}
.nut-meal-name{font-weight:600}.nut-meal-cal{margin-left:auto;color:var(--gray);font-size:.65rem}
.nut-card-foot{display:flex;align-items:center;justify-content:space-between;padding:.7rem 1.2rem;border-top:1px solid var(--border)}
.nut-card-cal{font-size:.7rem;color:var(--gray)}.nut-card-cal strong{color:var(--accent);font-family:var(--font-display);font-size:.9rem}
.nut-card-acts{display:flex;gap:.3rem}
.nut-card-acts button{background:none;border:1px solid var(--border);border-radius:6px;color:var(--gray);font-size:.65rem;padding:.22rem .45rem;cursor:pointer;transition:all .2s;display:flex;align-items:center;gap:.15rem}
.nut-card-acts button:hover{border-color:var(--accent);color:var(--accent)}.nut-card-acts .nut-del:hover{border-color:#f87171;color:#f87171}
.nut-add-btn{display:flex;align-items:center;gap:.4rem;padding:.55rem 1rem;border-radius:10px;border:none;background:var(--accent);color:#000;font-size:.78rem;font-weight:700;cursor:pointer;transition:all .2s;letter-spacing:.3px}.nut-add-btn:hover{box-shadow:0 4px 20px rgba(200,240,61,.3);transform:scale(1.03)}
.nut-modal-bg{position:fixed;inset:0;background:rgba(0,0,0,.7);z-index:9000;display:none;align-items:center;justify-content:center;backdrop-filter:blur(6px)}.nut-modal-bg.open{display:flex}
.nut-modal{background:#111;border:1px solid var(--border);border-radius:18px;width:600px;max-width:94vw;max-height:90vh;overflow-y:auto;padding:2rem;animation:fadeIn .3s ease}
.nut-modal h2{font-family:var(--font-display);font-size:1.4rem;letter-spacing:2px;margin-bottom:1.2rem;display:flex;align-items:center;gap:.5rem}.nut-modal h2 span{color:var(--accent)}
.nut-field{margin-bottom:.8rem}.nut-field label{display:block;font-size:.68rem;font-weight:700;letter-spacing:1px;text-transform:uppercase;color:var(--gray);margin-bottom:.3rem}
.nut-field input,.nut-field select,.nut-field textarea{width:100%;padding:.55rem .8rem;border-radius:8px;border:1px solid var(--border);background:rgba(255,255,255,.04);color:#fff;font-size:.8rem;font-family:inherit;outline:none}.nut-field input:focus,.nut-field select:focus,.nut-field textarea:focus{border-color:rgba(var(--accent-rgb),.4)}
.nut-field textarea{resize:vertical;min-height:60px}
.nut-field-row{display:grid;grid-template-columns:1fr 1fr;gap:.8rem}
.nut-field-row3{display:grid;grid-template-columns:1fr 1fr 1fr;gap:.8rem}
.nut-submit{width:100%;padding:.65rem;border-radius:10px;border:none;background:var(--accent);color:#000;font-size:.8rem;font-weight:800;cursor:pointer;margin-top:.5rem}.nut-submit:hover{box-shadow:0 4px 20px rgba(200,240,61,.3)}
.nut-cancel{width:100%;padding:.5rem;border-radius:8px;border:1px solid var(--border);background:none;color:var(--gray);font-size:.72rem;cursor:pointer;margin-top:.5rem}.nut-cancel:hover{border-color:#f87171;color:#f87171}
.nut-del-modal-bg{position:fixed;inset:0;background:rgba(0,0,0,.7);z-index:9100;display:none;align-items:center;justify-content:center;backdrop-filter:blur(6px)}.nut-del-modal-bg.open{display:flex}
.nut-del-modal{background:#111;border:1px solid var(--border);border-radius:18px;width:420px;max-width:94vw;padding:2rem;text-align:center;animation:fadeIn .3s ease}
.nut-empty{text-align:center;padding:3rem;color:var(--gray)}.nut-empty i{font-size:2.5rem;display:block;margin-bottom:.8rem;opacity:.25}
@media(max-width:768px){.nut-stats{grid-template-columns:repeat(2,1fr)}.nut-grid{grid-template-columns:1fr}}
</style>

<div class="sec-header" style="display:flex;align-items:center;justify-content:space-between;flex-wrap:wrap;gap:1rem">
  <div><h2>NUTRITION <span>& MEAL PLANS</span></h2><p style="color:var(--gray);font-size:.75rem;margin:.2rem 0 0"><i class="bi bi-info-circle"></i> Manage meal plans that appear on the landing page Nutrition section</p></div>
  <button class="nut-add-btn" onclick="nutOpenModal()"><i class="bi bi-plus-circle-fill"></i> Add Meal Plan</button>
</div>
<div class="nut-stats" id="nutStats"></div>
<div class="nut-filters">
  <div class="nut-search-wrap"><i class="bi bi-search"></i><input type="text" class="nut-search" id="nutSearch" placeholder="Search meal plans…"></div>
  <select class="nut-select" id="nutTypeFilter"><option value="">All Types</option><option value="bulking">Bulking</option><option value="cutting">Cutting</option><option value="maintenance">Maintenance</option><option value="vegan">Vegan</option><option value="keto">Keto</option><option value="general">General</option></select>
</div>
<div class="nut-grid" id="nutGrid"></div>

<!-- Add/Edit Modal -->
<div class="nut-modal-bg" id="nutModal"><div class="nut-modal">
  <h2><i class="bi bi-egg-fried" style="color:var(--accent)"></i> <span id="nutModalTitle">ADD MEAL PLAN</span></h2>
  <input type="hidden" id="nutEditIdx" value="-1">
  <div class="nut-field-row">
    <div class="nut-field"><label>Plan Name</label><input type="text" id="nutName" placeholder="e.g. Lean Muscle Builder"></div>
    <div class="nut-field"><label>Type</label><select id="nutType"><option value="bulking">Bulking</option><option value="cutting">Cutting</option><option value="maintenance">Maintenance</option><option value="vegan">Vegan</option><option value="keto">Keto</option><option value="general">General</option></select></div>
  </div>
  <div class="nut-field"><label>Description</label><textarea id="nutDesc" placeholder="Brief description of this meal plan…"></textarea></div>
  <div class="nut-field-row3">
    <div class="nut-field"><label>Calories (kcal)</label><input type="number" id="nutCal" placeholder="e.g. 2500"></div>
    <div class="nut-field"><label>Protein (g)</label><input type="number" id="nutProt" placeholder="e.g. 180"></div>
    <div class="nut-field"><label>Carbs (g)</label><input type="number" id="nutCarbs" placeholder="e.g. 250"></div>
  </div>
  <div class="nut-field-row">
    <div class="nut-field"><label>Fats (g)</label><input type="number" id="nutFats" placeholder="e.g. 80"></div>
    <div class="nut-field"><label>Duration</label><input type="text" id="nutDur" placeholder="e.g. 4 weeks"></div>
  </div>
  <div class="nut-field"><label>Meals (one per line: meal name | calories)</label><textarea id="nutMeals" placeholder="Breakfast: Oatmeal & Eggs | 450&#10;Lunch: Grilled Chicken & Rice | 650&#10;Snack: Protein Shake | 280&#10;Dinner: Salmon & Quinoa | 580"></textarea></div>
  <button class="nut-submit" onclick="nutSave()"><i class="bi bi-check-circle-fill"></i> Save Meal Plan</button>
  <button class="nut-cancel" onclick="nutCloseModal()">Cancel</button>
</div></div>

<!-- Delete Modal -->
<div class="nut-del-modal-bg" id="nutDelModal"><div class="nut-del-modal">
  <div style="font-size:2.5rem;color:#f87171;margin-bottom:.8rem"><i class="bi bi-exclamation-triangle-fill"></i></div>
  <h3 style="font-family:var(--font-display);font-size:1.3rem;letter-spacing:2px;margin-bottom:.5rem">DELETE MEAL PLAN</h3>
  <p style="color:var(--gray);font-size:.82rem;margin-bottom:1.5rem">Remove <strong id="nutDelName" style="color:#fff"></strong>? This cannot be undone.</p>
  <div style="display:flex;gap:.8rem;justify-content:center">
    <button onclick="nutCloseDelModal()" style="padding:.5rem 1.2rem;border-radius:8px;border:1px solid var(--border);background:none;color:var(--gray);cursor:pointer">Cancel</button>
    <button onclick="nutConfirmDel()" style="padding:.5rem 1.2rem;border-radius:8px;border:none;background:#f87171;color:#000;font-weight:700;cursor:pointer"><i class="bi bi-trash3"></i> Delete</button>
  </div>
</div></div>

<script>
var NUT_KEY='fcms_nutrition';
var NUT_DEFAULT=[
  {name:'Lean Muscle Builder',type:'bulking',desc:'High-protein plan designed for lean muscle gain with controlled surplus. Ideal for intermediate to advanced lifters.',cal:2800,prot:200,carbs:300,fats:90,dur:'8 weeks',meals:[{n:'Breakfast: Eggs & Oats',c:520},{n:'Snack: Greek Yogurt & Berries',c:280},{n:'Lunch: Grilled Chicken & Brown Rice',c:680},{n:'Pre-Workout: Banana & Peanut Butter',c:320},{n:'Dinner: Steak & Sweet Potato',c:720},{n:'Evening: Casein Protein Shake',c:280}]},
  {name:'Shredding Protocol',type:'cutting',desc:'Calorie-deficit plan for fat loss while preserving muscle. Includes strategic carb cycling for optimal results.',cal:1800,prot:180,carbs:120,fats:65,dur:'6 weeks',meals:[{n:'Breakfast: Egg Whites & Spinach',c:280},{n:'Snack: Protein Bar',c:200},{n:'Lunch: Turkey Salad Bowl',c:450},{n:'Snack: Almonds & Apple',c:180},{n:'Dinner: Fish & Vegetables',c:480},{n:'Evening: Cottage Cheese',c:210}]},
  {name:'Balanced Lifestyle',type:'maintenance',desc:'Sustainable nutrition plan for maintaining current physique while staying energized throughout the day.',cal:2200,prot:150,carbs:230,fats:75,dur:'Ongoing',meals:[{n:'Breakfast: Smoothie Bowl',c:380},{n:'Snack: Mixed Nuts',c:220},{n:'Lunch: Chicken Wrap & Soup',c:550},{n:'Snack: Fruit & Yogurt',c:200},{n:'Dinner: Pasta & Grilled Veggies',c:620},{n:'Dessert: Dark Chocolate',c:130}]},
  {name:'Plant Power',type:'vegan',desc:'100% plant-based meal plan rich in complete proteins, iron, and B12. Designed for active vegans and athletes.',cal:2400,prot:130,carbs:310,fats:80,dur:'Ongoing',meals:[{n:'Breakfast: Tofu Scramble & Toast',c:420},{n:'Snack: Hummus & Veggies',c:250},{n:'Lunch: Lentil Bowl & Quinoa',c:580},{n:'Snack: Protein Smoothie',c:300},{n:'Dinner: Chickpea Curry & Rice',c:650},{n:'Evening: Soy Milk & Granola',c:200}]},
  {name:'Keto Performance',type:'keto',desc:'Ultra-low carb, high fat plan for ketosis-based fat burning. Includes MCT oil and electrolyte recommendations.',cal:2100,prot:140,carbs:30,fats:160,dur:'4 weeks',meals:[{n:'Breakfast: Avocado & Bacon Eggs',c:480},{n:'Snack: Cheese & Olives',c:280},{n:'Lunch: Salmon & Spinach Salad',c:520},{n:'Snack: Fat Bombs',c:200},{n:'Dinner: Ribeye & Asparagus',c:620}]},
  {name:'Beginner Nutrition',type:'general',desc:'Simple, easy-to-follow meal plan for newcomers. Focuses on whole foods and balanced macros for general fitness.',cal:2000,prot:120,carbs:240,fats:65,dur:'4 weeks',meals:[{n:'Breakfast: Oatmeal & Banana',c:350},{n:'Snack: Apple & Peanut Butter',c:200},{n:'Lunch: Rice & Chicken Breast',c:500},{n:'Snack: Boiled Eggs',c:150},{n:'Dinner: Grilled Fish & Salad',c:520},{n:'Evening: Warm Milk',c:130}]}
];
var nutDelIdx=-1;
function nutGetAll(){try{return JSON.parse(localStorage.getItem(NUT_KEY))||[];}catch(e){return[];}}
function nutSaveAll(a){localStorage.setItem(NUT_KEY,JSON.stringify(a));}
function nutRenderStats(){
  var all=nutGetAll(),tc=0,avg=0,types={};
  all.forEach(function(p){tc+=p.cal||0;types[p.type]=true;});
  avg=all.length?Math.round(tc/all.length):0;
  var highest=0;all.forEach(function(p){if((p.cal||0)>highest)highest=p.cal;});
  document.getElementById('nutStats').innerHTML='<div class="nut-stat"><div class="nut-stat-val">'+all.length+'</div><div class="nut-stat-lbl">Total Plans</div></div><div class="nut-stat"><div class="nut-stat-val" style="color:#34d399">'+avg+'</div><div class="nut-stat-lbl">Avg Calories</div></div><div class="nut-stat"><div class="nut-stat-val" style="color:#fbbf24">'+highest+'</div><div class="nut-stat-lbl">Highest Cal</div></div><div class="nut-stat"><div class="nut-stat-val" style="color:#a78bfa">'+Object.keys(types).length+'</div><div class="nut-stat-lbl">Diet Types</div></div>';
}
function nutRender(){
  var all=nutGetAll(),q=(document.getElementById('nutSearch').value||'').toLowerCase(),tf=document.getElementById('nutTypeFilter').value;
  var filtered=all.filter(function(p){
    var text=(p.name+p.desc+p.type).toLowerCase();
    return(!q||text.indexOf(q)>=0)&&(!tf||p.type===tf);
  });
  if(!filtered.length){document.getElementById('nutGrid').innerHTML='<div class="nut-empty" style="grid-column:1/-1"><i class="bi bi-egg-fried"></i><div style="font-size:1rem;font-weight:600;margin-bottom:.3rem">No Meal Plans Found</div><div style="font-size:.8rem">Click "Add Meal Plan" to create your first plan</div></div>';return;}
  var html='';
  filtered.forEach(function(p,fi){
    var oi=all.indexOf(p);
    var tc=p.type||'general';
    html+='<div class="nut-card" style="animation:fadeIn .3s ease '+(fi*0.05)+'s both">';
    html+='<div class="nut-card-top '+tc+'">';
    html+='<div class="nut-card-name">'+p.name+'</div>';
    html+='<div class="nut-card-desc">'+p.desc+'</div>';
    var icons={bulking:'trophy-fill',cutting:'scissors',maintenance:'arrow-left-right',vegan:'flower1',keto:'droplet-fill',general:'star-fill'};
    html+='<div class="nut-card-type nut-type-'+tc+'"><i class="bi bi-'+(icons[tc]||'star')+'" style="font-size:.45rem"></i> '+tc.toUpperCase()+'</div>';
    html+='</div>';
    html+='<div class="nut-card-body">';
    html+='<div class="nut-macros"><div class="nut-macro"><div class="nut-macro-val">'+(p.prot||0)+'g</div><div class="nut-macro-lbl">Protein</div></div><div class="nut-macro"><div class="nut-macro-val">'+(p.carbs||0)+'g</div><div class="nut-macro-lbl">Carbs</div></div><div class="nut-macro"><div class="nut-macro-val">'+(p.fats||0)+'g</div><div class="nut-macro-lbl">Fats</div></div></div>';
    if(p.meals&&p.meals.length){
      html+='<div class="nut-meals">';
      p.meals.forEach(function(m){html+='<div class="nut-meal"><span class="nut-meal-dot"></span><span class="nut-meal-name">'+m.n+'</span><span class="nut-meal-cal">'+m.c+' kcal</span></div>';});
      html+='</div>';
    }
    html+='</div>';
    html+='<div class="nut-card-foot"><div class="nut-card-cal"><strong>'+(p.cal||0)+'</strong> kcal/day · '+( p.dur||'—')+'</div><div class="nut-card-acts"><button onclick="nutEdit('+oi+')"><i class="bi bi-pencil"></i> Edit</button><button class="nut-del" onclick="nutOpenDel('+oi+')"><i class="bi bi-trash3"></i></button></div></div>';
    html+='</div>';
  });
  document.getElementById('nutGrid').innerHTML=html;
}
function nutOpenModal(){document.getElementById('nutEditIdx').value='-1';document.getElementById('nutModalTitle').textContent='ADD MEAL PLAN';['nutName','nutDesc','nutCal','nutProt','nutCarbs','nutFats','nutDur','nutMeals'].forEach(function(id){document.getElementById(id).value='';});document.getElementById('nutType').value='bulking';document.getElementById('nutModal').classList.add('open');}
function nutCloseModal(){document.getElementById('nutModal').classList.remove('open');}
function nutEdit(i){var p=nutGetAll()[i];if(!p)return;document.getElementById('nutEditIdx').value=i;document.getElementById('nutModalTitle').textContent='EDIT MEAL PLAN';document.getElementById('nutName').value=p.name||'';document.getElementById('nutType').value=p.type||'general';document.getElementById('nutDesc').value=p.desc||'';document.getElementById('nutCal').value=p.cal||'';document.getElementById('nutProt').value=p.prot||'';document.getElementById('nutCarbs').value=p.carbs||'';document.getElementById('nutFats').value=p.fats||'';document.getElementById('nutDur').value=p.dur||'';document.getElementById('nutMeals').value=(p.meals||[]).map(function(m){return m.n+' | '+m.c;}).join('\n');document.getElementById('nutModal').classList.add('open');}
function nutSave(){var n=document.getElementById('nutName').value.trim();if(!n){alert('Please enter a plan name.');return;}var mealsText=document.getElementById('nutMeals').value.trim();var meals=[];if(mealsText){mealsText.split('\n').forEach(function(l){l=l.trim();if(!l)return;var parts=l.split('|');meals.push({n:parts[0].trim(),c:parseInt(parts[1])||0});});}var o={name:n,type:document.getElementById('nutType').value,desc:document.getElementById('nutDesc').value.trim(),cal:parseInt(document.getElementById('nutCal').value)||0,prot:parseInt(document.getElementById('nutProt').value)||0,carbs:parseInt(document.getElementById('nutCarbs').value)||0,fats:parseInt(document.getElementById('nutFats').value)||0,dur:document.getElementById('nutDur').value.trim()||'4 weeks',meals:meals};var all=nutGetAll(),idx=parseInt(document.getElementById('nutEditIdx').value);if(idx>=0&&idx<all.length)all[idx]=o;else all.push(o);nutSaveAll(all);nutCloseModal();nutRenderStats();nutRender();}
function nutOpenDel(i){nutDelIdx=i;document.getElementById('nutDelName').textContent=(nutGetAll()[i]||{}).name||'';document.getElementById('nutDelModal').classList.add('open');}
function nutCloseDelModal(){document.getElementById('nutDelModal').classList.remove('open');nutDelIdx=-1;}
function nutConfirmDel(){if(nutDelIdx<0)return;var a=nutGetAll();a.splice(nutDelIdx,1);nutSaveAll(a);nutCloseDelModal();nutRenderStats();nutRender();}
document.addEventListener('DOMContentLoaded',function(){if(!localStorage.getItem(NUT_KEY))nutSaveAll(NUT_DEFAULT);nutRenderStats();nutRender();document.getElementById('nutSearch').addEventListener('input',nutRender);document.getElementById('nutTypeFilter').addEventListener('change',nutRender);});
</script>
</div>

</main>
</div><!-- end admin-layout -->

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/static/js/fcms.js"></script>
<script>
// Sidebar section switching
function showDashSection(name, el) {
  document.querySelectorAll('.dash-section').forEach(s => s.classList.remove('active-section'));
  const sec = document.getElementById('sec-' + name);
  if (sec) { sec.classList.add('active-section'); sec.scrollIntoView({behavior:'smooth',block:'start'}); }
  document.querySelectorAll('.admin-sidebar .sb-item').forEach(i => i.classList.remove('active'));
  if (el) el.classList.add('active');
}

document.addEventListener('DOMContentLoaded', function() {
  // Handle URL hash on page load (e.g. /home#sec-analytics)
  const hash = window.location.hash;
  if (hash && hash.startsWith('#sec-')) {
    const secName = hash.replace('#sec-', '');
    const sec = document.getElementById('sec-' + secName);
    if (sec) {
      document.querySelectorAll('.dash-section').forEach(s => s.classList.remove('active-section'));
      sec.classList.add('active-section');
      document.querySelectorAll('.admin-sidebar .sb-item').forEach(i => {
        if (i.getAttribute('href') && i.getAttribute('href').includes('#sec-' + secName)) i.classList.add('active');
      });
      setTimeout(() => sec.scrollIntoView({behavior:'smooth',block:'start'}), 100);
    }
  }

  // Intercept sidebar hash links — switch section without full reload
  document.querySelectorAll('.admin-sidebar .sb-item[href*="#sec-"]').forEach(function(link) {
    link.addEventListener('click', function(e) {
      const href = this.getAttribute('href');
      const hashIdx = href.indexOf('#sec-');
      if (hashIdx !== -1) {
        // Only intercept if we are already on /home
        if (window.location.pathname.endsWith('/home') || window.location.pathname === '/') {
          e.preventDefault();
          const secName = href.substring(hashIdx + 5);
          showDashSection(secName, this);
          history.pushState(null, '', '#sec-' + secName);
        }
        // else let browser navigate normally
      }
    });
  });

  // Dashboard home link — go back to overview section
  document.querySelector('.admin-sidebar .sb-item[href$="/home"]')?.addEventListener('click', function(e) {
    if (window.location.pathname.endsWith('/home')) {
      e.preventDefault();
      document.querySelectorAll('.dash-section').forEach(s => s.classList.remove('active-section'));
      document.getElementById('sec-overview')?.classList.add('active-section');
      document.querySelectorAll('.admin-sidebar .sb-item').forEach(i => i.classList.remove('active'));
      this.classList.add('active');
      history.pushState(null, '', window.location.pathname);
    }
  });
});

// Charts
const chartColors = {accent:'#C8F03D',accent2:'rgba(200,240,61,0.15)',blue:'#60a5fa',red:'#f87171',yellow:'#fbbf24',green:'#34d399'};
const chartFont = {family:'Inter',size:11,color:'#888'};
Chart.defaults.color = '#888';
Chart.defaults.borderColor = 'rgba(255,255,255,0.06)';

// Revenue Chart
new Chart(document.getElementById('revenueChart'),{type:'line',data:{labels:['Oct','Nov','Dec','Jan','Feb','Mar'],datasets:[{label:'Revenue (Rs.)',data:[85000,92000,78000,105000,115000,${monthlyRevenue > 0 ? monthlyRevenue : 125000}],borderColor:chartColors.accent,backgroundColor:chartColors.accent2,fill:true,tension:.4,pointRadius:4,pointBackgroundColor:chartColors.accent}]},options:{responsive:true,plugins:{legend:{display:false}},scales:{y:{ticks:{callback:v=>'Rs.'+v/1000+'k'}}}}});

// Plan Distribution Chart
new Chart(document.getElementById('planChart'),{type:'doughnut',data:{labels:['Basic','Standard','Premium','Trial'],datasets:[{data:[35,45,15,5],backgroundColor:[chartColors.blue,chartColors.accent,chartColors.yellow,chartColors.green],borderWidth:0}]},options:{responsive:true,cutout:'65%',plugins:{legend:{position:'bottom',labels:{padding:12,usePointStyle:true,pointStyle:'circle'}}}}});

// Class Popularity Chart
new Chart(document.getElementById('classChart'),{type:'bar',data:{labels:['HIIT','Yoga','Zumba','Strength','Cardio','Spin'],datasets:[{label:'Bookings',data:[42,38,35,28,25,20],backgroundColor:[chartColors.accent,chartColors.blue,chartColors.red,chartColors.yellow,chartColors.green,'#a78bfa'],borderRadius:6,barThickness:28}]},options:{responsive:true,plugins:{legend:{display:false}},scales:{y:{beginAtZero:true}}}});
</script>
</body>
</html>
