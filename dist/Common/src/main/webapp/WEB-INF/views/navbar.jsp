<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%-- Shared Navbar — APEX Dark Theme --%>

<nav class="fcms-navbar">
    <div class="brand">
        <span class="brand-apex">APEX</span><span class="brand-fitness">FITNESS</span><span class="brand-sep">·</span><span class="brand-admin">ADMIN</span>
    </div>

    <div class="admin-nav-right">
        <!-- Search -->
        <button class="admin-nav-icon" title="Search" onclick="document.querySelector('.search-input-wrapper input')?.focus()">
            <i class="bi bi-search"></i>
        </button>
        <!-- Notifications -->
        <button class="admin-nav-icon" title="Notifications" style="position:relative" onclick="if(typeof showDashSection==='function'){showDashSection('notifications',document.querySelector('.sb-item[href*=notifications]'))}else{window.location.href='${pageContext.request.contextPath}/home#sec-notifications'}">
            <i class="bi bi-bell"></i>
            <span class="admin-notif-badge">4</span>
        </button>
        <!-- Website Link -->
        <a href="${pageContext.request.contextPath}/landing.html" class="admin-nav-pill" title="View Website">
            <i class="bi bi-globe2"></i>
            <span>Website</span>
        </a>
        <!-- Divider -->
        <div class="admin-nav-divider"></div>
        <!-- Admin Avatar + Dropdown -->
        <div class="admin-profile-wrap" id="adminProfileWrap">
            <button class="admin-avatar-trigger" onclick="toggleAdminDrop()">
                <div class="admin-avatar-circle">A</div>
                <div class="admin-avatar-info">
                    <span class="admin-avatar-name">Admin</span>
                    <span class="admin-avatar-role">Super Admin</span>
                </div>
                <i class="bi bi-chevron-down admin-dd-chev"></i>
            </button>
            <!-- Dropdown -->
            <div class="admin-dropdown" id="adminDropdown">
                <div class="admin-dd-head">
                    <div class="admin-dd-avatar">A</div>
                    <div>
                        <div class="admin-dd-name">Administrator</div>
                        <div class="admin-dd-email">admin@apexfitness.com</div>
                    </div>
                </div>
                <div class="admin-dd-sep"></div>
                <a href="${pageContext.request.contextPath}/home" class="admin-dd-link"><i class="bi bi-speedometer2"></i> Dashboard</a>
                <a href="${pageContext.request.contextPath}/landing.html" class="admin-dd-link"><i class="bi bi-globe2"></i> View Website</a>
                <div class="admin-dd-sep"></div>
                <a href="${pageContext.request.contextPath}/logout" class="admin-dd-link admin-dd-danger"><i class="bi bi-box-arrow-right"></i> Sign Out</a>
            </div>
        </div>
    </div>
</nav>

<script>
function toggleAdminDrop(){
  var dd=document.getElementById('adminDropdown');
  var ch=document.querySelector('.admin-dd-chev');
  if(dd){dd.classList.toggle('open');}
  if(ch){ch.style.transform=dd&&dd.classList.contains('open')?'rotate(180deg)':'rotate(0)';}
}
document.addEventListener('click',function(e){
  var w=document.getElementById('adminProfileWrap');
  var d=document.getElementById('adminDropdown');
  if(w&&d&&!w.contains(e.target)&&d.classList.contains('open')){
    d.classList.remove('open');
    var ch=document.querySelector('.admin-dd-chev');
    if(ch)ch.style.transform='rotate(0)';
  }
});
</script>
