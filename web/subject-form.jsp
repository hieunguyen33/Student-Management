<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Subject" %>
<%
    Subject subject      = (Subject) request.getAttribute("subject");
    String  formAction   = (String)  request.getAttribute("formAction");
    String  errorMessage = (String)  request.getAttribute("errorMessage");
    if (subject    == null) subject    = new Subject();
    if (formAction == null) formAction = "add";
    boolean isEdit  = "edit".equals(formAction);
    String  ctx     = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= isEdit?"Sửa":"Thêm" %> Môn Học</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">
    <link rel="stylesheet" href="<%= ctx %>/css/style.css">
</head>
<body>

<%@ include file="/WEB-INF/includes/sidebar.jsp" %>

<div class="main-content">
    <nav class="mb-3"><ol class="breadcrumb">
        <li class="breadcrumb-item"><a href="<%= ctx %>/dashboard">Dashboard</a></li>
        <li class="breadcrumb-item"><a href="<%= ctx %>/subjects?action=list">Môn Học</a></li>
        <li class="breadcrumb-item active"><%= isEdit?"Sửa":"Thêm" %></li>
    </ol></nav>

    <div class="form-card" style="max-width:600px">
        <div class="text-center mb-4">
            <i class="bi bi-book-fill" style="font-size:3rem;color:#0f3460"></i>
            <h5 class="mt-2 fw-bold"><%= isEdit?"Sửa Môn Học":"Thêm Môn Học Mới" %></h5>
        </div>

        <% if (errorMessage != null) { %>
        <div class="alert alert-danger">
            <i class="bi bi-exclamation-triangle-fill me-2"></i><%= errorMessage %>
        </div>
        <% } %>

        <form action="<%= ctx %>/subjects" method="POST" novalidate>
            <input type="hidden" name="action" value="<%= formAction %>">
            <% if (isEdit) { %><input type="hidden" name="id" value="<%= subject.getId() %>"><% } %>

            <div class="mb-3">
                <label class="form-label fw-semibold">Mã Môn Học <span class="required-star">*</span></label>
                <input type="text" class="form-control" name="subjectCode"
                       value="<%= subject.getSubjectCode()==null?"":subject.getSubjectCode() %>"
                       placeholder="VD: CNTT001" maxlength="20" required>
            </div>
            <div class="mb-3">
                <label class="form-label fw-semibold">Tên Môn Học <span class="required-star">*</span></label>
                <input type="text" class="form-control" name="subjectName"
                       value="<%= subject.getSubjectName()==null?"":subject.getSubjectName() %>"
                       placeholder="VD: Lập trình Java" maxlength="100" required>
            </div>
            <div class="mb-4">
                <label class="form-label fw-semibold">Số Tín Chỉ <span class="required-star">*</span></label>
                <input type="number" class="form-control" name="credits"
                       value="<%= subject.getCredits()==0?3:subject.getCredits() %>"
                       min="1" max="10" required>
            </div>

            <div class="d-flex justify-content-end gap-2">
                <a href="<%= ctx %>/subjects?action=list" class="btn btn-outline-secondary px-4">
                    <i class="bi bi-arrow-left me-1"></i>Huỷ
                </a>
                <button type="submit" class="btn btn-submit btn-primary text-white px-4">
                    <i class="bi <%= isEdit?"bi-save":"bi-plus-circle" %> me-1"></i>
                    <%= isEdit?"Cập Nhật":"Thêm Môn Học" %>
                </button>
            </div>
        </form>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>