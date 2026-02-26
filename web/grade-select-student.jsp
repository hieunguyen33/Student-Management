<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, model.Student" %>
<%
    List<Student> students = (List<Student>) request.getAttribute("students");
    String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chọn Sinh Viên – Bảng Điểm</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">
    <link rel="stylesheet" href="<%= ctx %>/css/style.css">
    <style>
        .student-item {
            border: 1px solid #e9ecef; border-radius: 12px;
            padding: 1rem; transition: all .2s;
            text-decoration: none; color: inherit; display: block;
        }
        .student-item:hover {
            border-color: #0f3460; background: #f0f4ff;
            transform: translateY(-2px); color: inherit;
        }
    </style>
</head>
<body>

<%@ include file="/WEB-INF/includes/sidebar.jsp" %>

<div class="main-content">
    <div class="topbar">
        <div>
            <h5>Bảng Điểm</h5>
            <small>Chọn sinh viên để xem hoặc nhập điểm</small>
        </div>
    </div>

    <div class="content-card">
        <input type="text" id="searchInput" class="form-control mb-4"
               placeholder="🔍 Tìm sinh viên theo tên...">

        <div class="row g-3" id="studentGrid">
            <% if (students != null) { for (Student s : students) { %>
            <div class="col-md-4 student-card">
                <a href="<%= ctx %>/grades?action=viewByStudent&studentId=<%= s.getId() %>"
                   class="student-item">
                    <div class="d-flex align-items-center gap-3">
                        <div class="avatar" style="width:45px;height:45px;font-size:1.1rem">
                            <%= s.getName().isEmpty()?"?":String.valueOf(s.getName().charAt(0)).toUpperCase() %>
                        </div>
                        <div>
                            <div class="fw-semibold"><%= s.getName() %></div>
                            <small class="text-muted">
                                <% if (s.getClassName()!=null&&!s.getClassName().isEmpty()) { %>
                                    <i class="bi bi-mortarboard me-1"></i><%= s.getClassName() %>
                                <% } else { %>ID: <%= s.getId() %><% } %>
                            </small>
                        </div>
                        <i class="bi bi-chevron-right ms-auto text-muted"></i>
                    </div>
                </a>
            </div>
            <% } } %>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
document.getElementById('searchInput').addEventListener('input', function() {
    const kw = this.value.toLowerCase();
    document.querySelectorAll('.student-card').forEach(card => {
        const name = card.querySelector('.fw-semibold').textContent.toLowerCase();
        card.style.display = name.includes(kw) ? '' : 'none';
    });
});
</script>
</body>
</html>