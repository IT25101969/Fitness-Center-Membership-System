<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Membership Plans — APEX FITNESS</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Bebas+Neue&family=Inter:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.min.css">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
<c:set var="pageTitle" value="Membership Plans"/>
<style>
:root{--accent:#C8F03D;--accent-rgb:200,240,61;--black:#0a0a0a;--card:#111113;--border:rgba(255,255,255,.07);--gray:rgba(255,255,255,.45);--font-display:'Bebas Neue',sans-serif;--font-body:'Inter',sans-serif;--radius:14px}
*{margin:0;padding:0;box-sizing:border-box}
body{background:var(--black);color:#fff;font-family:var(--font-body)}

.pl-page{display:flex;min-height:100vh}
.pl-sb{width:260px;background:var(--card);border-right:1px solid var(--border);padding:1.5rem 0;flex-shrink:0;position:sticky;top:0;height:100vh;overflow-y:auto;display:flex;flex-direction:column}
.pl-main{flex:1;padding:2rem 2.5rem;overflow-y:auto}
.pl-logo{font-family:var(--font-display);font-size:1.5rem;padding:0 1.5rem 1.5rem;letter-spacing:2px;border-bottom:1px solid var(--border);margin-bottom:1rem}.pl-logo span{color:var(--accent)}
.pl-sb-sec{padding:0 .8rem;margin-bottom:1rem}
.pl-sb-lbl{font-size:.6rem;font-weight:700;letter-spacing:2px;text-transform:uppercase;color:var(--gray);padding:.5rem .7rem}
.pl-sb-item{display:flex;align-items:center;gap:.6rem;padding:.55rem .7rem;border-radius:8px;font-size:.82rem;font-weight:500;color:rgba(255,255,255,.55);text-decoration:none;transition:all .2s;margin-bottom:.1rem}
.pl-sb-item:hover{background:rgba(255,255,255,.04);color:#fff}.pl-sb-item.active{background:rgba(var(--accent-rgb),.1);color:var(--accent);font-weight:700}
.pl-sb-item i{font-size:1rem;width:20px;text-align:center}

.pl-header{display:flex;align-items:center;justify-content:space-between;flex-wrap:wrap;gap:1rem;margin-bottom:2rem}
.pl-header h1{font-family:var(--font-display);font-size:2rem;letter-spacing:3px;margin:0}.pl-header h1 span{color:var(--accent)}
.pl-header p{color:var(--gray);font-size:.8rem;margin:.3rem 0 0}
.pl-add-btn{display:flex;align-items:center;gap:.4rem;padding:.6rem 1.2rem;border-radius:10px;border:none;background:var(--accent);color:#000;font-size:.8rem;font-weight:700;cursor:pointer;transition:all .2s;letter-spacing:.3px;text-decoration:none}.pl-add-btn:hover{box-shadow:0 4px 20px rgba(200,240,61,.3);transform:scale(1.03);color:#000}

/* Stats */
.pl-stats{display:grid;grid-template-columns:repeat(4,1fr);gap:1rem;margin-bottom:1.8rem}
.pl-stat{background:var(--card);border:1px solid var(--border);border-radius:var(--radius);padding:1rem;text-align:center;position:relative;overflow:hidden}
.pl-stat::after{content:'';position:absolute;top:0;left:0;right:0;height:2px;background:linear-gradient(90deg,transparent,var(--accent),transparent);opacity:.2}
.pl-stat-val{font-family:var(--font-display);font-size:1.7rem;color:var(--accent)}.pl-stat-lbl{font-size:.6rem;color:var(--gray);text-transform:uppercase;letter-spacing:1.5px;margin-top:.1rem}

/* Plan Cards */
.pl-grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(320px,1fr));gap:1.25rem}
.pl-card{background:var(--card);border:1px solid var(--border);border-radius:var(--radius);overflow:hidden;transition:border-color .25s,transform .25s}.pl-card:hover{border-color:rgba(var(--accent-rgb),.3);transform:translateY(-2px)}
.pl-card-head{padding:1.5rem 1.2rem;text-align:center;position:relative;overflow:hidden;border-bottom:1px solid var(--border)}
.pl-card-head::before{content:'';position:absolute;top:0;left:0;right:0;height:3px}
.pl-card-head.free::before{background:linear-gradient(90deg,#6b7280,#9ca3af)}.pl-card-head.basic::before{background:linear-gradient(90deg,#60a5fa,#3b82f6)}.pl-card-head.standard::before{background:linear-gradient(90deg,var(--accent),#a3e635)}.pl-card-head.premium::before{background:linear-gradient(90deg,#fbbf24,#f59e0b)}
.pl-plan-icon{width:48px;height:48px;border-radius:12px;display:inline-flex;align-items:center;justify-content:center;font-size:1.3rem;margin-bottom:.6rem;border:1px solid var(--border)}
.pl-card-head.free .pl-plan-icon{background:rgba(107,114,128,.1);color:#9ca3af;border-color:rgba(107,114,128,.2)}
.pl-card-head.basic .pl-plan-icon{background:rgba(96,165,250,.1);color:#60a5fa;border-color:rgba(96,165,250,.2)}
.pl-card-head.standard .pl-plan-icon{background:rgba(var(--accent-rgb),.1);color:var(--accent);border-color:rgba(var(--accent-rgb),.2)}
.pl-card-head.premium .pl-plan-icon{background:rgba(251,191,36,.1);color:#fbbf24;border-color:rgba(251,191,36,.2)}
.pl-plan-name{font-family:var(--font-display);font-size:1.3rem;letter-spacing:3px;text-transform:uppercase}
.pl-plan-price{font-family:var(--font-display);font-size:2rem;letter-spacing:1px;margin:.2rem 0}.pl-plan-price small{font-family:var(--font-body);font-size:.7rem;color:var(--gray);font-weight:400;letter-spacing:0}
.pl-plan-dur{font-size:.7rem;color:var(--gray)}
.pl-card-body{padding:1.2rem}
.pl-access{display:inline-flex;align-items:center;gap:.3rem;padding:.2rem .6rem;border-radius:20px;font-size:.6rem;font-weight:700;letter-spacing:1px;text-transform:uppercase;margin-bottom:.8rem}
.pl-access.unlimited{background:rgba(52,211,153,.1);color:#34d399;border:1px solid rgba(52,211,153,.2)}.pl-access.limited{background:rgba(251,191,36,.1);color:#fbbf24;border:1px solid rgba(251,191,36,.2)}
.pl-feat{display:flex;align-items:center;gap:.5rem;padding:.35rem 0;font-size:.78rem;color:rgba(255,255,255,.7)}.pl-feat i{color:var(--accent);font-size:.7rem;flex-shrink:0}
.pl-card-foot{display:flex;align-items:center;justify-content:space-between;padding:.8rem 1.2rem;border-top:1px solid var(--border);background:rgba(255,255,255,.015)}
.pl-members{display:flex;align-items:center;gap:.4rem;font-size:.75rem;color:var(--gray)}.pl-members i{color:var(--accent)}
.pl-actions{display:flex;gap:.4rem}
.pl-actions a,.pl-actions button{background:none;border:1px solid var(--border);border-radius:6px;color:var(--gray);font-size:.7rem;padding:.3rem .55rem;cursor:pointer;transition:all .2s;display:flex;align-items:center;gap:.2rem;text-decoration:none}
.pl-actions a:hover{border-color:var(--accent);color:var(--accent)}.pl-actions button:hover{border-color:#f87171;color:#f87171}

.pl-empty{text-align:center;padding:3rem;color:var(--gray);grid-column:1/-1;background:var(--card);border:1px solid var(--border);border-radius:var(--radius)}.pl-empty i{font-size:2.5rem;display:block;margin-bottom:.8rem;opacity:.25}

/* Flash */
.pl-flash{padding:.7rem 1.2rem;border-radius:10px;font-size:.8rem;font-weight:600;margin-bottom:1.5rem;display:flex;align-items:center;gap:.5rem;animation:fadeIn .3s ease}
.pl-flash-ok{background:rgba(52,211,153,.1);border:1px solid rgba(52,211,153,.25);color:#34d399}
.pl-flash-err{background:rgba(248,113,113,.1);border:1px solid rgba(248,113,113,.25);color:#f87171}

/* Modal override */
.modal-content{background:var(--card)!important;border:1px solid var(--border)!important;color:#fff}
.modal-header{background:rgba(255,255,255,.03)!important;border-bottom:1px solid var(--border)!important;color:#fff!important}.modal-header .btn-close{filter:invert(1)}
.modal-footer{border-top:1px solid var(--border)!important}
.form-control,.form-select{background:rgba(255,255,255,.04)!important;border-color:var(--border)!important;color:#fff!important}.form-control:focus,.form-select:focus{border-color:rgba(var(--accent-rgb),.4)!important;box-shadow:none!important}
.form-label{font-size:.72rem;font-weight:700;letter-spacing:1px;text-transform:uppercase;color:var(--gray)}

@media(max-width:1024px){.pl-sb{display:none}.pl-main{padding:1.5rem}.pl-stats{grid-template-columns:repeat(2,1fr)}}
@media(max-width:600px){.pl-grid{grid-template-columns:1fr}.pl-header{flex-direction:column;align-items:flex-start}}
@keyframes fadeIn{from{opacity:0;transform:translateY(8px)}to{opacity:1;transform:translateY(0)}}
</style>
</head>
<body>
<div class="pl-page">
<aside class="pl-sb">
  <div class="pl-logo">APEX<span>FITNESS</span></div>
  <div class="pl-sb-sec">
    <div class="pl-sb-lbl">Navigation</div>
    <a href="${pageContext.request.contextPath}/home" class="pl-sb-item"><i class="bi bi-speedometer2"></i> Dashboard</a>
    <a href="${pageContext.request.contextPath}/plans" class="pl-sb-item active"><i class="bi bi-card-checklist"></i> Plans</a>
    <a href="${pageContext.request.contextPath}/plans" class="pl-sb-item" style="padding-left:2.2rem;font-size:.78rem"><i class="bi bi-plus-circle"></i> Add Plan</a>
  </div>
  <div class="pl-sb-sec">
    <div class="pl-sb-lbl">Management</div>
    <a href="${pageContext.request.contextPath}/members" class="pl-sb-item"><i class="bi bi-people-fill"></i> Members</a>
    <a href="${pageContext.request.contextPath}/home#sec-classes" class="pl-sb-item"><i class="bi bi-calendar3"></i> Classes</a>
    <a href="${pageContext.request.contextPath}/home#sec-trainers" class="pl-sb-item"><i class="bi bi-person-badge-fill"></i> Trainers</a>
    <a href="${pageContext.request.contextPath}/home#sec-exercises" class="pl-sb-item"><i class="bi bi-activity"></i> Exercises</a>
    <a href="${pageContext.request.contextPath}/home#sec-supplements" class="pl-sb-item"><i class="bi bi-capsule"></i> Supplements</a>
  </div>
  <div class="pl-sb-sec" style="margin-top:auto;padding-top:1rem;border-top:1px solid var(--border)">
    <a href="${pageContext.request.contextPath}/landing.html" class="pl-sb-item"><i class="bi bi-globe2"></i> View Website</a>
  </div>
</aside>

<div class="pl-main">
  <div class="pl-header" style="animation:fadeIn .4s ease">
    <div><h1>MEMBERSHIP <span>PLANS</span></h1><p><i class="bi bi-info-circle"></i> Manage subscription tiers and their features</p></div>
    <button class="pl-add-btn" data-bs-toggle="modal" data-bs-target="#addPlanModal"><i class="bi bi-plus-circle-fill"></i> Add New Plan</button>
  </div>

  <c:if test="${param.msg == 'created'}"><div class="pl-flash pl-flash-ok"><i class="bi bi-check-circle-fill"></i> Plan created successfully!</div></c:if>
  <c:if test="${param.msg == 'updated'}"><div class="pl-flash pl-flash-ok"><i class="bi bi-check-circle-fill"></i> Plan updated successfully!</div></c:if>
  <c:if test="${param.msg == 'deleted'}"><div class="pl-flash pl-flash-err"><i class="bi bi-trash-fill"></i> Plan deleted.</div></c:if>
  <c:if test="${not empty error}"><div class="pl-flash pl-flash-err"><i class="bi bi-exclamation-triangle-fill"></i> ${error}</div></c:if>

  <div class="pl-stats" style="animation:fadeIn .45s ease">
    <div class="pl-stat"><div class="pl-stat-val">${fn:length(plans)}</div><div class="pl-stat-lbl">Total Plans</div></div>
    <div class="pl-stat"><div class="pl-stat-val" style="color:#60a5fa"><c:set var="totalMem" value="0"/><c:forEach var="p" items="${plans}"><c:set var="totalMem" value="${totalMem + p.activeMembers}"/></c:forEach>${totalMem}</div><div class="pl-stat-lbl">Total Enrolled</div></div>
    <div class="pl-stat"><div class="pl-stat-val" style="color:#34d399"><c:set var="maxPrice" value="0"/><c:forEach var="p" items="${plans}"><c:if test="${p.price > maxPrice}"><c:set var="maxPrice" value="${p.price}"/></c:if></c:forEach>Rs.<fmt:formatNumber value="${maxPrice}" pattern="#,##0"/></div><div class="pl-stat-lbl">Highest Plan</div></div>
    <div class="pl-stat"><div class="pl-stat-val" style="color:#a78bfa">${fn:length(plans)}</div><div class="pl-stat-lbl">Active Tiers</div></div>
  </div>

  <div class="pl-grid" style="animation:fadeIn .5s ease">
    <c:forEach var="plan" items="${plans}" varStatus="st">
      <c:set var="tier" value="${fn:toLowerCase(plan.planName)}"/>
      <c:set var="tierClass" value="standard"/>
      <c:if test="${fn:contains(tier,'free') || fn:contains(tier,'trial')}"><c:set var="tierClass" value="free"/></c:if>
      <c:if test="${fn:contains(tier,'basic')}"><c:set var="tierClass" value="basic"/></c:if>
      <c:if test="${fn:contains(tier,'premium') || fn:contains(tier,'gold') || fn:contains(tier,'vip')}"><c:set var="tierClass" value="premium"/></c:if>
      <div class="pl-card" style="animation:fadeIn .4s ease ${st.index * 0.06}s both">
        <div class="pl-card-head ${tierClass}">
          <div class="pl-plan-icon"><i class="bi bi-${tierClass == 'free' ? 'gift' : (tierClass == 'basic' ? 'star' : (tierClass == 'premium' ? 'gem' : 'award'))}"></i></div>
          <div class="pl-plan-name">${plan.planName}</div>
          <div class="pl-plan-price">Rs.<fmt:formatNumber value="${plan.price}" pattern="#,##0"/> <small>/month</small></div>
          <div class="pl-plan-dur">${plan.durationDays} days duration</div>
        </div>
        <div class="pl-card-body">
          <div class="pl-access ${plan.classAccess == 'UNLIMITED' ? 'unlimited' : 'limited'}"><i class="bi bi-${plan.classAccess == 'UNLIMITED' ? 'infinity' : 'dash-circle'}"></i> ${plan.classAccess} Classes</div>
          <c:forEach var="feature" items="${plan.featureList}"><div class="pl-feat"><i class="bi bi-check-circle-fill"></i> ${feature}</div></c:forEach>
        </div>
        <div class="pl-card-foot">
          <div class="pl-members"><i class="bi bi-people-fill"></i> <strong>${plan.activeMembers}</strong>&nbsp;member(s)</div>
          <div class="pl-actions">
            <a href="${pageContext.request.contextPath}/plans/edit?id=${plan.planId}" title="Edit"><i class="bi bi-pencil"></i> Edit</a>
            <button onclick="confirmDelete('${pageContext.request.contextPath}/plans/delete?id=${plan.planId}','${plan.planName}')" title="Delete"><i class="bi bi-trash3"></i></button>
          </div>
        </div>
      </div>
    </c:forEach>
    <c:if test="${empty plans}">
      <div class="pl-empty"><i class="bi bi-card-list"></i><div style="font-size:1rem;font-weight:600;margin-bottom:.3rem">No Plans Yet</div><div style="font-size:.8rem">Click "Add New Plan" to create your first membership plan</div></div>
    </c:if>
  </div>
</div>
</div>

<!-- Add Plan Modal -->
<div class="modal fade" id="addPlanModal" tabindex="-1">
<div class="modal-dialog modal-lg modal-dialog-centered">
<div class="modal-content" style="border-radius:var(--radius)">
  <div class="modal-header"><h5 class="modal-title" style="font-family:var(--font-display);letter-spacing:2px"><i class="bi bi-plus-circle me-2" style="color:var(--accent)"></i>ADD NEW PLAN</h5><button type="button" class="btn-close" data-bs-dismiss="modal"></button></div>
  <form method="post" action="${pageContext.request.contextPath}/plans/create" novalidate>
    <div class="modal-body" style="padding:1.5rem">
      <div class="row g-3">
        <div class="col-md-6"><label class="form-label" for="planName">Plan Name *</label><input type="text" id="planName" name="planName" class="form-control" required placeholder="e.g. Gold Monthly"></div>
        <div class="col-md-6"><label class="form-label" for="price">Price (Rs.) *</label><input type="number" id="price" name="price" class="form-control" required min="0" step="0.01" placeholder="e.g. 5000"></div>
        <div class="col-md-6"><label class="form-label" for="durationDays">Duration (Days) *</label><input type="number" id="durationDays" name="durationDays" class="form-control" required min="1" placeholder="e.g. 30"></div>
        <div class="col-md-6"><label class="form-label" for="classAccess">Class Access *</label><select id="classAccess" name="classAccess" class="form-select" required><option value="">— Select —</option><option value="LIMITED">LIMITED</option><option value="UNLIMITED">UNLIMITED</option></select></div>
        <div class="col-12"><label class="form-label" for="features">Features (pipe-separated)</label><input type="text" id="features" name="features" class="form-control" placeholder="e.g. Gym Access|Locker|Shower|Sauna"><small style="color:var(--gray);font-size:.7rem">Separate features with | character</small></div>
      </div>
    </div>
    <div class="modal-footer"><button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button><button type="submit" class="pl-add-btn"><i class="bi bi-plus-circle-fill"></i> Create Plan</button></div>
  </form>
</div></div></div>

<!-- Delete Modal -->
<div class="modal fade" id="deleteModal" tabindex="-1">
<div class="modal-dialog modal-dialog-centered">
<div class="modal-content" style="border-radius:var(--radius)">
  <div class="modal-header" style="background:rgba(248,113,113,.1)!important"><h5 class="modal-title" style="font-family:var(--font-display);letter-spacing:2px"><i class="bi bi-exclamation-triangle-fill me-2" style="color:#f87171"></i>DELETE PLAN</h5><button type="button" class="btn-close" data-bs-dismiss="modal"></button></div>
  <div class="modal-body" style="padding:1.5rem;text-align:center"><p style="font-size:.9rem">Are you sure you want to delete <strong id="deleteTargetName" style="color:var(--accent)"></strong>?</p><p style="color:var(--gray);font-size:.8rem">This action cannot be undone.</p></div>
  <div class="modal-footer"><button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button><button type="button" id="confirmDeleteBtn" style="padding:.5rem 1.2rem;border-radius:8px;border:none;background:#f87171;color:#000;font-weight:700;cursor:pointer"><i class="bi bi-trash3"></i> Delete Plan</button></div>
</div></div></div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
function confirmDelete(url,name){
  document.getElementById('deleteTargetName').textContent=name;
  document.getElementById('confirmDeleteBtn').onclick=function(){window.location.href=url;};
  new bootstrap.Modal(document.getElementById('deleteModal')).show();
}
setTimeout(function(){document.querySelectorAll('.pl-flash').forEach(function(f){f.style.opacity='0';setTimeout(function(){f.remove()},300)})},4000);
</script>
</body>
</html>
