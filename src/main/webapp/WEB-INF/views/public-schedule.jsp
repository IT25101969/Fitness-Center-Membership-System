<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width,initial-scale=1">
  <title>Class Schedule — APEX FITNESS</title>
  <link href="https://fonts.googleapis.com/css2?family=Bebas+Neue&family=Inter:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.min.css">
  <style>
    :root{--accent:#C8F03D;--accent-rgb:200,240,61;--black:#050506;--dark:#0a0a0c;--card:#101013;--card2:#141417;--border:rgba(255,255,255,.06);--gray:rgba(255,255,255,.4);--white:#fff;--font-display:'Bebas Neue',sans-serif;--font:'Inter',sans-serif;--radius:16px}
    *{margin:0;padding:0;box-sizing:border-box}
    html{scroll-behavior:smooth}
    body{background:var(--black);color:var(--white);font-family:var(--font);line-height:1.6;overflow-x:hidden}
    a{text-decoration:none;color:inherit}

    /* NAV */
    .sc-nav{position:fixed;top:0;left:0;right:0;z-index:100;height:60px;background:rgba(5,5,6,.92);backdrop-filter:blur(20px);border-bottom:1px solid var(--border);display:flex;align-items:center;justify-content:space-between;padding:0 2rem}
    .sc-brand{font-family:var(--font-display);font-size:1.4rem;letter-spacing:2px}.sc-brand span{color:var(--accent)}
    .sc-back{display:flex;align-items:center;gap:.4rem;color:rgba(255,255,255,.5);font-size:.82rem;font-weight:500;transition:color .2s}.sc-back:hover{color:var(--accent)}

    /* HERO */
    .sc-hero{position:relative;padding:9rem 2rem 4rem;text-align:center;overflow:hidden}
    .sc-hero::before{content:'';position:absolute;inset:0;background:radial-gradient(ellipse at 50% 0%,rgba(var(--accent-rgb),.06) 0%,transparent 60%)}
    .sc-hero-badge{display:inline-flex;align-items:center;gap:.4rem;padding:.4rem 1rem;border-radius:50px;font-size:.68rem;font-weight:700;letter-spacing:2px;text-transform:uppercase;color:var(--accent);background:rgba(var(--accent-rgb),.06);border:1px solid rgba(var(--accent-rgb),.15);margin-bottom:1.2rem}
    .sc-hero h1{font-family:var(--font-display);font-size:clamp(2.5rem,6vw,4.5rem);letter-spacing:4px;line-height:1;margin-bottom:.8rem}
    .sc-hero h1 em{color:var(--accent);font-style:normal}
    .sc-hero p{color:var(--gray);font-size:.95rem;max-width:550px;margin:0 auto}

    /* STATS */
    .sc-stats{display:flex;justify-content:center;gap:2.5rem;padding:2rem 2rem 1rem;flex-wrap:wrap}
    .sc-stat{text-align:center}
    .sc-stat-val{font-family:var(--font-display);font-size:2rem;letter-spacing:1px}
    .sc-stat-label{font-size:.62rem;color:var(--gray);letter-spacing:2px;text-transform:uppercase;margin-top:.1rem}

    /* LIVE INDICATOR */
    .live-ind{display:inline-flex;align-items:center;gap:.35rem;font-size:.68rem;font-weight:700;color:#34d399;padding:.3rem .8rem;border-radius:50px;background:rgba(52,211,153,.06);border:1px solid rgba(52,211,153,.12)}
    .live-dot{width:6px;height:6px;border-radius:50%;background:#34d399;animation:pulse 2s ease infinite}
    @keyframes pulse{0%,100%{box-shadow:0 0 0 0 rgba(52,211,153,.4)}50%{box-shadow:0 0 0 5px rgba(52,211,153,0)}}

    /* FILTER */
    .sc-filter{display:flex;justify-content:center;gap:.5rem;flex-wrap:wrap;padding:1rem 2rem 2rem}
    .sc-fbtn{padding:.45rem 1.1rem;border-radius:50px;border:1px solid var(--border);background:transparent;color:var(--gray);font-size:.75rem;font-weight:600;cursor:pointer;transition:all .25s;font-family:var(--font)}
    .sc-fbtn:hover{border-color:rgba(var(--accent-rgb),.3);color:var(--white)}
    .sc-fbtn.active{background:var(--accent);color:#000;border-color:var(--accent);box-shadow:0 4px 20px rgba(var(--accent-rgb),.2)}

    /* GRID */
    .sc-container{max-width:1300px;margin:0 auto;padding:0 2rem 4rem}
    .sc-count{text-align:center;margin-bottom:1.5rem;font-size:.78rem;color:var(--gray)}.sc-count b{color:var(--white)}
    .sc-grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(340px,1fr));gap:1.5rem}

    /* CARD */
    .sc-card{background:var(--card);border:1px solid var(--border);border-radius:var(--radius);overflow:hidden;transition:all .35s cubic-bezier(.4,0,.2,1)}
    .sc-card:hover{border-color:rgba(var(--accent-rgb),.25);transform:translateY(-5px);box-shadow:0 20px 60px rgba(0,0,0,.5)}
    .sc-card-img{position:relative;height:180px;overflow:hidden}
    .sc-card-img img{width:100%;height:100%;object-fit:cover;transition:transform .5s}
    .sc-card:hover .sc-card-img img{transform:scale(1.06)}
    .sc-card-img::after{content:'';position:absolute;bottom:0;left:0;right:0;height:60%;background:linear-gradient(transparent,rgba(0,0,0,.8))}
    .sc-level{position:absolute;top:.7rem;left:.7rem;z-index:2;padding:.25rem .6rem;border-radius:6px;font-size:.58rem;font-weight:800;letter-spacing:1.5px;text-transform:uppercase;background:rgba(var(--accent-rgb),.15);backdrop-filter:blur(8px);color:var(--accent);border:1px solid rgba(var(--accent-rgb),.25)}
    .sc-seats{position:absolute;top:.7rem;right:.7rem;z-index:2;display:flex;align-items:center;gap:.3rem;padding:.25rem .6rem;border-radius:6px;font-size:.62rem;font-weight:700;backdrop-filter:blur(8px)}
    .sc-seats.open{background:rgba(52,211,153,.1);color:#34d399;border:1px solid rgba(52,211,153,.2)}
    .sc-seats.limited{background:rgba(251,191,36,.1);color:#fbbf24;border:1px solid rgba(251,191,36,.2)}
    .sc-seats.full-s{background:rgba(248,113,113,.1);color:#f87171;border:1px solid rgba(248,113,113,.2)}

    /* Card body */
    .sc-body{padding:1.2rem 1.2rem 1rem}
    .sc-status{display:inline-flex;align-items:center;gap:.25rem;padding:.2rem .6rem;border-radius:50px;font-size:.58rem;font-weight:700;letter-spacing:1px;text-transform:uppercase;margin-bottom:.4rem}
    .sc-status.open{background:rgba(var(--accent-rgb),.08);color:var(--accent);border:1px solid rgba(var(--accent-rgb),.15)}
    .sc-status.full{background:rgba(248,113,113,.08);color:#f87171;border:1px solid rgba(248,113,113,.15)}
    .sc-status.cancelled{background:rgba(136,136,136,.08);color:#888;border:1px solid rgba(136,136,136,.15)}
    .sc-card h3{font-family:var(--font-display);font-size:1.4rem;letter-spacing:1px;margin-bottom:.2rem}
    .sc-coach{font-size:.76rem;color:var(--gray);display:flex;align-items:center;gap:.35rem;margin-bottom:.8rem}
    .sc-coach i{color:rgba(var(--accent-rgb),.5);font-size:.8rem}

    /* Capacity */
    .sc-cap{margin-bottom:.8rem}
    .sc-cap-top{display:flex;justify-content:space-between;font-size:.65rem;margin-bottom:.25rem}
    .sc-cap-top span{color:var(--gray)}.sc-cap-top strong{color:var(--white)}
    .sc-cap-bar{height:4px;border-radius:10px;background:rgba(255,255,255,.06);overflow:hidden}
    .sc-cap-fill{height:100%;border-radius:10px;transition:width .8s cubic-bezier(.4,0,.2,1)}
    .sc-cap-fill.low{background:linear-gradient(90deg,var(--accent),#a3e635)}
    .sc-cap-fill.mid{background:linear-gradient(90deg,#fbbf24,#f59e0b)}
    .sc-cap-fill.high{background:linear-gradient(90deg,#f87171,#ef4444)}

    /* Meta */
    .sc-meta{display:flex;gap:.5rem;flex-wrap:wrap;margin-bottom:.8rem}
    .sc-chip{display:flex;align-items:center;gap:.25rem;padding:.22rem .55rem;border-radius:6px;font-size:.68rem;color:rgba(255,255,255,.5);background:rgba(255,255,255,.03);border:1px solid rgba(255,255,255,.04)}
    .sc-chip i{color:rgba(var(--accent-rgb),.5);font-size:.7rem}

    /* Book btn */
    .sc-book{display:flex;align-items:center;justify-content:center;gap:.4rem;width:100%;padding:.6rem;border-radius:10px;font-size:.76rem;font-weight:700;border:none;cursor:pointer;transition:all .25s;font-family:var(--font);letter-spacing:.3px}
    .sc-book.open{background:var(--accent);color:#000}
    .sc-book.open:hover{box-shadow:0 6px 20px rgba(var(--accent-rgb),.3);transform:translateY(-1px)}
    .sc-book.full{background:rgba(255,255,255,.04);color:rgba(255,255,255,.25);cursor:not-allowed}
    .sc-book.cancelled{background:rgba(136,136,136,.06);color:rgba(136,136,136,.5);cursor:not-allowed}

    /* EMPTY */
    .sc-empty{text-align:center;padding:4rem 2rem;color:var(--gray);grid-column:1/-1}
    .sc-empty i{font-size:3rem;display:block;margin-bottom:.8rem;opacity:.2}
    .sc-empty h3{font-size:1rem;color:var(--white);margin-bottom:.3rem}

    /* MODAL */
    .sc-modal-bg{position:fixed;inset:0;z-index:1000;background:rgba(0,0,0,.8);backdrop-filter:blur(8px);display:flex;align-items:center;justify-content:center;opacity:0;pointer-events:none;transition:opacity .3s}
    .sc-modal-bg.active{opacity:1;pointer-events:auto}
    .sc-modal{background:var(--card);border:1px solid var(--border);border-radius:var(--radius);width:100%;max-width:420px;padding:2rem;position:relative;transform:translateY(20px);transition:transform .3s}
    .sc-modal-bg.active .sc-modal{transform:translateY(0)}
    .sc-modal-close{position:absolute;top:1rem;right:1rem;background:none;border:none;color:var(--gray);font-size:1.2rem;cursor:pointer}.sc-modal-close:hover{color:var(--white)}
    .sc-modal h2{font-family:var(--font-display);font-size:1.8rem;letter-spacing:2px;margin-bottom:.8rem}
    .sc-modal-info{background:rgba(255,255,255,.03);border:1px solid rgba(255,255,255,.05);border-radius:12px;padding:1rem;margin-bottom:1.2rem}
    .sc-modal-row{display:flex;justify-content:space-between;margin-bottom:.4rem;font-size:.82rem}.sc-modal-row:last-child{margin-bottom:0}
    .sc-modal-row span{color:var(--gray)}.sc-modal-row strong{color:var(--white)}
    .sc-fg{margin-bottom:1rem}.sc-fg label{display:block;font-size:.76rem;color:var(--gray);margin-bottom:.35rem}
    .sc-input{width:100%;background:rgba(0,0,0,.5);border:1px solid var(--border);color:var(--white);padding:.75rem;border-radius:8px;font-family:var(--font)}.sc-input:focus{outline:none;border-color:var(--accent)}
    .alert{padding:1rem;margin:1.5rem auto 0;max-width:600px;border-radius:8px;text-align:center;font-weight:600;font-size:.9rem}
    .alert-success{background:rgba(var(--accent-rgb),.08);color:var(--accent);border:1px solid rgba(var(--accent-rgb),.2)}
    .alert-danger{background:rgba(248,113,113,.08);color:#f87171;border:1px solid rgba(248,113,113,.2)}

    /* CTA */
    .sc-cta{text-align:center;padding:3rem 2rem;position:relative}
    .sc-cta h2{font-family:var(--font-display);font-size:2rem;letter-spacing:3px;margin-bottom:.4rem}
    .sc-cta h2 em{color:var(--accent);font-style:normal}
    .sc-cta p{color:var(--gray);font-size:.85rem;max-width:450px;margin:0 auto 1.2rem}
    .sc-cta-btn{display:inline-flex;align-items:center;gap:.5rem;padding:.75rem 1.8rem;border-radius:50px;background:var(--accent);color:#000;font-weight:800;font-size:.85rem;border:none;cursor:pointer;transition:all .25s}
    .sc-cta-btn:hover{transform:translateY(-2px);box-shadow:0 8px 30px rgba(var(--accent-rgb),.3)}

    /* FOOTER */
    .sc-footer{text-align:center;padding:1.5rem;border-top:1px solid var(--border);font-size:.7rem;color:rgba(255,255,255,.2)}
    .sc-footer a{color:var(--accent)}

    /* ANIMATIONS */
    @keyframes fadeUp{from{opacity:0;transform:translateY(20px)}to{opacity:1;transform:translateY(0)}}
    .sc-card{animation:fadeUp .5s ease both}
    .sc-card:nth-child(1){animation-delay:.05s}.sc-card:nth-child(2){animation-delay:.1s}.sc-card:nth-child(3){animation-delay:.15s}
    .sc-card:nth-child(4){animation-delay:.2s}.sc-card:nth-child(5){animation-delay:.25s}.sc-card:nth-child(6){animation-delay:.3s}

    @media(max-width:768px){
      .sc-grid{grid-template-columns:1fr}
      .sc-hero h1{font-size:2.5rem}
      .sc-stats{gap:1.2rem}
      .sc-container,.sc-filter{padding-left:1rem;padding-right:1rem}
    }
  </style>
</head>
<body>

<nav class="sc-nav">
  <a href="${pageContext.request.contextPath}/landing.html" class="sc-brand">APEX<span>FITNESS</span></a>
  <a href="${pageContext.request.contextPath}/landing.html" class="sc-back"><i class="bi bi-arrow-left"></i> Back to Home</a>
</nav>

<!-- HERO -->
<section class="sc-hero">
  <div class="sc-hero-badge"><i class="bi bi-broadcast"></i> Live Availability</div>
  <h1>WEEKLY <em>CLASS</em> SCHEDULE</h1>
  <p>Browse all classes, check real-time seat availability, and book your spot instantly.</p>
</section>

<!-- ALERTS -->
<c:if test="${param.msg == 'booked'}">
  <div class="alert alert-success"><i class="bi bi-check-circle"></i> Successfully booked! See you in class.</div>
</c:if>
<c:if test="${param.msg == 'full'}">
  <div class="alert alert-danger"><i class="bi bi-x-circle"></i> Sorry, this class is now full.</div>
</c:if>

<!-- STATS -->
<div class="sc-stats">
  <div class="sc-stat"><div class="sc-stat-val" style="color:var(--accent)">${allClasses.size()}</div><div class="sc-stat-label">Total Classes</div></div>
  <div class="sc-stat"><div class="sc-stat-val" style="color:#60a5fa">${fn:length(days)}</div><div class="sc-stat-label">Days Active</div></div>
  <div class="sc-stat"><div class="sc-stat-val" style="color:#34d399">
    <c:set var="openCount" value="0"/>
    <c:forEach var="fc" items="${allClasses}"><c:if test="${!fc.full && fc.status != 'CANCELLED'}"><c:set var="openCount" value="${openCount + 1}"/></c:if></c:forEach>${openCount}
  </div><div class="sc-stat-label">Open Now</div></div>
  <div class="sc-stat"><div class="live-ind"><span class="live-dot"></span> Live Updates</div><div class="sc-stat-label" style="margin-top:.3rem">Auto-refresh</div></div>
</div>

<!-- FILTER -->
<div class="sc-filter">
  <button class="sc-fbtn active" onclick="filterSC('all',this)">All Days</button>
  <c:forEach var="day" items="${days}">
    <button class="sc-fbtn" onclick="filterSC('${day}',this)">${day}</button>
  </c:forEach>
</div>

<!-- GRID -->
<div class="sc-container">
  <div class="sc-count" id="scCount">Showing <b>${allClasses.size()}</b> classes</div>
  <div class="sc-grid" id="scGrid">
    <c:choose>
      <c:when test="${empty allClasses}">
        <div class="sc-empty"><i class="bi bi-calendar-x"></i><h3>No Classes Scheduled</h3><p>Check back soon — we're building the timetable.</p></div>
      </c:when>
      <c:otherwise>
        <c:forEach var="fc" items="${allClasses}" varStatus="vs">
          <c:set var="pct" value="${fc.capacityPercent}"/>
          <c:set var="isFull" value="${fc.full}"/>
          <c:set var="isCancelled" value="${fc.status == 'CANCELLED'}"/>
          <c:set var="avail" value="${fc.capacity - fc.enrolled}"/>
          <c:set var="nm" value="${fc.className}"/>

          <div class="sc-card" data-day="${fc.scheduleDay}" data-name="${nm}">
            <!-- Image -->
            <div class="sc-card-img">
              <img src="${pageContext.request.contextPath}/static/images/<c:choose><c:when test="${fn:containsIgnoreCase(nm,'cardio') || fn:containsIgnoreCase(nm,'hiit')}">workout-class.png</c:when><c:when test="${fn:containsIgnoreCase(nm,'strength') || fn:containsIgnoreCase(nm,'power')}">gym-interior.png</c:when><c:otherwise>trainer.png</c:otherwise></c:choose>" alt="${nm}">
              <span class="sc-level"><c:choose><c:when test="${fn:containsIgnoreCase(nm,'hiit') || fn:containsIgnoreCase(nm,'crossfit')}">Advanced</c:when><c:when test="${fn:containsIgnoreCase(nm,'cardio') || fn:containsIgnoreCase(nm,'strength')}">Intermediate</c:when><c:otherwise>All Levels</c:otherwise></c:choose></span>
              <span class="sc-seats <c:choose><c:when test="${isFull}">full-s</c:when><c:when test="${pct >= 80}">limited</c:when><c:otherwise>open</c:otherwise></c:choose>">
                <span class="live-dot"></span>
                <c:choose><c:when test="${isFull}">Full</c:when><c:when test="${isCancelled}">Cancelled</c:when><c:otherwise>${avail} seats left</c:otherwise></c:choose>
              </span>
            </div>

            <!-- Body -->
            <div class="sc-body">
              <span class="sc-status <c:choose><c:when test="${isCancelled}">cancelled</c:when><c:when test="${isFull}">full</c:when><c:otherwise>open</c:otherwise></c:choose>">
                <i class="bi <c:choose><c:when test="${isFull}">bi-x-circle</c:when><c:when test="${isCancelled}">bi-slash-circle</c:when><c:otherwise>bi-check-circle</c:otherwise></c:choose>" style="font-size:.5rem"></i>
                <c:choose><c:when test="${isFull}">Full</c:when><c:when test="${isCancelled}">Cancelled</c:when><c:otherwise>Open</c:otherwise></c:choose>
              </span>
              <h3>${nm}</h3>
              <div class="sc-coach"><i class="bi bi-person-badge-fill"></i> Coach ${not empty fc.trainerName ? fc.trainerName : 'TBA'}</div>

              <!-- Capacity bar -->
              <div class="sc-cap">
                <div class="sc-cap-top"><span>Capacity</span><strong>${fc.enrolled} / ${fc.capacity}</strong></div>
                <div class="sc-cap-bar"><div class="sc-cap-fill <c:choose><c:when test="${pct >= 90}">high</c:when><c:when test="${pct >= 70}">mid</c:when><c:otherwise>low</c:otherwise></c:choose>" data-w="${pct}" style="width:0%"></div></div>
              </div>

              <!-- Meta chips -->
              <div class="sc-meta">
                <span class="sc-chip"><i class="bi bi-calendar3"></i> ${fc.scheduleDay}</span>
                <span class="sc-chip"><i class="bi bi-clock"></i> ${fc.scheduleTime}</span>
                <span class="sc-chip"><i class="bi bi-people-fill"></i> ${fc.capacity} spots</span>
                <c:if test="${not isFull && not isCancelled}">
                  <span class="sc-chip" style="color:#34d399;border-color:rgba(52,211,153,.15)"><i class="bi bi-lightning-fill" style="color:#34d399"></i> ${avail} available</span>
                </c:if>
              </div>

              <!-- Book button -->
              <c:choose>
                <c:when test="${isCancelled}">
                  <button class="sc-book cancelled" disabled><i class="bi bi-slash-circle"></i> Cancelled</button>
                </c:when>
                <c:when test="${isFull}">
                  <button class="sc-book full" disabled><i class="bi bi-x-circle"></i> Class Full</button>
                </c:when>
                <c:otherwise>
                  <button class="sc-book open" onclick="openBook('${fc.classId}','${fc.className}','${fc.scheduleDay} ${fc.scheduleTime}','${fc.trainerName}','${avail}')">
                    <i class="bi bi-calendar-check"></i> Book This Class
                  </button>
                </c:otherwise>
              </c:choose>
            </div>
          </div>
        </c:forEach>
      </c:otherwise>
    </c:choose>
  </div>
</div>

<!-- CTA -->
<section class="sc-cta">
  <h2>READY TO <em>TRAIN?</em></h2>
  <p>Join APEX FITNESS today and get access to all classes with your membership.</p>
  <a href="${pageContext.request.contextPath}/landing.html#pricing" class="sc-cta-btn"><i class="bi bi-lightning-fill"></i> View Plans</a>
</section>

<!-- BOOKING MODAL -->
<div class="sc-modal-bg" id="bookModal">
  <div class="sc-modal">
    <button class="sc-modal-close" onclick="closeBook()"><i class="bi bi-x-lg"></i></button>
    <h2>Book Class</h2>
    <div class="sc-modal-info">
      <div class="sc-modal-row"><span>Class:</span><strong id="bmName"></strong></div>
      <div class="sc-modal-row"><span>Time:</span><strong id="bmTime"></strong></div>
      <div class="sc-modal-row"><span>Coach:</span><strong id="bmCoach"></strong></div>
      <div class="sc-modal-row"><span>Spots Left:</span><strong id="bmSpots" style="color:var(--accent)"></strong></div>
    </div>
    <form action="${pageContext.request.contextPath}/schedule/book" method="post">
      <input type="hidden" name="classId" id="bmId">
      <div class="sc-fg">
        <label>Your Name</label>
        <input type="text" name="guestName" class="sc-input" placeholder="Enter your full name" required>
      </div>
      <button type="submit" class="sc-book open" style="padding:.8rem;font-size:.88rem"><i class="bi bi-calendar-check"></i> Confirm Booking</button>
    </form>
  </div>
</div>

<footer class="sc-footer">&copy; 2025 APEX FITNESS. All rights reserved. &nbsp;|&nbsp; <a href="${pageContext.request.contextPath}/landing.html">Back to Website</a></footer>

<script>
function openBook(id,name,time,coach,spots){
  document.getElementById('bmId').value=id;
  document.getElementById('bmName').innerText=name;
  document.getElementById('bmTime').innerText=time;
  document.getElementById('bmCoach').innerText=coach||'TBA';
  document.getElementById('bmSpots').innerText=spots;
  document.getElementById('bookModal').classList.add('active');
}
function closeBook(){document.getElementById('bookModal').classList.remove('active')}

function filterSC(day,btn){
  document.querySelectorAll('.sc-fbtn').forEach(function(f){f.classList.remove('active')});
  btn.classList.add('active');
  var cards=document.querySelectorAll('.sc-card'),shown=0;
  cards.forEach(function(c,i){
    var match=day==='all'||c.dataset.day===day;
    c.style.display=match?'':'none';
    if(match){c.style.animation='fadeUp .4s ease '+(shown*0.05)+'s both';shown++}
  });
  document.getElementById('scCount').innerHTML='Showing <b>'+shown+'</b> of <b>'+cards.length+'</b> classes';
}

// Animate capacity bars
window.addEventListener('load',function(){
  document.querySelectorAll('.sc-cap-fill').forEach(function(bar){
    var w=bar.dataset.w;bar.style.width='0';
    setTimeout(function(){bar.style.width=w+'%'},300);
  });
});

// Auto-refresh every 30s
setInterval(function(){location.reload()},30000);
</script>
</body>
</html>
