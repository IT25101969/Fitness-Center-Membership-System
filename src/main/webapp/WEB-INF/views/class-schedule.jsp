<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Class Schedule — FCMS</title>
    <meta name="description" content="Weekly fitness class schedule with enrollment management and capacity tracking.">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css">
    <c:set var="pageTitle" value="Class Schedule"/>
</head>
<body>

<jsp:include page="navbar.jsp"/>

<main class="full-main">

    <!-- Banner -->
    <div class="page-banner fade-in">
        <img src="${pageContext.request.contextPath}/static/images/workout-class.png" alt="" class="page-banner-bg">
        <div class="page-banner-overlay"></div>
        <div class="page-banner-content">
            <div>
                <h1 class="page-banner-title"><i class="bi bi-calendar3-week me-2"></i>CLASS SCHEDULE</h1>
                <p class="page-banner-sub">Manage weekly class schedule and bookings</p>
            </div>
            <button class="btn-fcms-primary" data-bs-toggle="modal" data-bs-target="#addClassModal">
                <i class="bi bi-plus-circle-fill"></i> Add New Class
            </button>
        </div>
    </div>

    <!-- Quick Nav -->
    <div class="quick-nav fade-in-delay">
        <a href="${pageContext.request.contextPath}/home"><i class="bi bi-speedometer2"></i> Dashboard</a>
        <a href="${pageContext.request.contextPath}/members"><i class="bi bi-people-fill"></i> Members</a>
        <a href="${pageContext.request.contextPath}/plans"><i class="bi bi-card-list"></i> Plans</a>
        <a href="${pageContext.request.contextPath}/classes" class="active"><i class="bi bi-calendar3-week"></i> Classes</a>
        <a href="${pageContext.request.contextPath}/attendance"><i class="bi bi-clock-history"></i> Attendance</a>
        <a href="${pageContext.request.contextPath}/attendance/report"><i class="bi bi-bar-chart-line"></i> Reports</a>
    </div>

    <!-- Flash messages -->
    <c:if test="${param.msg == 'created'}"><div class="fcms-alert fcms-alert-success" data-auto-dismiss><i class="bi bi-check-circle-fill"></i> Class created successfully!</div></c:if>
    <c:if test="${param.msg == 'enrolled'}"><div class="fcms-alert fcms-alert-success" data-auto-dismiss><i class="bi bi-check-circle-fill"></i> Enrolled successfully!</div></c:if>
    <c:if test="${param.msg == 'deleted'}"><div class="fcms-alert fcms-alert-danger" data-auto-dismiss><i class="bi bi-trash-fill"></i> Class deleted.</div></c:if>
    <c:if test="${param.error == 'class_full'}"><div class="fcms-alert fcms-alert-danger" data-auto-dismiss><i class="bi bi-exclamation-triangle-fill"></i> Class is full! Enrollment rejected.</div></c:if>
    <c:if test="${param.error == 'member_not_found'}"><div class="fcms-alert fcms-alert-danger" data-auto-dismiss><i class="bi bi-exclamation-triangle-fill"></i> Member not found.</div></c:if>
    <c:if test="${not empty error}"><div class="fcms-alert fcms-alert-danger"><i class="bi bi-exclamation-triangle-fill"></i> ${error}</div></c:if>

    <!-- Legend -->
    <div style="display:flex;gap:1rem;flex-wrap:wrap;margin-bottom:1.5rem;align-items:center;">
        <span style="font-size:.72rem;font-weight:700;letter-spacing:2px;text-transform:uppercase;color:rgba(255,255,255,.4);">Capacity:</span>
        <span style="display:flex;align-items:center;gap:.4rem;font-size:.78rem;"><span style="width:10px;height:10px;border-radius:50%;background:#34d399;display:inline-block;"></span> &lt;70% Available</span>
        <span style="display:flex;align-items:center;gap:.4rem;font-size:.78rem;"><span style="width:10px;height:10px;border-radius:50%;background:#fbbf24;display:inline-block;"></span> 70–90% Filling Up</span>
        <span style="display:flex;align-items:center;gap:.4rem;font-size:.78rem;"><span style="width:10px;height:10px;border-radius:50%;background:#f87171;display:inline-block;"></span> &gt;90% / Full</span>
    </div>

    <!-- Weekly Schedule Grid -->
    <div style="overflow-x:auto;margin-bottom:2rem;">
        <div style="display:grid;grid-template-columns:repeat(7,minmax(130px,1fr));gap:.75rem;min-width:900px;">
            <c:forEach var="day" items="${days}">
                <div>
                    <div style="font-size:.65rem;font-weight:800;letter-spacing:3px;text-transform:uppercase;color:var(--accent);padding:.5rem .75rem .4rem;border-bottom:1px solid rgba(255,255,255,.07);margin-bottom:.6rem;">${day}</div>
                    <c:forEach var="cls" items="${schedule[day]}">
                        <c:set var="isFull" value="${cls.capacityPercent >= 100}"/>
                        <c:set var="isNear" value="${cls.capacityPercent >= 70}"/>
                        <a href="#" onclick="showClassModal('${cls.classId}','${cls.className}','${not empty cls.trainerName ? cls.trainerName : (not empty cls.trainerId ? cls.trainerId : 'Unassigned')}','${cls.schedule}',${cls.capacity},${cls.enrolled},'${cls.status}');return false;"
                           style="display:block;text-decoration:none;background:${isFull ? 'rgba(248,113,113,.1)' : (isNear ? 'rgba(251,191,36,.08)' : 'rgba(52,211,153,.08)')};border:1px solid ${isFull ? 'rgba(248,113,113,.35)' : (isNear ? 'rgba(251,191,36,.3)' : 'rgba(52,211,153,.25)')};border-radius:12px;padding:.75rem;margin-bottom:.5rem;transition:all .2s;position:relative;overflow:hidden;">
                            <div style="font-size:.72rem;font-weight:800;letter-spacing:.4px;text-transform:uppercase;color:#fff;margin-bottom:.25rem;line-height:1.3;">${cls.className}</div>
                            <div style="font-size:.65rem;color:rgba(255,255,255,.5);margin-bottom:.5rem;">
                                <i class="bi bi-clock" style="color:${isFull ? '#f87171' : (isNear ? '#fbbf24' : '#34d399')};"></i> ${cls.scheduleTime}
                            </div>
                            <div style="display:flex;align-items:center;justify-content:space-between;">
                                <span style="font-size:.6rem;font-weight:700;color:${isFull ? '#f87171' : (isNear ? '#fbbf24' : '#34d399')};">${cls.enrolled}/${cls.capacity}</span>
                                <span style="width:28px;height:4px;border-radius:2px;background:rgba(255,255,255,.1);overflow:hidden;display:block;">
                                    <span style="display:block;height:100%;width:${cls.capacityPercent > 100 ? 100 : cls.capacityPercent}%;background:${isFull ? '#f87171' : (isNear ? '#fbbf24' : '#34d399')};border-radius:2px;"></span>
                                </span>
                            </div>
                        </a>
                    </c:forEach>
                    <c:if test="${empty schedule[day]}">
                        <div style="border:1px dashed rgba(255,255,255,.08);border-radius:12px;padding:1rem .75rem;text-align:center;">
                            <i class="bi bi-dash" style="color:rgba(255,255,255,.2);font-size:1.2rem;"></i>
                        </div>
                    </c:if>
                </div>
            </c:forEach>
        </div>
    </div>

    <!-- All Classes Cards -->
    <div style="margin-bottom:2rem;">
        <div style="display:flex;align-items:center;justify-content:space-between;margin-bottom:1.25rem;">
            <div>
                <div style="font-size:.62rem;font-weight:800;letter-spacing:3px;text-transform:uppercase;color:var(--accent);">Management</div>
                <h3 style="font-family:'Bebas Neue',sans-serif;font-size:1.8rem;letter-spacing:2px;margin:0;">ALL CLASSES</h3>
            </div>
            <span style="font-size:.78rem;color:rgba(255,255,255,.4);">${allClasses.size()} total</span>
        </div>
        <div style="display:grid;grid-template-columns:repeat(auto-fill,minmax(280px,1fr));gap:1rem;">
            <c:forEach var="cls" items="${allClasses}">
                <c:set var="isFull" value="${cls.capacityPercent >= 100}"/>
                <c:set var="isNear" value="${cls.capacityPercent >= 70}"/>
                <div style="background:rgba(255,255,255,.03);border:1px solid rgba(255,255,255,.08);border-radius:16px;padding:1.25rem;transition:border-color .2s;position:relative;overflow:hidden;">
                    <div style="position:absolute;top:0;left:0;width:3px;height:100%;background:${isFull ? '#f87171' : (isNear ? '#fbbf24' : '#34d399')};border-radius:16px 0 0 16px;"></div>
                    <div style="padding-left:.5rem;">
                        <div style="display:flex;align-items:flex-start;justify-content:space-between;margin-bottom:.75rem;">
                            <div>
                                <div style="font-size:.6rem;font-weight:700;letter-spacing:2px;text-transform:uppercase;color:var(--accent);margin-bottom:.2rem;">${cls.classId}</div>
                                <div style="font-size:.95rem;font-weight:800;letter-spacing:.3px;color:#fff;">${cls.className}</div>
                            </div>
                            <span style="font-size:.6rem;font-weight:800;padding:.2rem .6rem;border-radius:20px;background:${isFull ? 'rgba(248,113,113,.15)' : 'rgba(52,211,153,.12)'};color:${isFull ? '#f87171' : '#34d399'};border:1px solid ${isFull ? 'rgba(248,113,113,.3)' : 'rgba(52,211,153,.25)'}; white-space:nowrap;">${cls.status}</span>
                        </div>
                        <div style="display:flex;flex-direction:column;gap:.35rem;margin-bottom:1rem;">
                            <div style="font-size:.75rem;color:rgba(255,255,255,.5);display:flex;align-items:center;gap:.5rem;">
                                <i class="bi bi-person-badge" style="color:var(--accent);"></i>
                                ${not empty cls.trainerName ? cls.trainerName : (not empty cls.trainerId ? cls.trainerId : 'Unassigned')}
                            </div>
                            <div style="font-size:.75rem;color:rgba(255,255,255,.5);display:flex;align-items:center;gap:.5rem;">
                                <i class="bi bi-clock" style="color:var(--accent);"></i> ${cls.schedule}
                            </div>
                        </div>
                        <div style="margin-bottom:.85rem;">
                            <div style="display:flex;justify-content:space-between;font-size:.7rem;color:rgba(255,255,255,.45);margin-bottom:.35rem;">
                                <span>Enrollment</span>
                                <span style="color:${isFull ? '#f87171' : (isNear ? '#fbbf24' : '#34d399')};font-weight:700;">${cls.enrolled} / ${cls.capacity}</span>
                            </div>
                            <div style="height:5px;border-radius:3px;background:rgba(255,255,255,.08);overflow:hidden;">
                                <div style="height:100%;width:${cls.capacityPercent > 100 ? 100 : cls.capacityPercent}%;background:${isFull ? '#f87171' : (isNear ? '#fbbf24' : '#34d399')};border-radius:3px;transition:width .4s;"></div>
                            </div>
                        </div>
                        <div style="display:flex;gap:.5rem;">
                            <button onclick="showClassModal('${cls.classId}','${cls.className}','${not empty cls.trainerName ? cls.trainerName : (not empty cls.trainerId ? cls.trainerId : 'Unassigned')}','${cls.schedule}',${cls.capacity},${cls.enrolled},'${cls.status}')"
                                    style="flex:1;padding:.45rem;border-radius:8px;border:1px solid rgba(200,240,61,.25);background:rgba(200,240,61,.07);color:var(--accent);font-size:.72rem;font-weight:700;cursor:pointer;transition:all .2s;">
                                <i class="bi bi-person-check-fill"></i> Enroll
                            </button>
                            <button onclick="confirmDelete('${pageContext.request.contextPath}/classes/delete?id=${cls.classId}','${cls.className}')"
                                    style="padding:.45rem .75rem;border-radius:8px;border:1px solid rgba(248,113,113,.25);background:rgba(248,113,113,.07);color:#f87171;font-size:.72rem;cursor:pointer;transition:all .2s;">
                                <i class="bi bi-trash-fill"></i>
                            </button>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
        <c:if test="${empty allClasses}">
            <div style="text-align:center;padding:4rem;border:1px dashed rgba(255,255,255,.1);border-radius:16px;">
                <i class="bi bi-calendar-x" style="font-size:2.5rem;color:rgba(255,255,255,.2);display:block;margin-bottom:1rem;"></i>
                <div style="color:rgba(255,255,255,.35);font-size:.85rem;">No classes yet. Click <strong>Add New Class</strong> to get started.</div>
            </div>
        </c:if>
    </div>
