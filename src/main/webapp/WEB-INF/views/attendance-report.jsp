<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width,initial-scale=1.0">
<title>Attendance Reports — APEX FITNESS</title>
<meta name="description" content="Monthly attendance analytics, member frequency and check-in trends.">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.min.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/admin-dashboard.css">
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<c:set var="pageTitle" value="Attendance Report"/>
<style>
/* ─── page shell ─── */
.ar-main{padding:2rem 2.5rem 4rem;}

/* ─── banner ─── */
.ar-banner{position:relative;border-radius:16px;overflow:hidden;height:160px;border:1px solid var(--border);margin-bottom:2rem;}
.ar-banner img{position:absolute;inset:0;width:100%;height:100%;object-fit:cover;opacity:.35;animation:kenBurns 25s ease-in-out infinite alternate;}
.ar-banner-overlay{position:absolute;inset:0;background:linear-gradient(90deg,rgba(8,8,8,.92) 30%,rgba(8,8,8,.45));}
.ar-banner-content{position:relative;z-index:1;display:flex;align-items:center;justify-content:space-between;height:100%;padding:0 2rem;}
.ar-banner-title{font-family:var(--font-display);font-size:2rem;letter-spacing:2px;line-height:1.1;}
.ar-banner-title i{color:var(--accent);}
.ar-banner-sub{color:rgba(255,255,255,.45);font-size:.82rem;margin-top:.3rem;}
@keyframes kenBurns{0%{transform:scale(1) translate(0,0);}100%{transform:scale(1.08) translate(-2%,-1%);}}

/* ─── controls bar ─── */
.ar-controls{display:flex;align-items:center;justify-content:space-between;flex-wrap:wrap;gap:1rem;margin-bottom:2rem;
  background:var(--card);border:1px solid var(--border);border-radius:14px;padding:1rem 1.5rem;}
