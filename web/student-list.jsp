<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, model.Student" %>
<%
    List<Student> students  = (List<Student>) request.getAttribute("students");
    Integer totalCount      = (Integer)       request.getAttribute("totalCount");
    Integer currentPage     = (Integer)       request.getAttribute("page");
    Integer totalPages      = (Integer)       request.getAttribute("totalPages");
    String  keyword         = (String)        request.getAttribute("keyword");
    String  field           = (String)        request.getAttribute("field");
    String  flashMessage    = (String)        session.getAttribute("flashMessage");
    String  flashError      = (String)        session.getAttribute("flashError");
    session.removeAttribute("flashMessage");
    session.removeAttribute("flashError");
    if (keyword     == null) keyword     = "";
    if (field       == null) field       = "name";
    if (totalCount  == null) totalCount  = 0;
    if (currentPage == null) currentPage = 1;
    if (totalPages  == null) totalPages  = 1;
    String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Danh Sách Sinh Viên</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">
    <link rel="stylesheet" href="<%= ctx %>/css/style.css">
</head>
<body>

<%@ include file="/WEB-INF/includes/sidebar.jsp" %>

<div class="main-content">

    <!-- Topbar -->
    <div class="topbar">
        <div>
            <h5>Danh Sách Sinh Viên</h5>
            <small>
                <% if (!keyword.isEmpty()) { %>Kết quả tìm "<strong><%= keyword %></strong>" – <% } %>
                <strong><%= totalCount %></strong> sinh viên |
                Trang <strong><%= currentPage %></strong>/<strong><%= totalPages %></strong>
            </small>
        </div>
        <div class="d-flex gap-2">
            <a href="<%= ctx %>/export" class="btn btn-success btn-sm">
                <i class="bi bi-file-earmark-csv me-1"></i>Xuất CSV
            </a>
            <a href="<%= ctx %>/logout" class="btn btn-outline-danger btn-sm">
                <i class="bi bi-box-arrow-left me-1"></i>Đăng Xuất
            </a>
        </div>
    </div>

    <!-- Flash -->
    <% if (flashMessage != null) { %>
    <div class="alert alert-success alert-dismissible fade show d-flex align-items-center mb-3">
        <i class="bi bi-check-circle-fill me-2"></i><%= flashMessage %>
        <button type="button" class="btn-close ms-auto" data-bs-dismiss="alert"></button>
    </div>
    <% } %>
    <% if (flashError != null) { %>
    <div class="alert alert-danger alert-dismissible fade show d-flex align-items-center mb-3">
        <i class="bi bi-exclamation-triangle-fill me-2"></i><%= flashError %>
        <button type="button" class="btn-close ms-auto" data-bs-dismiss="alert"></button>
    </div>
    <% } %>

    <div class="content-card">

        <!-- Toolbar -->
        <div class="d-flex justify-content-between align-items-center mb-3 flex-wrap gap-2">
            <form action="<%= ctx %>/students" method="GET" class="d-flex gap-2 align-items-center">
                <input type="hidden" name="action" value="search">
                <select name="field" class="form-select form-select-sm" style="width:130px">
                    <option value="name"       <%= "name".equals(field)       ? "selected":"" %>>Tên</option>
                    <option value="email"      <%= "email".equals(field)      ? "selected":"" %>>Email</option>
                    <option value="phone"      <%= "phone".equals(field)      ? "selected":"" %>>Điện thoại</option>
                    <option value="class_name" <%= "class_name".equals(field) ? "selected":"" %>>Lớp</option>
                </select>
                <input type="text" class="form-control form-control-sm" name="keyword"
                       value="<%= keyword %>" placeholder="Tìm kiếm…" style="width:220px">
                <button type="submit" class="btn btn-primary btn-sm px-3">
                    <i class="bi bi-search"></i>
                </button>
                <% if (!keyword.isEmpty()) { %>
                <a href="<%= ctx %>/students?action=list" class="btn btn-outline-secondary btn-sm">
                    <i class="bi bi-x-lg"></i>
                </a>
                <% } %>
            </form>
            <a href="<%= ctx %>/students?action=showAdd" class="btn btn-success btn-sm">
                <i class="bi bi-person-plus me-1"></i>Thêm Sinh Viên
            </a>
        </div>

        <!-- Table -->
        <% if (students == null || students.isEmpty()) { %>
        <div class="text-center py-5">
            <i class="bi bi-people display-1 text-muted opacity-25"></i>
            <p class="text-muted mt-3 fs-5">
                <% if (!keyword.isEmpty()) { %>
                    Không tìm thấy sinh viên với từ khoá "<strong><%= keyword %></strong>".
                    <a href="<%= ctx %>/students?action=list">Xem tất cả</a>
                <% } else { %>
                    Chưa có sinh viên nào.
                    <a href="<%= ctx %>/students?action=showAdd">Thêm ngay!</a>
                <% } %>
            </p>
        </div>
        <% } else { %>
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0">
                <thead>
                    <tr>
                        <th width="45">#</th>
                        <th width="55">ID</th>
                        <th>Họ và Tên</th>
                        <th>Email</th>
                        <th>Ngày Sinh</th>
                        <th>Giới Tính</th>
                        <th>Lớp</th>
                        <th>Điện Thoại</th>
                        <th width="110" class="text-center">Thao Tác</th>
                    </tr>
                </thead>
                <tbody>
                <% int stt = 1; %>
                <% for (Student s : students) { %>
                <tr>
                    <td><small class="text-muted"><%= stt++ %></small></td>
                    <td><span class="badge-id"><%= s.getId() %></span></td>
                    <td>
                        <div class="d-flex align-items-center gap-2">
                            <div class="avatar">
                                <%= s.getName().isEmpty() ? "?" : String.valueOf(s.getName().charAt(0)).toUpperCase() %>
                            </div>
                            <span class="fw-semibold"><%= s.getName() %></span>
                        </div>
                    </td>
                    <td><small><%= s.getEmail() %></small></td>
                    <td><%= (s.getDob()==null||s.getDob().isEmpty()) ? "<span class='text-muted'>—</span>" : s.getDob() %></td>
                    <td>
                        <%
                            String gender  = s.getGender();
                            String gBadge  = "Nam".equals(gender) ? "bg-primary" :
                                             "Nữ".equals(gender)  ? "bg-danger"  : "bg-secondary";
                        %>
                        <span class="badge <%= gBadge %>"><%= gender %></span>
                    </td>
                    <td>
                        <% if (s.getClassName()!=null && !s.getClassName().isEmpty()) { %>
                            <span class="badge bg-light text-dark border">
                                <i class="bi bi-mortarboard me-1"></i><%= s.getClassName() %>
                            </span>
                        <% } else { %><span class="text-muted">—</span><% } %>
                    </td>
                    <td><small><%= s.getPhone().isEmpty() ? "—" : s.getPhone() %></small></td>
                    <td class="text-center">
                        <a href="<%= ctx %>/students?action=showEdit&id=<%= s.getId() %>"
                           class="btn btn-sm btn-outline-primary me-1" title="Sửa">
                            <i class="bi bi-pencil"></i>
                        </a>
                        <button class="btn btn-sm btn-outline-danger" title="Xoá"
                                onclick="confirmDelete(<%= s.getId() %>,'<%= s.getName().replace("'","\\'") %>')">
                            <i class="bi bi-trash3"></i>
                        </button>
                    </td>
                </tr>
                <% } %>
                </tbody>
            </table>
        </div>

        <!-- Pagination -->
        <% if (totalPages > 1) { %>
        <div class="d-flex justify-content-between align-items-center mt-3">
            <small class="text-muted">
                Hiển thị <strong><%= students.size() %></strong> /
                <strong><%= totalCount %></strong> sinh viên
            </small>
            <nav>
                <ul class="pagination pagination-sm mb-0">
                    <li class="page-item <%= (currentPage<=1)?"disabled":"" %>">
                        <a class="page-link" href="<%= ctx %>/students?action=<%= keyword.isEmpty()?"list":"search" %>&keyword=<%= keyword %>&field=<%= field %>&page=<%= currentPage-1 %>">
                            <i class="bi bi-chevron-left"></i>
                        </a>
                    </li>
                    <%
                        int startP = Math.max(1, currentPage-2);
                        int endP   = Math.min(totalPages, currentPage+2);
                    %>
                    <% if (startP > 1) { %>
                        <li class="page-item"><a class="page-link" href="<%= ctx %>/students?action=<%= keyword.isEmpty()?"list":"search" %>&keyword=<%= keyword %>&field=<%= field %>&page=1">1</a></li>
                        <% if (startP > 2) { %><li class="page-item disabled"><span class="page-link">…</span></li><% } %>
                    <% } %>
                    <% for (int i = startP; i <= endP; i++) { %>
                    <li class="page-item <%= (i==currentPage)?"active":"" %>">
                        <a class="page-link" href="<%= ctx %>/students?action=<%= keyword.isEmpty()?"list":"search" %>&keyword=<%= keyword %>&field=<%= field %>&page=<%= i %>"><%= i %></a>
                    </li>
                    <% } %>
                    <% if (endP < totalPages) { %>
                        <% if (endP < totalPages-1) { %><li class="page-item disabled"><span class="page-link">…</span></li><% } %>
                        <li class="page-item"><a class="page-link" href="<%= ctx %>/students?action=<%= keyword.isEmpty()?"list":"search" %>&keyword=<%= keyword %>&field=<%= field %>&page=<%= totalPages %>"><%= totalPages %></a></li>
                    <% } %>
                    <li class="page-item <%= (currentPage>=totalPages)?"disabled":"" %>">
                        <a class="page-link" href="<%= ctx %>/students?action=<%= keyword.isEmpty()?"list":"search" %>&keyword=<%= keyword %>&field=<%= field %>&page=<%= currentPage+1 %>">
                            <i class="bi bi-chevron-right"></i>
                        </a>
                    </li>
                </ul>
            </nav>
        </div>
        <% } %>
        <% } %>
    </div>
</div>

<!-- Delete Modal -->
<div class="modal fade" id="deleteModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-body text-center p-4">
                <i class="bi bi-trash3-fill text-danger" style="font-size:3rem"></i>
                <h5 class="fw-bold mt-3">Xác nhận xoá?</h5>
                <p class="text-muted">Bạn sắp xoá <strong id="delName"></strong>.<br>Hành động này không thể hoàn tác.</p>
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
    document.getElementById('delName').textContent = name;
    document.getElementById('delBtn').href = '<%= ctx %>/students?action=delete&id=' + id;
    new bootstrap.Modal(document.getElementById('deleteModal')).show();
}
</script>
</body>
</html>