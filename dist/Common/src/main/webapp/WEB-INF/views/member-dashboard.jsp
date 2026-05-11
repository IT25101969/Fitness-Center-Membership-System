<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Member Dashboard - APEX FITNESS</title>
    <link href="https://fonts.googleapis.com/css2?family=Bebas+Neue&family=Inter:wght@400;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.min.css">
    <style>
        body { background: #080808; color: #fff; font-family: 'Inter', sans-serif; margin: 0; padding: 2rem; }
        .container { max-width: 800px; margin: 0 auto; text-align: center; }
        .header h1 { font-family: 'Bebas Neue', sans-serif; font-size: 3.5rem; letter-spacing: 2px; color: #C8F03D; margin-bottom: 0.5rem; }
        .header p { color: #888; font-size: 1.1rem; }
        .card { background: #161616; border: 1px solid rgba(255,255,255,0.08); border-radius: 16px; padding: 3rem; margin-top: 3rem; }
        .card i { font-size: 4rem; color: #C8F03D; margin-bottom: 1rem; }
        .btn { display: inline-block; background: transparent; border: 1px solid #C8F03D; color: #C8F03D; text-decoration: none; padding: 0.8rem 2rem; border-radius: 50px; font-weight: 600; margin-top: 2rem; transition: background 0.2s, color 0.2s; }
        .btn:hover { background: #C8F03D; color: #000; }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>WELCOME TO THE MEMBER PORTAL</h1>
            <p>Logged in as: <%= session.getAttribute("memberEmail") %></p>
        </div>
        
        <div class="card">
            <i class="bi bi-person-check-fill"></i>
            <h2>Your Account is Active</h2>
            <p style="color: #aaa; margin-top: 1rem;">This is the member-exclusive area. Currently, there are no additional actions required. Keep pushing your limits!</p>
            <div style="margin-top: 2rem;">
                <a href="${pageContext.request.contextPath}/landing.html" class="btn" style="margin-top: 0; margin-right: 1rem;">Back to Home</a>
                <a href="${pageContext.request.contextPath}/logout" class="btn" style="margin-top: 0; border-color: #ff4444; color: #ff4444;">Logout</a>
            </div>
        </div>
    </div>
</body>
</html>
