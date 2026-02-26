<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, model.Grade, model.Student, model.Subject" %>
<%
    Student       student  = (Student)       request.getAttribute("student");
    List<Grade>   grades   = (List<Grade>)   request.getAttribute("grades");
    Float         cumGpa   = (Float)         request.getAttribute("cumGpa");
    List<Subject> subjects = (List<Subject>) request.getAttribute("subjects");
    String flashMessage    = (String) session.getAttribute("flashMessage");
    String flashError      = (String) session.getAttribute("flashError");
    session.removeAttribute("flashMessage");
    session.removeAttribute("flashError");
    String ctx = request.getContextPath();

    String rankLabel = "Chưa có dữ liệu";
    String rankColor = "secondary";
    if (cumGpa != null) {
        if      (cumGpa >= 3.6) { rankLabel = "Xuất Sắc";  rankColor = "success"; }
        else if (cumGpa >= 3.2) { rankLabel = "Giỏi";       rankColor = "primary"; }
        else if (cumGpa >= 2.5) { rankLabel = "Khá";        rankColor = "info"; }
        else if (cumGpa >= 2.0) { rankLabel = "Trung Bình"; rankColor = "warning"; }
        else                    { rankLabel = "Yếu/Kém";    rankColor = "danger"; }
    }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Bảng Điểm – <%= student.getName() %></title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">
    <link rel="stylesheet" href="<%= ctx %>/css/style.css">
</head>
<body>

<%@ include file="/WEB-INF/includes/sidebar.jsp" %>

