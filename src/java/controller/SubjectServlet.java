package controller;

import dao.SubjectDAO;
import model.Subject;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

public class SubjectServlet extends HttpServlet {

    private SubjectDAO dao;

    @Override
    public void init() { dao = new SubjectDAO(); }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");
        if (action == null) action = "list";
        switch (action) {
            case "list":     list(req, resp);     break;
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
        if ("add".equals(action))  { add(req, resp);  return; }
        if ("edit".equals(action)) { edit(req, resp); return; }
        list(req, resp);
    }

    private void list(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setAttribute("subjects",   dao.getAllSubjects());
        req.setAttribute("activeMenu", "subjects"); // ← active
        req.getRequestDispatcher("/subject-list.jsp").forward(req, resp);
    }

    private void showAdd(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setAttribute("subject",    new Subject());
        req.setAttribute("formAction", "add");
        req.setAttribute("activeMenu", "subjects"); // ← active
        req.getRequestDispatcher("/subject-form.jsp").forward(req, resp);
    }

    private void showEdit(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(req.getParameter("id"));
            Subject s = dao.getSubjectById(id);
            if (s == null) { list(req, resp); return; }
            req.setAttribute("subject",    s);
            req.setAttribute("formAction", "edit");
            req.setAttribute("activeMenu", "subjects"); // ← active
            req.getRequestDispatcher("/subject-form.jsp").forward(req, resp);
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/subjects?action=list");
        }
    }

    private void add(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        Subject s   = build(req, 0);
        String  err = validate(s, 0);
        if (err != null) {
            req.setAttribute("errorMessage", err);
            req.setAttribute("subject",    s);
            req.setAttribute("formAction", "add");
            req.setAttribute("activeMenu", "subjects"); // ← active
            req.getRequestDispatcher("/subject-form.jsp").forward(req, resp);
            return;
        }
        if (dao.addSubject(s)) {
            req.getSession().setAttribute("flashMessage", "✅ Thêm môn học thành công!");
        } else {
            req.getSession().setAttribute("flashError", "Thêm môn học thất bại.");
        }
        resp.sendRedirect(req.getContextPath() + "/subjects?action=list");
    }

    private void edit(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            int     id  = Integer.parseInt(req.getParameter("id"));
            Subject s   = build(req, id);
            String  err = validate(s, id);
            if (err != null) {
                req.setAttribute("errorMessage", err);
                req.setAttribute("subject",    s);
                req.setAttribute("formAction", "edit");
                req.setAttribute("activeMenu", "subjects"); // ← active
                req.getRequestDispatcher("/subject-form.jsp").forward(req, resp);
                return;
            }
            if (dao.updateSubject(s)) {
                req.getSession().setAttribute("flashMessage", "✅ Cập nhật môn học thành công!");
            } else {
                req.getSession().setAttribute("flashError", "Cập nhật thất bại.");
            }
            resp.sendRedirect(req.getContextPath() + "/subjects?action=list");
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/subjects?action=list");
        }
    }

    private void delete(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(req.getParameter("id"));
            if (dao.deleteSubject(id)) {
                req.getSession().setAttribute("flashMessage", "🗑️ Xoá môn học thành công.");
            } else {
                req.getSession().setAttribute("flashError", "Xoá thất bại.");
            }
        } catch (NumberFormatException e) {
            req.getSession().setAttribute("flashError", "ID không hợp lệ.");
        }
        resp.sendRedirect(req.getContextPath() + "/subjects?action=list");
    }

    private Subject build(HttpServletRequest req, int id) {
        Subject s = new Subject();
        s.setId(id);
        s.setSubjectCode(safe(req.getParameter("subjectCode")));
        s.setSubjectName(safe(req.getParameter("subjectName")));
        try { s.setCredits(Integer.parseInt(req.getParameter("credits"))); }
        catch (Exception e) { s.setCredits(3); }
        return s;
    }

    private String validate(Subject s, int excludeId) {
        if (s.getSubjectCode().isEmpty()) return "Mã môn học không được để trống.";
        if (s.getSubjectName().isEmpty()) return "Tên môn học không được để trống.";
        if (s.getCredits() < 1 || s.getCredits() > 10) return "Số tín chỉ phải từ 1 đến 10.";
        if (dao.isCodeTaken(s.getSubjectCode(), excludeId))
            return "Mã môn '" + s.getSubjectCode() + "' đã tồn tại.";
        return null;
    }

    private String safe(String s) { return s == null ? "" : s.trim(); }
}