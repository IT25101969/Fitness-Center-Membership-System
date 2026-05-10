<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Our Trainers — APEX FITNESS</title>
<meta name="description" content="Meet our elite fitness trainers at APEX FITNESS. Certified experts in Strength, Cardio, Yoga, HIIT, CrossFit and more.">
<link href="https://fonts.googleapis.com/css2?family=Bebas+Neue&family=Inter:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.min.css">
<style>
:root{--accent:#C8F03D;--accent-rgb:200,240,61;--black:#050506;--dark:#0a0a0c;--card:#101013;--card2:#141417;--border:rgba(255,255,255,.06);--gray:rgba(255,255,255,.4);--white:#fff;--font-display:'Bebas Neue',sans-serif;--font:'Inter',sans-serif;--radius:16px}
*{margin:0;padding:0;box-sizing:border-box}
html{scroll-behavior:smooth}
body{background:var(--black);color:var(--white);font-family:var(--font);line-height:1.6;overflow-x:hidden}
a{text-decoration:none;color:inherit}

/* ── NAV ── */
.pt-nav{position:fixed;top:0;left:0;right:0;z-index:100;height:60px;background:rgba(5,5,6,.92);backdrop-filter:blur(20px);border-bottom:1px solid var(--border);display:flex;align-items:center;justify-content:space-between;padding:0 2rem}
.pt-brand{font-family:var(--font-display);font-size:1.4rem;letter-spacing:2px}.pt-brand span{color:var(--accent)}
.pt-nav-links{display:flex;gap:.5rem;align-items:center}
.pt-nav-link{padding:.4rem .9rem;border-radius:50px;font-size:.78rem;font-weight:500;color:rgba(255,255,255,.5);transition:all .2s;border:1px solid transparent}
.pt-nav-link:hover{color:var(--white);background:rgba(255,255,255,.04)}
.pt-nav-link.accent{border-color:rgba(var(--accent-rgb),.3);color:var(--accent);font-weight:600}
.pt-nav-link.accent:hover{background:rgba(var(--accent-rgb),.08)}

/* ── HERO ── */
.pt-hero{position:relative;padding:10rem 2rem 5rem;text-align:center;overflow:hidden}
.pt-hero::before{content:'';position:absolute;inset:0;background:radial-gradient(ellipse at 50% 0%, rgba(var(--accent-rgb),.06) 0%, transparent 60%)}
.pt-hero::after{content:'';position:absolute;bottom:0;left:0;right:0;height:120px;background:linear-gradient(transparent,var(--black))}
.pt-hero-badge{display:inline-flex;align-items:center;gap:.4rem;padding:.4rem 1rem;border-radius:50px;font-size:.7rem;font-weight:700;letter-spacing:2px;text-transform:uppercase;color:var(--accent);background:rgba(var(--accent-rgb),.06);border:1px solid rgba(var(--accent-rgb),.15);margin-bottom:1.5rem}
.pt-hero h1{font-family:var(--font-display);font-size:clamp(2.5rem,6vw,4.5rem);letter-spacing:4px;line-height:1;margin-bottom:1rem}
.pt-hero h1 span{color:var(--accent)}
.pt-hero p{color:var(--gray);font-size:1rem;max-width:600px;margin:0 auto;line-height:1.7}

/* ── STATS BAR ── */
.pt-stats{display:flex;justify-content:center;gap:3rem;padding:2.5rem 2rem;margin-bottom:1rem;position:relative;z-index:1}
.pt-stat{text-align:center}
.pt-stat-val{font-family:var(--font-display);font-size:2.2rem;color:var(--accent);letter-spacing:1px}
.pt-stat-label{font-size:.65rem;color:var(--gray);letter-spacing:2px;text-transform:uppercase;margin-top:.15rem}

/* ── FILTER ── */
.pt-filter-bar{display:flex;justify-content:center;gap:.5rem;flex-wrap:wrap;padding:0 2rem;margin-bottom:2.5rem}
.pt-filter{padding:.45rem 1.1rem;border-radius:50px;border:1px solid var(--border);background:transparent;color:var(--gray);font-size:.75rem;font-weight:600;cursor:pointer;transition:all .25s;font-family:var(--font);letter-spacing:.3px}
.pt-filter:hover{border-color:rgba(var(--accent-rgb),.3);color:var(--white)}
.pt-filter.active{background:var(--accent);color:#000;border-color:var(--accent);box-shadow:0 4px 24px rgba(200,240,61,.2)}

/* ── GRID ── */
.pt-container{max-width:1280px;margin:0 auto;padding:0 2rem 5rem}
.pt-grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(380px,1fr));gap:1.5rem}

