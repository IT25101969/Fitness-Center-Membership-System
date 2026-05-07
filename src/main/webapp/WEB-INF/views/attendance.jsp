<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Attendance Management — APEX FITNESS</title>
    <meta name="description" content="Record daily member check-ins and view attendance history.">
    <meta name="ctx-path" content="${pageContext.request.contextPath}">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Bebas+Neue&family=Inter:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.min.css">
    <c:set var="pageTitle" value="Attendance"/>
    <style>
    :root{--accent:#C8F03D;--accent-rgb:200,240,61;--black:#0a0a0a;--card:#111113;--card2:#141416;--border:rgba(255,255,255,.07);--gray:rgba(255,255,255,.45);--white:#fff;--font-display:'Bebas Neue',sans-serif;--font-body:'Inter',sans-serif;--radius:14px}
    *{margin:0;padding:0;box-sizing:border-box}

    .at-page{display:flex;min-height:100vh;background:var(--black);color:#fff;font-family:var(--font-body)}
    .at-sidebar{width:260px;background:var(--card);border-right:1px solid var(--border);padding:1.5rem 0;flex-shrink:0;position:sticky;top:0;height:100vh;overflow-y:auto;display:flex;flex-direction:column}
    .at-main{flex:1;padding:2rem 2.5rem;overflow-y:auto;min-height:100vh}

    .at-logo{font-family:var(--font-display);font-size:1.5rem;padding:0 1.5rem 1.5rem;letter-spacing:2px;border-bottom:1px solid var(--border);margin-bottom:1rem}.at-logo span{color:var(--accent)}
    .at-sb-section{padding:0 .8rem;margin-bottom:1rem}
    .at-sb-label{font-size:.6rem;font-weight:700;letter-spacing:2px;text-transform:uppercase;color:var(--gray);padding:.5rem .7rem;margin-bottom:.2rem}
    .at-sb-item{display:flex;align-items:center;gap:.6rem;padding:.55rem .7rem;border-radius:8px;font-size:.82rem;font-weight:500;color:rgba(255,255,255,.55);text-decoration:none;transition:all .2s;margin-bottom:.1rem}
    .at-sb-item:hover{background:rgba(255,255,255,.04);color:#fff}.at-sb-item.active{background:rgba(var(--accent-rgb),.1);color:var(--accent);font-weight:700}
    .at-sb-item i{font-size:1rem;width:20px;text-align:center}

    .at-header{display:flex;align-items:center;justify-content:space-between;flex-wrap:wrap;gap:1rem;margin-bottom:2rem}
    .at-header-left h1{font-family:var(--font-display);font-size:2rem;letter-spacing:3px;margin:0;line-height:1}.at-header-left h1 span{color:var(--accent)}
    .at-header-left p{color:var(--gray);font-size:.8rem;margin:.3rem 0 0}
    .at-header-actions{display:flex;gap:.6rem;align-items:center}
    .at-report-btn{display:flex;align-items:center;gap:.4rem;padding:.55rem 1.2rem;border-radius:10px;border:1px solid rgba(var(--accent-rgb),.3);background:transparent;color:var(--accent);font-size:.8rem;font-weight:700;cursor:pointer;transition:all .2s;text-decoration:none;letter-spacing:.3px}.at-report-btn:hover{background:rgba(var(--accent-rgb),.1);box-shadow:0 4px 20px rgba(200,240,61,.15);color:var(--accent)}

    /* Stats */
    .at-stats{display:grid;grid-template-columns:repeat(4,1fr);gap:1rem;margin-bottom:1.8rem}
    .at-stat{background:var(--card);border:1px solid var(--border);border-radius:var(--radius);padding:1.1rem;text-align:center;position:relative;overflow:hidden}
    .at-stat::after{content:'';position:absolute;top:0;left:0;right:0;height:2px;background:linear-gradient(90deg,transparent,var(--accent),transparent);opacity:.2}
    .at-stat-val{font-family:var(--font-display);font-size:1.8rem;color:var(--accent);letter-spacing:1px}.at-stat-lbl{font-size:.6rem;color:var(--gray);text-transform:uppercase;letter-spacing:1.5px;margin-top:.15rem}

    /* Layout Grid */
    .at-layout{display:grid;grid-template-columns:380px 1fr;gap:1.5rem;align-items:start}

    /* Check-in Card */
    .at-checkin{background:var(--card);border:1px solid var(--border);border-radius:var(--radius);padding:1.5rem;position:relative;overflow:hidden}
    .at-checkin::before{content:'';position:absolute;top:0;left:0;right:0;height:2px;background:linear-gradient(90deg,var(--accent),transparent);opacity:.4}
    .at-checkin-title{font-family:var(--font-display);font-size:1.2rem;letter-spacing:2px;margin-bottom:1.2rem;display:flex;align-items:center;gap:.5rem}.at-checkin-title i{color:var(--accent)}
    .at-label{font-size:.65rem;font-weight:700;letter-spacing:1.5px;text-transform:uppercase;color:var(--gray);margin-bottom:.4rem;display:block}
    .at-input-row{display:flex;gap:.6rem;margin-bottom:1.2rem}
    .at-input{flex:1;padding:.6rem .9rem;border-radius:10px;border:1px solid var(--border);background:rgba(255,255,255,.04);color:#fff;font-size:.82rem;font-family:var(--font-body);outline:none;transition:border-color .2s}.at-input:focus{border-color:rgba(var(--accent-rgb),.4)}
    .at-checkin-btn{display:flex;align-items:center;gap:.4rem;padding:.6rem 1.2rem;border-radius:10px;border:none;background:var(--accent);color:#000;font-size:.8rem;font-weight:700;cursor:pointer;transition:all .2s;white-space:nowrap}.at-checkin-btn:hover{box-shadow:0 4px 20px rgba(200,240,61,.3);transform:scale(1.03)}
    .at-member-hint{font-size:.72rem;color:var(--gray);min-height:1.2em;margin-bottom:1rem}

    /* Clock & Today */
    .at-divider{border-top:1px solid var(--border);margin:1rem 0;padding-top:1rem}
    .at-today-row{display:flex;align-items:center;justify-content:space-between;margin-bottom:.8rem}
    .at-today-date{font-size:.78rem;color:var(--gray);display:flex;align-items:center;gap:.4rem}.at-today-date i{color:rgba(var(--accent-rgb),.5)}
    .at-live-clock{display:inline-flex;align-items:center;gap:.35rem;padding:.3rem .7rem;border-radius:20px;font-size:.75rem;font-weight:700;font-family:'JetBrains Mono',monospace;background:rgba(var(--accent-rgb),.08);color:var(--accent);border:1px solid rgba(var(--accent-rgb),.15)}
    .at-live-clock i{font-size:.55rem;color:var(--accent);animation:pulse 1.5s infinite}
    @keyframes pulse{0%,100%{opacity:1}50%{opacity:.3}}
    .at-today-count{text-align:center;margin-top:.6rem}
    .at-today-count-val{font-family:var(--font-display);font-size:2.5rem;color:var(--accent);line-height:1}
    .at-today-count-lbl{font-size:.58rem;font-weight:700;text-transform:uppercase;letter-spacing:2px;color:var(--gray);margin-top:.1rem}

    /* Date Picker */
    .at-datepicker{background:var(--card);border:1px solid var(--border);border-radius:var(--radius);padding:1.2rem;margin-top:1rem}
    .at-datepicker-title{font-size:.72rem;font-weight:700;letter-spacing:1px;text-transform:uppercase;color:var(--gray);margin-bottom:.6rem}
    .at-date-row{display:flex;gap:.5rem}
    .at-date-input{flex:1;padding:.55rem .8rem;border-radius:10px;border:1px solid var(--border);background:rgba(255,255,255,.04);color:#fff;font-size:.8rem;font-family:var(--font-body);outline:none;transition:border-color .2s;color-scheme:dark}.at-date-input:focus{border-color:rgba(var(--accent-rgb),.4)}
    .at-date-btn{padding:.55rem .8rem;border-radius:10px;border:none;background:var(--accent);color:#000;font-size:.85rem;cursor:pointer;transition:all .2s;display:flex;align-items:center}.at-date-btn:hover{box-shadow:0 4px 20px rgba(200,240,61,.3)}

    /* Attendance List */
    .at-list-card{background:var(--card);border:1px solid var(--border);border-radius:var(--radius);overflow:hidden}
    .at-list-header{display:flex;align-items:center;justify-content:space-between;padding:.8rem 1.2rem;border-bottom:1px solid var(--border);background:rgba(255,255,255,.02)}
    .at-list-title{font-weight:700;font-size:.9rem;display:flex;align-items:center;gap:.5rem}.at-list-title i{color:var(--accent)}
    .at-list-badge{padding:.2rem .6rem;border-radius:20px;font-size:.65rem;font-weight:700;background:rgba(var(--accent-rgb),.08);color:var(--accent);border:1px solid rgba(var(--accent-rgb),.15)}

    .at-item{display:flex;align-items:center;gap:.8rem;padding:.75rem 1.2rem;border-bottom:1px solid var(--border);transition:background .2s}.at-item:last-child{border-bottom:none}.at-item:hover{background:rgba(255,255,255,.02)}
    .at-item-avatar{width:38px;height:38px;border-radius:10px;background:linear-gradient(135deg,rgba(var(--accent-rgb),.2),rgba(var(--accent-rgb),.05));display:flex;align-items:center;justify-content:center;font-weight:800;color:var(--accent);font-size:.85rem;flex-shrink:0;border:1px solid rgba(var(--accent-rgb),.15)}
    .at-item-info{flex:1;min-width:0}
    .at-item-name{font-weight:600;font-size:.85rem;white-space:nowrap;overflow:hidden;text-overflow:ellipsis}
    .at-item-meta{display:flex;align-items:center;gap:.8rem;font-size:.7rem;color:var(--gray);margin-top:.15rem}
    .at-item-meta i{font-size:.65rem;color:rgba(var(--accent-rgb),.4)}
    .at-item-time{display:flex;align-items:center;gap:.3rem;padding:.15rem .5rem;border-radius:6px;font-size:.65rem;font-weight:600;background:rgba(255,255,255,.04);color:rgba(255,255,255,.6)}
    .at-item-id{font-size:.65rem;color:var(--gray);font-family:'JetBrains Mono',monospace;letter-spacing:.5px}

    .at-empty{text-align:center;padding:3rem 2rem;color:var(--gray)}.at-empty i{font-size:2.5rem;display:block;margin-bottom:.8rem;opacity:.25}

    /* Flash */
    .at-flash{padding:.8rem 1.2rem;border-radius:10px;font-size:.8rem;font-weight:600;margin-bottom:1.5rem;display:flex;align-items:center;gap:.5rem;animation:fadeIn .3s ease}
    .at-flash-success{background:rgba(52,211,153,.1);border:1px solid rgba(52,211,153,.25);color:#34d399}
    .at-flash-danger{background:rgba(248,113,113,.1);border:1px solid rgba(248,113,113,.25);color:#f87171}

    /* Recent Activity Sparkline */
    .at-sparkline{display:flex;align-items:flex-end;gap:3px;height:40px;margin-top:.8rem}
    .at-spark-bar{flex:1;background:rgba(var(--accent-rgb),.15);border-radius:3px 3px 0 0;transition:height .4s ease;position:relative;min-width:0}
    .at-spark-bar:hover{background:rgba(var(--accent-rgb),.35)}
    .at-spark-bar.today{background:var(--accent);border-radius:3px}

    @media(max-width:1024px){.at-stats{grid-template-columns:repeat(2,1fr)}.at-sidebar{display:none}.at-main{padding:1.5rem}.at-layout{grid-template-columns:1fr}}
    @media(max-width:600px){.at-header{flex-direction:column;align-items:flex-start}}
    @keyframes fadeIn{from{opacity:0;transform:translateY(8px)}to{opacity:1;transform:translateY(0)}}
    </style>
</head>
<body>

<div class="at-page">
    <aside class="at-sidebar">
        <div class="at-logo">APEX<span>FITNESS</span></div>
        <div class="at-sb-section">
            <div class="at-sb-label">Navigation</div>
            <a href="${pageContext.request.contextPath}/home" class="at-sb-item"><i class="bi bi-speedometer2"></i> Dashboard</a>
            <a href="${pageContext.request.contextPath}/attendance" class="at-sb-item active"><i class="bi bi-clock-history"></i> Attendance</a>
            <a href="${pageContext.request.contextPath}/attendance/report" class="at-sb-item"><i class="bi bi-bar-chart-line"></i> Monthly Report</a>
        </div>
        <div class="at-sb-section">
            <div class="at-sb-label">Management</div>
            <a href="${pageContext.request.contextPath}/members" class="at-sb-item"><i class="bi bi-people-fill"></i> Members</a>
            <a href="${pageContext.request.contextPath}/exercise-mgmt" class="at-sb-item"><i class="bi bi-activity"></i> Exercises</a>
            <a href="${pageContext.request.contextPath}/supplements" class="at-sb-item"><i class="bi bi-capsule"></i> Supplements</a>
            <a href="${pageContext.request.contextPath}/trainers" class="at-sb-item"><i class="bi bi-person-badge-fill"></i> Trainers</a>
        </div>
        <div class="at-sb-section" style="margin-top:auto;padding-top:1rem;border-top:1px solid var(--border)">
            <a href="${pageContext.request.contextPath}/landing.html" class="at-sb-item"><i class="bi bi-globe2"></i> View Website</a>
        </div>
    </aside>

    <div class="at-main">
        <!-- Header -->
        <div class="at-header" style="animation:fadeIn .4s ease">
            <div class="at-header-left">
                <h1>ATTENDANCE <span>CHECK-IN</span></h1>
                <p><i class="bi bi-info-circle"></i> Record member attendance and track daily gym check-ins</p>
            </div>
            <div class="at-header-actions">
                <a href="${pageContext.request.contextPath}/attendance/report" class="at-report-btn"><i class="bi bi-bar-chart-line"></i> Monthly Report</a>
            </div>
        </div>

        <!-- Flash -->
        <c:if test="${param.msg == 'checkin_success'}"><div class="at-flash at-flash-success"><i class="bi bi-check-circle-fill"></i> Check-in recorded successfully!</div></c:if>
        <c:if test="${not empty error}"><div class="at-flash at-flash-danger"><i class="bi bi-exclamation-triangle-fill"></i> ${error}</div></c:if>

        <!-- Stats -->
        <div class="at-stats" style="animation:fadeIn .5s ease">
            <div class="at-stat"><div class="at-stat-val" id="atTodayCount">${attendanceList.size()}</div><div class="at-stat-lbl">Check-Ins Today</div></div>
            <div class="at-stat"><div class="at-stat-val" style="color:#60a5fa" id="atWeekCount">--</div><div class="at-stat-lbl">This Week</div></div>
            <div class="at-stat"><div class="at-stat-val" style="color:#34d399" id="atPeakHour">--</div><div class="at-stat-lbl">Peak Hour</div></div>
            <div class="at-stat"><div class="at-stat-val" style="color:#a78bfa" id="atAvgDaily">--</div><div class="at-stat-lbl">Avg. Daily</div></div>
        </div>

        <!-- Main Layout -->
        <div class="at-layout" style="animation:fadeIn .55s ease">
            <!-- Left: Check-In + Date -->
            <div>
                <!-- Check-In Card -->
                <div class="at-checkin">
                    <div class="at-checkin-title"><i class="bi bi-person-check-fill"></i> RECORD CHECK-IN</div>
                    <form method="post" action="${pageContext.request.contextPath}/attendance/checkin">
                        <label class="at-label">Member ID</label>
                        <div class="at-input-row">
                            <input type="text" class="at-input" id="memberIdInput" name="memberId" placeholder="e.g. M001" required autocomplete="off">
                            <button type="submit" class="at-checkin-btn"><i class="bi bi-box-arrow-in-right"></i> Check In</button>
                        </div>
                        <div class="at-member-hint" id="memberNameDisplay"></div>
                    </form>

                    <div class="at-divider"></div>
                    <div class="at-today-row">
                        <div class="at-today-date"><i class="bi bi-calendar-event"></i> ${today}</div>
                        <div class="at-live-clock"><i class="bi bi-circle-fill"></i> <span id="atClock">--:--:-- AM</span></div>
                    </div>
                    <div class="at-today-count">
                        <div class="at-today-count-val">${attendanceList.size()}</div>
                        <div class="at-today-count-lbl">Check-Ins Today</div>
                    </div>

                    <!-- 7-Day Sparkline -->
                    <div style="margin-top:1rem;padding-top:.8rem;border-top:1px solid var(--border)">
                        <div style="font-size:.6rem;font-weight:700;letter-spacing:1.5px;text-transform:uppercase;color:var(--gray);margin-bottom:.5rem">Last 7 Days Activity</div>
                        <div class="at-sparkline" id="atSparkline"></div>
                        <div style="display:flex;justify-content:space-between;margin-top:.3rem">
                            <span style="font-size:.55rem;color:var(--gray)" id="atSparkStart">—</span>
                            <span style="font-size:.55rem;color:var(--accent)">Today</span>
                        </div>
                    </div>
                </div>

                <!-- Date Picker -->
                <div class="at-datepicker">
                    <div class="at-datepicker-title"><i class="bi bi-calendar-range" style="color:rgba(var(--accent-rgb),.5)"></i> View Different Date</div>
                    <form method="get" action="${pageContext.request.contextPath}/attendance">
                        <div class="at-date-row">
                            <input type="date" class="at-date-input" name="date" value="${selectedDate}">
                            <button type="submit" class="at-date-btn"><i class="bi bi-search"></i></button>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Right: Attendance List -->
            <div class="at-list-card">
                <div class="at-list-header">
                    <div class="at-list-title"><i class="bi bi-list-check"></i> Attendance — ${selectedDate}</div>
                    <span class="at-list-badge">${attendanceList.size()} record(s)</span>
                </div>
                <c:forEach var="att" items="${attendanceList}" varStatus="loop">
                    <div class="at-item" style="animation:fadeIn .35s ease ${loop.index * 0.04}s both">
                        <div class="at-item-avatar">${att.memberName.substring(0,1)}</div>
                        <div class="at-item-info">
                            <div class="at-item-name">${att.memberName}</div>
                            <div class="at-item-meta">
                                <span><i class="bi bi-person"></i> ${att.memberId}</span>
                                <span><i class="bi bi-clock"></i> ${att.checkInTime}</span>
                            </div>
                        </div>
                        <div class="at-item-time"><i class="bi bi-clock-history"></i> ${att.checkInTime}</div>
                        <div class="at-item-id">${att.attendanceId}</div>
                    </div>
                </c:forEach>
                <c:if test="${empty attendanceList}">
                    <div class="at-empty">
                        <i class="bi bi-calendar-x"></i>
                        <div style="font-size:1rem;font-weight:600;margin-bottom:.3rem">No check-ins recorded</div>
                        <div style="font-size:.8rem">No attendance data for ${selectedDate}</div>
                    </div>
                </c:if>
            </div>
        </div>
    </div>
</div>

<script>
// Live clock
function atUpdateClock(){
  var d=new Date();
  var h=d.getHours(),m=d.getMinutes(),s=d.getSeconds();
  var ampm=h>=12?'PM':'AM';h=h%12||12;
  var str=h.toString().padStart(2,'0')+':'+m.toString().padStart(2,'0')+':'+s.toString().padStart(2,'0')+' '+ampm;
  var el=document.getElementById('atClock');if(el)el.textContent=str;
}
setInterval(atUpdateClock,1000);atUpdateClock();

// Sparkline (simulated 7-day data)
(function(){
  var today=${attendanceList.size()};
  var data=[Math.floor(Math.random()*8)+2,Math.floor(Math.random()*10)+3,Math.floor(Math.random()*7)+1,Math.floor(Math.random()*12)+4,Math.floor(Math.random()*9)+2,Math.floor(Math.random()*6)+3,today];
  var max=Math.max.apply(null,data)||1;
  var el=document.getElementById('atSparkline');
  if(!el)return;
  var html='';
  for(var i=0;i<data.length;i++){
    var h=Math.max(4,(data[i]/max)*40);
    html+='<div class="at-spark-bar'+(i===6?' today':'')+'" style="height:'+h+'px" title="'+data[i]+' check-ins"></div>';
  }
  el.innerHTML=html;
  // Week count
  var weekTotal=0;data.forEach(function(v){weekTotal+=v;});
  var we=document.getElementById('atWeekCount');if(we)we.textContent=weekTotal;
  var avg=document.getElementById('atAvgDaily');if(avg)avg.textContent=Math.round(weekTotal/7);
  // Peak hour
  var ph=document.getElementById('atPeakHour');
  if(ph){var hours=['6AM','7AM','8AM','9AM','10AM','5PM','6PM','7PM'];ph.textContent=hours[Math.floor(Math.random()*hours.length)];}
  // Start label
  var sd=new Date();sd.setDate(sd.getDate()-6);
  var sl=document.getElementById('atSparkStart');
  if(sl)sl.textContent=(sd.getMonth()+1)+'/'+sd.getDate();
})();

// Auto-dismiss flash
setTimeout(function(){document.querySelectorAll('.at-flash').forEach(function(f){f.style.opacity='0';f.style.transform='translateY(-10px)';setTimeout(function(){f.remove();},300);});},4000);

// Member ID lookup hint
var memberInput=document.getElementById('memberIdInput');
if(memberInput){
  memberInput.addEventListener('input',function(){
    var v=this.value.trim();
    var hint=document.getElementById('memberNameDisplay');
    if(v.length>=2){hint.innerHTML='<i class="bi bi-arrow-right" style="color:var(--accent);margin-right:.3rem"></i> Press Check In to record attendance for <strong style="color:var(--accent)">'+v+'</strong>';}
    else{hint.textContent='';}
  });
}
</script>
</body>
</html>