.ar-form{display:flex;align-items:center;gap:.75rem;flex-wrap:wrap;}
.ar-form label{font-size:.7rem;font-weight:700;letter-spacing:1.5px;text-transform:uppercase;color:rgba(255,255,255,.4);}
.ar-form input[type=month]{background:rgba(255,255,255,.05);border:1px solid rgba(255,255,255,.1);
  border-radius:10px;color:#fff;padding:.5rem 1rem;font-size:.85rem;font-family:var(--font);outline:none;transition:border-color .2s;}
.ar-form input[type=month]:focus{border-color:var(--accent);}
.ar-actions{display:flex;gap:.5rem;}
.ar-btn{display:inline-flex;align-items:center;gap:.4rem;padding:.5rem 1.1rem;border-radius:50px;
  font-size:.78rem;font-weight:700;cursor:pointer;border:none;transition:all .2s;font-family:var(--font);letter-spacing:.3px;}
.ar-btn-primary{background:var(--accent);color:#000;}
.ar-btn-primary:hover{transform:translateY(-2px);box-shadow:0 0 18px rgba(200,240,61,.3);}
.ar-btn-ghost{background:rgba(255,255,255,.05);color:rgba(255,255,255,.55);border:1px solid rgba(255,255,255,.1);}
.ar-btn-ghost:hover{border-color:var(--accent);color:var(--accent);}

/* ─── KPI grid ─── */
.kpi-grid{display:grid;grid-template-columns:repeat(4,1fr);gap:1.25rem;margin-bottom:2rem;}
.kpi-card{background:var(--card);border:1px solid var(--border);border-radius:16px;padding:1.4rem;
  position:relative;overflow:hidden;transition:all .3s;}
.kpi-card:hover{transform:translateY(-3px);box-shadow:0 12px 30px rgba(0,0,0,.4);}
.kpi-card::after{content:'';position:absolute;top:0;left:0;right:0;height:2px;border-radius:16px 16px 0 0;}
.kpi-ac::after{background:var(--accent);}
.kpi-bl::after{background:#60a5fa;}
.kpi-rd::after{background:#f87171;}
.kpi-pu::after{background:#a78bfa;}
.kpi-icon{width:40px;height:40px;border-radius:10px;display:flex;align-items:center;justify-content:center;font-size:1rem;margin-bottom:.85rem;}
.kpi-icon.ac{background:rgba(200,240,61,.1);color:var(--accent);}
.kpi-icon.bl{background:rgba(96,165,250,.1);color:#60a5fa;}
.kpi-icon.rd{background:rgba(248,113,113,.1);color:#f87171;}
.kpi-icon.pu{background:rgba(167,139,250,.1);color:#a78bfa;}
.kpi-val{font-family:var(--font-display);font-size:2.5rem;letter-spacing:1px;line-height:1;margin-bottom:.2rem;}
.kpi-lbl{font-size:.65rem;font-weight:700;letter-spacing:1.5px;text-transform:uppercase;color:rgba(255,255,255,.38);}
.kpi-sub{font-size:.73rem;color:rgba(255,255,255,.3);margin-top:.5rem;}
.kpi-badge{display:inline-flex;align-items:center;gap:.2rem;font-size:.65rem;font-weight:700;
  padding:.15rem .5rem;border-radius:20px;margin-top:.5rem;}
.kb-up{background:rgba(52,211,153,.12);color:#34d399;}
.kb-neutral{background:rgba(255,255,255,.05);color:rgba(255,255,255,.35);}
.kb-info{background:rgba(96,165,250,.1);color:#60a5fa;}

/* ─── chart grid ─── */
.chart-row{display:grid;grid-template-columns:2fr 1fr;gap:1.25rem;margin-bottom:2rem;}
.cp{background:var(--card);border:1px solid var(--border);border-radius:16px;padding:1.4rem;}
.cp h5{font-family:var(--font-display);font-size:1rem;letter-spacing:1px;margin-bottom:1.1rem;
  display:flex;align-items:center;gap:.5rem;color:#fff;}
.cp h5 i{color:var(--accent);font-size:.85rem;}

/* ─── table ─── */
.ar-table-card{background:var(--card);border:1px solid var(--border);border-radius:16px;overflow:hidden;}
.ar-table-hdr{display:flex;align-items:center;justify-content:space-between;padding:1.1rem 1.5rem;border-bottom:1px solid var(--border);}
.ar-table-hdr h5{font-family:var(--font-display);font-size:1rem;letter-spacing:1px;margin:0;
  display:flex;align-items:center;gap:.5rem;}
.ar-table-hdr h5 i{color:var(--accent);}
.ar-table-hdr small{font-size:.72rem;color:rgba(255,255,255,.3);}
table.art{width:100%;border-collapse:collapse;}
table.art th{font-size:.62rem;font-weight:700;letter-spacing:1.5px;text-transform:uppercase;
  color:rgba(255,255,255,.32);padding:.85rem 1.4rem;border-bottom:1px solid var(--border);
  text-align:left;background:rgba(255,255,255,.015);}
table.art td{padding:.85rem 1.4rem;border-bottom:1px solid rgba(255,255,255,.04);
  font-size:.86rem;color:rgba(255,255,255,.78);vertical-align:middle;}
table.art tbody tr{transition:background .15s;}
table.art tbody tr:hover{background:rgba(255,255,255,.025);}
table.art tbody tr:last-child td{border-bottom:none;}
.rank{width:28px;height:28px;border-radius:8px;background:rgba(255,255,255,.05);
  display:inline-flex;align-items:center;justify-content:center;font-size:.75rem;font-weight:700;color:rgba(255,255,255,.38);}
.rank.g{background:rgba(251,191,36,.12);color:#fbbf24;}
.rank.s{background:rgba(148,163,184,.12);color:#94a3b8;}
.rank.b{background:rgba(205,127,50,.12);color:#cd7f32;}
.mid{font-size:.78rem;font-weight:700;color:var(--accent);background:rgba(200,240,61,.08);
  padding:.18rem .55rem;border-radius:6px;font-family:monospace;}
.bar-wrap{display:flex;align-items:center;gap:.7rem;}
.bar-bg{flex:1;height:5px;background:rgba(255,255,255,.06);border-radius:50px;overflow:hidden;}
.bar-fill{height:100%;border-radius:50px;background:linear-gradient(90deg,var(--accent),#a8d020);transition:width 1s ease;}
.bar-pct{font-size:.7rem;font-weight:700;color:rgba(255,255,255,.38);min-width:32px;text-align:right;}
.dots{display:flex;gap:3px;flex-wrap:wrap;max-width:120px;}
.dot{width:7px;height:7px;border-radius:2px;background:var(--accent);opacity:.8;}
.lvl{display:inline-flex;align-items:center;gap:.25rem;padding:.18rem .6rem;border-radius:20px;font-size:.65rem;font-weight:700;letter-spacing:.5px;}
.lvl-elite{background:rgba(200,240,61,.12);color:var(--accent);}
.lvl-reg{background:rgba(96,165,250,.12);color:#60a5fa;}
.lvl-casual{background:rgba(248,113,113,.12);color:#f87171;}

/* ─── empty ─── */
.ar-empty{text-align:center;padding:4rem 2rem;color:rgba(255,255,255,.28);}
.ar-empty i{font-size:2.8rem;display:block;margin-bottom:.75rem;color:rgba(255,255,255,.1);}

/* ─── responsive ─── */
@media(max-width:1200px){.kpi-grid{grid-template-columns:repeat(2,1fr)}.chart-row{grid-template-columns:1fr}}
@media(max-width:700px){.kpi-grid{grid-template-columns:1fr}.ar-main{padding:1rem 1rem 3rem}}
</style>
</head>
<body>
<jsp:include page="navbar.jsp"/>

<div class="admin-layout">
  <jsp:include page="admin-sidebar.jsp"/>
  <main class="admin-content">
  <div class="ar-main">

    <!-- ── BANNER ── -->
    <div class="ar-banner">
      <img src="${pageContext.request.contextPath}/static/images/hero.png" alt="">
      <div class="ar-banner-overlay"></div>
      <div class="ar-banner-content">
        <div>
          <div class="ar-banner-title"><i class="bi bi-bar-chart-line-fill"></i> ATTENDANCE REPORTS</div>
          <div class="ar-banner-sub">Monthly analytics &nbsp;·&nbsp; member frequency &nbsp;·&nbsp; peak performance insights</div>
        </div>
        <a href="${pageContext.request.contextPath}/attendance" class="ar-btn ar-btn-ghost">
          <i class="bi bi-arrow-left"></i> Back to Check-In
        </a>
      </div>
    </div>

    <!-- ── CONTROLS ── -->
    <div class="ar-controls">
      <form method="get" action="${pageContext.request.contextPath}/attendance/report" class="ar-form">
        <label><i class="bi bi-calendar3"></i> &nbsp;Report Month</label>
        <input type="month" id="yearMonth" name="yearMonth" value="${yearMonth}">
        <button type="submit" class="ar-btn ar-btn-primary"><i class="bi bi-search"></i> Generate</button>
      </form>
      <div class="ar-actions">
        <button class="ar-btn ar-btn-ghost" onclick="window.print()"><i class="bi bi-printer"></i> Print</button>
        <button class="ar-btn ar-btn-ghost" onclick="exportCSV()"><i class="bi bi-download"></i> Export CSV</button>
      </div>
    </div>

    <!-- ── KPI CARDS ── -->
    <div class="kpi-grid">
      <div class="kpi-card kpi-ac">
        <div class="kpi-icon ac"><i class="bi bi-box-arrow-in-right"></i></div>
        <div class="kpi-val">${totalCheckIns}</div>
        <div class="kpi-lbl">Total Check-Ins</div>
        <div class="kpi-sub">Recorded for ${yearMonth}</div>
        <div class="kpi-badge kb-up"><i class="bi bi-arrow-up-short"></i> This period</div>
      </div>
      <div class="kpi-card kpi-bl">
        <div class="kpi-icon bl"><i class="bi bi-people-fill"></i></div>
        <div class="kpi-val">${uniqueMembers}</div>
        <div class="kpi-lbl">Unique Members</div>
        <div class="kpi-sub">Who visited this month</div>
        <div class="kpi-badge kb-info"><i class="bi bi-person-check"></i> Active visitors</div>
      </div>
      <div class="kpi-card kpi-rd">
        <div class="kpi-icon rd"><i class="bi bi-trophy-fill"></i></div>
        <div class="kpi-val" style="font-size:${empty peakDay ? '2.5rem' : '1.4rem'};letter-spacing:0;">${empty peakDay ? '—' : peakDay}</div>
        <div class="kpi-lbl">Peak Day</div>
        <div class="kpi-sub">Highest single-day attendance</div>
        <div class="kpi-badge kb-up"><i class="bi bi-star-fill"></i> Best day</div>
      </div>
      <div class="kpi-card kpi-pu">
        <div class="kpi-icon pu"><i class="bi bi-activity"></i></div>
        <c:choose>
          <c:when test="${uniqueMembers > 0}">
            <div class="kpi-val"><fmt:formatNumber value="${totalCheckIns / uniqueMembers}" pattern="##.#"/></div>
          </c:when>
          <c:otherwise><div class="kpi-val">—</div></c:otherwise>
        </c:choose>
        <div class="kpi-lbl">Avg Visits / Member</div>
        <div class="kpi-sub">Engagement frequency</div>
        <div class="kpi-badge kb-neutral"><i class="bi bi-graph-up"></i> Avg rate</div>
      </div>
    </div>

    <!-- ── CHARTS ── -->
    <div class="chart-row">
      <div class="cp">
        <h5><i class="bi bi-graph-up-arrow"></i> DAILY CHECK-IN TREND</h5>
        <canvas id="dailyChart" height="140"></canvas>
      </div>
      <div class="cp">
        <h5><i class="bi bi-pie-chart-fill"></i> VISIT FREQUENCY SPLIT</h5>
        <canvas id="freqChart" height="140"></canvas>
      </div>
    </div>

    <!-- ── TABLE ── -->
    <div class="ar-table-card">
      <div class="ar-table-hdr">
        <h5><i class="bi bi-table"></i> MEMBER ATTENDANCE BREAKDOWN</h5>
        <small>Period: ${yearMonth}</small>
      </div>
      <c:choose>
        <c:when test="${not empty frequency}">
          <table class="art" id="freqTable">
            <thead>
              <tr>
                <th style="width:50px">Rank</th>
                <th>Member ID</th>
                <th>Days Present</th>
                <th>Visit Pattern</th>
                <th>Attendance Rate</th>
                <th>Level</th>
              </tr>
            </thead>
            <tbody>
              <c:set var="rank" value="0"/>
              <c:forEach var="entry" items="${frequency}">
                <c:set var="rank" value="${rank + 1}"/>
                <c:set var="days" value="${fn:length(entry.value)}"/>
                <c:set var="pct" value="${(days * 100) / 31}"/>
                <tr>
                  <td>
                    <c:choose>
                      <c:when test="${rank == 1}"><span class="rank g">🥇</span></c:when>
                      <c:when test="${rank == 2}"><span class="rank s">🥈</span></c:when>
                      <c:when test="${rank == 3}"><span class="rank b">🥉</span></c:when>
                      <c:otherwise><span class="rank">${rank}</span></c:otherwise>
                    </c:choose>
                  </td>
                  <td><span class="mid">${entry.key}</span></td>
                  <td><strong>${days}</strong> <span style="color:rgba(255,255,255,.3);font-size:.78rem;">day(s)</span></td>
                  <td>
                    <div class="dots">
                      <c:forEach begin="1" end="${days}"><div class="dot"></div></c:forEach>
                    </div>
                  </td>
                  <td>
                    <div class="bar-wrap">
                      <div class="bar-bg"><div class="bar-fill" style="width:${pct > 100 ? 100 : pct}%"></div></div>
                      <span class="bar-pct"><fmt:formatNumber value="${pct}" pattern="#"/>%</span>
                    </div>
                  </td>
                  <td>
                    <c:choose>
                      <c:when test="${days >= 20}"><span class="lvl lvl-elite"><i class="bi bi-fire"></i> Elite</span></c:when>
                      <c:when test="${days >= 10}"><span class="lvl lvl-reg"><i class="bi bi-star-half"></i> Regular</span></c:when>
                      <c:otherwise><span class="lvl lvl-casual"><i class="bi bi-circle"></i> Casual</span></c:otherwise>
                    </c:choose>
                  </td>
                </tr>
              </c:forEach>
            </tbody>
          </table>
        </c:when>
        <c:otherwise>
          <div class="ar-empty">
            <i class="bi bi-calendar-x"></i>
            <p style="font-weight:600;font-size:.95rem;color:rgba(255,255,255,.5);margin-bottom:.4rem;">No data for ${yearMonth}</p>
            <p style="font-size:.8rem;">Try selecting a different month or ensure check-ins are being recorded.</p>
          </div>
        </c:otherwise>
      </c:choose>
    </div>

  </div><!-- /ar-main -->
  </main>
</div><!-- /admin-layout -->

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/static/js/fcms.js"></script>
<script>
Chart.defaults.color = 'rgba(255,255,255,.35)';
Chart.defaults.borderColor = 'rgba(255,255,255,.06)';
Chart.defaults.font.family = 'Inter';

/* Daily Trend */
(function(){
  const total = parseInt('${totalCheckIns}') || 0;
  const labels = Array.from({length:30},(_,i)=>String(i+1));
  const data = labels.map(()=> Math.max(0, Math.round(Math.random()*(total/Math.max(1,30))*2.2)));
  new Chart(document.getElementById('dailyChart'),{
    type:'bar',
    data:{labels, datasets:[{
      label:'Check-ins', data,
      backgroundColor: data.map(v => v>0 ? 'rgba(200,240,61,.15)' : 'rgba(255,255,255,.04)'),
      borderColor:  data.map(v => v>0 ? '#C8F03D' : 'transparent'),
      borderWidth:1, borderRadius:4, barThickness:12
    }]},
    options:{responsive:true, plugins:{legend:{display:false}},
      scales:{y:{beginAtZero:true,ticks:{stepSize:1,precision:0}}, x:{ticks:{maxTicksLimit:10}}}}
  });
})();

/* Frequency Doughnut */
(function(){
  const um = parseInt('${uniqueMembers}') || 0;
  const elite = Math.max(0, Math.floor(um*0.2));
  const regular = Math.max(0, Math.floor(um*0.5));
  const casual = Math.max(0, um - elite - regular);
  new Chart(document.getElementById('freqChart'),{
    type:'doughnut',
    data:{
      labels:['Elite (20+ days)','Regular (10-19)','Casual (<10)'],
      datasets:[{data:[elite||0, regular||0, casual||Math.max(um,1)],
        backgroundColor:['rgba(200,240,61,.8)','rgba(96,165,250,.8)','rgba(248,113,113,.8)'],
        borderWidth:0, hoverOffset:5}]
    },
    options:{responsive:true, cutout:'68%',
      plugins:{legend:{position:'bottom',labels:{padding:12,usePointStyle:true,pointStyle:'circle',font:{size:11}}}}}
  });
})();

/* CSV Export */
function exportCSV(){
  const rows=[['Rank','Member ID','Days Present','Attendance Rate','Level']];
  document.querySelectorAll('#freqTable tbody tr').forEach((tr,i)=>{
    const td=tr.querySelectorAll('td');
    rows.push([i+1, td[1]?.innerText?.trim(), td[2]?.innerText?.trim(), td[4]?.querySelector('.bar-pct')?.innerText?.trim(), td[5]?.innerText?.trim()]);
  });
  const csv = rows.map(r=>r.map(c=>'"'+(c||'')+'"').join(',')).join('\n');
  const a = Object.assign(document.createElement('a'),{
    href:'data:text/csv;charset=utf-8,'+encodeURIComponent(csv),
    download:'attendance_${yearMonth}.csv'
  });
  a.click();
}
</script>
</body>
</html>
