<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Grade, model.Student, model.Subject" %>
<%
    Student student      = (Student) request.getAttribute("student");
    Subject subject      = (Subject) request.getAttribute("subject");
    Grade   grade        = (Grade)   request.getAttribute("grade");
    String  errorMessage = (String)  request.getAttribute("errorMessage");
    String  ctx          = request.getContextPath();
    boolean isEdit       = (grade!=null && grade.getFinalScore()!=null);
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Nhập Điểm</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">
    <link rel="stylesheet" href="<%= ctx %>/css/style.css">
</head>
<body>

<%@ include file="/WEB-INF/includes/sidebar.jsp" %>

<div class="main-content">
    <nav class="mb-3"><ol class="breadcrumb">
        <li class="breadcrumb-item"><a href="<%= ctx %>/grades?action=viewByStudent">Bảng Điểm</a></li>
        <li class="breadcrumb-item"><a href="<%= ctx %>/grades?action=viewByStudent&studentId=<%= student.getId() %>"><%= student.getName() %></a></li>
        <li class="breadcrumb-item active">Nhập Điểm</li>
    </ol></nav>

    <div class="form-card" style="max-width:600px">
        <div class="text-center mb-4">
            <i class="bi bi-pencil-square" style="font-size:3rem;color:#0f3460"></i>
            <h5 class="mt-2 fw-bold"><%= isEdit?"Sửa Điểm":"Nhập Điểm Mới" %></h5>
        </div>

        <!-- Info Box -->
        <div class="info-box">
            <div class="row g-2">
                <div class="col-6">
                    <small class="text-muted">Sinh viên</small>
                    <div class="fw-semibold"><%= student.getName() %></div>
                </div>
                <div class="col-6">
                    <small class="text-muted">Môn học</small>
                    <div class="fw-semibold"><%= subject.getSubjectName() %></div>
                </div>
                <div class="col-6">
                    <small class="text-muted">Mã môn</small>
                    <div><%= subject.getSubjectCode() %></div>
                </div>
                <div class="col-6">
                    <small class="text-muted">Tín chỉ</small>
                    <div><%= subject.getCredits() %> tín chỉ</div>
                </div>
            </div>
        </div>

        <% if (errorMessage!=null) { %>
        <div class="alert alert-danger">
            <i class="bi bi-exclamation-triangle-fill me-2"></i><%= errorMessage %>
        </div>
        <% } %>

        <form action="<%= ctx %>/grades" method="POST">
            <input type="hidden" name="studentId" value="<%= student.getId() %>">
            <input type="hidden" name="subjectId" value="<%= subject.getId() %>">

            <div class="row g-3 mb-3">
                <div class="col-md-4">
                    <label class="form-label fw-semibold">
                        Chuyên Cần <span class="badge bg-secondary">×10%</span>
                    </label>
                    <input type="number" class="form-control score-input" id="attendance"
                           name="attendance"
                           value="<%= (grade!=null&&grade.getAttendance()!=null)?grade.getAttendance():"" %>"
                           min="0" max="10" step="0.1" placeholder="0 – 10">
                </div>
                <div class="col-md-4">
                    <label class="form-label fw-semibold">
                        Giữa Kỳ <span class="badge bg-primary">×30%</span>
                    </label>
                    <input type="number" class="form-control score-input" id="midterm"
                           name="midterm"
                           value="<%= (grade!=null&&grade.getMidterm()!=null)?grade.getMidterm():"" %>"
                           min="0" max="10" step="0.1" placeholder="0 – 10">
                </div>
                <div class="col-md-4">
                    <label class="form-label fw-semibold">
                        Cuối Kỳ <span class="badge bg-success">×60%</span>
                    </label>
                    <input type="number" class="form-control score-input" id="finalExam"
                           name="finalExam"
                           value="<%= (grade!=null&&grade.getFinalExam()!=null)?grade.getFinalExam():"" %>"
                           min="0" max="10" step="0.1" placeholder="0 – 10">
                </div>
            </div>

            <!-- Preview -->
            <div class="score-preview mb-4">
                <div class="row text-center g-2">
                    <div class="col-4">
                        <div class="text-muted small">Điểm Tổng Kết</div>
                        <div id="previewScore" class="fw-bold fs-3 text-primary">—</div>
                    </div>
                    <div class="col-4">
                        <div class="text-muted small">Xếp Loại</div>
                        <div id="previewLetter" class="fw-bold fs-3">—</div>
                    </div>
                    <div class="col-4">
                        <div class="text-muted small">GPA</div>
                        <div id="previewGpa" class="fw-bold fs-3">—</div>
                    </div>
                </div>
                <div class="text-muted small mt-2 text-center">
                    * Tự tính khi nhập đủ 3 điểm
                </div>
            </div>

            <div class="d-flex justify-content-end gap-2">
                <a href="<%= ctx %>/grades?action=viewByStudent&studentId=<%= student.getId() %>"
                   class="btn btn-outline-secondary px-4">
                    <i class="bi bi-arrow-left me-1"></i>Huỷ
                </a>
                <button type="submit" class="btn btn-submit btn-primary text-white px-4">
                    <i class="bi bi-save me-1"></i>
                    <%= isEdit?"Cập Nhật Điểm":"Lưu Điểm" %>
                </button>
            </div>
        </form>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
function calcPreview() {
    const att = parseFloat(document.getElementById('attendance').value);
    const mid = parseFloat(document.getElementById('midterm').value);
    const fin = parseFloat(document.getElementById('finalExam').value);
    if (!isNaN(att) && !isNaN(mid) && !isNaN(fin)) {
        const total = Math.round((att*0.1 + mid*0.3 + fin*0.6)*100)/100;
        document.getElementById('previewScore').textContent = total.toFixed(2);
        document.getElementById('previewScore').style.color = total>=5?'#198754':'#dc3545';
        let letter, gpa;
        if      (total>=9.0){letter='A'; gpa=4.0;}
        else if (total>=8.5){letter='B+';gpa=3.7;}
        else if (total>=8.0){letter='B'; gpa=3.5;}
        else if (total>=7.5){letter='B-';gpa=3.0;}
        else if (total>=7.0){letter='C+';gpa=2.5;}
        else if (total>=6.5){letter='C'; gpa=2.3;}
        else if (total>=6.0){letter='C-';gpa=2.0;}
        else if (total>=5.5){letter='D+';gpa=1.5;}
        else if (total>=5.0){letter='D'; gpa=1.0;}
        else                {letter='F'; gpa=0.0;}
        const colors={'A':'#198754','B+':'#0d6efd','B':'#0d6efd','B-':'#0d6efd',
                      'C+':'#ffc107','C':'#ffc107','C-':'#ffc107',
                      'D+':'#fd7e14','D':'#fd7e14','F':'#dc3545'};
        document.getElementById('previewLetter').textContent = letter;
        document.getElementById('previewLetter').style.color = colors[letter]||'#6c757d';
        document.getElementById('previewGpa').textContent = gpa.toFixed(1);
    } else {
        document.getElementById('previewScore').textContent  = '—';
        document.getElementById('previewLetter').textContent = '—';
        document.getElementById('previewGpa').textContent    = '—';
    }
}
document.querySelectorAll('.score-input').forEach(el=>el.addEventListener('input',calcPreview));
calcPreview();
</script>
</body>
</html>
