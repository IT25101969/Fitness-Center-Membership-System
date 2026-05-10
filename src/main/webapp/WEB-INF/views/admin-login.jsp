<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width,initial-scale=1">
    <title>Admin Access — APEX FITNESS</title>
    <meta name="robots" content="noindex,nofollow">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Bebas+Neue&family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.min.css">
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

        :root {
            --accent: #C8F03D;
            --accent-dim: rgba(200,240,61,0.15);
            --bg: #060608;
            --surface: #0e0e12;
            --surface-2: #14141a;
            --border: rgba(255,255,255,0.07);
            --text: #ffffff;
            --text-muted: rgba(255,255,255,0.4);
            --red: #ff4d4d;
            --font-display: 'Bebas Neue', sans-serif;
            --font-body: 'Inter', sans-serif;
        }

        html, body { height: 100%; background: var(--bg); color: var(--text); font-family: var(--font-body); overflow: hidden; }

        /* ── GRID BACKGROUND ── */
        .bg-grid {
            position: fixed; inset: 0; z-index: 0;
            background-image:
                linear-gradient(rgba(200,240,61,0.025) 1px, transparent 1px),
                linear-gradient(90deg, rgba(200,240,61,0.025) 1px, transparent 1px);
            background-size: 60px 60px;
            mask-image: radial-gradient(ellipse 80% 80% at 50% 50%, black 40%, transparent 100%);
        }

        /* ── GLOW ORBS ── */
        .orb {
            position: fixed; border-radius: 50%; filter: blur(80px); pointer-events: none; z-index: 0;
            animation: orb-float 8s ease-in-out infinite alternate;
        }
        .orb-1 { width: 500px; height: 500px; background: radial-gradient(circle, rgba(200,240,61,0.06) 0%, transparent 70%); top: -15%; left: -10%; }
        .orb-2 { width: 400px; height: 400px; background: radial-gradient(circle, rgba(200,240,61,0.04) 0%, transparent 70%); bottom: -10%; right: -5%; animation-delay: -4s; }
        @keyframes orb-float { from { transform: translate(0,0) scale(1); } to { transform: translate(20px,-20px) scale(1.05); } }

        /* ── SCAN LINE EFFECT ── */
        .scan-line {
            position: fixed; inset: 0; z-index: 0; pointer-events: none;
            background: repeating-linear-gradient(0deg, transparent, transparent 2px, rgba(0,0,0,0.03) 2px, rgba(0,0,0,0.03) 4px);
        }

        /* ── PAGE LAYOUT ── */
        .page {
            position: relative; z-index: 1;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            padding: 2rem;
        }

        /* ── TOP BAR ── */
        .top-bar {
            position: fixed; top: 0; left: 0; right: 0; z-index: 100;
            display: flex; align-items: center; justify-content: space-between;
            padding: 1rem 2rem;
            background: rgba(6,6,8,0.8);
            backdrop-filter: blur(20px);
            border-bottom: 1px solid var(--border);
        }
        .top-brand {
            font-family: var(--font-display);
            font-size: 1.3rem; letter-spacing: 3px;
            color: var(--text); text-decoration: none;
        }
        .top-brand span { color: var(--accent); }
        .top-badge {
            display: flex; align-items: center; gap: 0.5rem;
            background: rgba(200,240,61,0.06);
            border: 1px solid rgba(200,240,61,0.15);
            color: var(--accent);
            font-size: 0.7rem; font-weight: 700; letter-spacing: 2px;
            padding: 0.35rem 0.85rem; border-radius: 50px;
        }

        /* ── MAIN CARD ── */
        .login-card {
            width: 100%; max-width: 440px;
            position: relative;
        }

        /* Glowing border effect */
        .card-glow-border {
            position: absolute; inset: -1px;
            background: linear-gradient(145deg, rgba(200,240,61,0.2), transparent 40%, transparent 60%, rgba(200,240,61,0.1));
            border-radius: 25px;
            z-index: -1;
        }

        .card-inner {
            background: var(--surface);
            border: 1px solid rgba(255,255,255,0.06);
            border-radius: 24px;
            padding: 2.5rem;
            backdrop-filter: blur(20px);
            box-shadow:
                0 60px 120px rgba(0,0,0,0.7),
                inset 0 1px 0 rgba(255,255,255,0.04);
        }

        /* ── HEADER ── */
        .card-header { text-align: center; margin-bottom: 2rem; }

        .shield-wrap {
            position: relative;
            width: 72px; height: 72px;
            margin: 0 auto 1.5rem;
        }
        .shield-bg {
            width: 100%; height: 100%;
            background: rgba(200,240,61,0.06);
            border: 1px solid rgba(200,240,61,0.2);
            border-radius: 20px;
            display: flex; align-items: center; justify-content: center;
            font-size: 1.8rem; color: var(--accent);
        }
        .shield-ping {
            position: absolute; inset: -4px;
            border: 1px solid rgba(200,240,61,0.15);
            border-radius: 24px;
            animation: shield-pulse 3s ease-in-out infinite;
        }
        .shield-ping-2 {
            position: absolute; inset: -10px;
            border: 1px solid rgba(200,240,61,0.07);
            border-radius: 28px;
            animation: shield-pulse 3s ease-in-out infinite 0.5s;
        }
        @keyframes shield-pulse {
            0%, 100% { opacity: 1; transform: scale(1); }
            50% { opacity: 0.4; transform: scale(1.05); }
        }

        .card-title {
            font-family: var(--font-display);
            font-size: 2.2rem; letter-spacing: 3px; margin-bottom: 0.3rem;
        }
        .card-title span { color: var(--accent); }
        .card-subtitle {
            font-size: 0.75rem; color: var(--text-muted);
            letter-spacing: 1.5px; text-transform: uppercase;
        }

        /* ── SECURITY STRIP ── */
        .security-strip {
            display: flex; align-items: center; justify-content: center;
            gap: 0.5rem;
            background: rgba(200,240,61,0.04);
            border: 1px solid rgba(200,240,61,0.12);
            border-radius: 10px;
            padding: 0.6rem 1rem;
            margin-bottom: 1.75rem;
            font-size: 0.73rem; color: var(--text-muted);
        }
        .security-strip i { color: var(--accent); font-size: 0.85rem; }
        .security-strip strong { color: rgba(255,255,255,0.6); }

        /* ── ALERT ── */
        .alert {
            display: flex; align-items: flex-start; gap: 0.6rem;
            padding: 0.85rem 1rem; border-radius: 12px;
            font-size: 0.83rem; margin-bottom: 1.5rem;
            animation: slide-in 0.3s ease;
        }
        .alert-error {
            background: rgba(255,77,77,0.08);
            border: 1px solid rgba(255,77,77,0.2);
            color: #ff8080;
        }
        .alert i { flex-shrink: 0; margin-top: 1px; }
        @keyframes slide-in { from { opacity: 0; transform: translateY(-8px); } to { opacity: 1; transform: translateY(0); } }

        /* ── FORM ── */
        .field { margin-bottom: 1.2rem; }
        .field-label {
            display: flex; align-items: center; justify-content: space-between;
            margin-bottom: 0.55rem;
        }
        .field-label span {
            font-size: 0.72rem; font-weight: 600;
            color: var(--text-muted); text-transform: uppercase; letter-spacing: 0.8px;
        }
        .field-wrap { position: relative; }
        .field-icon {
            position: absolute; left: 1rem; top: 50%; transform: translateY(-50%);
            color: rgba(255,255,255,0.2); font-size: 0.9rem;
            pointer-events: none; transition: color 0.2s;
        }
        .field-wrap input {
            width: 100%;
            padding: 0.9rem 1rem 0.9rem 2.75rem;
            background: rgba(255,255,255,0.03);
            border: 1px solid rgba(255,255,255,0.07);
            color: var(--text);
            border-radius: 12px;
            font-family: var(--font-body); font-size: 0.9rem;
            transition: border-color 0.2s, background 0.2s, box-shadow 0.2s;
            outline: none;
            letter-spacing: 0.3px;
        }
        .field-wrap input::placeholder { color: rgba(255,255,255,0.18); }
        .field-wrap input:focus {
            border-color: rgba(200,240,61,0.4);
            background: rgba(200,240,61,0.03);
            box-shadow: 0 0 0 3px rgba(200,240,61,0.06);
        }
        .field-wrap:focus-within .field-icon { color: var(--accent); }

        .toggle-pw {
            position: absolute; right: 1rem; top: 50%; transform: translateY(-50%);
            background: none; border: none; color: rgba(255,255,255,0.2);
            cursor: pointer; font-size: 1rem; padding: 0;
            transition: color 0.2s; display: flex; align-items: center;
        }
        .toggle-pw:hover { color: rgba(255,255,255,0.55); }

        /* ── SUBMIT ── */
        .btn-submit {
            width: 100%; margin-top: 0.5rem;
            background: var(--accent); color: #000;
            border: none; border-radius: 12px;
            padding: 0.95rem;
            font-family: var(--font-body); font-size: 0.9rem; font-weight: 700;
            letter-spacing: 0.5px; cursor: pointer;
            transition: transform 0.2s, box-shadow 0.2s, opacity 0.2s;
            display: flex; align-items: center; justify-content: center; gap: 0.5rem;
        }
        .btn-submit:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 28px rgba(200,240,61,0.3);
        }
        .btn-submit:active { transform: translateY(0); box-shadow: none; }

        /* ── HINT BOX ── */
        .hint-box {
            background: rgba(255,255,255,0.025);
            border: 1px solid rgba(255,255,255,0.06);
            border-radius: 12px;
            padding: 1rem 1.1rem;
            margin-top: 1.5rem;
            display: flex; align-items: flex-start; gap: 0.75rem;
        }
        .hint-box i { color: rgba(200,240,61,0.5); font-size: 0.9rem; margin-top: 2px; flex-shrink: 0; }
        .hint-box-text { font-size: 0.78rem; color: var(--text-muted); line-height: 1.6; }
        .hint-box-text strong { color: rgba(255,255,255,0.55); }

        /* ── BACK LINK ── */
        .back-link {
            display: inline-flex; align-items: center; gap: 0.45rem;
            color: var(--text-muted); font-size: 0.8rem;
            text-decoration: none; transition: color 0.2s;
            margin-top: 1.75rem;
            width: 100%; justify-content: center;
        }
        .back-link:hover { color: rgba(255,255,255,0.7); }

        /* ── FOOTER NOTE ── */
        .footer-note {
            position: fixed; bottom: 1.5rem; left: 0; right: 0;
            text-align: center;
            font-size: 0.7rem; color: rgba(255,255,255,0.12);
            letter-spacing: 1px;
        }

        /* ── RESPONSIVE ── */
        @media (max-width: 480px) {
            .card-inner { padding: 1.75rem 1.25rem; }
            .page { padding: 1rem; }
        }

        @keyframes spin { to { transform: rotate(360deg); } }
    </style>
