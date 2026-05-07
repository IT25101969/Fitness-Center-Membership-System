<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${empty supplement ? 'Add' : 'Edit'} Supplement — FCMS</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css">
    <c:set var="pageTitle" value="${empty supplement ? 'Add Supplement' : 'Edit Supplement'}"/>
    <style>
    /* ── Two-Column Grid ── */
    .sf-grid{display:grid;grid-template-columns:1fr 360px;gap:1.5rem;align-items:start}
    @media(max-width:900px){.sf-grid{grid-template-columns:1fr}}

    /* ── Image Upload Panel ── */
    .img-panel{background:var(--card);border:1px solid var(--border);border-radius:var(--radius);overflow:hidden;position:sticky;top:90px}
    .img-panel-head{padding:1rem 1.25rem;border-bottom:1px solid var(--border);font-weight:700;font-size:.85rem;display:flex;align-items:center;gap:.5rem}
    .img-panel-head i{color:var(--accent)}
    .img-preview-box{width:100%;aspect-ratio:1;background:rgba(255,255,255,.02);display:flex;align-items:center;justify-content:center;overflow:hidden;position:relative}
    .img-preview-box img{max-width:90%;max-height:90%;object-fit:contain;border-radius:8px}
    .img-placeholder{display:flex;flex-direction:column;align-items:center;gap:.5rem;color:rgba(255,255,255,.12)}
    .img-placeholder i{font-size:3.5rem}
    .img-placeholder span{font-size:.6rem;letter-spacing:2px;text-transform:uppercase}

    /* ── Upload Zone ── */
    .upload-zone{margin:1rem 1.25rem;border:2px dashed var(--border);border-radius:12px;padding:1.5rem 1rem;text-align:center;cursor:pointer;transition:all .3s;position:relative}
    .upload-zone:hover,.upload-zone.dragover{border-color:var(--accent);background:rgba(200,240,61,.03)}
    .upload-zone i{font-size:1.5rem;color:var(--accent);display:block;margin-bottom:.4rem}
    .upload-zone p{font-size:.72rem;color:var(--gray);margin:0}
    .upload-zone small{font-size:.6rem;color:rgba(255,255,255,.2)}
    .upload-zone input{position:absolute;inset:0;opacity:0;cursor:pointer}

    /* ── Upload Actions ── */
    .img-actions{padding:.75rem 1.25rem 1.25rem;display:flex;gap:.5rem}
    .img-btn{flex:1;padding:.55rem;border-radius:10px;border:1px solid var(--border);background:rgba(255,255,255,.03);color:rgba(255,255,255,.6);font-size:.72rem;font-weight:600;cursor:pointer;font-family:var(--font-body);transition:all .2s;display:flex;align-items:center;justify-content:center;gap:.4rem}
    .img-btn:hover{border-color:var(--accent);color:var(--accent)}
    .img-btn.danger:hover{border-color:var(--danger);color:var(--danger)}

    /* ── Upload Status ── */
    .upload-status{padding:0 1.25rem;margin-bottom:.75rem;font-size:.72rem;display:none}
    .upload-status.show{display:block}
    .upload-status.success{color:#34d399}
    .upload-status.error{color:#f87171}
    .upload-status.uploading{color:var(--accent)}
    .upload-progress{height:3px;background:rgba(255,255,255,.06);border-radius:2px;margin-top:.3rem;overflow:hidden}
    .upload-progress-bar{height:100%;background:var(--accent);border-radius:2px;width:0;transition:width .3s}

    /* ── Quick Info ── */
    .quick-info{margin:0 1.25rem 1.25rem;background:rgba(255,255,255,.02);border:1px solid var(--border);border-radius:10px;padding:.75rem 1rem}
    .qi-row{display:flex;justify-content:space-between;font-size:.72rem;padding:.3rem 0}
    .qi-row span:first-child{color:var(--gray)}
    .qi-row span:last-child{font-weight:700;color:rgba(255,255,255,.7)}

    /* ── Stock Toggle ── */
    .stock-toggle{display:flex;align-items:center;gap:.75rem;cursor:pointer;padding:.75rem 1rem;border-radius:var(--radius);border:1px solid var(--border);background:var(--card);transition:all .2s}
    .stock-toggle:hover{border-color:var(--accent)}
    .stock-toggle input{display:none}
    .stock-indicator{width:42px;height:24px;border-radius:12px;background:#333;position:relative;transition:all .3s}
    .stock-indicator::after{content:'';position:absolute;width:18px;height:18px;border-radius:50%;background:#fff;top:3px;left:3px;transition:all .3s}
    .stock-toggle input:checked ~ .stock-indicator{background:var(--accent)}
    .stock-toggle input:checked ~ .stock-indicator::after{left:21px}
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
                    <i class="bi ${empty supplement ? 'bi-plus-circle-fill' : 'bi-pencil-fill'} me-2"></i>
                    ${empty supplement ? 'ADD NEW SUPPLEMENT' : 'EDIT SUPPLEMENT'}
                </h1>
                <p class="page-banner-sub">${empty supplement ? 'Add a new nutrition product to the inventory' : 'Update product details and image'}</p>
            </div>
            <a href="${pageContext.request.contextPath}/supplements" class="btn-fcms-primary" style="background:transparent;border:1px solid var(--accent);color:var(--accent);">
                <i class="bi bi-arrow-left"></i> Back to Supplements
            </a>
        </div>
    </div>

    <!-- Quick Nav -->
    <div class="quick-nav fade-in-delay">
        <a href="${pageContext.request.contextPath}/home"><i class="bi bi-speedometer2"></i> Dashboard</a>
        <a href="${pageContext.request.contextPath}/supplements"><i class="bi bi-capsule"></i> Supplements</a>
        <a href="${pageContext.request.contextPath}/supplements/new" ${empty supplement ? 'class="active"' : ''}><i class="bi bi-plus-circle"></i> Add Product</a>
    </div>

    <c:if test="${not empty error}">
        <div class="fcms-alert fcms-alert-danger"><i class="bi bi-exclamation-triangle-fill"></i> ${error}</div>
    </c:if>

    <form method="post"
          action="${pageContext.request.contextPath}/supplements/${empty supplement ? 'create' : 'update'}"
          novalidate>
        <c:if test="${not empty supplement}">
            <input type="hidden" name="id" value="${supplement.id}">
        </c:if>

        <div class="sf-grid">
            <!-- ═══ LEFT: Form Fields ═══ -->
            <div>
                <div class="fcms-form-section">
                    <p class="form-section-title"><i class="bi bi-capsule me-2"></i>Product Information</p>
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label" for="name">Product Name <span style="color:var(--danger)">*</span></label>
                            <input type="text" id="name" name="name" class="form-control" required minlength="2"
                                   placeholder="e.g. ON Gold Standard Whey"
                                   value="${not empty supplement ? supplement.name : ''}">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label" for="brand">Brand</label>
                            <input type="text" id="brand" name="brand" class="form-control"
                                   placeholder="e.g. Optimum Nutrition"
                                   value="${not empty supplement ? supplement.brand : ''}">
                        </div>
                        <div class="col-md-4">
                            <label class="form-label" for="category">Category</label>
                            <select id="category" name="category" class="form-select">
                                <option value="Protein" ${supplement.category == 'Protein' ? 'selected' : ''}>Protein</option>
                                <option value="Creatine" ${supplement.category == 'Creatine' ? 'selected' : ''}>Creatine</option>
                                <option value="Pre-Workout" ${supplement.category == 'Pre-Workout' ? 'selected' : ''}>Pre-Workout</option>
                                <option value="BCAA" ${supplement.category == 'BCAA' ? 'selected' : ''}>BCAA</option>
                                <option value="Mass Gainer" ${supplement.category == 'Mass Gainer' ? 'selected' : ''}>Mass Gainer</option>
                                <option value="Fat Burner" ${supplement.category == 'Fat Burner' ? 'selected' : ''}>Fat Burner</option>
                                <option value="Vitamins" ${supplement.category == 'Vitamins' ? 'selected' : ''}>Vitamins</option>
                                <option value="Other" ${supplement.category == 'Other' ? 'selected' : ''}>Other</option>
                            </select>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label" for="price">Price (Rs.) <span style="color:var(--danger)">*</span></label>
                            <input type="number" id="price" name="price" class="form-control" required step="0.01" min="0"
                                   placeholder="e.g. 8500.00"
                                   value="${not empty supplement ? supplement.price : ''}">
                        </div>
                        <div class="col-md-4">
                            <label class="form-label">Stock Status</label>
                            <label class="stock-toggle">
                                <input type="checkbox" name="inStock" ${empty supplement || supplement.inStock ? 'checked' : ''}>
                                <span class="stock-indicator"></span>
                                <span style="font-size:.85rem;font-weight:600" id="stockLabel">In Stock</span>
                            </label>
                        </div>
                        <div class="col-12">
                            <label class="form-label" for="description">Description</label>
                            <textarea id="description" name="description" class="form-control" rows="3"
                                      placeholder="Brief product description...">${not empty supplement ? supplement.description : ''}</textarea>
                        </div>
                        <div class="col-12">
                            <label class="form-label" for="imageUrl">External Image URL <small style="color:var(--gray)">(optional fallback)</small></label>
                            <input type="url" id="imageUrl" name="imageUrl" class="form-control"
                                   placeholder="https://example.com/product-image.jpg"
                                   value="${not empty supplement ? supplement.imageUrl : ''}">
                            <small class="text-muted-sm">Used only if no image is uploaded above</small>
                        </div>
                    </div>
                </div>

                <div style="display:flex;gap:.75rem;justify-content:flex-end;">
                    <a href="${pageContext.request.contextPath}/supplements" class="btn btn-outline-secondary">Cancel</a>
                    <button type="submit" class="btn-fcms-primary">
                        <i class="bi ${empty supplement ? 'bi-plus-circle-fill' : 'bi-check-lg'} me-1"></i>
                        ${empty supplement ? 'Add Supplement' : 'Save Changes'}
                    </button>
                </div>
            </div>

            <!-- ═══ RIGHT: Image Sidebar ═══ -->
            <div class="img-panel">
                <div class="img-panel-head"><i class="bi bi-image"></i> Product Image</div>

                <!-- Preview -->
                <div class="img-preview-box" id="imgPreview">
                    <c:choose>
                        <c:when test="${not empty supplement}">
                            <div class="img-placeholder" id="imgPlaceholder">
                                <i class="bi bi-capsule"></i><span>Loading...</span>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="img-placeholder" id="imgPlaceholder">
                                <i class="bi bi-cloud-arrow-up"></i><span>Save first, then upload</span>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-- Upload Status -->
                <div class="upload-status" id="uploadStatus">
                    <span id="uploadMsg"></span>
                    <div class="upload-progress"><div class="upload-progress-bar" id="uploadBar"></div></div>
                </div>

                <c:if test="${not empty supplement}">
                    <!-- Upload Zone -->
                    <div class="upload-zone" id="uploadZone">
                        <i class="bi bi-cloud-arrow-up-fill"></i>
                        <p>Drop image here or click to upload</p>
                        <small>JPG, PNG, WebP — Max 5 MB</small>
                        <input type="file" id="imageFile" accept="image/*" onchange="uploadImage(this.files[0])">
                    </div>

                    <!-- Actions -->
                    <div class="img-actions">
                        <button type="button" class="img-btn" onclick="document.getElementById('imageFile').click()">
                            <i class="bi bi-upload"></i> Upload
                        </button>
                        <button type="button" class="img-btn danger" id="removeBtn" onclick="deleteImage()" style="display:none">
                            <i class="bi bi-trash3"></i> Remove
                        </button>
                    </div>
                </c:if>

                <c:if test="${empty supplement}">
                    <div style="padding:1rem 1.25rem;text-align:center">
                        <p style="font-size:.72rem;color:var(--gray);margin:0"><i class="bi bi-info-circle me-1"></i> Image upload available after saving</p>
                    </div>
                </c:if>

                <!-- Quick Info -->
                <c:if test="${not empty supplement}">
                    <div class="quick-info">
                        <div class="qi-row"><span>Product ID</span><span>${supplement.id}</span></div>
                        <div class="qi-row"><span>Category</span><span>${supplement.category}</span></div>
                        <div class="qi-row"><span>Price</span><span>${supplement.formattedPrice}</span></div>
                        <div class="qi-row"><span>Stock</span><span style="color:${supplement.inStock ? '#34d399' : '#f87171'}">${supplement.inStock ? 'In Stock' : 'Out of Stock'}</span></div>
                    </div>
                </c:if>
            </div>
        </div>
    </form>
</main>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/static/js/fcms.js"></script>
<script>
// ── Stock Toggle ──
document.querySelector('.stock-toggle input').addEventListener('change', function() {
    document.getElementById('stockLabel').textContent = this.checked ? 'In Stock' : 'Out of Stock';
});

// ── Image Upload Logic ──
var SUPP_ID = '${not empty supplement ? supplement.id : ""}';
var IMG_API = '${pageContext.request.contextPath}/api/supplement-images';
var IMG_DEL_API = '${pageContext.request.contextPath}/api/supplement-images-delete';

function initImage() {
    if (!SUPP_ID) return;
    var img = new Image();
    img.onload = function() {
        showImage(IMG_API + '?id=' + SUPP_ID + '&t=' + Date.now());
    };
    img.onerror = function() {
        // Try external URL
        var extUrl = document.getElementById('imageUrl').value;
        if (extUrl) {
            showImage(extUrl);
        } else {
            showPlaceholder();
        }
    };
    img.src = IMG_API + '?id=' + SUPP_ID + '&t=' + Date.now();
}

function showImage(src) {
    document.getElementById('imgPreview').innerHTML = '<img src="' + src + '" alt="Product" onerror="showPlaceholder()">';
    var rb = document.getElementById('removeBtn');
    if (rb) rb.style.display = 'flex';
}

function showPlaceholder() {
    document.getElementById('imgPreview').innerHTML = '<div class="img-placeholder"><i class="bi bi-cloud-arrow-up"></i><span>No image</span></div>';
    var rb = document.getElementById('removeBtn');
    if (rb) rb.style.display = 'none';
}

function showStatus(msg, type) {
    var el = document.getElementById('uploadStatus');
    el.className = 'upload-status show ' + type;
    document.getElementById('uploadMsg').textContent = msg;
    if (type !== 'uploading') {
        setTimeout(function() { el.classList.remove('show'); }, 4000);
    }
}

function uploadImage(file) {
    if (!file || !SUPP_ID) return;
    if (!file.type.startsWith('image/')) { showStatus('Please select an image file', 'error'); return; }
    if (file.size > 5 * 1024 * 1024) { showStatus('File too large (max 5 MB)', 'error'); return; }

    var fd = new FormData();
    fd.append('image', file);

    showStatus('Uploading...', 'uploading');
    document.getElementById('uploadBar').style.width = '30%';

    var xhr = new XMLHttpRequest();
    xhr.open('POST', IMG_API + '?id=' + SUPP_ID);
    xhr.upload.onprogress = function(e) {
        if (e.lengthComputable) {
            document.getElementById('uploadBar').style.width = Math.round((e.loaded / e.total) * 100) + '%';
        }
    };
    xhr.onload = function() {
        document.getElementById('uploadBar').style.width = '100%';
        if (xhr.status === 200) {
            showStatus('Image uploaded successfully!', 'success');
            showImage(IMG_API + '?id=' + SUPP_ID + '&t=' + Date.now());
        } else {
            showStatus('Upload failed: ' + xhr.statusText, 'error');
        }
    };
    xhr.onerror = function() { showStatus('Upload failed — network error', 'error'); };
    xhr.send(fd);
}

function deleteImage() {
    if (!SUPP_ID) return;
    if (!confirm('Remove product image?')) return;

    showStatus('Removing...', 'uploading');
    fetch(IMG_DEL_API + '?id=' + SUPP_ID, { method: 'POST' })
    .then(function(r) { return r.json(); })
    .then(function(data) {
        if (data.success) {
            showStatus('Image removed', 'success');
            showPlaceholder();
        } else {
            showStatus('Failed: ' + data.message, 'error');
        }
    })
    .catch(function() { showStatus('Remove failed — network error', 'error'); });
}

// ── Drag & Drop ──
var zone = document.getElementById('uploadZone');
if (zone) {
    zone.addEventListener('dragover', function(e) { e.preventDefault(); zone.classList.add('dragover'); });
    zone.addEventListener('dragleave', function() { zone.classList.remove('dragover'); });
    zone.addEventListener('drop', function(e) {
        e.preventDefault();
        zone.classList.remove('dragover');
        if (e.dataTransfer.files.length) uploadImage(e.dataTransfer.files[0]);
    });
}

// ── Init ──
document.addEventListener('DOMContentLoaded', initImage);
</script>
</body>
</html>