<div class="main-content">

    <nav class="mb-3"><ol class="breadcrumb">
        <li class="breadcrumb-item"><a href="<%= ctx %>/grades?action=viewByStudent">Bảng Điểm</a></li>
        <li class="breadcrumb-item active"><%= student.getName() %></li>
    </ol></nav>

    <% if (flashMessage != null) { %>
    <div class="alert alert-success alert-dismissible fade show">
        <i class="bi bi-check-circle-fill me-2"></i><%= flashMessage %>
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
    <% } %>
    <% if (flashError != null) { %>
    <div class="alert alert-danger alert-dismissible fade show">
        <i class="bi bi-exclamation-triangle-fill me-2"></i><%= flashError %>
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
    <% } %>

    <!-- Student Header -->
    <div class="student-header d-flex align-items-center justify-content-between flex-wrap gap-3">
        <div class="d-flex align-items-center gap-3">
            <div class="avatar avatar-lg">
                <%= student.getName().isEmpty()?"?":String.valueOf(student.getName().charAt(0)).toUpperCase() %>
            </div>
            <div>
                <h5 class="mb-0 fw-bold"><%= student.getName() %></h5>
                <small class="opacity-75">
                    <% if (student.getClassName()!=null&&!student.getClassName().isEmpty()) { %>
                        <i class="bi bi-mortarboard me-1"></i><%= student.getClassName() %> &nbsp;|&nbsp;
                    <% } %>
                    <i class="bi bi-envelope me-1"></i><%= student.getEmail() %>
                </small>
            </div>
        </div>
        <div class="d-flex align-items-center gap-3">
            <div class="gpa-circle">
                <span style="font-size:1.3rem;font-weight:800">
                    <%= cumGpa!=null?String.format("%.2f",cumGpa):"—" %>
                </span>
                <span style="font-size:.65rem;opacity:.8">GPA 4.0</span>
            </div>
            <div>
                <span class="badge bg-<%= rankColor %> fs-6"><%= rankLabel %></span>
                <div class="mt-1">
                    <small class="opacity-75"><%= grades!=null?grades.size():0 %> môn học</small>
                </div>
            </div>
        </div>
    </div>

    <!-- Grade Table -->
    <div class="content-card">
        <div class="d-flex justify-content-between align-items-center mb-3">
            <h6 class="fw-bold mb-0">
                <i class="bi bi-table me-2 text-primary"></i>Bảng Điểm Chi Tiết
            </h6>
            <div class="dropdown">
                <button class="btn btn-success btn-sm dropdown-toggle" data-bs-toggle="dropdown">
                    <i class="bi bi-plus-circle me-1"></i>Nhập Điểm Môn Mới
                </button>
                <ul class="dropdown-menu dropdown-menu-end" style="max-height:300px;overflow-y:auto">
                    <% if (subjects!=null) { for (Subject sub : subjects) {
                        boolean hasGrade = false;
                        if (grades!=null) { for (Grade g : grades) { if (g.getSubjectId()==sub.getId()) { hasGrade=true; break; } } }
                    %>
                    <li>
                        <a class="dropdown-item <%= hasGrade?"text-muted":"" %>"
                           href="<%= hasGrade?"#":ctx+"/grades?action=showInput&studentId="+student.getId()+"&subjectId="+sub.getId() %>">
                            <% if (hasGrade) { %>
                                <i class="bi bi-check-circle text-success me-2"></i>
                            <% } else { %>
                                <i class="bi bi-plus me-2"></i>
                            <% } %>
                            <%= sub.getSubjectCode() %> – <%= sub.getSubjectName() %>
                            <% if (hasGrade) { %><small class="ms-1">(đã có)</small><% } %>
                        </a>
                    </li>
                    <% } } %>
                </ul>
            </div>
        </div>

        <% if (grades==null||grades.isEmpty()) { %>
        <div class="text-center py-5">
            <i class="bi bi-journal-x display-1 text-muted opacity-25"></i>
            <p class="text-muted mt-3">Chưa có điểm môn nào.<br>
                Nhấn <strong>"Nhập Điểm Môn Mới"</strong> để bắt đầu.</p>
        </div>
        <% } else { %>
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0">
                <thead><tr>
                    <th>#</th><th>Mã Môn</th><th>Tên Môn</th><th>TC</th>
                    <th class="text-center">Chuyên Cần<br><small class="fw-normal text-muted">(10%)</small></th>
                    <th class="text-center">Giữa Kỳ<br><small class="fw-normal text-muted">(30%)</small></th>
                    <th class="text-center">Cuối Kỳ<br><small class="fw-normal text-muted">(60%)</small></th>
                    <th class="text-center">Tổng Kết</th>
                    <th class="text-center">Xếp Loại</th>
                    <th class="text-center">GPA</th>
                    <th class="text-center">Thao Tác</th>
                </tr></thead>
                <tbody>
                <% int stt=1; for (Grade g : grades) { %>
                <tr>
                    <td><small class="text-muted"><%= stt++ %></small></td>
                    <td><span class="badge-id"><%= g.getSubjectCode() %></span></td>
                    <td><small><%= g.getSubjectName() %></small></td>
                    <td><span class="badge bg-light text-dark border"><%= g.getCredits() %></span></td>
                    <td class="text-center fw-semibold"><%= g.getAttendance()!=null?String.format("%.1f",g.getAttendance()):"<span class='text-muted'>—</span>" %></td>
                    <td class="text-center fw-semibold"><%= g.getMidterm()!=null?String.format("%.1f",g.getMidterm()):"<span class='text-muted'>—</span>" %></td>
                    <td class="text-center fw-semibold"><%= g.getFinalExam()!=null?String.format("%.1f",g.getFinalExam()):"<span class='text-muted'>—</span>" %></td>
                    <td class="text-center">
                        <% if (g.getFinalScore()!=null) { %>
                        <strong style="font-size:1.1rem;color:<%= g.getFinalScore()>=5.0?"#198754":"#dc3545" %>">
                            <%= String.format("%.2f",g.getFinalScore()) %>
                        </strong>
                        <% } else { %><span class="text-muted">—</span><% } %>
                    </td>
                    <td class="text-center">
                        <% if (g.getLetterGrade()!=null) { %>
                        <span class="badge bg-<%= g.getGradeBadgeColor() %> fs-6"><%= g.getLetterGrade() %></span>
                        <small class="d-block text-muted" style="font-size:.7rem"><%= g.getRankName() %></small>
                        <% } else { %><span class="text-muted">—</span><% } %>
                    </td>
                    <td class="text-center"><strong><%= g.getGpaPoint()!=null?String.format("%.1f",g.getGpaPoint()):"—" %></strong></td>
                    <td class="text-center">
                        <a href="<%= ctx %>/grades?action=showInput&studentId=<%= student.getId() %>&subjectId=<%= g.getSubjectId() %>"
                           class="btn btn-sm btn-outline-primary me-1"><i class="bi bi-pencil"></i></a>
                        <button class="btn btn-sm btn-outline-danger"
                                onclick="confirmDelete(<%= student.getId() %>,<%= g.getSubjectId() %>,'<%= g.getSubjectName().replace("'","\\'") %>')">
                            <i class="bi bi-trash3"></i>
                        </button>
                    </td>
                </tr>
                <% } %>
                </tbody>
            </table>
        </div>
        <% } %>
    </div>
</div>

<div class="modal fade" id="deleteModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-body text-center p-4">
                <i class="bi bi-trash3-fill text-danger" style="font-size:3rem"></i>
                <h5 class="fw-bold mt-3">Xoá điểm môn này?</h5>
                <p class="text-muted">Điểm môn <strong id="subName"></strong> sẽ bị xoá vĩnh viễn.</p>
            </div>
            <div class="modal-footer border-0 justify-content-center gap-2">
                <button class="btn btn-secondary px-4" data-bs-dismiss="modal">Huỷ</button>
                <a id="delBtn" href="#" class="btn btn-danger px-4"><i class="bi bi-trash3 me-1"></i>Xoá</a>
            </div>
        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
function confirmDelete(studentId, subjectId, subName) {
    document.getElementById('subName').textContent = subName;
    document.getElementById('delBtn').href = '<%= ctx %>/grades?action=delete&studentId=' + studentId + '&subjectId=' + subjectId;
    new bootstrap.Modal(document.getElementById('deleteModal')).show();
}
</script>
</body>
</html>