</main>

<!-- Class Detail / Enroll Modal -->
<div class="modal fade" id="classDetailModal" tabindex="-1" aria-labelledby="classDetailLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-lg">
        <div class="modal-content" style="border-radius:var(--radius);border:none;">
            <div class="modal-header" style="background:var(--accent);color:var(--black);border-radius:var(--radius) var(--radius) 0 0;">
                <h5 class="modal-title" id="classDetailLabel"><i class="bi bi-calendar3 me-2"></i><span id="modalClassName"></span></h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body" style="padding:1.5rem;">
                <div class="row g-3 mb-3">
                    <div class="col-md-4">
                        <small class="text-muted-sm">Trainer</small>
                        <div style="font-weight:600;" id="modalTrainer"></div>
                    </div>
                    <div class="col-md-4">
                        <small class="text-muted-sm">Schedule</small>
                        <div style="font-weight:600;" id="modalSchedule"></div>
                    </div>
                    <div class="col-md-4">
                        <small class="text-muted-sm">Status</small>
                        <div style="font-weight:600;" id="modalStatus"></div>
                    </div>
                </div>
                <div style="margin-bottom:1rem;">
                    <div style="display:flex;justify-content:space-between;font-size:.85rem;margin-bottom:.4rem;">
                        <span>Capacity</span>
                        <span id="modalEnrolled" style="font-weight:600;"></span>
                    </div>
                    <div class="capacity-bar" style="height:12px;">
                        <div id="modalCapacityBar" class="capacity-fill" style="width:0%;line-height:12px;font-size:.65rem;text-align:center;color:#fff;"></div>
                    </div>
                </div>
                <hr>
                <h6 style="margin-bottom:.75rem;font-weight:600;">Enroll a Member</h6>
                <form method="post" action="${pageContext.request.contextPath}/enrollments/enroll">
                    <input type="hidden" id="enrollClassId" name="classId" value="">
                    <div style="display:flex;gap:.75rem;align-items:flex-end;">
                        <div style="flex:1;">
                            <label class="form-label" for="enrollMemberId">Member ID</label>
                            <input type="text" id="enrollMemberId" name="memberId" class="form-control"
                                   placeholder="e.g. M001" required>
                        </div>
                        <button type="submit" class="btn-fcms-primary">
                            <i class="bi bi-person-check-fill"></i> Enroll
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<!-- Add Class Modal -->
<div class="modal fade" id="addClassModal" tabindex="-1" aria-labelledby="addClassLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-lg">
        <div class="modal-content" style="border-radius:var(--radius);border:none;">
            <div class="modal-header" style="background:var(--accent);color:#fff;border-radius:var(--radius) var(--radius) 0 0;">
                <h5 class="modal-title" id="addClassLabel"><i class="bi bi-plus-circle me-2"></i>Add New Class</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <form method="post" action="${pageContext.request.contextPath}/classes/create">
                <div class="modal-body" style="padding:1.5rem;">
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label" for="className">Class Name *</label>
                            <input type="text" id="className" name="className" class="form-control" required placeholder="e.g. Morning Yoga">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label" for="trainerId">Trainer ID</label>
                            <input type="text" id="trainerId" name="trainerId" class="form-control" placeholder="e.g. T001">
                        </div>
                        <div class="col-md-4">
                            <label class="form-label" for="scheduleDay">Day *</label>
                            <select id="scheduleDay" name="scheduleDay" class="form-select" required>
                                <option value="">— Day —</option>
                                <option>Mon</option><option>Tue</option><option>Wed</option>
                                <option>Thu</option><option>Fri</option><option>Sat</option><option>Sun</option>
                            </select>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label" for="scheduleTime">Time *</label>
                            <input type="time" id="scheduleTime" name="scheduleTime" class="form-control" required>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label" for="capacity">Capacity *</label>
                            <input type="number" id="capacity" name="capacity" class="form-control" required min="1" max="100" placeholder="e.g. 20">
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn-fcms-primary"><i class="bi bi-plus-circle me-1"></i>Create Class</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Delete Confirmation Modal -->
<div class="modal fade" id="deleteModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content" style="border-radius:var(--radius);border:none;">
            <div class="modal-header" style="background:var(--danger);color:#fff;border-radius:var(--radius) var(--radius) 0 0;">
                <h5 class="modal-title" id="deleteModalLabel">Confirm Delete</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body" style="padding:1.5rem;">
                <p>Delete class <strong id="deleteTargetName"></strong>?</p>
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
</body>
</html>
