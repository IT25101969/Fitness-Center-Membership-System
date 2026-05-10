<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Error — FCMS</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css">
</head>
<body style="display:flex;align-items:center;justify-content:center;min-height:100vh;background:var(--black);">
<div style="text-align:center;max-width:500px;padding:2rem;">
    <div style="font-size:5rem;color:var(--danger);margin-bottom:1rem;">
        <i class="bi bi-exclamation-triangle-fill"></i>
    </div>
    <h1 style="font-size:2.5rem;font-weight:800;color:var(--white);">
        ${requestScope['jakarta.servlet.error.status_code']}
    </h1>
    <h2 style="font-size:1.2rem;font-weight:500;color:var(--gray);margin-bottom:1.5rem;">
        ${requestScope['jakarta.servlet.error.message']}
    </h2>
    <p style="color:var(--gray);margin-bottom:2rem;">
        Something went wrong. Please check the URL or return to the dashboard.
    </p>
    <a href="${pageContext.request.contextPath}/home" class="btn-fcms-primary" style="font-size:1rem;padding:.75rem 2rem;">
        <i class="bi bi-house-fill me-2"></i>Go to Dashboard
    </a>
</div>
</body>
</html>
