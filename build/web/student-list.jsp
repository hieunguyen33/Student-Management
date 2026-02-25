<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, model.Student" %>
<%
    List<Student> students  = (List<Student>) request.getAttribute("students");
    Integer totalCount      = (Integer)       request.getAttribute("totalCount");
    Integer currentPage     = (Integer)       request.getAttribute("page");       // ← đổi page → currentPage
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
    if (currentPage == null) currentPage = 1;   // ← đổi
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
    <style>
        body { background: #f0f2f5; }
        .sidebar {
            background: linear-gradient(180deg,#0f3460,#533483);
            min-height: 100vh; width: 250px;
            position: fixed; left: 0; top: 0; z-index: 100;
        }
        .sidebar .brand { color:#fff; font-size:1.2rem; font-weight:700; padding:1.2rem 1.5rem; border-bottom:1px solid rgba(255,255,255,.15); }
        .sidebar .nav-link { color:rgba(255,255,255,.75); padding:.7rem 1.5rem; border-radius:0 50px 50px 0; margin-right:1rem; transition:all .2s; }
        .sidebar .nav-link:hover, .sidebar .nav-link.active { color:#fff; background:rgba(255,255,255,.15); }
        .main-content { margin-left:250px; padding:2rem; }
        .topbar { background:#fff; border-radius:12px; padding:1rem 1.5rem; margin-bottom:1.5rem; box-shadow:0 2px 10px rgba(0,0,0,.07); display:flex; align-items:center; justify-content:space-between; }
        .content-card { background:#fff; border-radius:16px; padding:1.5rem; box-shadow:0 4px 15px rgba(0,0,0,.07); }
        .table th { background:#f8f9fa; font-weight:600; color:#495057; white-space:nowrap; }
        .table tbody tr:hover { background:#f8f9ff; }
        .badge-id { background:#e8edf8; color:#0f3460; padding:.3em .7em; border-radius:50px; font-weight:600; font-size:.8em; }
        .avatar { width:36px; height:36px; border-radius:50%; background:#0f3460; color:#fff; display:flex; align-items:center; justify-content:center; font-weight:700; font-size:.9rem; flex-shrink:0; }
        .pagination .page-link { color:#0f3460; border-radius:8px !important; margin:0 2px; }
        .pagination .page-item.active .page-link { background:#0f3460; border-color:#0f3460; }
        .pagination .page-link:hover { background:#e8edf8; }
    </style>
</head>
<body>

<!-- Sidebar -->
<nav class="sidebar pt-2">
    <div class="brand"><i class="bi bi-mortarboard-fill me-2"></i>StudentMgmt</div>
    <ul class="nav flex-column mt-2">
        <li class="nav-item"><a class="nav-link" href="<%= ctx %>/dashboard"><i class="bi bi-speedometer2 me-2"></i>Dashboard</a></li>
        <li class="nav-item"><a class="nav-link active" href="<%= ctx %>/students?action=list"><i class="bi bi-people me-2"></i>Sinh Viên</a></li>
        <li class="nav-item"><a class="nav-link" href="<%= ctx %>/students?action=showAdd"><i class="bi bi-person-plus me-2"></i>Thêm Mới</a></li>
        <li class="nav-item"><a class="nav-link" href="<%= ctx %>/export"><i class="bi bi-file-earmark-csv me-2"></i>Xuất CSV</a></li>
        <li class="nav-item mt-4"><a class="nav-link text-warning" href="<%= ctx %>/logout"><i class="bi bi-box-arrow-left me-2"></i>Đăng Xuất</a></li>
    </ul>
</nav>

<div class="main-content">

    <!-- Topbar -->
    <div class="topbar">
        <div>
            <h5 class="mb-0">Danh Sách Sinh Viên</h5>
            <small class="text-muted">
                <% if (!keyword.isEmpty()) { %>Kết quả tìm "<strong><%= keyword %></strong>" – <% } %>
                <strong><%= totalCount %></strong> sinh viên
                &nbsp;|&nbsp; Trang <strong><%= currentPage %></strong>/<strong><%= totalPages %></strong>
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

    <!-- Flash messages -->
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
                    <option value="name"       <%= "name".equals(field)       ? "selected" : "" %>>Tên</option>
                    <option value="email"      <%= "email".equals(field)      ? "selected" : "" %>>Email</option>
                    <option value="phone"      <%= "phone".equals(field)      ? "selected" : "" %>>Điện thoại</option>
                    <option value="class_name" <%= "class_name".equals(field) ? "selected" : "" %>>Lớp</option>
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
                    Chưa có sinh viên nào. <a href="<%= ctx %>/students?action=showAdd">Thêm ngay!</a>
                <% } %>
            </p>
        </div>
        <% } else { %>
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0">
                <thead>
                    <tr>
                        <th width="50">#</th>
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
                    <td><%= (s.getDob() == null || s.getDob().isEmpty()) ? "<span class='text-muted'>—</span>" : s.getDob() %></td>
                    <td>
                        <%
                            String gender = s.getGender();
                            String gBadge = "Nam".equals(gender) ? "bg-primary" :
                                            "Nữ".equals(gender)  ? "bg-danger"  : "bg-secondary";
                        %>
                        <span class="badge <%= gBadge %>"><%= gender %></span>
                    </td>
                    <td>
                        <% if (s.getClassName() != null && !s.getClassName().isEmpty()) { %>
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
                                onclick="confirmDelete(<%= s.getId() %>, '<%= s.getName().replace("'", "\\'") %>')">
                            <i class="bi bi-trash3"></i>
                        </button>
                    </td>
                </tr>
                <% } %>
                </tbody>
            </table>
        </div>

        <!-- PAGINATION -->
        <% if (totalPages > 1) { %>
        <div class="d-flex justify-content-between align-items-center mt-3">
            <small class="text-muted">
                Hiển thị <strong><%= students.size() %></strong> / <strong><%= totalCount %></strong> sinh viên
            </small>
            <nav>
                <ul class="pagination pagination-sm mb-0">
                    <!-- Prev -->
                    <li class="page-item <%= (currentPage <= 1) ? "disabled" : "" %>">
                        <a class="page-link"
                           href="<%= ctx %>/students?action=<%= keyword.isEmpty() ? "list" : "search" %>&keyword=<%= keyword %>&field=<%= field %>&page=<%= currentPage - 1 %>">
                            <i class="bi bi-chevron-left"></i>
                        </a>
                    </li>
                    <%
                        int startP = Math.max(1, currentPage - 2);
                        int endP   = Math.min(totalPages, currentPage + 2);
                    %>
                    <% if (startP > 1) { %>
                        <li class="page-item">
                            <a class="page-link" href="<%= ctx %>/students?action=<%= keyword.isEmpty() ? "list" : "search" %>&keyword=<%= keyword %>&field=<%= field %>&page=1">1</a>
                        </li>
                        <% if (startP > 2) { %><li class="page-item disabled"><span class="page-link">…</span></li><% } %>
                    <% } %>
                    <% for (int i = startP; i <= endP; i++) { %>
                    <li class="page-item <%= (i == currentPage) ? "active" : "" %>">
                        <a class="page-link"
                           href="<%= ctx %>/students?action=<%= keyword.isEmpty() ? "list" : "search" %>&keyword=<%= keyword %>&field=<%= field %>&page=<%= i %>">
                            <%= i %>
                        </a>
                    </li>
                    <% } %>
                    <% if (endP < totalPages) { %>
                        <% if (endP < totalPages - 1) { %><li class="page-item disabled"><span class="page-link">…</span></li><% } %>
                        <li class="page-item">
                            <a class="page-link" href="<%= ctx %>/students?action=<%= keyword.isEmpty() ? "list" : "search" %>&keyword=<%= keyword %>&field=<%= field %>&page=<%= totalPages %>"><%= totalPages %></a>
                        </li>
                    <% } %>
                    <!-- Next -->
                    <li class="page-item <%= (currentPage >= totalPages) ? "disabled" : "" %>">
                        <a class="page-link"
                           href="<%= ctx %>/students?action=<%= keyword.isEmpty() ? "list" : "search" %>&keyword=<%= keyword %>&field=<%= field %>&page=<%= currentPage + 1 %>">
                            <i class="bi bi-chevron-right"></i>
                        </a>
                    </li>
                </ul>
            </nav>
        </div>
        <% } %>
        <% } %>
    </div><!-- /content-card -->
</div><!-- /main-content -->

<!-- Delete Modal -->
<div class="modal fade" id="deleteModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-body text-center p-4">
                <i class="bi bi-trash3-fill text-danger" style="font-size:3rem"></i>
                <h5 class="fw-bold mt-3">Xác nhận xoá?</h5>
                <p class="text-muted">Bạn sắp xoá sinh viên <strong id="delName"></strong>.<br>Hành động này không thể hoàn tác.</p>
            </div>
            <div class="modal-footer border-0 justify-content-center gap-2">
                <button type="button" class="btn btn-secondary px-4" data-bs-dismiss="modal">Huỷ</button>
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