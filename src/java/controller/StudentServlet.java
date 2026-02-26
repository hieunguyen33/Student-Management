package controller;

import dao.StudentDAO;
import model.Student;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

public class StudentServlet extends HttpServlet {

    private static final int PAGE_SIZE = 8;
    private StudentDAO dao;

    @Override
    public void init() { dao = new StudentDAO(); }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");
        if (action == null) action = "list";
        switch (action) {
            case "list":     list(req, resp);     break;
            case "search":   search(req, resp);   break;
            case "showAdd":  showAdd(req, resp);  break;
            case "showEdit": showEdit(req, resp); break;
            case "delete":   delete(req, resp);   break;
            default:         list(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");
        if (action == null) action = "list";
        switch (action) {
            case "add":  add(req, resp);  break;
            case "edit": edit(req, resp); break;
            default:     list(req, resp);
        }
    }

    private void list(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        int page       = parsePage(req.getParameter("page"));
        int total      = dao.countAll();
        int totalPages = (int) Math.ceil((double) total / PAGE_SIZE);
        if (page > totalPages && totalPages > 0) page = totalPages;

        List<Student> students = dao.getStudentsPaged(page, PAGE_SIZE);
        setPaginationAttributes(req, students, total, page, totalPages, "", "");
        req.setAttribute("activeMenu", "students"); // ← active
        req.getRequestDispatcher("/student-list.jsp").forward(req, resp);
    }

    private void search(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String keyword = safe(req.getParameter("keyword"));
        String field   = safe(req.getParameter("field"));
        if (field.isEmpty()) field = "name";

        int page       = parsePage(req.getParameter("page"));
        int total      = dao.countByKeyword(field, keyword);
        int totalPages = (int) Math.ceil((double) total / PAGE_SIZE);
        if (page > totalPages && totalPages > 0) page = totalPages;

        List<Student> students = dao.getStudentsPagedSearch(page, PAGE_SIZE, field, keyword);
        setPaginationAttributes(req, students, total, page, totalPages, keyword, field);
        req.setAttribute("keyword",    keyword);
        req.setAttribute("field",      field);
        req.setAttribute("activeMenu", "students"); // ← active
        req.getRequestDispatcher("/student-list.jsp").forward(req, resp);
    }

    private void showAdd(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setAttribute("student",    new Student());
        req.setAttribute("formAction", "add");
        req.setAttribute("activeMenu", "students"); // ← active
        req.getRequestDispatcher("/student-form.jsp").forward(req, resp);
    }

    private void showEdit(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(req.getParameter("id"));
            Student s = dao.getStudentById(id);
            if (s == null) { list(req, resp); return; }
            req.setAttribute("student",    s);
            req.setAttribute("formAction", "edit");
            req.setAttribute("activeMenu", "students"); // ← active
            req.getRequestDispatcher("/student-form.jsp").forward(req, resp);
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/students?action=list");
        }
    }

    private void add(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        Student s   = build(req, 0);
        String  err = validate(s, 0);
        if (err != null) {
            req.setAttribute("errorMessage", err);
            req.setAttribute("student",    s);
            req.setAttribute("formAction", "add");
            req.setAttribute("activeMenu", "students"); // ← active
            req.getRequestDispatcher("/student-form.jsp").forward(req, resp);
            return;
        }
        if (dao.addStudent(s)) {
            req.getSession().setAttribute("flashMessage", "✅ Thêm sinh viên thành công!");
        } else {
            req.getSession().setAttribute("flashError", "Thêm thất bại. Vui lòng kiểm tra log.");
        }
        resp.sendRedirect(req.getContextPath() + "/students?action=list");
    }

    private void edit(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            int     id  = Integer.parseInt(req.getParameter("id"));
            Student s   = build(req, id);
            String  err = validate(s, id);
            if (err != null) {
                req.setAttribute("errorMessage", err);
                req.setAttribute("student",    s);
                req.setAttribute("formAction", "edit");
                req.setAttribute("activeMenu", "students"); // ← active
                req.getRequestDispatcher("/student-form.jsp").forward(req, resp);
                return;
            }
            if (dao.updateStudent(s)) {
                req.getSession().setAttribute("flashMessage", "✅ Cập nhật thành công!");
            } else {
                req.getSession().setAttribute("flashError", "Cập nhật thất bại.");
            }
            resp.sendRedirect(req.getContextPath() + "/students?action=list");
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/students?action=list");
        }
    }

    private void delete(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(req.getParameter("id"));
            if (dao.deleteStudent(id)) {
                req.getSession().setAttribute("flashMessage", "🗑️ Xoá sinh viên thành công.");
            } else {
                req.getSession().setAttribute("flashError", "Không tìm thấy sinh viên.");
            }
        } catch (NumberFormatException e) {
            req.getSession().setAttribute("flashError", "ID không hợp lệ.");
        }
        resp.sendRedirect(req.getContextPath() + "/students?action=list");
    }

    // ── Helpers ───────────────────────────────────────────────────────────────
    private Student build(HttpServletRequest req, int id) {
        return new Student(id,
            safe(req.getParameter("name")),
            safe(req.getParameter("email")),
            safe(req.getParameter("dob")),
            safe(req.getParameter("gender")),
            safe(req.getParameter("className")),
            safe(req.getParameter("phone")),
            safe(req.getParameter("address"))
        );
    }

    private String validate(Student s, int excludeId) {
        if (s.getName().isEmpty())  return "Họ tên không được để trống.";
        if (s.getEmail().isEmpty()) return "Email không được để trống.";
        if (!s.getEmail().matches("^[\\w.+\\-]+@[a-zA-Z0-9.\\-]+\\.[a-zA-Z]{2,}$"))
            return "Định dạng email không hợp lệ.";
        if (dao.isEmailTaken(s.getEmail(), excludeId))
            return "Email '" + s.getEmail() + "' đã được sử dụng.";
        if (!s.getPhone().isEmpty() &&
            !s.getPhone().matches("^(0[3|5|7|8|9])+([0-9]{8})$"))
            return "Số điện thoại không hợp lệ (10 chữ số VN, bắt đầu 03/05/07/08/09).";
        return null;
    }

    private void setPaginationAttributes(HttpServletRequest req,
            List<Student> students, int total, int page,
            int totalPages, String keyword, String field) {
        req.setAttribute("students",   students);
        req.setAttribute("totalCount", total);
        req.setAttribute("page",       page);
        req.setAttribute("totalPages", totalPages);
        req.setAttribute("pageSize",   PAGE_SIZE);
        req.setAttribute("keyword",    keyword);
        req.setAttribute("field",      field);
    }

    private int parsePage(String param) {
        try { int p = Integer.parseInt(param); return p < 1 ? 1 : p; }
        catch (Exception e) { return 1; }
    }

    private String safe(String s) { return s == null ? "" : s.trim(); }
}