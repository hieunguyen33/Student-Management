package controller;

import dao.GradeDAO;
import dao.StudentDAO;
import dao.SubjectDAO;
import model.Grade;
import model.Student;
import model.Subject;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

public class GradeServlet extends HttpServlet {

    private GradeDAO   gradeDAO;
    private StudentDAO studentDAO;
    private SubjectDAO subjectDAO;

    @Override
    public void init() {
        gradeDAO   = new GradeDAO();
        studentDAO = new StudentDAO();
        subjectDAO = new SubjectDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");
        if (action == null) action = "viewByStudent";
        switch (action) {
            case "viewByStudent": viewByStudent(req, resp); break;
            case "showInput":     showInput(req, resp);     break;
            case "delete":        delete(req, resp);        break;
            default:              viewByStudent(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        saveGrade(req, resp);
    }

    private void viewByStudent(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String idParam = req.getParameter("studentId");
        if (idParam == null || idParam.isEmpty()) {
            req.setAttribute("students",   studentDAO.getAllStudents());
            req.setAttribute("activeMenu", "grades"); // ← active
            req.getRequestDispatcher("/grade-select-student.jsp").forward(req, resp);
            return;
        }
        try {
            int     studentId = Integer.parseInt(idParam);
            Student student   = studentDAO.getStudentById(studentId);
            if (student == null) {
                req.setAttribute("students",   studentDAO.getAllStudents());
                req.setAttribute("activeMenu", "grades"); // ← active
                req.getRequestDispatcher("/grade-select-student.jsp").forward(req, resp);
                return;
            }
            List<Grade> grades = gradeDAO.getGradesByStudentId(studentId);
            Float       cumGpa = gradeDAO.calcCumulativeGpa(studentId);

            req.setAttribute("student",    student);
            req.setAttribute("grades",     grades);
            req.setAttribute("cumGpa",     cumGpa);
            req.setAttribute("subjects",   subjectDAO.getAllSubjects());
            req.setAttribute("activeMenu", "grades"); // ← active
            req.getRequestDispatcher("/grade-view.jsp").forward(req, resp);
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/grades?action=viewByStudent");
        }
    }

    private void showInput(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            int     studentId = Integer.parseInt(req.getParameter("studentId"));
            int     subjectId = Integer.parseInt(req.getParameter("subjectId"));
            Student student   = studentDAO.getStudentById(studentId);
            Subject subject   = subjectDAO.getSubjectById(subjectId);
            Grade   existing  = gradeDAO.getGrade(studentId, subjectId);

            req.setAttribute("student",    student);
            req.setAttribute("subject",    subject);
            req.setAttribute("grade",      existing);
            req.setAttribute("activeMenu", "grades"); // ← active
            req.getRequestDispatcher("/grade-form.jsp").forward(req, resp);
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/grades?action=viewByStudent");
        }
    }

    private void saveGrade(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            int   studentId  = Integer.parseInt(req.getParameter("studentId"));
            int   subjectId  = Integer.parseInt(req.getParameter("subjectId"));
            Float attendance = parseFloat(req.getParameter("attendance"));
            Float midterm    = parseFloat(req.getParameter("midterm"));
            Float finalExam  = parseFloat(req.getParameter("finalExam"));

            String err = validateScores(attendance, midterm, finalExam);
            if (err != null) {
                Student student = studentDAO.getStudentById(studentId);
                Subject subject = subjectDAO.getSubjectById(subjectId);
                req.setAttribute("student",       student);
                req.setAttribute("subject",       subject);
                req.setAttribute("errorMessage",  err);
                req.setAttribute("activeMenu",    "grades"); // ← active
                req.getRequestDispatcher("/grade-form.jsp").forward(req, resp);
                return;
            }

            boolean ok = gradeDAO.saveGrade(studentId, subjectId, attendance, midterm, finalExam);
            if (ok) {
                req.getSession().setAttribute("flashMessage", "✅ Lưu điểm thành công!");
            } else {
                req.getSession().setAttribute("flashError", "Lưu điểm thất bại.");
            }
            resp.sendRedirect(req.getContextPath() +
                "/grades?action=viewByStudent&studentId=" + studentId);
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/grades?action=viewByStudent");
        }
    }

    private void delete(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            int studentId = Integer.parseInt(req.getParameter("studentId"));
            int subjectId = Integer.parseInt(req.getParameter("subjectId"));
            if (gradeDAO.deleteGrade(studentId, subjectId)) {
                req.getSession().setAttribute("flashMessage", "🗑️ Xoá điểm thành công.");
            } else {
                req.getSession().setAttribute("flashError", "Xoá điểm thất bại.");
            }
            resp.sendRedirect(req.getContextPath() +
                "/grades?action=viewByStudent&studentId=" + studentId);
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/grades?action=viewByStudent");
        }
    }

    private Float parseFloat(String s) {
        if (s == null || s.trim().isEmpty()) return null;
        try { return Float.parseFloat(s.trim()); }
        catch (NumberFormatException e) { return null; }
    }

    private String validateScores(Float att, Float mid, Float fin) {
        if (att != null && (att < 0 || att > 10)) return "Điểm chuyên cần phải từ 0 đến 10.";
        if (mid != null && (mid < 0 || mid > 10)) return "Điểm giữa kỳ phải từ 0 đến 10.";
        if (fin != null && (fin < 0 || fin > 10)) return "Điểm cuối kỳ phải từ 0 đến 10.";
        return null;
    }
}