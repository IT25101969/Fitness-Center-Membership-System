<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${empty exercise ? 'Add' : 'Edit'} Exercise — FCMS</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css">
    <c:set var="pageTitle" value="${empty exercise ? 'Add Exercise' : 'Edit Exercise'}"/>
    <style>
    /* ── Tag Input ── */
    .style-tag-input{display:flex;flex-wrap:wrap;gap:.4rem;padding:.6rem;border-radius:var(--radius);border:1px solid var(--border);background:rgba(255,255,255,.03);min-height:44px;align-items:center;cursor:text;transition:border-color .25s}
    .style-tag-input:focus-within{border-color:var(--accent);box-shadow:0 0 0 2px rgba(200,240,61,.08)}
    .style-tag{display:inline-flex;align-items:center;gap:.3rem;padding:.22rem .6rem;border-radius:6px;font-size:.72rem;font-weight:600;background:rgba(200,240,61,.12);color:var(--accent);animation:tagIn .25s ease}
    @keyframes tagIn{from{opacity:0;transform:scale(.85)}to{opacity:1;transform:scale(1)}}
    .style-tag button{background:none;border:none;color:var(--accent);font-size:.75rem;cursor:pointer;padding:0;line-height:1;opacity:.6;transition:opacity .15s}
    .style-tag button:hover{opacity:1}
    .style-tag-input input{border:none;background:none;color:#fff;outline:none;font-size:.85rem;flex:1;min-width:100px;font-family:inherit}
    .style-tag-input input::placeholder{color:rgba(255,255,255,.25)}
    .style-suggestions{display:flex;flex-wrap:wrap;gap:.35rem;margin-top:.5rem}
    .style-sug{padding:.22rem .55rem;border-radius:6px;font-size:.65rem;font-weight:600;background:rgba(255,255,255,.04);color:rgba(255,255,255,.35);border:1px solid rgba(255,255,255,.06);cursor:pointer;transition:all .2s}
    .style-sug:hover{background:rgba(200,240,61,.12);color:var(--accent);border-color:rgba(200,240,61,.2);transform:translateY(-1px)}

    /* ── Form Layout ── */
    .ef-grid{display:grid;grid-template-columns:1fr 340px;gap:1.8rem;align-items:start}
    @media(max-width:900px){.ef-grid{grid-template-columns:1fr}}
    .ef-main{}
    .ef-sidebar{position:sticky;top:1.5rem}

    /* ── Image Upload ── */
    .img-card{background:var(--card);border:1px solid var(--border);border-radius:var(--radius);overflow:hidden}
    .img-card-header{padding:.85rem 1.1rem;border-bottom:1px solid var(--border);display:flex;align-items:center;gap:.5rem;font-size:.78rem;font-weight:700;letter-spacing:.5px;text-transform:uppercase;color:rgba(255,255,255,.55)}
    .img-card-header i{color:var(--accent);font-size:.9rem}
    .img-card-body{padding:1.1rem}
    .img-upload-area{border:2px dashed rgba(255,255,255,.1);border-radius:12px;padding:2rem 1.5rem;text-align:center;transition:all .3s ease;cursor:pointer;display:flex;flex-direction:column;align-items:center;justify-content:center;gap:.6rem;min-height:180px}
    .img-upload-area:hover,.img-upload-area.dragover{border-color:var(--accent);background:rgba(200,240,61,.04);transform:scale(1.01)}
    .img-upload-area i.upload-icon{font-size:2.5rem;color:rgba(255,255,255,.18);transition:all .3s}
    .img-upload-area:hover i.upload-icon{color:var(--accent);transform:translateY(-3px)}
    .img-upload-area .upload-text{font-size:.8rem;color:rgba(255,255,255,.4);font-weight:500}
    .img-upload-area .upload-text b{color:var(--accent)}
    .img-upload-area .upload-hint{font-size:.62rem;color:rgba(255,255,255,.18);letter-spacing:.3px}
    .img-preview-wrap{position:relative;border-radius:12px;overflow:hidden;border:1px solid rgba(255,255,255,.08);animation:imgFadeIn .4s ease}
    @keyframes imgFadeIn{from{opacity:0;transform:scale(.97)}to{opacity:1;transform:scale(1)}}
    .img-preview-wrap img{width:100%;height:220px;object-fit:cover;display:block;transition:transform .4s}
    .img-preview-wrap:hover img{transform:scale(1.03)}
    .img-preview-wrap .img-overlay{position:absolute;inset:0;background:linear-gradient(180deg,transparent 40%,rgba(0,0,0,.7));opacity:0;transition:opacity .3s;display:flex;align-items:flex-end;justify-content:center;padding:1rem;gap:.5rem}
    .img-preview-wrap:hover .img-overlay{opacity:1}
    .img-preview-actions{display:flex;gap:.5rem;margin-top:.75rem}
    .img-upload-status{font-size:.72rem;margin-top:.5rem;min-height:1.2rem;transition:all .3s}
    .img-upload-status.success{color:var(--accent)}
    .img-upload-status.error{color:#ef4444}
    .img-upload-status.uploading{color:rgba(255,255,255,.5)}
    .btn-img{padding:.4rem .85rem;border-radius:8px;font-size:.72rem;font-weight:600;border:none;cursor:pointer;display:inline-flex;align-items:center;gap:.35rem;transition:all .2s}
    .btn-img:hover{transform:translateY(-1px)}
    .btn-img-upload{background:rgba(200,240,61,.12);color:var(--accent)}
    .btn-img-upload:hover{background:rgba(200,240,61,.25)}
    .btn-img-replace{background:rgba(96,165,250,.12);color:#60a5fa}
    .btn-img-replace:hover{background:rgba(96,165,250,.25)}
    .btn-img-delete{background:rgba(239,68,68,.1);color:#ef4444}
    .btn-img-delete:hover{background:rgba(239,68,68,.22)}
    .img-new-note{font-size:.75rem;color:rgba(255,255,255,.35);display:flex;align-items:center;gap:.6rem;padding:1rem;background:rgba(200,240,61,.03);border-radius:10px;border:1px solid rgba(200,240,61,.08)}
    .img-new-note i{font-size:1.1rem;color:var(--accent);flex-shrink:0}

    /* ── Exercise ID Badge ── */
    .ex-id-badge{display:inline-flex;align-items:center;gap:.35rem;padding:.2rem .6rem;border-radius:6px;font-size:.65rem;font-weight:700;letter-spacing:.5px;background:rgba(200,240,61,.1);color:var(--accent);font-family:'Courier New',monospace}

    /* ── Form Section Titles ── */
    .ef-section-title{font-size:.72rem;font-weight:700;letter-spacing:1.5px;text-transform:uppercase;color:rgba(255,255,255,.45);margin-bottom:1rem;display:flex;align-items:center;gap:.5rem}
    .ef-section-title::after{content:'';flex:1;height:1px;background:var(--border)}

    /* ── Submit Bar ── */
    .ef-submit-bar{display:flex;gap:.75rem;justify-content:flex-end;padding-top:1.5rem;border-top:1px solid var(--border);margin-top:.5rem}
    </style>
</head>
<body>
<jsp:include page="navbar.jsp"/>

<main class="full-main">

    <!-- Banner -->
    <div class="page-banner fade-in">
        <div class="page-banner-overlay" style="background:linear-gradient(135deg,rgba(0,0,0,.85),rgba(200,240,61,.08))"></div>
        <div class="page-banner-content">
            <div>
                <h1 class="page-banner-title">
                    <i class="bi ${empty exercise ? 'bi-plus-circle-fill' : 'bi-pencil-fill'} me-2"></i>
                    ${empty exercise ? 'ADD NEW EXERCISE' : 'EDIT EXERCISE'}
                </h1>
                <p class="page-banner-sub">
                    ${empty exercise ? 'Add a new exercise to the library' : 'Update exercise details'}
                    <c:if test="${not empty exercise}">
                        <span class="ex-id-badge ms-2"><i class="bi bi-hash"></i>${exercise.id}</span>
                    </c:if>
                </p>
            </div>
            <a href="${pageContext.request.contextPath}/exercise-mgmt" class="btn-fcms-primary" style="background:transparent;border:1px solid var(--accent);color:var(--accent);">
                <i class="bi bi-arrow-left"></i> Back to Exercises
            </a>
        </div>
    </div>

    <!-- Quick Nav -->
    <div class="quick-nav fade-in-delay">
        <a href="${pageContext.request.contextPath}/home"><i class="bi bi-speedometer2"></i> Dashboard</a>
        <a href="${pageContext.request.contextPath}/exercise-mgmt"><i class="bi bi-activity"></i> Exercises</a>
        <a href="${pageContext.request.contextPath}/exercise-mgmt/new" ${empty exercise ? 'class="active"' : ''}><i class="bi bi-plus-circle"></i> Add Exercise</a>
    </div>

    <c:if test="${not empty error}">
        <div class="fcms-alert fcms-alert-danger"><i class="bi bi-exclamation-triangle-fill"></i> ${error}</div>
    </c:if>

    <form method="post"
          action="${pageContext.request.contextPath}/exercise-mgmt/${empty exercise ? 'create' : 'update'}"
          novalidate>
        <c:if test="${not empty exercise}">
            <input type="hidden" name="id" value="${exercise.id}">
        </c:if>

        <div class="ef-grid">
            <!-- ═══ LEFT: Main Form ═══ -->
            <div class="ef-main">
                <div class="fcms-form-section">
                    <div class="ef-section-title"><i class="bi bi-activity"></i> Exercise Information</div>
                    <div class="row g-3">
                        <div class="col-md-8">
                            <label class="form-label" for="name">Exercise Name <span style="color:var(--danger)">*</span></label>
                            <input type="text" id="name" name="name" class="form-control" required minlength="2"
                                   placeholder="e.g. Barbell Bench Press"
                                   value="${not empty exercise ? exercise.name : ''}">
                        </div>
                        <div class="col-md-4">
                            <label class="form-label" for="muscleGroup">Muscle Group</label>
                            <select id="muscleGroup" name="muscleGroup" class="form-select">
                                <option value="abs" ${exercise.muscleGroup == 'abs' ? 'selected' : ''}>Abs / Core</option>
                                <option value="arms" ${exercise.muscleGroup == 'arms' ? 'selected' : ''}>Arms</option>
                                <option value="back" ${exercise.muscleGroup == 'back' ? 'selected' : ''}>Back</option>
                                <option value="chest" ${exercise.muscleGroup == 'chest' ? 'selected' : ''}>Chest</option>
                                <option value="glutes" ${exercise.muscleGroup == 'glutes' ? 'selected' : ''}>Glutes</option>
                                <option value="legs" ${exercise.muscleGroup == 'legs' ? 'selected' : ''}>Legs</option>
                                <option value="shoulders" ${exercise.muscleGroup == 'shoulders' ? 'selected' : ''}>Shoulders</option>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label" for="equipment">Equipment</label>
                            <select id="equipment" name="equipment" class="form-select">
                                <option value="barbell" ${exercise.equipment == 'barbell' ? 'selected' : ''}>Barbell</option>
                                <option value="dumbbell" ${exercise.equipment == 'dumbbell' ? 'selected' : ''}>Dumbbell</option>
                                <option value="bodyweight" ${exercise.equipment == 'bodyweight' ? 'selected' : ''}>Bodyweight</option>
                                <option value="cable" ${exercise.equipment == 'cable' ? 'selected' : ''}>Cable</option>
                                <option value="machine" ${exercise.equipment == 'machine' ? 'selected' : ''}>Machine</option>
                                <option value="kettlebell" ${exercise.equipment == 'kettlebell' ? 'selected' : ''}>Kettlebell</option>
                                <option value="band" ${exercise.equipment == 'band' ? 'selected' : ''}>Resistance Band</option>
                                <option value="stability" ${exercise.equipment == 'stability' ? 'selected' : ''}>Stability Ball</option>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label" for="category">Training Category</label>
                            <select id="category" name="category" class="form-select">
                                <option value="build" ${exercise.category == 'build' ? 'selected' : ''}>Build — Muscle growth</option>
                                <option value="focus" ${exercise.category == 'focus' ? 'selected' : ''}>Focus — Technique & skill</option>
                                <option value="goals" ${exercise.category == 'goals' ? 'selected' : ''}>Goals — Recovery & mobility</option>
                            </select>
                        </div>
                        <div class="col-12">
                            <label class="form-label" for="description">Description</label>
                            <textarea id="description" name="description" class="form-control" rows="3"
                                      placeholder="Brief description of how to perform this exercise...">${not empty exercise ? exercise.description : ''}</textarea>
                        </div>
                    </div>
                </div>

                <div class="fcms-form-section">
                    <div class="ef-section-title"><i class="bi bi-tags"></i> Training Styles</div>
                    <input type="hidden" name="styles" id="stylesHidden"
                           value="${not empty exercise ? exercise.styles : 'Strength'}">
                    <div class="style-tag-input" id="styleTagInput" onclick="document.getElementById('styleInput').focus()">
                        <input type="text" id="styleInput" placeholder="Type and press Enter to add..."
                               onkeydown="handleStyleKey(event)">
                    </div>
                    <div class="style-suggestions">
                        <span class="style-sug" onclick="addStyle('Strength')">Strength</span>
                        <span class="style-sug" onclick="addStyle('Bodybuilding')">Bodybuilding</span>
                        <span class="style-sug" onclick="addStyle('Powerlifting')">Powerlifting</span>
                        <span class="style-sug" onclick="addStyle('HIIT')">HIIT</span>
                        <span class="style-sug" onclick="addStyle('Crossfit')">Crossfit</span>
                        <span class="style-sug" onclick="addStyle('Cardio')">Cardio</span>
                        <span class="style-sug" onclick="addStyle('Core')">Core</span>
                        <span class="style-sug" onclick="addStyle('Endurance')">Endurance</span>
                        <span class="style-sug" onclick="addStyle('Stretching')">Stretching</span>
                        <span class="style-sug" onclick="addStyle('Mobility')">Mobility</span>
                        <span class="style-sug" onclick="addStyle('Recovery')">Recovery</span>
                    </div>
                </div>

                <!-- Submit Bar -->
                <div class="ef-submit-bar">
                    <a href="${pageContext.request.contextPath}/exercise-mgmt" class="btn btn-outline-secondary">Cancel</a>
                    <button type="submit" class="btn-fcms-primary">
                        <i class="bi ${empty exercise ? 'bi-plus-circle-fill' : 'bi-check-lg'} me-1"></i>
                        ${empty exercise ? 'Add Exercise' : 'Save Changes'}
                    </button>
                </div>
            </div>

            <!-- ═══ RIGHT: Image Sidebar ═══ -->
            <div class="ef-sidebar">
                <div class="img-card">
                    <div class="img-card-header"><i class="bi bi-image"></i> Exercise Image</div>
                    <div class="img-card-body">
                        <c:choose>
                            <c:when test="${not empty exercise}">
                                <!-- Edit mode: image preview + upload -->
                                <div id="imgPreviewContainer">
                                    <div class="img-preview-wrap" id="imgPreview" style="display:none">
                                        <img id="imgPreviewImg" src="" alt="Exercise image">
                                        <div class="img-overlay">
                                            <button type="button" class="btn-img btn-img-replace"
                                                    onclick="event.stopPropagation();document.getElementById('imgFileInput').click()">
                                                <i class="bi bi-arrow-repeat"></i> Replace
                                            </button>
                                            <button type="button" class="btn-img btn-img-delete"
                                                    onclick="event.stopPropagation();deleteExerciseImage()">
                                                <i class="bi bi-trash3"></i> Remove
                                            </button>
                                        </div>
                                    </div>
                                    <div class="img-upload-area" id="imgDropZone" style="display:none"
                                         onclick="document.getElementById('imgFileInput').click()">
                                        <i class="bi bi-cloud-arrow-up-fill upload-icon"></i>
                                        <div class="upload-text"><b>Click to upload</b> or drag & drop</div>
                                        <div class="upload-hint">JPEG, PNG, WebP — max 5 MB</div>
                                    </div>
                                    <input type="file" id="imgFileInput" accept="image/*" style="display:none"
                                           onchange="uploadExerciseImage(this)">
                                    <div class="img-preview-actions" id="imgActions">
                                        <button type="button" class="btn-img btn-img-upload"
                                                onclick="document.getElementById('imgFileInput').click()">
                                            <i class="bi bi-upload"></i> Upload
                                        </button>
                                        <button type="button" class="btn-img btn-img-delete" id="imgDeleteBtn"
                                                style="display:none" onclick="deleteExerciseImage()">
                                            <i class="bi bi-trash3"></i> Remove
                                        </button>
                                    </div>
                                    <div class="img-upload-status" id="imgStatus"></div>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="img-new-note">
                                    <i class="bi bi-info-circle-fill"></i>
                                    <span>Save the exercise first, then edit it to upload an image.</span>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <!-- Quick Info Card (Edit Mode) -->
                <c:if test="${not empty exercise}">
                <div class="img-card" style="margin-top:1rem">
                    <div class="img-card-header"><i class="bi bi-info-circle"></i> Quick Info</div>
                    <div class="img-card-body" style="font-size:.75rem;color:rgba(255,255,255,.4)">
                        <div style="display:flex;justify-content:space-between;margin-bottom:.5rem">
                            <span>ID</span>
                            <span class="ex-id-badge">${exercise.id}</span>
                        </div>
                        <div style="display:flex;justify-content:space-between;margin-bottom:.5rem">
                            <span>Muscle Group</span>
                            <span style="text-transform:capitalize;color:rgba(255,255,255,.6)">${exercise.muscleGroup}</span>
                        </div>
                        <div style="display:flex;justify-content:space-between;margin-bottom:.5rem">
                            <span>Equipment</span>
                            <span style="text-transform:capitalize;color:rgba(255,255,255,.6)">${exercise.equipment}</span>
                        </div>
                        <div style="display:flex;justify-content:space-between">
                            <span>Category</span>
                            <span style="text-transform:capitalize;color:rgba(255,255,255,.6)">${exercise.category}</span>
                        </div>
                    </div>
                </div>
                </c:if>
            </div>
        </div>
    </form>
</main>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/static/js/fcms.js"></script>
<script>
/* ── Training Styles Tag Input ── */
var currentStyles = [];

function initStyles() {
    var val = document.getElementById('stylesHidden').value;
    if (val) {
        val.split('|').forEach(function(s) {
            if (s.trim()) currentStyles.push(s.trim());
        });
    }
    renderStyles();
}

function renderStyles() {
    var container = document.getElementById('styleTagInput');
    var input = document.getElementById('styleInput');
    // Remove existing tags
    container.querySelectorAll('.style-tag').forEach(function(t) { t.remove(); });
    currentStyles.forEach(function(s, i) {
        var tag = document.createElement('span');
        tag.className = 'style-tag';
        tag.innerHTML = s + ' <button type="button" onclick="removeStyle(' + i + ')">&times;</button>';
        container.insertBefore(tag, input);
    });
    document.getElementById('stylesHidden').value = currentStyles.join('|');
}

function addStyle(name) {
    name = name.trim();
    if (!name || currentStyles.indexOf(name) >= 0) return;
    currentStyles.push(name);
    renderStyles();
    document.getElementById('styleInput').value = '';
}

function removeStyle(idx) {
    currentStyles.splice(idx, 1);
    renderStyles();
}

function handleStyleKey(e) {
    if (e.key === 'Enter' || e.key === ',') {
        e.preventDefault();
        addStyle(e.target.value);
    }
    if (e.key === 'Backspace' && e.target.value === '' && currentStyles.length > 0) {
        currentStyles.pop();
        renderStyles();
    }
}

document.addEventListener('DOMContentLoaded', function() {
    initStyles();
    initExerciseImage();
});

/* ── Image Upload Functions ── */
var EXERCISE_ID = '${not empty exercise ? exercise.slugId : ""}';
var IMG_API = '${pageContext.request.contextPath}/api/exercise-images';

function initExerciseImage() {
    if (!EXERCISE_ID) return;
    
    var previewWrap = document.getElementById('imgPreview');
    var dropZone = document.getElementById('imgDropZone');
    var deleteBtn = document.getElementById('imgDeleteBtn');
    var previewImg = document.getElementById('imgPreviewImg');
    
    if (!previewWrap) return;

    // Check if image exists by trying to load it
    var imgUrl = IMG_API + '?id=' + EXERCISE_ID + '&t=' + Date.now();
    var testImg = new Image();
    testImg.onload = function() {
        previewImg.src = imgUrl;
        previewWrap.style.display = 'block';
        dropZone.style.display = 'none';
        deleteBtn.style.display = '';
    };
    testImg.onerror = function() {
        previewWrap.style.display = 'none';
        dropZone.style.display = '';
        deleteBtn.style.display = 'none';
    };
    testImg.src = imgUrl;

    // Drag & drop
    if (dropZone) {
        ['dragover','dragenter'].forEach(function(evt) {
            dropZone.addEventListener(evt, function(e) { e.preventDefault(); dropZone.classList.add('dragover'); });
        });
        ['dragleave','dragend'].forEach(function(evt) {
            dropZone.addEventListener(evt, function() { dropZone.classList.remove('dragover'); });
        });
        dropZone.addEventListener('drop', function(e) {
            e.preventDefault();
            dropZone.classList.remove('dragover');
            if (e.dataTransfer.files.length > 0) {
                document.getElementById('imgFileInput').files = e.dataTransfer.files;
                uploadExerciseImage(document.getElementById('imgFileInput'));
            }
        });
    }
}

function uploadExerciseImage(input) {
    if (!input.files || !input.files[0]) return;
    
    var file = input.files[0];
    if (!file.type.startsWith('image/')) {
        setImgStatus('Please select an image file (JPEG, PNG, WebP)', 'error');
        return;
    }
    if (file.size > 5 * 1024 * 1024) {
        setImgStatus('Image must be under 5 MB', 'error');
        return;
    }

    setImgStatus('Uploading image…', 'uploading');

    var formData = new FormData();
    formData.append('image', file);

    fetch(IMG_API + '?id=' + EXERCISE_ID, {
        method: 'POST',
        body: formData
    })
    .then(function(res) { return res.json(); })
    .then(function(data) {
        if (data.success) {
            setImgStatus('Image uploaded successfully!', 'success');
            var previewImg = document.getElementById('imgPreviewImg');
            previewImg.src = IMG_API + '?id=' + EXERCISE_ID + '&t=' + Date.now();
            document.getElementById('imgPreview').style.display = 'block';
            document.getElementById('imgDropZone').style.display = 'none';
            document.getElementById('imgDeleteBtn').style.display = '';
            setTimeout(function() { setImgStatus('', ''); }, 3000);
        } else {
            setImgStatus(data.message || 'Upload failed', 'error');
        }
    })
    .catch(function(err) {
        setImgStatus('Upload failed: ' + err.message, 'error');
    });
    
    input.value = '';
}

function deleteExerciseImage() {
    if (!confirm('Remove this exercise image?')) return;
    
    setImgStatus('Removing image…', 'uploading');

    // Use the dedicated delete servlet (separate from multipart upload servlet)
    fetch(IMG_API + '-delete?id=' + EXERCISE_ID, {
        method: 'POST'
    })
    .then(function(res) { return res.json(); })
    .then(function(data) {
        if (data.success) {
            setImgStatus('Image removed', 'success');
            document.getElementById('imgPreview').style.display = 'none';
            document.getElementById('imgDropZone').style.display = '';
            document.getElementById('imgDeleteBtn').style.display = 'none';
            setTimeout(function() { setImgStatus('', ''); }, 3000);
        } else {
            setImgStatus(data.message || 'Delete failed', 'error');
        }
    })
    .catch(function(err) {
        setImgStatus('Delete failed: ' + err.message, 'error');
    });
}

function setImgStatus(msg, cls) {
    var el = document.getElementById('imgStatus');
    if (!el) return;
    el.textContent = msg;
    el.className = 'img-upload-status' + (cls ? ' ' + cls : '');
}
</script>
</body>
</html>
