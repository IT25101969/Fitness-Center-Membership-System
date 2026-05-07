<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Plan — FCMS</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css">
    <c:set var="pageTitle" value="Edit Plan"/>
</head>
<body>
<jsp:include page="navbar.jsp"/>

<main class="full-main">

    <!-- Banner -->
    <div class="page-banner fade-in">
        <img src="${pageContext.request.contextPath}/static/images/hero.png" alt="" class="page-banner-bg">
        <div class="page-banner-overlay"></div>
        <div class="page-banner-content">
            <div>
                <h1 class="page-banner-title"><i class="bi bi-pencil-square me-2"></i>EDIT MEMBERSHIP PLAN</h1>
                <p class="page-banner-sub">Update plan details, pricing, and features</p>
            </div>
            <a href="${pageContext.request.contextPath}/plans" class="btn-fcms-primary" style="background:transparent;border:1px solid var(--accent);color:var(--accent);">
                <i class="bi bi-arrow-left"></i> Back to Plans
            </a>
        </div>
    </div>

    <!-- Quick Nav -->
    <div class="quick-nav fade-in-delay">
        <a href="${pageContext.request.contextPath}/home"><i class="bi bi-speedometer2"></i> Dashboard</a>
        <a href="${pageContext.request.contextPath}/plans" class="active"><i class="bi bi-card-list"></i> Plans</a>
        <a href="${pageContext.request.contextPath}/members"><i class="bi bi-people-fill"></i> Members</a>
    </div>
    <c:if test="${not empty error}">
        <div class="fcms-alert fcms-alert-danger"><i class="bi bi-exclamation-triangle-fill"></i> ${error}</div>
    </c:if>
    <form id="planForm" method="post" action="${pageContext.request.contextPath}/plans/update" novalidate>
        <input type="hidden" name="planId" value="${plan.planId}">
        <div class="fcms-form-section">
            <p class="form-section-title">Plan Details</p>
            <div class="row g-3">
                <div class="col-md-6">
                    <label class="form-label" for="planName">Plan Name *</label>
                    <input type="text" id="planName" name="planName" class="form-control" required value="${plan.planName}">
                </div>
                <div class="col-md-6">
                    <label class="form-label" for="price">Price (Rs.) *</label>
                    <input type="number" id="price" name="price" class="form-control" required min="0" step="0.01" value="${plan.price}">
                </div>
                <div class="col-md-6">
                    <label class="form-label" for="durationDays">Duration (Days) *</label>
                    <input type="number" id="durationDays" name="durationDays" class="form-control" required min="1" value="${plan.durationDays}">
                </div>
                <div class="col-md-6">
                    <label class="form-label" for="classAccess">Class Access *</label>
                    <select id="classAccess" name="classAccess" class="form-select" required>
                        <option value="LIMITED" ${plan.classAccess == 'LIMITED' ? 'selected' : ''}>LIMITED</option>
                        <option value="UNLIMITED" ${plan.classAccess == 'UNLIMITED' ? 'selected' : ''}>UNLIMITED</option>
                    </select>
                </div>
                <div class="col-12">
                    <label class="form-label" for="features">Features (pipe-separated)</label>
                    <input type="text" id="features" name="features" class="form-control" value="${plan.features}">
                </div>
            </div>
        </div>
        <div style="display:flex;gap:.75rem;justify-content:flex-end;">
            <a href="${pageContext.request.contextPath}/plans" class="btn btn-outline-secondary">Cancel</a>
            <button type="submit" class="btn-fcms-primary"><i class="bi bi-floppy-fill me-1"></i>Save Changes</button>
        </div>
    </form>
</main>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/static/js/fcms.js"></script>
</body>
</html>
