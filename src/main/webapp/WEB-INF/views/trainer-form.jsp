<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${empty trainer ? 'Add' : 'Edit'} Trainer — FCMS</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css">
    <c:set var="pageTitle" value="${empty trainer ? 'Add Trainer' : 'Edit Trainer'}"/>
</head>
<body>
<jsp:include page="navbar.jsp"/>

<main class="full-main">

    <!-- Banner -->
    <div class="page-banner fade-in">
        <img src="${pageContext.request.contextPath}/static/images/trainer.png" alt="" class="page-banner-bg">
        <div class="page-banner-overlay"></div>
        <div class="page-banner-content">
            <div>
                <h1 class="page-banner-title">
                    <i class="bi ${empty trainer ? 'bi-person-plus-fill' : 'bi-pencil-fill'} me-2"></i>
                    ${empty trainer ? 'ADD NEW TRAINER' : 'EDIT TRAINER'}
                </h1>
                <p class="page-banner-sub">${empty trainer ? 'Register a new fitness trainer to the system' : 'Update trainer details'}</p>
            </div>
            <a href="${pageContext.request.contextPath}/trainers" class="btn-fcms-primary" style="background:transparent;border:1px solid var(--accent);color:var(--accent);">
                <i class="bi bi-arrow-left"></i> Back to Trainers
            </a>
        </div>
    </div>

    <!-- Quick Nav -->
    <div class="quick-nav fade-in-delay">
        <a href="${pageContext.request.contextPath}/home"><i class="bi bi-speedometer2"></i> Dashboard</a>
        <a href="${pageContext.request.contextPath}/trainers"><i class="bi bi-person-badge"></i> Trainers</a>
        <a href="${pageContext.request.contextPath}/trainers/new" ${empty trainer ? 'class="active"' : ''}><i class="bi bi-person-plus-fill"></i> Add Trainer</a>
    </div>

    <c:if test="${not empty error}">
        <div class="fcms-alert fcms-alert-danger"><i class="bi bi-exclamation-triangle-fill"></i> ${error}</div>
    </c:if>

    <form method="post"
          action="${pageContext.request.contextPath}/trainers/${empty trainer ? 'create' : 'update'}"
          novalidate>
        <!-- Hidden ID for edit mode -->
        <c:if test="${not empty trainer}">
            <input type="hidden" name="id" value="${trainer.id}">
        </c:if>
        <div class="fcms-form-section">
            <p class="form-section-title"><i class="bi bi-person-vcard me-2"></i>Trainer Information</p>
            <div class="row g-3">
                <div class="col-md-6">
                    <label class="form-label" for="name">Full Name <span style="color:var(--danger)">*</span></label>
                    <input type="text" id="name" name="name" class="form-control" required minlength="2"
                           placeholder="e.g. Priya Jayawardena"
                           value="${not empty trainer ? trainer.name : ''}">
                </div>
                <div class="col-md-6">
                    <label class="form-label" for="email">Email Address <span style="color:var(--danger)">*</span></label>
                    <input type="email" id="email" name="email" class="form-control" required
                           placeholder="e.g. priya@fcms.lk"
                           value="${not empty trainer ? trainer.email : ''}">
                </div>
                <div class="col-md-6">
                    <label class="form-label" for="phone">Phone Number</label>
                    <input type="tel" id="phone" name="phone" class="form-control"
                           pattern="[0-9]{10}" placeholder="10-digit number"
                           value="${not empty trainer ? trainer.phone : ''}">
                </div>
                <div class="col-md-6">
                    <label class="form-label" for="specialization">Specialization</label>
                    <input type="text" id="specialization" name="specialization" class="form-control"
                           placeholder="e.g. Yoga, Cardio, HIIT"
                           value="${not empty trainer ? trainer.specialization : ''}">
                </div>
                <div class="col-12">
                    <label class="form-label" for="certifications">Certifications (pipe-separated)</label>
                    <input type="text" id="certifications" name="certifications" class="form-control"
                           placeholder="e.g. RYT-200|ACE Certified|CPR Certified"
                           value="${not empty trainer ? trainer.certifications : ''}">
                    <small class="text-muted-sm">Separate certifications with | character</small>
                </div>
            </div>
        </div>
        <div style="display:flex;gap:.75rem;justify-content:flex-end;">
            <a href="${pageContext.request.contextPath}/trainers" class="btn btn-outline-secondary">Cancel</a>
            <button type="submit" class="btn-fcms-primary">
                <i class="bi ${empty trainer ? 'bi-person-plus-fill' : 'bi-check-lg'} me-1"></i>
                ${empty trainer ? 'Add Trainer' : 'Save Changes'}
            </button>
        </div>
    </form>
</main>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/static/js/fcms.js"></script>
</body>
</html>