</head>
<body>

<!-- Decorative layers -->
<div class="bg-grid"></div>
<div class="orb orb-1"></div>
<div class="orb orb-2"></div>
<div class="scan-line"></div>

<!-- Top bar -->
<div class="top-bar">
    <a href="${pageContext.request.contextPath}/landing.html" class="top-brand">APEX<span>FITNESS</span></a>
    <div class="top-badge"><i class="bi bi-shield-lock-fill"></i> ADMIN AREA</div>
</div>

<div class="page">
    <div class="login-card">

        <!-- Glowing border -->
        <div class="card-glow-border"></div>

        <div class="card-inner">

            <!-- Header -->
            <div class="card-header">
                <div class="shield-wrap">
                    <div class="shield-ping"></div>
                    <div class="shield-ping-2"></div>
                    <div class="shield-bg"><i class="bi bi-shield-lock-fill"></i></div>
                </div>
                <h1 class="card-title">APEX <span>ADMIN</span></h1>
                <p class="card-subtitle">Authorized Personnel Only</p>
            </div>

            <!-- Security strip -->
            <div class="security-strip">
                <i class="bi bi-lock-fill"></i>
                <span>Secure connection &nbsp;·&nbsp; <strong>SSL Encrypted</strong> &nbsp;·&nbsp; Access logged</span>
            </div>

            <!-- Error -->
            <% if (request.getAttribute("error") != null) { %>
            <div class="alert alert-error">
                <i class="bi bi-exclamation-triangle-fill"></i>
                <span><%= request.getAttribute("error") %></span>
            </div>
            <% } %>

            <!-- Form -->
            <form action="${pageContext.request.contextPath}/admin-login" method="post" id="adminLoginForm">
                <div class="field">
                    <div class="field-label"><span>Username</span></div>
                    <div class="field-wrap">
                        <i class="bi bi-person-badge-fill field-icon"></i>
                        <input type="text" name="username" id="username"
                               placeholder="Admin username" required autocomplete="off">
                    </div>
                </div>

                <div class="field">
                    <div class="field-label"><span>Password</span></div>
                    <div class="field-wrap">
                        <i class="bi bi-key-fill field-icon"></i>
                        <input type="password" name="password" id="adminPassword"
                               placeholder="Admin password" required autocomplete="current-password">
                        <button type="button" class="toggle-pw" id="togglePw" aria-label="Toggle password visibility">
                            <i class="bi bi-eye-fill" id="pwIcon"></i>
                        </button>
                    </div>
                </div>

                <button type="submit" class="btn-submit" id="submitBtn">
                    <i class="bi bi-shield-lock-fill"></i> Access Dashboard
                </button>
            </form>

            <!-- Hint -->
            <div class="hint-box">
                <i class="bi bi-info-circle-fill"></i>
                <div class="hint-box-text">
                    Default credentials &mdash;
                    Username: <strong>admin</strong> &nbsp;&middot;&nbsp;
                    Password: <strong>admin123</strong>
                </div>
            </div>

            <!-- Back link -->
            <a href="${pageContext.request.contextPath}/landing.html" class="back-link">
                <i class="bi bi-arrow-left"></i> Return to public website
            </a>

        </div>
    </div>
