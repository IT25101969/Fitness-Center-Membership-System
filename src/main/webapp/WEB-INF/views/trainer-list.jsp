<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Trainer Management — APEX FITNESS</title>
    <meta name="description" content="Manage fitness trainers at the fitness center.">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Bebas+Neue&family=Inter:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.min.css">
    <c:set var="pageTitle" value="Trainer Management"/>
    <style>
    :root{--accent:#C8F03D;--accent-rgb:200,240,61;--black:#0a0a0a;--card:#111113;--card2:#141416;--border:rgba(255,255,255,.07);--gray:rgba(255,255,255,.45);--white:#fff;--font-display:'Bebas Neue',sans-serif;--font-body:'Inter',sans-serif;--radius:14px}
    *{margin:0;padding:0;box-sizing:border-box}

    /* Layout */
    .tm-page{display:flex;min-height:100vh;background:var(--black);color:#fff;font-family:var(--font-body)}
    .tm-sidebar{width:260px;background:var(--card);border-right:1px solid var(--border);padding:1.5rem 0;flex-shrink:0;position:sticky;top:0;height:100vh;overflow-y:auto;display:flex;flex-direction:column}
    .tm-main{flex:1;padding:2rem 2.5rem;overflow-y:auto;min-height:100vh}

    /* Sidebar */
    .tm-logo{font-family:var(--font-display);font-size:1.5rem;padding:0 1.5rem 1.5rem;letter-spacing:2px;border-bottom:1px solid var(--border);margin-bottom:1rem}.tm-logo span{color:var(--accent)}
    .tm-sb-section{padding:0 .8rem;margin-bottom:1rem}
    .tm-sb-label{font-size:.6rem;font-weight:700;letter-spacing:2px;text-transform:uppercase;color:var(--gray);padding:.5rem .7rem;margin-bottom:.2rem}
    .tm-sb-item{display:flex;align-items:center;gap:.6rem;padding:.55rem .7rem;border-radius:8px;font-size:.82rem;font-weight:500;color:rgba(255,255,255,.55);text-decoration:none;transition:all .2s;margin-bottom:.1rem}
    .tm-sb-item:hover{background:rgba(255,255,255,.04);color:#fff}.tm-sb-item.active{background:rgba(var(--accent-rgb),.1);color:var(--accent);font-weight:700}
    .tm-sb-item i{font-size:1rem;width:20px;text-align:center}

    /* Header */
    .tm-header{display:flex;align-items:center;justify-content:space-between;flex-wrap:wrap;gap:1rem;margin-bottom:2rem}
    .tm-header-left h1{font-family:var(--font-display);font-size:2rem;letter-spacing:3px;margin:0;line-height:1}.tm-header-left h1 span{color:var(--accent)}
    .tm-header-left p{color:var(--gray);font-size:.8rem;margin:.3rem 0 0}
    .tm-header-actions{display:flex;gap:.6rem;align-items:center}
    .tm-search{position:relative}.tm-search i{position:absolute;left:.8rem;top:50%;transform:translateY(-50%);color:rgba(255,255,255,.25);font-size:.85rem}
    .tm-search input{padding:.55rem .9rem .55rem 2.3rem;border-radius:10px;border:1px solid var(--border);background:rgba(255,255,255,.04);color:#fff;font-size:.8rem;width:250px;outline:none;transition:border-color .2s}.tm-search input:focus{border-color:rgba(var(--accent-rgb),.4)}
    .tm-add-btn{display:flex;align-items:center;gap:.4rem;padding:.55rem 1.2rem;border-radius:10px;border:none;background:var(--accent);color:#000;font-size:.8rem;font-weight:700;cursor:pointer;transition:all .2s;text-decoration:none;letter-spacing:.3px}.tm-add-btn:hover{box-shadow:0 4px 20px rgba(200,240,61,.3);transform:scale(1.03);color:#000}

    /* Stats */
    .tm-stats{display:grid;grid-template-columns:repeat(4,1fr);gap:1rem;margin-bottom:1.8rem}
    .tm-stat{background:var(--card);border:1px solid var(--border);border-radius:var(--radius);padding:1.1rem;text-align:center;position:relative;overflow:hidden}
    .tm-stat::after{content:'';position:absolute;top:0;left:0;right:0;height:2px;background:linear-gradient(90deg,transparent,var(--accent),transparent);opacity:.2}
    .tm-stat-val{font-family:var(--font-display);font-size:1.8rem;color:var(--accent);letter-spacing:1px}.tm-stat-lbl{font-size:.6rem;color:var(--gray);text-transform:uppercase;letter-spacing:1.5px;margin-top:.15rem}

    /* Filters */
    .tm-filters{display:flex;align-items:center;gap:.5rem;margin-bottom:1.5rem;flex-wrap:wrap}
    .tm-filter-label{font-size:.65rem;font-weight:700;letter-spacing:2px;text-transform:uppercase;color:var(--gray);margin-right:.3rem}
    .tm-filter-btn{padding:.4rem 1rem;border-radius:50px;border:1px solid var(--border);background:transparent;color:var(--gray);font-size:.7rem;font-weight:700;cursor:pointer;transition:all .25s;letter-spacing:.3px}
    .tm-filter-btn:hover{border-color:rgba(var(--accent-rgb),.3);color:#fff}
    .tm-filter-btn.active{background:var(--accent);color:#000;border-color:var(--accent);box-shadow:0 4px 20px rgba(200,240,61,.15)}

    /* Cards Grid */
    .tm-grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(360px,1fr));gap:1.25rem}
    .tm-card{background:var(--card);border:1px solid var(--border);border-radius:var(--radius);overflow:hidden;transition:all .25s}.tm-card:hover{border-color:rgba(var(--accent-rgb),.3);transform:translateY(-2px)}
    .tm-card-top{display:flex;align-items:center;justify-content:space-between;padding:.8rem 1rem;border-bottom:1px solid var(--border);background:rgba(255,255,255,.02)}
    .tm-card-name{font-weight:700;font-size:.88rem;display:flex;align-items:center;gap:.6rem;min-width:0}
    .tm-card-avatar{width:36px;height:36px;border-radius:10px;background:linear-gradient(135deg,rgba(var(--accent-rgb),.2),rgba(var(--accent-rgb),.05));display:flex;align-items:center;justify-content:center;font-weight:800;color:var(--accent);font-size:.85rem;flex-shrink:0;border:1px solid rgba(var(--accent-rgb),.15)}
    .tm-card-name-text{white-space:nowrap;overflow:hidden;text-overflow:ellipsis}
    .tm-card-actions{display:flex;gap:.4rem;flex-shrink:0}
    .tm-card-actions a,.tm-card-actions button{background:none;border:1px solid var(--border);border-radius:6px;color:var(--gray);font-size:.68rem;padding:.3rem .55rem;cursor:pointer;transition:all .2s;display:flex;align-items:center;gap:.2rem;text-decoration:none}
    .tm-card-actions a:hover{border-color:var(--accent);color:var(--accent)}
    .tm-card-actions .tm-del{border:1px solid var(--border);background:none;color:var(--gray)}.tm-card-actions .tm-del:hover{border-color:#f87171;color:#f87171}
    .tm-card-body{padding:1rem}
    .tm-card-info{display:grid;grid-template-columns:1fr 1fr;gap:.5rem;margin-bottom:.8rem}
    .tm-info-item{display:flex;align-items:center;gap:.4rem;font-size:.72rem;color:var(--gray)}.tm-info-item i{color:rgba(var(--accent-rgb),.5);font-size:.8rem;width:16px}
    .tm-info-item strong{color:#fff;font-weight:600}
    .tm-card-foot{display:flex;gap:.4rem;flex-wrap:wrap;padding-top:.7rem;border-top:1px solid var(--border)}

    /* Spec Pills */
    .tm-spec{display:inline-flex;align-items:center;gap:.2rem;padding:.2rem .55rem;border-radius:20px;font-size:.55rem;font-weight:800;letter-spacing:1.5px;text-transform:uppercase}
    .tm-spec.strength{background:rgba(248,113,113,.1);border:1px solid rgba(248,113,113,.25);color:#f87171}
    .tm-spec.cardio{background:rgba(96,165,250,.1);border:1px solid rgba(96,165,250,.25);color:#60a5fa}
    .tm-spec.yoga{background:rgba(167,139,250,.1);border:1px solid rgba(167,139,250,.25);color:#a78bfa}
    .tm-spec.hiit{background:rgba(251,191,36,.1);border:1px solid rgba(251,191,36,.25);color:#fbbf24}
    .tm-spec.crossfit{background:rgba(244,114,182,.1);border:1px solid rgba(244,114,182,.25);color:#f472b6}
    .tm-spec.dance{background:rgba(52,211,153,.1);border:1px solid rgba(52,211,153,.25);color:#34d399}
    .tm-spec.boxing{background:rgba(45,212,191,.1);border:1px solid rgba(45,212,191,.25);color:#2dd4bf}
    .tm-spec.pilates{background:rgba(251,146,60,.1);border:1px solid rgba(251,146,60,.25);color:#fb923c}
    .tm-spec.functional{background:rgba(200,240,61,.08);border:1px solid rgba(200,240,61,.2);color:var(--accent)}
    .tm-cert{display:inline-flex;padding:.12rem .4rem;border-radius:6px;font-size:.55rem;font-weight:700;background:rgba(var(--accent-rgb),.08);color:var(--accent);letter-spacing:.5px;text-transform:uppercase}
    .tm-status{display:inline-flex;align-items:center;gap:.25rem;padding:.15rem .5rem;border-radius:20px;font-size:.6rem;font-weight:700}
    .tm-status.active-s{background:rgba(52,211,153,.1);color:#34d399;border:1px solid rgba(52,211,153,.2)}

    /* Count */
    .tm-count{font-size:.78rem;color:var(--gray);margin-bottom:1rem}.tm-count b{color:var(--white)}

    /* Empty */
    .tm-empty{text-align:center;padding:4rem 2rem;color:var(--gray);grid-column:1/-1}.tm-empty i{font-size:3rem;display:block;margin-bottom:1rem;opacity:.25}
    .tm-empty a{color:var(--accent);text-decoration:none;font-weight:600}

    /* Flash */
    .tm-flash{padding:.8rem 1.2rem;border-radius:10px;font-size:.8rem;font-weight:600;margin-bottom:1.5rem;display:flex;align-items:center;gap:.5rem;animation:fadeIn .3s ease}
    .tm-flash-success{background:rgba(52,211,153,.1);border:1px solid rgba(52,211,153,.25);color:#34d399}
    .tm-flash-danger{background:rgba(248,113,113,.1);border:1px solid rgba(248,113,113,.25);color:#f87171}

    /* Delete Modal */
    .tm-modal-bg{position:fixed;inset:0;background:rgba(0,0,0,.7);z-index:9000;display:none;align-items:center;justify-content:center;backdrop-filter:blur(6px)}.tm-modal-bg.open{display:flex}
    .tm-modal{background:#111;border:1px solid var(--border);border-radius:18px;width:420px;max-width:94vw;padding:2rem;text-align:center;animation:fadeIn .3s ease}
    .tm-modal-icon{font-size:2.5rem;color:#f87171;margin-bottom:.8rem}
    .tm-modal h3{font-family:var(--font-display);font-size:1.3rem;letter-spacing:2px;margin-bottom:.5rem}
    .tm-modal p{color:var(--gray);font-size:.82rem;margin-bottom:1.5rem}.tm-modal p strong{color:#fff}
    .tm-modal-btns{display:flex;gap:.8rem;justify-content:center}
    .tm-modal-cancel{padding:.5rem 1.2rem;border-radius:8px;border:1px solid var(--border);background:none;color:var(--gray);font-size:.78rem;cursor:pointer;transition:all .2s}.tm-modal-cancel:hover{border-color:#fff;color:#fff}
    .tm-modal-del{padding:.5rem 1.2rem;border-radius:8px;border:none;background:#f87171;color:#000;font-size:.78rem;font-weight:700;cursor:pointer;transition:all .2s}.tm-modal-del:hover{box-shadow:0 4px 20px rgba(248,113,113,.3)}

    /* Responsive */
    @media(max-width:1024px){.tm-stats{grid-template-columns:repeat(2,1fr)}.tm-sidebar{display:none}.tm-main{padding:1.5rem}}
    @media(max-width:600px){.tm-grid{grid-template-columns:1fr}.tm-header{flex-direction:column;align-items:flex-start}.tm-search input{width:100%}}
    @keyframes fadeIn{from{opacity:0;transform:translateY(8px)}to{opacity:1;transform:translateY(0)}}
    </style>
</head>
<body>

<div class="tm-page">
    <!-- Sidebar -->
    <aside class="tm-sidebar">
        <div class="tm-logo">APEX<span>FITNESS</span></div>
        <div class="tm-sb-section">
            <div class="tm-sb-label">Navigation</div>
            <a href="${pageContext.request.contextPath}/home" class="tm-sb-item"><i class="bi bi-speedometer2"></i> Dashboard</a>
            <a href="${pageContext.request.contextPath}/trainers" class="tm-sb-item active"><i class="bi bi-person-badge-fill"></i> Trainers</a>
            <a href="${pageContext.request.contextPath}/trainers/new" class="tm-sb-item"><i class="bi bi-person-plus-fill"></i> Add Trainer</a>
        </div>
        <div class="tm-sb-section">
            <div class="tm-sb-label">Management</div>
            <a href="${pageContext.request.contextPath}/members" class="tm-sb-item"><i class="bi bi-people-fill"></i> Members</a>
            <a href="${pageContext.request.contextPath}/exercise-mgmt" class="tm-sb-item"><i class="bi bi-activity"></i> Exercises</a>
            <a href="${pageContext.request.contextPath}/supplements" class="tm-sb-item"><i class="bi bi-capsule"></i> Supplements</a>
            <a href="${pageContext.request.contextPath}/classes" class="tm-sb-item"><i class="bi bi-calendar3"></i> Classes</a>
        </div>
        <div class="tm-sb-section" style="margin-top:auto;padding-top:1rem;border-top:1px solid var(--border)">
            <a href="${pageContext.request.contextPath}/landing.html" class="tm-sb-item"><i class="bi bi-globe2"></i> View Website</a>
        </div>
    </aside>

    <!-- Main Content -->
    <div class="tm-main">
        <!-- Header -->
        <div class="tm-header" style="animation:fadeIn .4s ease">
            <div class="tm-header-left">
                <h1>TRAINER <span>MANAGEMENT</span></h1>
                <p><i class="bi bi-info-circle"></i> Add, edit and manage fitness trainers — assigned to classes and programs</p>
            </div>
            <div class="tm-header-actions">
                <div class="tm-search"><i class="bi bi-search"></i><input type="text" id="tmSearch" placeholder="Search trainers..." oninput="searchTrainer()"></div>
                <a href="${pageContext.request.contextPath}/trainers/new" class="tm-add-btn"><i class="bi bi-person-plus-fill"></i> Add Trainer</a>
            </div>
        </div>

        <!-- Flash Messages -->
        <c:if test="${param.msg == 'created'}"><div class="tm-flash tm-flash-success"><i class="bi bi-check-circle-fill"></i> Trainer added successfully.</div></c:if>
        <c:if test="${param.msg == 'deleted'}"><div class="tm-flash tm-flash-danger"><i class="bi bi-trash-fill"></i> Trainer deleted.</div></c:if>
        <c:if test="${param.msg == 'updated'}"><div class="tm-flash tm-flash-success"><i class="bi bi-check-circle-fill"></i> Trainer updated successfully.</div></c:if>

        <!-- Stats -->
        <div class="tm-stats" style="animation:fadeIn .5s ease">
            <div class="tm-stat"><div class="tm-stat-val">${trainers.size()}</div><div class="tm-stat-lbl">Total Trainers</div></div>
            <div class="tm-stat"><div class="tm-stat-val" style="color:#60a5fa">6</div><div class="tm-stat-lbl">Specializations</div></div>
            <div class="tm-stat"><div class="tm-stat-val" style="color:#34d399">${trainers.size()}</div><div class="tm-stat-lbl">Active</div></div>
            <div class="tm-stat"><div class="tm-stat-val" style="color:#a78bfa">9</div><div class="tm-stat-lbl">Classes Covered</div></div>
        </div>

        <!-- Filters -->
        <div class="tm-filters" style="animation:fadeIn .55s ease">
            <span class="tm-filter-label">Specialization:</span>
            <button class="tm-filter-btn active" onclick="filterTrainer('all',this)">All</button>
            <button class="tm-filter-btn" onclick="filterTrainer('Strength',this)">Strength</button>
            <button class="tm-filter-btn" onclick="filterTrainer('Cardio',this)">Cardio</button>
            <button class="tm-filter-btn" onclick="filterTrainer('Yoga',this)">Yoga</button>
            <button class="tm-filter-btn" onclick="filterTrainer('HIIT',this)">HIIT</button>
            <button class="tm-filter-btn" onclick="filterTrainer('CrossFit',this)">CrossFit</button>
            <button class="tm-filter-btn" onclick="filterTrainer('Dance',this)">Dance</button>
        </div>

        <!-- Count -->
        <div class="tm-count" id="tmCount">Showing <b>${trainers.size()}</b> of <b>${trainers.size()}</b> trainers</div>

        <!-- Trainer Cards Grid -->
        <div class="tm-grid" id="tmGrid">
            <c:forEach var="trainer" items="${trainers}">
                <div class="tm-card" data-spec="${trainer.specialization}" data-name="${trainer.name}" data-email="${trainer.email}" style="animation:fadeIn .5s ease">
                    <div class="tm-card-top">
                        <div class="tm-card-name">
                            <div class="tm-card-avatar">${trainer.name.substring(0,1)}</div>
                            <div>
                                <div class="tm-card-name-text">${trainer.name}</div>
                                <div style="font-size:.65rem;color:var(--gray);font-weight:400">${trainer.email}</div>
                            </div>
                        </div>
                        <div class="tm-card-actions">
                            <span class="tm-status active-s"><i class="bi bi-circle-fill" style="font-size:.4rem"></i> Active</span>
                            <a href="${pageContext.request.contextPath}/trainers/edit?id=${trainer.id}"><i class="bi bi-pencil"></i> Edit</a>
                            <button class="tm-del" onclick="openDeleteModal('${pageContext.request.contextPath}/trainers/delete?id=${trainer.id}','${trainer.name}')"><i class="bi bi-trash3"></i></button>
                        </div>
                    </div>
                    <div class="tm-card-body">
                        <div class="tm-card-info">
                            <div class="tm-info-item"><i class="bi bi-telephone-fill"></i> <strong>${trainer.phone}</strong></div>
                            <div class="tm-info-item"><i class="bi bi-hash"></i> ID: <strong>${trainer.id}</strong></div>
                        </div>
                        <div class="tm-card-foot">
                            <c:forTokens var="spec" items="${trainer.specialization}" delims="|,">
                                <c:set var="specLower" value="${spec.trim().toLowerCase().replaceAll('[^a-z]','')}"/>
                                <span class="tm-spec ${specLower == 'strengthtraining' || specLower == 'bodybuilding' ? 'strength' : specLower == 'cardio' ? 'cardio' : specLower == 'yoga' ? 'yoga' : specLower == 'hiit' ? 'hiit' : specLower == 'crossfit' ? 'crossfit' : specLower == 'zumba' || specLower == 'dancefitness' || specLower == 'dance' ? 'dance' : specLower == 'boxing' ? 'boxing' : specLower == 'pilates' ? 'pilates' : 'functional'}">${spec.trim()}</span>
                            </c:forTokens>
                            <c:if test="${not empty trainer.certifications}">
                                <c:forTokens var="cert" items="${trainer.certifications}" delims="|,">
                                    <span class="tm-cert"><i class="bi bi-patch-check-fill"></i> ${cert.trim()}</span>
                                </c:forTokens>
                            </c:if>
                        </div>
                    </div>
                </div>
            </c:forEach>
            <c:if test="${empty trainers}">
                <div class="tm-empty">
                    <i class="bi bi-person-badge"></i>
                    <div style="font-size:1rem;font-weight:600;margin-bottom:.3rem">No trainers found</div>
                    <div>Get started by <a href="${pageContext.request.contextPath}/trainers/new">adding the first trainer</a></div>
                </div>
            </c:if>
        </div>
    </div>
</div>

<!-- Delete Modal -->
<div class="tm-modal-bg" id="tmDeleteModal">
    <div class="tm-modal">
        <div class="tm-modal-icon"><i class="bi bi-exclamation-triangle-fill"></i></div>
        <h3>DELETE TRAINER</h3>
        <p>Are you sure you want to remove <strong id="tmDeleteName"></strong>? This action cannot be undone.</p>
        <div class="tm-modal-btns">
            <button class="tm-modal-cancel" onclick="closeDeleteModal()">Cancel</button>
            <button class="tm-modal-del" id="tmDeleteBtn" onclick="executeDelete()"><i class="bi bi-trash3"></i> Delete</button>
        </div>
    </div>
</div>

<script>
var tmDeleteUrl='';

function filterTrainer(spec,btn){
    document.querySelectorAll('.tm-filter-btn').forEach(function(p){p.classList.remove('active');});
    btn.classList.add('active');
    var cards=document.querySelectorAll('.tm-card'),shown=0,total=cards.length;
    cards.forEach(function(c){
        var s=(c.dataset.spec||'').toLowerCase();
        var match=spec==='all'||s.indexOf(spec.toLowerCase())>=0;
        c.style.display=match?'':'none';
        if(match){c.style.animation='fadeIn .35s ease '+(shown*0.04)+'s both';shown++;}
    });
    document.getElementById('tmCount').innerHTML='Showing <b>'+shown+'</b> of <b>'+total+'</b> trainers';
}

function searchTrainer(){
    var q=(document.getElementById('tmSearch').value||'').toLowerCase();
    var cards=document.querySelectorAll('.tm-card'),shown=0,total=cards.length;
    cards.forEach(function(c){
        var name=(c.dataset.name||'').toLowerCase();
        var email=(c.dataset.email||'').toLowerCase();
        var spec=(c.dataset.spec||'').toLowerCase();
        var match=!q||name.indexOf(q)>=0||email.indexOf(q)>=0||spec.indexOf(q)>=0;
        c.style.display=match?'':'none';
        if(match)shown++;
    });
    document.getElementById('tmCount').innerHTML='Showing <b>'+shown+'</b> of <b>'+total+'</b> trainers';
}

function openDeleteModal(url,name){
    tmDeleteUrl=url;
    document.getElementById('tmDeleteName').textContent=name;
    document.getElementById('tmDeleteModal').classList.add('open');
}
function closeDeleteModal(){document.getElementById('tmDeleteModal').classList.remove('open');}
function executeDelete(){if(tmDeleteUrl)window.location.href=tmDeleteUrl;}

setTimeout(function(){document.querySelectorAll('.tm-flash').forEach(function(f){f.style.opacity='0';f.style.transform='translateY(-10px)';setTimeout(function(){f.remove();},300);});},4000);
</script>
</body>
</html>
