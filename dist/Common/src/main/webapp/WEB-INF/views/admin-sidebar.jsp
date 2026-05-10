<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%-- Admin Sidebar Navigation --%>
<aside class="admin-sidebar" id="adminSidebar">
  <div class="sb-section">
    <div class="sb-label">Main</div>
    <a href="${pageContext.request.contextPath}/home" class="sb-item ${pageTitle == 'Dashboard' ? 'active' : ''}"><i class="bi bi-speedometer2"></i> Dashboard</a>
    <a href="${pageContext.request.contextPath}/home#sec-members" class="sb-item ${pageTitle.contains('Member') ? 'active' : ''}"><i class="bi bi-people-fill"></i> Members <span class="sb-badge">${totalMembers}</span></a>
    <a href="${pageContext.request.contextPath}/home#sec-plans" class="sb-item ${pageTitle.contains('Plan') ? 'active' : ''}"><i class="bi bi-card-checklist"></i> Plans</a>
    <a href="${pageContext.request.contextPath}/home#sec-classes" class="sb-item ${pageTitle.contains('Class') ? 'active' : ''}"><i class="bi bi-calendar3"></i> Classes</a>
    <a href="${pageContext.request.contextPath}/home#sec-trainers" class="sb-item ${pageTitle.contains('Trainer') ? 'active' : ''}"><i class="bi bi-person-badge-fill"></i> Trainers</a>
    <a href="${pageContext.request.contextPath}/home#sec-attendance" class="sb-item ${pageTitle.contains('Attendance') ? 'active' : ''}"><i class="bi bi-clock-history"></i> Attendance</a>
    <a href="${pageContext.request.contextPath}/home#sec-exercises" class="sb-item ${pageTitle.contains('Exercise') ? 'active' : ''}"><i class="bi bi-activity"></i> Exercises</a>
    <a href="${pageContext.request.contextPath}/home#sec-supplements" class="sb-item ${pageTitle.contains('Supplement') ? 'active' : ''}"><i class="bi bi-capsule"></i> Supplements</a>
    <a href="${pageContext.request.contextPath}/home#sec-nutrition" class="sb-item ${pageTitle.contains('Nutrition') ? 'active' : ''}"><i class="bi bi-egg-fried"></i> Nutrition</a>
  </div>
  <div class="sb-section">
    <div class="sb-label">Analytics</div>
    <a href="${pageContext.request.contextPath}/home#sec-analytics" class="sb-item"><i class="bi bi-graph-up"></i> Analytics</a>
    <a href="${pageContext.request.contextPath}/attendance/report" class="sb-item ${pageTitle.contains('Report') ? 'active' : ''}"><i class="bi bi-bar-chart-line"></i> Reports</a>
    <a href="${pageContext.request.contextPath}/home#sec-notifications" class="sb-item"><i class="bi bi-bell-fill"></i> Notifications <span class="sb-badge">4</span></a>
  </div>
  <div class="sb-section">
    <div class="sb-label">System</div>
    <a href="${pageContext.request.contextPath}/settings" class="sb-item ${pageTitle == 'Settings' ? 'active' : ''}"><i class="bi bi-gear-fill"></i> Settings</a>
    <a href="${pageContext.request.contextPath}/landing.html" class="sb-item"><i class="bi bi-globe2"></i> View Website</a>
    <a href="${pageContext.request.contextPath}/logout" class="sb-item" style="color:#f87171"><i class="bi bi-box-arrow-right"></i> Logout</a>
  </div>
</aside>