</div>

<p class="footer-note">APEX FITNESS &copy; <%= java.time.Year.now() %> &nbsp;·&nbsp; ADMIN PORTAL &nbsp;·&nbsp; CONFIDENTIAL</p>

<script>
    /* Password toggle */
    document.getElementById('togglePw')?.addEventListener('click', function () {
        const input = document.getElementById('adminPassword');
        const icon  = document.getElementById('pwIcon');
        const show  = input.type === 'password';
        input.type  = show ? 'text' : 'password';
        icon.className = show ? 'bi bi-eye-slash-fill' : 'bi bi-eye-fill';
    });

    /* Submit loading state */
    document.getElementById('adminLoginForm')?.addEventListener('submit', function () {
        const btn = document.getElementById('submitBtn');
        btn.innerHTML = '<i class="bi bi-arrow-clockwise" style="animation:spin .8s linear infinite"></i> Authenticating…';
        btn.disabled = true;
    });

    /* Subtle grid pulse on focus */
    ['username', 'adminPassword'].forEach(id => {
        const el = document.getElementById(id);
        const grid = document.querySelector('.bg-grid');
        el?.addEventListener('focus', () => { grid.style.opacity = '1.5'; });
        el?.addEventListener('blur',  () => { grid.style.opacity = '1';   });
    });
</script>
</body>
</html>
