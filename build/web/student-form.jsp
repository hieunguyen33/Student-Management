<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Student" %>
<!-- Thêm vào đầu danh sách nav, trước Dashboard -->
<li class="nav-item">
    <a class="nav-link" href="<%= request.getContextPath() %>/">
        <i class="bi bi-house me-2"></i>Trang Chủ
    </a>
</li>
<%
    Student student      = (Student) request.getAttribute("student");
    String  formAction   = (String)  request.getAttribute("formAction");
    String  errorMessage = (String)  request.getAttribute("errorMessage");
    if (student    == null) student    = new Student();
    if (formAction == null) formAction = "add";
    boolean isEdit     = "edit".equals(formAction);
    String  pageTitle  = isEdit ? "Sửa Sinh Viên" : "Thêm Sinh Viên";
    String  ctx        = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= pageTitle %></title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">
    <style>
        body { background: #f0f2f5; }
        .sidebar {
            background: linear-gradient(180deg,#0f3460,#533483);
            min-height:100vh; width:250px;
            position:fixed; left:0; top:0; z-index:100;
        }
        .sidebar .brand { color:#fff; font-size:1.2rem; font-weight:700; padding:1.2rem 1.5rem; border-bottom:1px solid rgba(255,255,255,.15); }
        .sidebar .nav-link { color:rgba(255,255,255,.75); padding:.7rem 1.5rem; border-radius:0 50px 50px 0; margin-right:1rem; transition:all .2s; }
        .sidebar .nav-link:hover,.sidebar .nav-link.active { color:#fff; background:rgba(255,255,255,.15); }
        .main-content { margin-left:250px; padding:2rem; }
        .topbar { background:#fff; border-radius:12px; padding:1rem 1.5rem; margin-bottom:1.5rem; box-shadow:0 2px 10px rgba(0,0,0,.07); display:flex; align-items:center; justify-content:space-between; }
        .form-card { background:#fff; border-radius:16px; padding:2rem; box-shadow:0 4px 15px rgba(0,0,0,.07); max-width:800px; margin:0 auto; }
        .section-title { font-size:.8rem; font-weight:700; text-transform:uppercase; letter-spacing:1px; color:#6c757d; margin-bottom:1rem; padding-bottom:.5rem; border-bottom:2px solid #f0f2f5; }
        .form-control:focus,.form-select:focus { border-color:#0f3460; box-shadow:0 0 0 .2rem rgba(15,52,96,.2); }
        .required-star { color:#dc3545; }
        .btn-submit { background:linear-gradient(135deg,#0f3460,#533483); border:none; }
        .btn-submit:hover { background:linear-gradient(135deg,#533483,#0f3460); }
    </style>
</head>
<body>

<!-- Sidebar -->
<nav class="sidebar pt-2">
    <div class="brand"><i class="bi bi-mortarboard-fill me-2"></i>StudentMgmt</div>
    <li class="nav-item">
        <a class="nav-link" href="<%= request.getContextPath() %>/">
            <i class="bi bi-house me-2"></i>Trang Chủ
        </a>
    </li>
    <ul class="nav flex-column mt-2">
        <li class="nav-item"><a class="nav-link" href="<%= ctx %>/dashboard"><i class="bi bi-speedometer2 me-2"></i>Dashboard</a></li>
        <li class="nav-item"><a class="nav-link" href="<%= ctx %>/students?action=list"><i class="bi bi-people me-2"></i>Sinh Viên</a></li>
        <li class="nav-item"><a class="nav-link active" href="<%= ctx %>/students?action=showAdd"><i class="bi bi-person-plus me-2"></i>Thêm Mới</a></li>
        <li class="nav-item mt-4"><a class="nav-link text-warning" href="<%= ctx %>/logout"><i class="bi bi-box-arrow-left me-2"></i>Đăng Xuất</a></li>
    </ul>
</nav>

<div class="main-content">
    <div class="topbar">
        <div>
            <h5 class="mb-0"><%= pageTitle %></h5>
            <small class="text-muted">
                <% if (isEdit) { %>Đang sửa ID #<strong><%= student.getId() %></strong>
                <% } else { %>Điền thông tin sinh viên mới<% } %>
            </small>
        </div>
        <a href="<%= ctx %>/logout" class="btn btn-outline-danger btn-sm"><i class="bi bi-box-arrow-left me-1"></i>Đăng Xuất</a>
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

            <!-- ══ THÔNG TIN CƠ BẢN ══ -->
            <div class="section-title"><i class="bi bi-person me-2"></i>Thông Tin Cơ Bản</div>
            <div class="row g-3 mb-4">
                <!-- Họ tên -->
                <div class="col-md-6">
                    <label class="form-label fw-semibold">Họ và Tên <span class="required-star">*</span></label>
                    <input type="text" class="form-control" name="name"
                           value="<%= student.getName() == null ? "" : student.getName() %>"
                           placeholder="Nguyễn Văn A" maxlength="100" required>
                </div>
                <!-- Email -->
                <div class="col-md-6">
                    <label class="form-label fw-semibold">Email <span class="required-star">*</span></label>
                    <input type="email" class="form-control" name="email"
                           value="<%= student.getEmail() == null ? "" : student.getEmail() %>"
                           placeholder="example@gmail.com" maxlength="100" required>
                </div>
                <!-- Ngày sinh -->
                <div class="col-md-4">
                    <label class="form-label fw-semibold">Ngày Sinh</label>
                    <input type="date" class="form-control" name="dob"
                           value="<%= student.getDob() == null ? "" : student.getDob() %>"
                           max="<%= new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date()) %>">
                </div>
                <!-- Giới tính -->
                <div class="col-md-4">
                    <label class="form-label fw-semibold">Giới Tính</label>
                    <select class="form-select" name="gender">
                        <option value="Nam"  <%= "Nam".equals(student.getGender())  ? "selected" : "" %>>Nam</option>
                        <option value="Nữ"   <%= "Nữ".equals(student.getGender())   ? "selected" : "" %>>Nữ</option>
                        <option value="Khác" <%= "Khác".equals(student.getGender()) ? "selected" : "" %>>Khác</option>
                    </select>
                </div>
                <!-- Lớp học -->
                <div class="col-md-4">
                    <label class="form-label fw-semibold">Lớp Học</label>
                    <input type="text" class="form-control" name="className"
                           value="<%= student.getClassName() == null ? "" : student.getClassName() %>"
                           placeholder="VD: CNTT01" maxlength="50">
                </div>
            </div>

            <!-- ══ THÔNG TIN LIÊN LẠC ══ -->
            <div class="section-title"><i class="bi bi-telephone me-2"></i>Thông Tin Liên Lạc</div>
            <div class="row g-3 mb-4">
                <!-- SĐT -->
                <div class="col-md-5">
                    <label class="form-label fw-semibold">Số Điện Thoại</label>
                    <input type="tel" class="form-control" name="phone"
                           value="<%= student.getPhone() == null ? "" : student.getPhone() %>"
                           placeholder="0901234567" maxlength="20">
                    <div class="form-text">Số điện thoại VN 10 chữ số (03x, 05x, 07x, 08x, 09x)</div>
                </div>
                <!-- Địa chỉ -->
                <div class="col-md-7">
                    <label class="form-label fw-semibold">Địa Chỉ</label>
                    <textarea class="form-control" name="address" rows="2"
                              placeholder="Số nhà, đường, phường/xã, quận/huyện, tỉnh/thành"
                              maxlength="255"><%= student.getAddress() == null ? "" : student.getAddress() %></textarea>
                </div>
            </div>

            <!-- Buttons -->
            <div class="d-flex justify-content-end gap-2 pt-2 border-top mt-2">
                <a href="<%= ctx %>/students?action=list" class="btn btn-outline-secondary px-4">
                    <i class="bi bi-arrow-left me-1"></i>Huỷ
                </a>
                <button type="submit" class="btn btn-submit btn-primary text-white px-5">
                    <i class="bi <%= isEdit ? "bi-save" : "bi-plus-circle" %> me-1"></i>
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