/* ── CARD ── */
.pt-card{background:var(--card);border:1px solid var(--border);border-radius:var(--radius);overflow:hidden;transition:all .35s cubic-bezier(.4,0,.2,1);position:relative}
.pt-card:hover{border-color:rgba(var(--accent-rgb),.25);transform:translateY(-4px);box-shadow:0 20px 60px rgba(0,0,0,.4)}
.pt-card-header{padding:1.5rem 1.5rem 1rem;display:flex;align-items:center;gap:1rem;position:relative}
.pt-card-avatar{width:56px;height:56px;border-radius:14px;background:linear-gradient(135deg,rgba(var(--accent-rgb),.2),rgba(var(--accent-rgb),.05));display:flex;align-items:center;justify-content:center;font-weight:900;color:var(--accent);font-size:1.3rem;font-family:var(--font-display);letter-spacing:1px;flex-shrink:0;border:1px solid rgba(var(--accent-rgb),.15);position:relative}
.pt-card-avatar::after{content:'';position:absolute;bottom:2px;right:2px;width:12px;height:12px;border-radius:50%;background:#34d399;border:2px solid var(--card)}
.pt-card-info h3{font-size:1rem;font-weight:700;margin-bottom:.15rem}
.pt-card-info .pt-card-title{font-size:.72rem;color:var(--accent);font-weight:600;letter-spacing:.5px}
.pt-card-status{position:absolute;top:1.2rem;right:1.2rem;display:inline-flex;align-items:center;gap:.3rem;padding:.2rem .6rem;border-radius:20px;font-size:.6rem;font-weight:700;background:rgba(52,211,153,.08);color:#34d399;border:1px solid rgba(52,211,153,.15)}
.pt-card-body{padding:0 1.5rem 1.25rem}
.pt-card-details{display:grid;grid-template-columns:1fr 1fr;gap:.6rem;margin-bottom:1rem}
.pt-detail{display:flex;align-items:center;gap:.45rem;font-size:.78rem;color:rgba(255,255,255,.5)}
.pt-detail i{color:rgba(var(--accent-rgb),.5);font-size:.85rem;width:16px;text-align:center}
.pt-detail strong{color:rgba(255,255,255,.85);font-weight:600}
.pt-card-specs{display:flex;flex-wrap:wrap;gap:.35rem;padding-top:1rem;border-top:1px solid var(--border)}
.pt-spec{display:inline-flex;align-items:center;gap:.2rem;padding:.25rem .6rem;border-radius:20px;font-size:.6rem;font-weight:800;letter-spacing:1.2px;text-transform:uppercase}
.pt-spec.strength{background:rgba(248,113,113,.08);border:1px solid rgba(248,113,113,.2);color:#f87171}
.pt-spec.cardio{background:rgba(96,165,250,.08);border:1px solid rgba(96,165,250,.2);color:#60a5fa}
.pt-spec.yoga{background:rgba(167,139,250,.08);border:1px solid rgba(167,139,250,.2);color:#a78bfa}
.pt-spec.hiit{background:rgba(251,191,36,.08);border:1px solid rgba(251,191,36,.2);color:#fbbf24}
.pt-spec.crossfit{background:rgba(244,114,182,.08);border:1px solid rgba(244,114,182,.2);color:#f472b6}
.pt-spec.dance{background:rgba(52,211,153,.08);border:1px solid rgba(52,211,153,.2);color:#34d399}
.pt-spec.boxing{background:rgba(45,212,191,.08);border:1px solid rgba(45,212,191,.2);color:#2dd4bf}
.pt-spec.pilates{background:rgba(251,146,60,.08);border:1px solid rgba(251,146,60,.2);color:#fb923c}
.pt-spec.functional{background:rgba(var(--accent-rgb),.06);border:1px solid rgba(var(--accent-rgb),.15);color:var(--accent)}
.pt-cert{display:inline-flex;align-items:center;gap:.25rem;padding:.2rem .5rem;border-radius:6px;font-size:.58rem;font-weight:700;background:rgba(var(--accent-rgb),.06);color:var(--accent);letter-spacing:.3px}
.pt-cert i{font-size:.6rem}

/* ── CTA ── */
.pt-cta{text-align:center;padding:4rem 2rem;position:relative}
.pt-cta::before{content:'';position:absolute;inset:0;background:radial-gradient(ellipse at 50% 100%, rgba(var(--accent-rgb),.04) 0%, transparent 60%)}
.pt-cta h2{font-family:var(--font-display);font-size:2rem;letter-spacing:3px;margin-bottom:.5rem}
.pt-cta h2 span{color:var(--accent)}
.pt-cta p{color:var(--gray);font-size:.88rem;max-width:500px;margin:0 auto 1.5rem}
.pt-cta-btn{display:inline-flex;align-items:center;gap:.5rem;padding:.8rem 2rem;border-radius:50px;background:var(--accent);color:#000;font-weight:800;font-size:.88rem;letter-spacing:.5px;transition:all .25s;border:none;cursor:pointer}
.pt-cta-btn:hover{transform:translateY(-2px);box-shadow:0 8px 30px rgba(200,240,61,.3)}

/* ── EMPTY ── */
.pt-empty{text-align:center;padding:5rem 2rem;color:var(--gray);grid-column:1/-1}
.pt-empty i{font-size:3.5rem;display:block;margin-bottom:1rem;opacity:.2}
.pt-empty h3{font-size:1.1rem;color:var(--white);margin-bottom:.3rem}

/* ── COUNT ── */
.pt-count{text-align:center;margin-bottom:1.5rem;font-size:.8rem;color:var(--gray)}
.pt-count b{color:var(--white)}

/* ── FOOTER ── */
.pt-footer{text-align:center;padding:2rem;border-top:1px solid var(--border);font-size:.72rem;color:rgba(255,255,255,.25)}
.pt-footer a{color:var(--accent)}

/* ── ANIMATIONS ── */
@keyframes fadeUp{from{opacity:0;transform:translateY(20px)}to{opacity:1;transform:translateY(0)}}
.pt-card{animation:fadeUp .5s ease both}
.pt-card:nth-child(1){animation-delay:.05s}
.pt-card:nth-child(2){animation-delay:.1s}
.pt-card:nth-child(3){animation-delay:.15s}
.pt-card:nth-child(4){animation-delay:.2s}
.pt-card:nth-child(5){animation-delay:.25s}
.pt-card:nth-child(6){animation-delay:.3s}
.pt-card:nth-child(7){animation-delay:.35s}
.pt-card:nth-child(8){animation-delay:.4s}
.pt-card:nth-child(9){animation-delay:.45s}

/* ── RESPONSIVE ── */
@media(max-width:768px){
  .pt-grid{grid-template-columns:1fr}
  .pt-stats{gap:1.5rem;flex-wrap:wrap}
  .pt-hero h1{font-size:2.5rem}
  .pt-card-details{grid-template-columns:1fr}
}
</style>
</head>
<body>

<!-- NAV -->
<nav class="pt-nav">
  <a href="${pageContext.request.contextPath}/landing.html" class="pt-brand">APEX<span>FITNESS</span></a>
</nav>

<!-- HERO -->
<section class="pt-hero">
  <div class="pt-hero-badge"><i class="bi bi-stars"></i> Certified Professionals</div>
  <h1>MEET OUR <span>ELITE TRAINERS</span></h1>
  <p>Every trainer at APEX FITNESS is handpicked, nationally certified, and passionate about helping you achieve your goals. Your transformation starts here.</p>
</section>

<!-- STATS -->
<div class="pt-stats">
  <div class="pt-stat">
    <div class="pt-stat-val">${trainers.size()}</div>
    <div class="pt-stat-label">Expert Trainers</div>
  </div>
  <div class="pt-stat">
    <div class="pt-stat-val" style="color:#60a5fa">6+</div>
    <div class="pt-stat-label">Specializations</div>
  </div>
  <div class="pt-stat">
    <div class="pt-stat-val" style="color:#34d399">100%</div>
    <div class="pt-stat-label">Certified</div>
  </div>
  <div class="pt-stat">
    <div class="pt-stat-val" style="color:#a78bfa">500+</div>
    <div class="pt-stat-label">Clients Trained</div>
  </div>
</div>

<!-- FILTERS -->
<div class="pt-filter-bar">
  <button class="pt-filter active" onclick="filterPT('all',this)">All Trainers</button>
  <button class="pt-filter" onclick="filterPT('Strength',this)">Strength</button>
  <button class="pt-filter" onclick="filterPT('Cardio',this)">Cardio</button>
  <button class="pt-filter" onclick="filterPT('Yoga',this)">Yoga</button>
  <button class="pt-filter" onclick="filterPT('HIIT',this)">HIIT</button>
  <button class="pt-filter" onclick="filterPT('CrossFit',this)">CrossFit</button>
  <button class="pt-filter" onclick="filterPT('Dance',this)">Dance</button>
  <button class="pt-filter" onclick="filterPT('Boxing',this)">Boxing</button>
</div>

<!-- COUNT -->
<div class="pt-count" id="ptCount">Showing <b>${trainers.size()}</b> trainers</div>

<!-- GRID -->
<div class="pt-container">
  <div class="pt-grid" id="ptGrid">
    <c:forEach var="t" items="${trainers}">
      <div class="pt-card" data-spec="${t.specialization}">
        <div class="pt-card-header">
          <div class="pt-card-avatar">${t.name.substring(0,1)}</div>
          <div class="pt-card-info">
            <h3>${t.name}</h3>
            <div class="pt-card-title">Fitness Coach</div>
          </div>
          <div class="pt-card-status"><i class="bi bi-circle-fill" style="font-size:.35rem"></i> Active</div>
        </div>
        <div class="pt-card-body">
          <div class="pt-card-details">
            <div class="pt-detail"><i class="bi bi-envelope-fill"></i> <strong>${t.email}</strong></div>
            <div class="pt-detail"><i class="bi bi-telephone-fill"></i> <strong>${t.phone}</strong></div>
          </div>
          <div class="pt-card-specs">
            <c:forTokens var="spec" items="${t.specialization}" delims="|,">
              <c:set var="specLower" value="${spec.trim().toLowerCase().replaceAll('[^a-z]','')}"/>
              <span class="pt-spec ${specLower == 'strengthtraining' || specLower == 'bodybuilding' ? 'strength' : specLower == 'cardio' ? 'cardio' : specLower == 'yoga' ? 'yoga' : specLower == 'hiit' ? 'hiit' : specLower == 'crossfit' ? 'crossfit' : specLower == 'zumba' || specLower == 'dancefitness' || specLower == 'dance' ? 'dance' : specLower == 'boxing' ? 'boxing' : specLower == 'pilates' ? 'pilates' : 'functional'}">${spec.trim()}</span>
            </c:forTokens>
            <c:if test="${not empty t.certifications}">
              <c:forTokens var="cert" items="${t.certifications}" delims="|,">
                <span class="pt-cert"><i class="bi bi-patch-check-fill"></i> ${cert.trim()}</span>
              </c:forTokens>
            </c:if>
          </div>
        </div>
      </div>
    </c:forEach>
    <c:if test="${empty trainers}">
      <div class="pt-empty">
        <i class="bi bi-person-badge"></i>
        <h3>No Trainers Available</h3>
        <p>Our team is being assembled. Check back soon for our elite lineup!</p>
      </div>
    </c:if>
  </div>
</div>

<!-- CTA -->
<section class="pt-cta">
  <h2>READY TO <span>TRANSFORM?</span></h2>
  <p>Work with our certified trainers and start your fitness journey today. First consultation is free.</p>
  <a href="${pageContext.request.contextPath}/landing.html#pricing" class="pt-cta-btn"><i class="bi bi-lightning-fill"></i> Join APEX Today</a>
</section>

<!-- FOOTER -->
<footer class="pt-footer">
  &copy; 2025 APEX FITNESS. All rights reserved. &nbsp;|&nbsp; <a href="${pageContext.request.contextPath}/landing.html">Back to Website</a>
</footer>

<script>
function filterPT(spec, btn) {
  document.querySelectorAll('.pt-filter').forEach(function(f) { f.classList.remove('active'); });
  btn.classList.add('active');
  var cards = document.querySelectorAll('.pt-card');
  var shown = 0, total = cards.length;
  cards.forEach(function(c, i) {
    var s = (c.dataset.spec || '').toLowerCase();
    var match = spec === 'all' || s.indexOf(spec.toLowerCase()) >= 0;
    c.style.display = match ? '' : 'none';
    if (match) {
      c.style.animation = 'fadeUp .4s ease ' + (shown * 0.05) + 's both';
      shown++;
    }
  });
  document.getElementById('ptCount').innerHTML = 'Showing <b>' + shown + '</b> of <b>' + total + '</b> trainers';
}
</script>
</body>
</html>
