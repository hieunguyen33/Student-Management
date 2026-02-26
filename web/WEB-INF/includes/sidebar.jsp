<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String _ctx        = request.getContextPath();
    String _currentURI = request.getRequestURI();
    String _active     = "";

    // Kiểm tra từ cụ thể → chung, tránh "/" match tất cả
    if      (_currentURI.contains("/grades"))    _active = "grades";
    else if (_currentURI.contains("/subjects"))  _active = "subjects";
    else if (_currentURI.contains("/students"))  _active = "students";
    else if (_currentURI.contains("/export"))    _active = "export";
    else if (_currentURI.contains("/dashboard")) _active = "dashboard";
    else if (_currentURI.endsWith("/") ||
             _currentURI.endsWith("/index.jsp")) _active = "home";
%>
<nav class="sidebar">
    <a href="<%= _ctx %>/" class="brand">
        <i class="bi bi-mortarboard-fill"></i>StudentMgmt
    </a>
    <ul class="nav flex-column mt-1">
        <li class="nav-item">
            <a class="nav-link <%= "home".equals(_active) ? "active" : "" %>"
               href="<%= _ctx %>/">
                <i class="bi bi-house"></i>Trang Chủ
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link <%= "dashboard".equals(_active) ? "active" : "" %>"
               href="<%= _ctx %>/dashboard">
                <i class="bi bi-speedometer2"></i>Dashboard
            </a>
        </li>

        <li class="nav-divider"></li>

        <li class="nav-item">
            <a class="nav-link <%= "students".equals(_active) ? "active" : "" %>"
               href="<%= _ctx %>/students?action=list">
                <i class="bi bi-people"></i>Sinh Viên
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link <%= "subjects".equals(_active) ? "active" : "" %>"
               href="<%= _ctx %>/subjects?action=list">
                <i class="bi bi-book"></i>Môn Học
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link <%= "grades".equals(_active) ? "active" : "" %>"
               href="<%= _ctx %>/grades?action=viewByStudent">
                <i class="bi bi-journal-text"></i>Bảng Điểm
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link <%= "export".equals(_active) ? "active" : "" %>"
               href="<%= _ctx %>/export">
                <i class="bi bi-file-earmark-csv"></i>Xuất CSV
            </a>
        </li>

        <li class="nav-divider"></li>

        <li class="nav-item mt-2">
            <a class="nav-link logout" href="<%= _ctx %>/logout">
                <i class="bi bi-box-arrow-left"></i>Đăng Xuất
            </a>
        </li>
    </ul>
</nav>