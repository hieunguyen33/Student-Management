<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Student" %>
<%
    Student student      = (Student) request.getAttribute("student");
    String  formAction   = (String)  request.getAttribute("formAction");
    String  errorMessage = (String)  request.getAttribute("errorMessage");
    if (student    == null) student    = new Student();
    if (formAction == null) formAction = "add";
    boolean isEdit    = "edit".equals(formAction);
    String  pageTitle = isEdit ? "Sửa Sinh Viên" : "Thêm Sinh Viên Mới";
    String  ctx       = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= pageTitle %></title>
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
            <h5><%= pageTitle %></h5>
            <small>
                <% if (isEdit) { %>Đang sửa ID #<strong><%= student.getId() %></strong>
                <% } else { %>Điền thông tin sinh viên mới<% } %>
            </small>
        </div>
        <a href="<%= ctx %>/logout" class="btn btn-outline-danger btn-sm">
            <i class="bi bi-box-arrow-left me-1"></i>Đăng Xuất
        </a>
    </div>

    <!-- Breadcrumb -->
    <nav class="mb-3"><ol class="breadcrumb">
        <li class="breadcrumb-item"><a href="<%= ctx %>/dashboard">Dashboard</a></li>
        <li class="breadcrumb-item"><a href="<%= ctx %>/students?action=list">Sinh Viên</a></li>
        <li class="breadcrumb-item active"><%= pageTitle %></li>
    </ol></nav>

    <div class="form-card">
        <div class="text-center mb-4">
            <i class="bi <%= isEdit ? "bi-pencil-square" : "bi-person-plus-fill" %>"
               style="font-size:3rem;color:#0f3460"></i>
            <h5 class="mt-2 fw-bold"><%= pageTitle %></h5>
            <small class="text-muted">Trường có dấu <span class="required-star">*</span> là bắt buộc</small>
        </div>

        <% if (errorMessage != null && !errorMessage.isEmpty()) { %>
        <div class="alert alert-danger d-flex align-items-center mb-4">
            <i class="bi bi-exclamation-triangle-fill me-2"></i><%= errorMessage %>
        </div>
        <% } %>

        <form action="<%= ctx %>/students" method="POST" id="studentForm" novalidate>
            <input type="hidden" name="action" value="<%= formAction %>">
            <% if (isEdit) { %><input type="hidden" name="id" value="<%= student.getId() %>"><% } %>

            <!-- Thông tin cơ bản -->
            <div class="section-title"><i class="bi bi-person me-2"></i>Thông Tin Cơ Bản</div>
            <div class="row g-3 mb-4">
                <div class="col-md-6">
                    <label class="form-label fw-semibold">Họ và Tên <span class="required-star">*</span></label>
                    <input type="text" class="form-control" name="name"
                           value="<%= student.getName()==null?"":student.getName() %>"
                           placeholder="Nguyễn Văn A" maxlength="100" required>
                </div>
                <div class="col-md-6">
                    <label class="form-label fw-semibold">Email <span class="required-star">*</span></label>
                    <input type="email" class="form-control" name="email"
                           value="<%= student.getEmail()==null?"":student.getEmail() %>"
                           placeholder="example@gmail.com" maxlength="100" required>
                </div>
                <div class="col-md-4">
                    <label class="form-label fw-semibold">Ngày Sinh</label>
                    <input type="date" class="form-control" name="dob"
                           value="<%= student.getDob()==null?"":student.getDob() %>">
                </div>
                <div class="col-md-4">
                    <label class="form-label fw-semibold">Giới Tính</label>
                    <select class="form-select" name="gender">
                        <option value="Nam"  <%= "Nam".equals(student.getGender())  ? "selected":"" %>>Nam</option>
                        <option value="Nữ"   <%= "Nữ".equals(student.getGender())   ? "selected":"" %>>Nữ</option>
                        <option value="Khác" <%= "Khác".equals(student.getGender()) ? "selected":"" %>>Khác</option>
                    </select>
                </div>
                <div class="col-md-4">
                    <label class="form-label fw-semibold">Lớp Học</label>
                    <input type="text" class="form-control" name="className"
                           value="<%= student.getClassName()==null?"":student.getClassName() %>"
                           placeholder="VD: CNTT01" maxlength="50">
                </div>
            </div>

            <!-- Thông tin liên lạc -->
            <div class="section-title"><i class="bi bi-telephone me-2"></i>Thông Tin Liên Lạc</div>
            <div class="row g-3 mb-4">
                <div class="col-md-5">
                    <label class="form-label fw-semibold">Số Điện Thoại</label>
                    <input type="tel" class="form-control" name="phone"
                           value="<%= student.getPhone()==null?"":student.getPhone() %>"
                           placeholder="0901234567" maxlength="20">
                    <div class="form-text">Số VN 10 chữ số (03x, 05x, 07x, 08x, 09x)</div>
                </div>
                <div class="col-md-7">
                    <label class="form-label fw-semibold">Địa Chỉ</label>
                    <textarea class="form-control" name="address" rows="2"
                              placeholder="Số nhà, đường, phường/xã, quận/huyện, tỉnh/thành"
                              maxlength="255"><%= student.getAddress()==null?"":student.getAddress() %></textarea>
                </div>
            </div>

            <div class="d-flex justify-content-end gap-2 pt-2 border-top">
                <a href="<%= ctx %>/students?action=list" class="btn btn-outline-secondary px-4">
                    <i class="bi bi-arrow-left me-1"></i>Huỷ
                </a>
                <button type="submit" class="btn btn-submit btn-primary text-white px-5">
                    <i class="bi <%= isEdit?"bi-save":"bi-plus-circle" %> me-1"></i>
                    <%= isEdit ? "Cập Nhật" : "Thêm Sinh Viên" %>
                </button>
            </div>
        </form>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
(function(){
    const form = document.getElementById('studentForm');
    form.addEventListener('submit', function(e){
        if (!form.checkValidity()) { e.preventDefault(); e.stopPropagation(); }
        form.classList.add('was-validated');
    });
})();
</script>
</body>
</html>