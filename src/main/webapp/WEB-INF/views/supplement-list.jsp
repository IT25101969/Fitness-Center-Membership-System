<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Supplement Management — FCMS</title>
    <meta name="description" content="Manage supplement products available at the fitness center.">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css">
    <c:set var="pageTitle" value="Supplement Management"/>
    <style>
    .supp-thumb{width:50px;height:50px;border-radius:10px;object-fit:cover;background:rgba(255,255,255,.05);border:1px solid rgba(255,255,255,.08)}
    .supp-thumb-placeholder{width:50px;height:50px;border-radius:10px;background:rgba(200,240,61,.08);display:flex;align-items:center;justify-content:center;color:var(--accent);font-size:1.2rem}
    .cat-pill{display:inline-block;padding:.2rem .6rem;border-radius:20px;font-size:.7rem;font-weight:700;letter-spacing:.5px;text-transform:uppercase}
    .cat-Protein{background:rgba(96,165,250,.12);color:#60a5fa}
    .cat-Creatine{background:rgba(167,139,250,.12);color:#a78bfa}
    .cat-Pre-Workout{background:rgba(248,113,113,.12);color:#f87171}
    .cat-BCAA{background:rgba(52,211,153,.12);color:#34d399}
    .cat-Mass-Gainer{background:rgba(251,191,36,.12);color:#fbbf24}
    .cat-Fat-Burner{background:rgba(244,114,182,.12);color:#f472b6}
    .cat-Vitamins{background:rgba(45,212,191,.12);color:#2dd4bf}
    .cat-Other{background:rgba(148,163,184,.12);color:#94a3b8}
    .stock-yes{color:#34d399;font-weight:700;font-size:.78rem}
    .stock-no{color:#f87171;font-weight:700;font-size:.78rem}
    .supp-stats{display:flex;gap:1.5rem;margin-bottom:1.5rem;flex-wrap:wrap}
    .supp-stat{background:var(--card);border:1px solid var(--border);border-radius:var(--radius);padding:1rem 1.5rem;flex:1;min-width:150px}
    .supp-stat-val{font-size:1.6rem;font-weight:800;color:var(--accent);line-height:1}
    .supp-stat-lbl{font-size:.72rem;color:var(--gray);margin-top:.3rem;text-transform:uppercase;letter-spacing:.5px}
    .filter-pills{display:flex;gap:.5rem;margin-bottom:1.5rem;flex-wrap:wrap}
    .filter-pill{padding:.35rem .8rem;border-radius:20px;font-size:.72rem;font-weight:600;border:1px solid var(--border);background:transparent;color:var(--gray);cursor:pointer;transition:all .2s}
    .filter-pill:hover,.filter-pill.active{background:var(--accent);color:#000;border-color:var(--accent)}
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
                <h1 class="page-banner-title"><i class="bi bi-capsule me-2"></i>SUPPLEMENT MANAGEMENT</h1>
                <p class="page-banner-sub">Manage supplements & nutrition products for your members</p>
            </div>
            <a href="${pageContext.request.contextPath}/supplements/new" class="btn-fcms-primary">
                <i class="bi bi-plus-circle-fill"></i> Add Supplement
            </a>
        </div>
    </div>

    <!-- Quick Nav -->
    <div class="quick-nav fade-in-delay">
        <a href="${pageContext.request.contextPath}/home"><i class="bi bi-speedometer2"></i> Dashboard</a>
        <a href="${pageContext.request.contextPath}/supplements" class="active"><i class="bi bi-capsule"></i> Supplements</a>
        <a href="${pageContext.request.contextPath}/supplements/new"><i class="bi bi-plus-circle"></i> Add Product</a>
    </div>

    <!-- Stats -->
    <div class="supp-stats fade-in-delay">
        <div class="supp-stat">
            <div class="supp-stat-val">${supplements.size()}</div>
            <div class="supp-stat-lbl">Total Products</div>
        </div>
        <div class="supp-stat">
            <c:set var="inStockCount" value="0"/>
            <c:forEach var="s" items="${supplements}"><c:if test="${s.inStock}"><c:set var="inStockCount" value="${inStockCount + 1}"/></c:if></c:forEach>
            <div class="supp-stat-val" style="color:#34d399">${inStockCount}</div>
            <div class="supp-stat-lbl">In Stock</div>
        </div>
        <div class="supp-stat">
            <div class="supp-stat-val" style="color:#f87171">${supplements.size() - inStockCount}</div>
            <div class="supp-stat-lbl">Out of Stock</div>
        </div>
    </div>

    <!-- Flash messages -->
    <c:if test="${param.msg == 'created'}"><div class="fcms-alert fcms-alert-success" data-auto-dismiss><i class="bi bi-check-circle-fill"></i> Supplement added successfully.</div></c:if>
    <c:if test="${param.msg == 'deleted'}"><div class="fcms-alert fcms-alert-danger" data-auto-dismiss><i class="bi bi-trash-fill"></i> Supplement deleted.</div></c:if>
    <c:if test="${param.msg == 'updated'}"><div class="fcms-alert fcms-alert-success" data-auto-dismiss><i class="bi bi-check-circle-fill"></i> Supplement updated successfully.</div></c:if>

    <!-- Category Filter -->
    <div class="filter-pills" id="filterPills">
        <button class="filter-pill active" onclick="filterSupps('all',this)">All</button>
        <button class="filter-pill" onclick="filterSupps('Protein',this)">Protein</button>
        <button class="filter-pill" onclick="filterSupps('Creatine',this)">Creatine</button>
        <button class="filter-pill" onclick="filterSupps('Pre-Workout',this)">Pre-Workout</button>
        <button class="filter-pill" onclick="filterSupps('BCAA',this)">BCAA</button>
        <button class="filter-pill" onclick="filterSupps('Mass Gainer',this)">Mass Gainer</button>
        <button class="filter-pill" onclick="filterSupps('Fat Burner',this)">Fat Burner</button>
        <button class="filter-pill" onclick="filterSupps('Vitamins',this)">Vitamins</button>
    </div>

    <!-- Supplements Table -->
    <div class="fcms-table-wrapper">
        <div style="overflow-x:auto;">
            <table class="fcms-table" id="suppTable">
                <thead>
                    <tr>
                        <th>Product</th>
                        <th>Brand</th>
                        <th>Category</th>
                        <th>Price</th>
                        <th>Stock</th>
                        <th style="text-align:center;">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="supp" items="${supplements}">
                        <tr data-category="${supp.category}">
                            <td>
                                <div style="display:flex;align-items:center;gap:.75rem;">
                                    <c:choose>
                                        <c:when test="${not empty supp.imageUrl}">
                                            <img src="${supp.imageUrl}" alt="${supp.name}" class="supp-thumb" onerror="this.outerHTML='<div class=supp-thumb-placeholder><i class=bi bi-capsule></i></div>'">
                                        </c:when>
                                        <c:otherwise>
                                            <div class="supp-thumb-placeholder"><i class="bi bi-capsule"></i></div>
                                        </c:otherwise>
                                    </c:choose>
                                    <div>
                                        <strong style="font-size:.9rem">${supp.name}</strong>
                                        <div style="font-size:.7rem;color:var(--gray);max-width:250px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap">${supp.description}</div>
                                    </div>
                                </div>
                            </td>
                            <td style="font-size:.85rem;">${supp.brand}</td>
                            <td>
                                <span class="cat-pill cat-${supp.category.replace(' ','-')}">${supp.category}</span>
                            </td>
                            <td style="font-weight:700;color:var(--accent);font-size:.9rem">${supp.formattedPrice}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${supp.inStock}">
                                        <span class="stock-yes"><i class="bi bi-check-circle-fill"></i> In Stock</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="stock-no"><i class="bi bi-x-circle-fill"></i> Out of Stock</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td style="white-space:nowrap;text-align:center;">
                                <a href="${pageContext.request.contextPath}/supplements/edit?id=${supp.id}"
                                   class="btn btn-sm btn-outline-warning me-1">
                                    <i class="bi bi-pencil-fill"></i> Edit
                                </a>
                                <button class="btn btn-sm btn-outline-danger" title="Delete supplement"
                                        onclick="confirmDelete('${pageContext.request.contextPath}/supplements/delete?id=${supp.id}','${supp.name}')">
                                    <i class="bi bi-trash-fill"></i> Delete
                                </button>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty supplements}">
                        <tr>
                            <td colspan="6" style="text-align:center;padding:3rem;color:var(--gray);">
                                <i class="bi bi-capsule" style="font-size:2.5rem;display:block;margin-bottom:.75rem;"></i>
                                No supplements found. <a href="${pageContext.request.contextPath}/supplements/new">Add your first product</a>.
                            </td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>
</main>

<!-- Delete Confirmation Modal -->
<div class="modal fade" id="deleteModal" tabindex="-1" aria-labelledby="deleteModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content" style="border-radius:var(--radius);border:none;">
            <div class="modal-header" style="background:var(--danger);color:#fff;border-radius:var(--radius) var(--radius) 0 0;">
                <h5 class="modal-title" id="deleteModalLabel">Confirm Delete</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body" style="padding:1.5rem;">
                <p>Delete supplement <strong id="deleteTargetName"></strong>? This action cannot be undone.</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                <button type="button" id="confirmDeleteBtn" class="btn-fcms-danger">Delete</button>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/static/js/fcms.js"></script>
<script>
function filterSupps(cat, btn) {
    document.querySelectorAll('.filter-pill').forEach(p => p.classList.remove('active'));
    btn.classList.add('active');
    document.querySelectorAll('#suppTable tbody tr[data-category]').forEach(row => {
        row.style.display = (cat === 'all' || row.dataset.category === cat) ? '' : 'none';
    });
}
</script>
</body>
</html>
