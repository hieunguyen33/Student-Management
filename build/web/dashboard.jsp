<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!-- Thêm vào đầu danh sách nav, trước Dashboard -->
<li class="nav-item">
    <a class="nav-link" href="<%= request.getContextPath() %>/">
        <i class="bi bi-house me-2"></i>Trang Chủ
    </a>
</li>
<%
    String loggedInUser = (String) session.getAttribute("loggedInUser");
    Integer totalStudents = (Integer) request.getAttribute("totalStudents");
    if (totalStudents == null) totalStudents = 0;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard – Student Management</title>
    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">
    <style>
        body { background-color: #f0f2f5; }
        .sidebar {
            background: linear-gradient(180deg, #0f3460 0%, #533483 100%);
            min-height: 100vh;
            width: 250px;
            position: fixed;
            left: 0; top: 0;
            z-index: 100;
            padding-top: 1rem;
        }
        .sidebar .brand {
            color: white;
            font-size: 1.2rem;
            font-weight: 700;
            padding: 1rem 1.5rem 2rem;
            border-bottom: 1px solid rgba(255,255,255,.15);
        }
        .sidebar .nav-link {
            color: rgba(255,255,255,.75);
            padding: .75rem 1.5rem;
            border-radius: 0 50px 50px 0;
            margin-right: 1rem;
            transition: all .2s;
        }
        .sidebar .nav-link:hover,
        .sidebar .nav-link.active {
            color: white;
            background: rgba(255,255,255,.15);
        }
        .sidebar .nav-link i { width: 22px; }
        .main-content {
            margin-left: 250px;
            padding: 2rem;
        }
        .topbar {
            background: white;
            border-radius: 12px;
            padding: 1rem 1.5rem;
            margin-bottom: 2rem;
            box-shadow: 0 2px 10px rgba(0,0,0,.07);
            display: flex;
            align-items: center;
            justify-content: space-between;
        }
        .stat-card {
            background: white;
            border-radius: 16px;
            padding: 1.5rem;
            box-shadow: 0 4px 15px rgba(0,0,0,.07);
            border-left: 5px solid;
            transition: transform .2s;
        }
        .stat-card:hover { transform: translateY(-4px); }
        .stat-card.blue  { border-color: #0d6efd; }
        .stat-card.green { border-color: #198754; }
        .stat-card.orange{ border-color: #fd7e14; }
        .stat-card.purple{ border-color: #6f42c1; }
        .stat-icon {
            font-size: 2.5rem;
            opacity: .15;
            float: right;
        }
        .quick-card {
            background: white;
            border-radius: 16px;
            padding: 1.5rem;
            box-shadow: 0 4px 15px rgba(0,0,0,.07);
            text-align: center;
            transition: transform .2s;
            cursor: pointer;
            text-decoration: none;
            color: inherit;
            display: block;
        }
        .quick-card:hover { transform: translateY(-4px); color: inherit; }
        .quick-card i { font-size: 2rem; margin-bottom: .5rem; }
    </style>
</head>
<body>

<!-- ── Sidebar ── -->
<nav class="sidebar">
    <div class="brand">
        <i class="bi bi-mortarboard-fill me-2"></i>StudentMgmt
    </div>
    <ul class="nav flex-column mt-2">
        <li class="nav-item">
            <a class="nav-link" href="<%= request.getContextPath() %>/">
                <i class="bi bi-house me-2"></i>Trang Chủ
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link active" href="<%= request.getContextPath() %>/dashboard">
                <i class="bi bi-speedometer2 me-2"></i>Dashboard
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link" href="<%= request.getContextPath() %>/students?action=list">
                <i class="bi bi-people me-2"></i>Students
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link" href="<%= request.getContextPath() %>/students?action=showAdd">
                <i class="bi bi-person-plus me-2"></i>Add Student
            </a>
        </li>
        <li class="nav-item mt-4">
            <a class="nav-link text-warning" href="<%= request.getContextPath() %>/logout">
                <i class="bi bi-box-arrow-left me-2"></i>Logout
            </a>
        </li>
    </ul>
</nav>

<!-- ── Main Content ── -->
<div class="main-content">

    <!-- Topbar -->
    <div class="topbar">
        <div>
            <h5 class="mb-0">Dashboard</h5>
            <small class="text-muted">Welcome back, <strong><%= loggedInUser %></strong>!</small>
        </div>
        <a href="<%= request.getContextPath() %>/logout"
           class="btn btn-outline-danger btn-sm">
            <i class="bi bi-box-arrow-left me-1"></i>Logout
        </a>
    </div>

    <!-- Stats Row -->
    <div class="row g-4 mb-4">
        <div class="col-md-3">
            <div class="stat-card blue">
                <i class="bi bi-people-fill stat-icon"></i>
                <div class="text-muted small">Total Students</div>
                <div class="fs-2 fw-bold text-primary"><%= totalStudents %></div>
                <div class="text-muted small mt-1">Registered in system</div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="stat-card green">
                <i class="bi bi-check-circle stat-icon text-success"></i>
                <div class="text-muted small">Active Records</div>
                <div class="fs-2 fw-bold text-success"><%= totalStudents %></div>
                <div class="text-muted small mt-1">All records active</div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="stat-card orange">
                <i class="bi bi-database stat-icon text-warning"></i>
                <div class="text-muted small">Database</div>
                <div class="fs-2 fw-bold text-warning">MySQL</div>
                <div class="text-muted small mt-1">Connected</div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="stat-card purple">
                <i class="bi bi-person-badge stat-icon text-purple"></i>
                <div class="text-muted small">Logged In As</div>
                <div class="fs-4 fw-bold text-purple" style="color:#6f42c1">
                    <%= loggedInUser %>
                </div>
                <div class="text-muted small mt-1">Administrator</div>
            </div>
        </div>
    </div>

    <!-- Quick Actions -->
    <h6 class="text-muted fw-semibold mb-3 text-uppercase" style="letter-spacing:1px">
        Quick Actions
    </h6>
    <div class="row g-4 mb-4">
        <div class="col-md-3">
            <a href="<%= request.getContextPath() %>/students?action=list" class="quick-card">
                <i class="bi bi-list-ul text-primary d-block"></i>
                <div class="fw-semibold">View All Students</div>
                <div class="text-muted small">Browse student list</div>
            </a>
        </div>
        <div class="col-md-3">
            <a href="<%= request.getContextPath() %>/students?action=showAdd" class="quick-card">
                <i class="bi bi-person-plus text-success d-block"></i>
                <div class="fw-semibold">Add New Student</div>
                <div class="text-muted small">Register a student</div>
            </a>
        </div>
        <div class="col-md-3">
            <a href="<%= request.getContextPath() %>/students?action=search" class="quick-card">
                <i class="bi bi-search text-info d-block"></i>
                <div class="fw-semibold">Search Student</div>
                <div class="text-muted small">Find by name</div>
            </a>
        </div>
        <div class="col-md-3">
            <a href="<%= request.getContextPath() %>/logout" class="quick-card">
                <i class="bi bi-power text-danger d-block"></i>
                <div class="fw-semibold">Logout</div>
                <div class="text-muted small">End session</div>
            </a>
        </div>
    </div>

    <!-- System Info -->
    <div class="row g-4">
        <div class="col-md-6">
            <div class="stat-card blue" style="border-left-color:#0dcaf0">
                <h6 class="fw-bold mb-3"><i class="bi bi-info-circle me-2 text-info"></i>System Info</h6>
                <table class="table table-sm table-borderless mb-0">
                    <tr><td class="text-muted">Server</td><td><strong>Apache Tomcat</strong></td></tr>
                    <tr><td class="text-muted">Language</td><td><strong>Java 8+ / JSP / Servlet</strong></td></tr>
                    <tr><td class="text-muted">Database</td><td><strong>MySQL + JDBC</strong></td></tr>
                    <tr><td class="text-muted">Pattern</td><td><strong>MVC</strong></td></tr>
                    <tr><td class="text-muted">Frontend</td><td><strong>Bootstrap 5</strong></td></tr>
                </table>
            </div>
        </div>
        <div class="col-md-6">
            <div class="stat-card green" style="border-left-color:#20c997">
                <h6 class="fw-bold mb-3"><i class="bi bi-activity me-2 text-success"></i>Features</h6>
                <ul class="list-unstyled mb-0">
                    <li class="mb-1"><i class="bi bi-check2-circle text-success me-2"></i>Student CRUD operations</li>
                    <li class="mb-1"><i class="bi bi-check2-circle text-success me-2"></i>Search by name</li>
                    <li class="mb-1"><i class="bi bi-check2-circle text-success me-2"></i>Session-based authentication</li>
                    <li class="mb-1"><i class="bi bi-check2-circle text-success me-2"></i>Auth filter protection</li>
                    <li class="mb-1"><i class="bi bi-check2-circle text-success me-2"></i>PreparedStatement (SQL injection safe)</li>
                </ul>
            </div>
        </div>
    </div>

</div><!-- /main-content -->

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>