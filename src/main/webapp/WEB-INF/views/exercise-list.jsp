<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Exercise Management — APEX FITNESS</title>
    <meta name="description" content="Manage the exercise library for the fitness center.">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Bebas+Neue&family=Inter:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css">
    <c:set var="pageTitle" value="Exercise Management"/>
    <style>
    :root{--accent:#C8F03D;--accent-rgb:200,240,61;--black:#0a0a0a;--card:#111113;--card2:#141416;--border:rgba(255,255,255,.07);--gray:rgba(255,255,255,.45);--white:#fff;--font-display:'Bebas Neue',sans-serif;--font-body:'Inter',sans-serif}

    /* ── Layout ── */
    .em-page{display:flex;min-height:100vh;background:var(--black);color:#fff;font-family:var(--font-body)}
    .em-sidebar{width:260px;background:var(--card);border-right:1px solid var(--border);padding:1.5rem 0;flex-shrink:0;position:sticky;top:0;height:100vh;overflow-y:auto}
    .em-main{flex:1;padding:2rem 2.5rem;overflow-y:auto;min-height:100vh}

    /* Sidebar */
    .em-logo{font-family:var(--font-display);font-size:1.5rem;padding:0 1.5rem 1.5rem;letter-spacing:2px;border-bottom:1px solid var(--border);margin-bottom:1rem}.em-logo span{color:var(--accent)}
    .em-sb-section{padding:0 .8rem;margin-bottom:1rem}
    .em-sb-label{font-size:.6rem;font-weight:700;letter-spacing:2px;text-transform:uppercase;color:var(--gray);padding:.5rem .7rem;margin-bottom:.2rem}
    .em-sb-item{display:flex;align-items:center;gap:.6rem;padding:.55rem .7rem;border-radius:8px;font-size:.82rem;font-weight:500;color:rgba(255,255,255,.55);text-decoration:none;transition:all .2s;margin-bottom:.1rem}
    .em-sb-item:hover{background:rgba(255,255,255,.04);color:#fff}.em-sb-item.active{background:rgba(var(--accent-rgb),.1);color:var(--accent);font-weight:700}
    .em-sb-item i{font-size:1rem;width:20px;text-align:center}

    /* ── Header ── */
    .em-header{display:flex;align-items:center;justify-content:space-between;flex-wrap:wrap;gap:1rem;margin-bottom:2rem}
    .em-header-left h1{font-family:var(--font-display);font-size:2rem;letter-spacing:3px;margin:0;line-height:1}.em-header-left h1 span{color:var(--accent)}
    .em-header-left p{color:var(--gray);font-size:.8rem;margin:.3rem 0 0}
    .em-header-actions{display:flex;gap:.6rem;align-items:center}
    .em-search{position:relative}.em-search i{position:absolute;left:.8rem;top:50%;transform:translateY(-50%);color:rgba(255,255,255,.25);font-size:.85rem}
    .em-search input{padding:.55rem .9rem .55rem 2.3rem;border-radius:10px;border:1px solid var(--border);background:rgba(255,255,255,.04);color:#fff;font-size:.8rem;width:250px;outline:none;transition:border-color .2s}.em-search input:focus{border-color:rgba(var(--accent-rgb),.4)}
    .em-add-btn{display:flex;align-items:center;gap:.4rem;padding:.55rem 1.2rem;border-radius:10px;border:none;background:var(--accent);color:#000;font-size:.8rem;font-weight:700;cursor:pointer;transition:all .2s;text-decoration:none;letter-spacing:.3px}.em-add-btn:hover{box-shadow:0 4px 20px rgba(200,240,61,.3);transform:scale(1.03);color:#000}

    /* ── Stats ── */
    .em-stats{display:grid;grid-template-columns:repeat(4,1fr);gap:1rem;margin-bottom:1.8rem}
    .em-stat{background:var(--card);border:1px solid var(--border);border-radius:14px;padding:1.1rem;text-align:center;position:relative;overflow:hidden}
    .em-stat::after{content:'';position:absolute;top:0;left:0;right:0;height:2px;background:linear-gradient(90deg,transparent,var(--accent),transparent);opacity:.2}
    .em-stat-val{font-family:var(--font-display);font-size:1.8rem;color:var(--accent);letter-spacing:1px}.em-stat-lbl{font-size:.6rem;color:var(--gray);text-transform:uppercase;letter-spacing:1.5px;margin-top:.15rem}

    /* ── Filters ── */
    .em-filters{display:flex;align-items:center;gap:.5rem;margin-bottom:1.5rem;flex-wrap:wrap}
    .em-filter-label{font-size:.65rem;font-weight:700;letter-spacing:2px;text-transform:uppercase;color:var(--gray);margin-right:.3rem}
    .em-filter-btn{padding:.4rem 1rem;border-radius:50px;border:1px solid var(--border);background:transparent;color:var(--gray);font-size:.7rem;font-weight:700;cursor:pointer;transition:all .25s;letter-spacing:.3px}
    .em-filter-btn:hover{border-color:rgba(var(--accent-rgb),.3);color:#fff}
    .em-filter-btn.active{background:var(--accent);color:#000;border-color:var(--accent);box-shadow:0 4px 20px rgba(200,240,61,.15)}

    /* ── Cards Grid ── */
    .em-grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(350px,1fr));gap:1.25rem}
    .em-card{background:var(--card);border:1px solid var(--border);border-radius:14px;overflow:hidden;transition:all .25s}.em-card:hover{border-color:rgba(var(--accent-rgb),.3)}
    .em-card-top{display:flex;align-items:center;justify-content:space-between;padding:.8rem 1rem;border-bottom:1px solid var(--border);background:rgba(255,255,255,.02)}
    .em-card-name{font-weight:700;font-size:.88rem;display:flex;align-items:center;gap:.5rem;min-width:0}.em-card-name i{color:var(--accent);font-size:.85rem;flex-shrink:0}
    .em-card-name span{white-space:nowrap;overflow:hidden;text-overflow:ellipsis}
    .em-card-actions{display:flex;gap:.4rem;flex-shrink:0}
    .em-card-actions a,.em-card-actions button{background:none;border:1px solid var(--border);border-radius:6px;color:var(--gray);font-size:.68rem;padding:.3rem .55rem;cursor:pointer;transition:all .2s;display:flex;align-items:center;gap:.2rem;text-decoration:none}
    .em-card-actions a:hover{border-color:var(--accent);color:var(--accent)}
    .em-card-actions .em-del{border:1px solid var(--border);background:none;color:var(--gray)}.em-card-actions .em-del:hover{border-color:#f87171;color:#f87171}
    .em-card-body{padding:1rem}
    .em-card-desc{font-size:.72rem;color:var(--gray);line-height:1.6;display:-webkit-box;-webkit-line-clamp:2;-webkit-box-orient:vertical;overflow:hidden;margin-bottom:.7rem}
    .em-card-meta{display:flex;gap:.6rem;flex-wrap:wrap;align-items:center;margin-bottom:.7rem}
    .em-card-foot{display:flex;gap:.5rem;flex-wrap:wrap;align-items:center;padding-top:.7rem;border-top:1px solid var(--border)}

    /* ── Pills ── */
    .em-muscle{display:inline-flex;align-items:center;gap:.2rem;padding:.2rem .55rem;border-radius:20px;font-size:.58rem;font-weight:800;letter-spacing:1.5px;text-transform:uppercase}
    .em-muscle.abs{background:rgba(248,113,113,.1);border:1px solid rgba(248,113,113,.25);color:#f87171}
    .em-muscle.arms{background:rgba(96,165,250,.1);border:1px solid rgba(96,165,250,.25);color:#60a5fa}
    .em-muscle.back{background:rgba(167,139,250,.1);border:1px solid rgba(167,139,250,.25);color:#a78bfa}
    .em-muscle.chest{background:rgba(251,191,36,.1);border:1px solid rgba(251,191,36,.25);color:#fbbf24}
    .em-muscle.glutes{background:rgba(244,114,182,.1);border:1px solid rgba(244,114,182,.25);color:#f472b6}
    .em-muscle.legs{background:rgba(52,211,153,.1);border:1px solid rgba(52,211,153,.25);color:#34d399}
    .em-muscle.shoulders{background:rgba(45,212,191,.1);border:1px solid rgba(45,212,191,.25);color:#2dd4bf}
    .em-equip{display:inline-flex;align-items:center;gap:.2rem;padding:.15rem .45rem;border-radius:6px;font-size:.6rem;font-weight:600;background:rgba(255,255,255,.05);color:rgba(255,255,255,.5);letter-spacing:.3px}
    .em-style{display:inline-flex;padding:.12rem .4rem;border-radius:6px;font-size:.55rem;font-weight:700;background:rgba(var(--accent-rgb),.08);color:var(--accent);letter-spacing:.5px;text-transform:uppercase}
    .em-cat{font-size:.68rem;color:var(--gray);display:flex;align-items:center;gap:.25rem}.em-cat i{color:rgba(var(--accent-rgb),.6);font-size:.72rem}

    /* ── Empty ── */
    .em-empty{text-align:center;padding:4rem 2rem;color:var(--gray)}.em-empty i{font-size:3rem;display:block;margin-bottom:1rem;opacity:.25}
    .em-empty a{color:var(--accent);text-decoration:none;font-weight:600}

    /* ── Count ── */
    .em-count{font-size:.78rem;color:var(--gray);margin-bottom:1rem}.em-count b{color:var(--white)}

    /* ── Flash ── */
    .em-flash{padding:.8rem 1.2rem;border-radius:10px;font-size:.8rem;font-weight:600;margin-bottom:1.5rem;display:flex;align-items:center;gap:.5rem;animation:fadeIn .3s ease}
    .em-flash-success{background:rgba(52,211,153,.1);border:1px solid rgba(52,211,153,.25);color:#34d399}
    .em-flash-danger{background:rgba(248,113,113,.1);border:1px solid rgba(248,113,113,.25);color:#f87171}

    /* ── Delete Modal ── */
    .em-modal-bg{position:fixed;inset:0;background:rgba(0,0,0,.7);z-index:9000;display:none;align-items:center;justify-content:center;backdrop-filter:blur(6px)}.em-modal-bg.open{display:flex}
    .em-modal{background:#111;border:1px solid var(--border);border-radius:18px;width:420px;max-width:94vw;padding:2rem;text-align:center;animation:fadeIn .3s ease}
    .em-modal-icon{font-size:2.5rem;color:#f87171;margin-bottom:.8rem}
    .em-modal h3{font-family:var(--font-display);font-size:1.3rem;letter-spacing:2px;margin-bottom:.5rem}
    .em-modal p{color:var(--gray);font-size:.82rem;margin-bottom:1.5rem}.em-modal p strong{color:#fff}
    .em-modal-btns{display:flex;gap:.8rem;justify-content:center}
    .em-modal-cancel{padding:.5rem 1.2rem;border-radius:8px;border:1px solid var(--border);background:none;color:var(--gray);font-size:.78rem;cursor:pointer;transition:all .2s}.em-modal-cancel:hover{border-color:#fff;color:#fff}
    .em-modal-del{padding:.5rem 1.2rem;border-radius:8px;border:none;background:#f87171;color:#000;font-size:.78rem;font-weight:700;cursor:pointer;transition:all .2s}.em-modal-del:hover{box-shadow:0 4px 20px rgba(248,113,113,.3)}

    /* ── Responsive ── */
    @media(max-width:1024px){.em-stats{grid-template-columns:repeat(2,1fr)}.em-sidebar{display:none}.em-main{padding:1.5rem}}
    @media(max-width:600px){.em-grid{grid-template-columns:1fr}.em-header{flex-direction:column;align-items:flex-start}.em-search input{width:100%}}
    @keyframes fadeIn{from{opacity:0;transform:translateY(8px)}to{opacity:1;transform:translateY(0)}}
    </style>
</head>
<body>

<div class="em-page">
    <!-- Sidebar -->
    <aside class="em-sidebar">
        <div class="em-logo">APEX<span>FITNESS</span></div>
        <div class="em-sb-section">
            <div class="em-sb-label">Navigation</div>
            <a href="${pageContext.request.contextPath}/home" class="em-sb-item"><i class="bi bi-speedometer2"></i> Dashboard</a>
            <a href="${pageContext.request.contextPath}/exercise-mgmt" class="em-sb-item active"><i class="bi bi-activity"></i> Exercises</a>
            <a href="${pageContext.request.contextPath}/exercise-mgmt/new" class="em-sb-item"><i class="bi bi-plus-circle"></i> Add Exercise</a>
        </div>
        <div class="em-sb-section">
            <div class="em-sb-label">Management</div>
            <a href="${pageContext.request.contextPath}/members" class="em-sb-item"><i class="bi bi-people-fill"></i> Members</a>
            <a href="${pageContext.request.contextPath}/home#sec-classes" class="em-sb-item"><i class="bi bi-calendar3"></i> Classes</a>
            <a href="${pageContext.request.contextPath}/home#sec-supplements" class="em-sb-item"><i class="bi bi-capsule"></i> Supplements</a>
            <a href="${pageContext.request.contextPath}/trainers" class="em-sb-item"><i class="bi bi-person-badge-fill"></i> Trainers</a>
        </div>
        <div class="em-sb-section" style="margin-top:auto;padding-top:1rem;border-top:1px solid var(--border)">
            <a href="${pageContext.request.contextPath}/landing.html" class="em-sb-item"><i class="bi bi-globe2"></i> View Website</a>
        </div>
    </aside>

    <!-- Main Content -->
    <div class="em-main">
        <!-- Header -->
        <div class="em-header" style="animation:fadeIn .4s ease">
            <div class="em-header-left">
                <h1>EXERCISE <span>MANAGEMENT</span></h1>
                <p><i class="bi bi-info-circle"></i> Add, edit and manage exercises in the library — syncs to the public exercise page</p>
            </div>
            <div class="em-header-actions">
                <div class="em-search"><i class="bi bi-search"></i><input type="text" id="emSearch" placeholder="Search exercises..." oninput="searchEx()"></div>
                <a href="${pageContext.request.contextPath}/exercise-mgmt/new" class="em-add-btn"><i class="bi bi-plus-circle-fill"></i> Add Exercise</a>
            </div>
        </div>

        <!-- Flash Messages -->
        <c:if test="${param.msg == 'created'}"><div class="em-flash em-flash-success"><i class="bi bi-check-circle-fill"></i> Exercise added successfully.</div></c:if>
        <c:if test="${param.msg == 'deleted'}"><div class="em-flash em-flash-danger"><i class="bi bi-trash-fill"></i> Exercise deleted.</div></c:if>
        <c:if test="${param.msg == 'updated'}"><div class="em-flash em-flash-success"><i class="bi bi-check-circle-fill"></i> Exercise updated successfully.</div></c:if>

        <!-- Stats -->
        <div class="em-stats" style="animation:fadeIn .5s ease">
            <div class="em-stat"><div class="em-stat-val">${exercises.size()}</div><div class="em-stat-lbl">Total Exercises</div></div>
            <div class="em-stat"><div class="em-stat-val" style="color:#60a5fa">7</div><div class="em-stat-lbl">Muscle Groups</div></div>
            <div class="em-stat"><div class="em-stat-val" style="color:#a78bfa">8</div><div class="em-stat-lbl">Equipment Types</div></div>
            <div class="em-stat"><div class="em-stat-val" style="color:#34d399">5</div><div class="em-stat-lbl">Training Styles</div></div>
        </div>

        <!-- Filters -->
        <div class="em-filters" style="animation:fadeIn .55s ease">
            <span class="em-filter-label">Filter:</span>
            <button class="em-filter-btn active" onclick="filterEx('all',this)">All</button>
            <button class="em-filter-btn" onclick="filterEx('abs',this)">Abs</button>
            <button class="em-filter-btn" onclick="filterEx('arms',this)">Arms</button>
            <button class="em-filter-btn" onclick="filterEx('back',this)">Back</button>
            <button class="em-filter-btn" onclick="filterEx('chest',this)">Chest</button>
            <button class="em-filter-btn" onclick="filterEx('glutes',this)">Glutes</button>
            <button class="em-filter-btn" onclick="filterEx('legs',this)">Legs</button>
            <button class="em-filter-btn" onclick="filterEx('shoulders',this)">Shoulders</button>
        </div>

        <!-- Count -->
        <div class="em-count" id="emCount">Showing <b>${exercises.size()}</b> of <b>${exercises.size()}</b> exercises</div>

        <!-- Exercise Grid -->
        <div class="em-grid" id="emGrid">
            <c:forEach var="ex" items="${exercises}">
                <div class="em-card" data-muscle="${ex.muscleGroup}" data-name="${ex.name}" data-desc="${ex.description}" style="animation:fadeIn .5s ease">
                    <div class="em-card-top">
                        <div class="em-card-name">
                            <i class="bi bi-activity"></i>
                            <span>${ex.name}</span>
                        </div>
                        <div class="em-card-actions">
                            <span class="em-muscle ${ex.muscleGroup}">${ex.muscleGroup}</span>
                            <a href="${pageContext.request.contextPath}/exercise-mgmt/edit?id=${ex.id}"><i class="bi bi-pencil"></i> Edit</a>
                            <button class="em-del" onclick="openDeleteModal('${pageContext.request.contextPath}/exercise-mgmt/delete?id=${ex.id}','${ex.name}')"><i class="bi bi-trash3"></i></button>
                        </div>
                    </div>
                    <div class="em-card-body">
                        <div class="em-card-desc">${ex.description}</div>
                        <div class="em-card-meta">
                            <span class="em-equip"><i class="bi bi-gear"></i> ${ex.equipment}</span>
                            <span class="em-cat"><i class="bi bi-folder2-open"></i> ${ex.category}</span>
                        </div>
                        <div class="em-card-foot">
                            <c:forEach var="style" items="${ex.stylesArray}">
                                <span class="em-style">${style}</span>
                            </c:forEach>
                        </div>
                    </div>
                </div>
            </c:forEach>
            <c:if test="${empty exercises}">
                <div class="em-empty" style="grid-column:1/-1">
                    <i class="bi bi-activity"></i>
                    <div style="font-size:1rem;font-weight:600;margin-bottom:.3rem">No exercises found</div>
                    <div>Get started by <a href="${pageContext.request.contextPath}/exercise-mgmt/new">adding the first exercise</a></div>
                </div>
            </c:if>
        </div>
    </div>
</div>

<!-- Delete Confirmation Modal -->
<div class="em-modal-bg" id="emDeleteModal">
    <div class="em-modal">
        <div class="em-modal-icon"><i class="bi bi-exclamation-triangle-fill"></i></div>
        <h3>DELETE EXERCISE</h3>
        <p>Are you sure you want to delete <strong id="emDeleteName"></strong>? This action cannot be undone.</p>
        <div class="em-modal-btns">
            <button class="em-modal-cancel" onclick="closeDeleteModal()">Cancel</button>
            <button class="em-modal-del" id="emDeleteBtn" onclick="executeDelete()"><i class="bi bi-trash3"></i> Delete</button>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/static/js/fcms.js"></script>
<script>
var emDeleteUrl = '';

function filterEx(muscle, btn) {
    document.querySelectorAll('.em-filter-btn').forEach(function(p) { p.classList.remove('active'); });
    btn.classList.add('active');
    var cards = document.querySelectorAll('.em-card'), shown = 0, total = cards.length;
    cards.forEach(function(c, i) {
        var match = muscle === 'all' || c.dataset.muscle === muscle;
        c.style.display = match ? '' : 'none';
        if (match) { c.style.animation = 'fadeIn .35s ease ' + (shown * 0.04) + 's both'; shown++; }
    });
    document.getElementById('emCount').innerHTML = 'Showing <b>' + shown + '</b> of <b>' + total + '</b> exercises';
}

function searchEx() {
    var q = (document.getElementById('emSearch').value || '').toLowerCase();
    var cards = document.querySelectorAll('.em-card'), shown = 0, total = cards.length;
    cards.forEach(function(c) {
        var name = (c.dataset.name || '').toLowerCase();
        var desc = (c.dataset.desc || '').toLowerCase();
        var muscle = (c.dataset.muscle || '').toLowerCase();
        var match = !q || name.indexOf(q) >= 0 || desc.indexOf(q) >= 0 || muscle.indexOf(q) >= 0;
        c.style.display = match ? '' : 'none';
        if (match) shown++;
    });
    document.getElementById('emCount').innerHTML = 'Showing <b>' + shown + '</b> of <b>' + total + '</b> exercises';
}

function openDeleteModal(url, name) {
    emDeleteUrl = url;
    document.getElementById('emDeleteName').textContent = name;
    document.getElementById('emDeleteModal').classList.add('open');
}
function closeDeleteModal() {
    document.getElementById('emDeleteModal').classList.remove('open');
}
function executeDelete() {
    if (emDeleteUrl) window.location.href = emDeleteUrl;
}

// Auto-dismiss flash
setTimeout(function(){ document.querySelectorAll('.em-flash').forEach(function(f){ f.style.opacity='0'; f.style.transform='translateY(-10px)'; setTimeout(function(){f.remove();},300); }); }, 4000);
</script>
</body>
</html>
