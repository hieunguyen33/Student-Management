<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, model.Subject" %>
<%
    List<Subject> subjects = (List<Subject>) request.getAttribute("subjects");
    String flashMessage    = (String) session.getAttribute("flashMessage");
    String flashError      = (String) session.getAttribute("flashError");
    session.removeAttribute("flashMessage");
    session.removeAttribute("flashError");
    String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Danh Sách Môn Học</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">
    <link rel="stylesheet" href="<%= ctx %>/css/style.css">
</head>
<body>

<%@ include file="/WEB-INF/includes/sidebar.jsp" %>

<div class="main-content">
    <div class="topbar">
        <div>
            <h5>Danh Sách Môn Học</h5>
            <small><strong><%= subjects!=null?subjects.size():0 %></strong> môn học</small>
        </div>
        <a href="<%= ctx %>/subjects?action=showAdd" class="btn btn-success btn-sm">
            <i class="bi bi-plus-circle me-1"></i>Thêm Môn Học
        </a>
    </div>

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

    <div class="content-card">
        <% if (subjects==null||subjects.isEmpty()) { %>
        <div class="text-center py-5">
            <i class="bi bi-book display-1 text-muted opacity-25"></i>
            <p class="text-muted mt-3">Chưa có môn học nào.
                <a href="<%= ctx %>/subjects?action=showAdd">Thêm ngay!</a></p>
        </div>
        <% } else { %>
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0">
                <thead><tr>
                    <th width="50">#</th>
                    <th>Mã Môn</th>
                    <th>Tên Môn Học</th>
                    <th>Số Tín Chỉ</th>
                    <th width="120" class="text-center">Thao Tác</th>
                </tr></thead>
                <tbody>
                <% int stt=1; for (Subject s : subjects) { %>
                <tr>
                    <td><small class="text-muted"><%= stt++ %></small></td>
                    <td><span class="badge-id"><%= s.getSubjectCode() %></span></td>
                    <td><i class="bi bi-book text-primary me-2"></i><strong><%= s.getSubjectName() %></strong></td>
                    <td><span class="badge bg-info text-dark"><%= s.getCredits() %> tín chỉ</span></td>
                    <td class="text-center">
                        <a href="<%= ctx %>/subjects?action=showEdit&id=<%= s.getId() %>"
                           class="btn btn-sm btn-outline-primary me-1"><i class="bi bi-pencil"></i></a>
                        <button class="btn btn-sm btn-outline-danger"
                                onclick="confirmDelete(<%= s.getId() %>,'<%= s.getSubjectName().replace("'","\\'") %>')">
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
                <h5 class="fw-bold mt-3">Xác nhận xoá?</h5>
                <p class="text-muted">Xoá môn <strong id="subjectName"></strong>?<br>
                    Toàn bộ điểm liên quan sẽ bị xoá theo.</p>
            </div>
            <div class="modal-footer border-0 justify-content-center gap-2">
                <button class="btn btn-secondary px-4" data-bs-dismiss="modal">Huỷ</button>
                <a id="delBtn" href="#" class="btn btn-danger px-4">
                    <i class="bi bi-trash3 me-1"></i>Xoá
                </a>
            </div>
        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
function confirmDelete(id, name) {
    document.getElementById('subjectName').textContent = name;
    document.getElementById('delBtn').href = '<%= ctx %>/subjects?action=delete&id=' + id;
    new bootstrap.Modal(document.getElementById('deleteModal')).show();
}
</script>
</body>
</html>