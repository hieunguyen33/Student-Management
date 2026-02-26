<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String  loggedInUser = (String)  session.getAttribute("loggedInUser");
    Integer totalStudents= (Integer) request.getAttribute("totalStudents");
    Long    totalNam     = (Long)    request.getAttribute("totalNam");
    Long    totalNu      = (Long)    request.getAttribute("totalNu");
    if (totalStudents == null) totalStudents = 0;
    if (totalNam      == null) totalNam      = 0L;
    if (totalNu       == null) totalNu       = 0L;
    String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard – Student Management</title>
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
            <h5>Dashboard</h5>
            <small>Xin chào, <strong><%= loggedInUser %></strong>! 👋</small>
        </div>
        <a href="<%= ctx %>/logout" class="btn btn-outline-danger btn-sm">
            <i class="bi bi-box-arrow-left me-1"></i>Đăng Xuất
        </a>
    </div>

    <!-- Stat Cards -->
    <div class="row g-4 mb-4">
        <div class="col-md-3">
            <div class="stat-card blue">
                <i class="bi bi-people-fill stat-icon"></i>
                <div class="text-muted small">Tổng Sinh Viên</div>
                <div class="fs-2 fw-bold text-primary"><%= totalStudents %></div>
                <div class="text-muted small mt-1">Đã đăng ký</div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="stat-card teal">
                <i class="bi bi-gender-male stat-icon text-info"></i>
                <div class="text-muted small">Sinh Viên Nam</div>
                <div class="fs-2 fw-bold text-info"><%= totalNam %></div>
                <div class="text-muted small mt-1">Nam giới</div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="stat-card orange">
                <i class="bi bi-gender-female stat-icon text-warning"></i>
                <div class="text-muted small">Sinh Viên Nữ</div>
                <div class="fs-2 fw-bold text-warning"><%= totalNu %></div>
                <div class="text-muted small mt-1">Nữ giới</div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="stat-card green">
                <i class="bi bi-database-fill stat-icon text-success"></i>
                <div class="text-muted small">Database</div>
                <div class="fs-4 fw-bold text-success">MySQL</div>
                <div class="text-muted small mt-1">Đang kết nối</div>
            </div>
        </div>
    </div>

    <!-- Quick Actions -->
    <h6 class="text-muted fw-semibold mb-3 text-uppercase" style="letter-spacing:1px">
        Thao Tác Nhanh
    </h6>
    <div class="row g-3 mb-4">
        <div class="col-md-3">
            <a href="<%= ctx %>/students?action=list"
               class="content-card d-block text-decoration-none text-center py-3 h-100"
               style="transition:transform .2s;cursor:pointer"
               onmouseover="this.style.transform='translateY(-4px)'"
               onmouseout="this.style.transform='translateY(0)'">
                <i class="bi bi-list-ul text-primary fs-2 d-block mb-2"></i>
                <div class="fw-semibold">Danh Sách Sinh Viên</div>
                <small class="text-muted">Xem tất cả sinh viên</small>
            </a>
        </div>
        <div class="col-md-3">
            <a href="<%= ctx %>/students?action=showAdd"
               class="content-card d-block text-decoration-none text-center py-3 h-100"
               style="transition:transform .2s;cursor:pointer"
               onmouseover="this.style.transform='translateY(-4px)'"
               onmouseout="this.style.transform='translateY(0)'">
                <i class="bi bi-person-plus text-success fs-2 d-block mb-2"></i>
                <div class="fw-semibold">Thêm Sinh Viên</div>
                <small class="text-muted">Đăng ký sinh viên mới</small>
            </a>
        </div>
        <div class="col-md-3">
            <a href="<%= ctx %>/subjects?action=list"
               class="content-card d-block text-decoration-none text-center py-3 h-100"
               style="transition:transform .2s;cursor:pointer"
               onmouseover="this.style.transform='translateY(-4px)'"
               onmouseout="this.style.transform='translateY(0)'">
                <i class="bi bi-book text-warning fs-2 d-block mb-2"></i>
                <div class="fw-semibold">Môn Học</div>
                <small class="text-muted">Quản lý môn học</small>
            </a>
        </div>
        <div class="col-md-3">
            <a href="<%= ctx %>/grades?action=viewByStudent"
               class="content-card d-block text-decoration-none text-center py-3 h-100"
               style="transition:transform .2s;cursor:pointer"
               onmouseover="this.style.transform='translateY(-4px)'"
               onmouseout="this.style.transform='translateY(0)'">
                <i class="bi bi-journal-text text-info fs-2 d-block mb-2"></i>
                <div class="fw-semibold">Bảng Điểm</div>
                <small class="text-muted">Xem & nhập điểm</small>
            </a>
        </div>
    </div>

    <!-- System Info -->
    <div class="row g-4">
        <div class="col-md-6">
            <div class="content-card">
                <h6 class="fw-bold mb-3">
                    <i class="bi bi-info-circle text-info me-2"></i>Thông Tin Hệ Thống
                </h6>
                <table class="table table-sm table-borderless mb-0">
                    <tr><td class="text-muted">Server</td><td><strong>Apache Tomcat</strong></td></tr>
                    <tr><td class="text-muted">Language</td><td><strong>Java 8+ / JSP / Servlet</strong></td></tr>
                    <tr><td class="text-muted">Database</td><td><strong>MySQL + JDBC</strong></td></tr>
                    <tr><td class="text-muted">Pattern</td><td><strong>MVC + DAO</strong></td></tr>
                    <tr><td class="text-muted">Frontend</td><td><strong>Bootstrap 5</strong></td></tr>
                    <tr><td class="text-muted">Bảo mật</td><td><strong>MD5 + Session + Filter</strong></td></tr>
                </table>
            </div>
        </div>
        <div class="col-md-6">
            <div class="content-card">
                <h6 class="fw-bold mb-3">
                    <i class="bi bi-activity text-success me-2"></i>Tính Năng
                </h6>
                <ul class="list-unstyled mb-0">
                    <li class="mb-2"><i class="bi bi-check2-circle text-success me-2"></i>CRUD sinh viên đầy đủ</li>
                    <li class="mb-2"><i class="bi bi-check2-circle text-success me-2"></i>Tìm kiếm theo nhiều tiêu chí</li>
                    <li class="mb-2"><i class="bi bi-check2-circle text-success me-2"></i>Phân trang 8 sinh viên/trang</li>
                    <li class="mb-2"><i class="bi bi-check2-circle text-success me-2"></i>Quản lý môn học & điểm số</li>
                    <li class="mb-2"><i class="bi bi-check2-circle text-success me-2"></i>Tính GPA tự động (thang 4.0)</li>
                    <li class="mb-2"><i class="bi bi-check2-circle text-success me-2"></i>Xuất danh sách CSV</li>
                </ul>
            </div>
        </div>
    </div>

</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>