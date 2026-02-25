package controller;

import dao.StudentDAO;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

public class DashboardServlet extends HttpServlet {

    private StudentDAO dao;

    @Override
    public void init() { dao = new StudentDAO(); }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        int total = dao.countAll();

        // Thống kê theo giới tính
        List<model.Student> all = dao.getAllStudents();
        long nam = all.stream().filter(s -> "Nam".equals(s.getGender())).count();
        long nu  = all.stream().filter(s -> "Nữ".equals(s.getGender())).count();

        req.setAttribute("totalStudents", total);
        req.setAttribute("totalNam",  nam);
        req.setAttribute("totalNu",   nu);
        req.getRequestDispatcher("/dashboard.jsp").forward(req, resp);
    }
}