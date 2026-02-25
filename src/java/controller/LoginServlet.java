package controller;

import dao.UserDAO;
import model.User;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;

public class LoginServlet extends HttpServlet {

    private UserDAO userDAO;

    @Override
    public void init() {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession s = req.getSession(false);
        if (s != null && s.getAttribute("loggedInUser") != null) {
            resp.sendRedirect(req.getContextPath() + "/dashboard");
            return;
        }
        req.getRequestDispatcher("/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        String username = safe(req.getParameter("username"));
        String password = safe(req.getParameter("password"));

        // Xác thực từ database
        User user = userDAO.login(username, password);

        if (user != null) {
            // Huỷ session cũ (chống session fixation)
            HttpSession old = req.getSession(false);
            if (old != null) old.invalidate();

            // Tạo session mới
            HttpSession session = req.getSession(true);
            session.setAttribute("loggedInUser", user.getUsername());
            session.setAttribute("loggedInFullName", user.getFullName());
            session.setAttribute("loggedInRole", user.getRole());
            session.setAttribute("isAdmin", user.isAdmin());
            session.setMaxInactiveInterval(30 * 60);

            resp.sendRedirect(req.getContextPath() + "/dashboard");
        } else {
            req.setAttribute("errorMessage",
                "Sai tên đăng nhập hoặc mật khẩu. Vui lòng thử lại.");
            req.setAttribute("username", username);
            req.getRequestDispatcher("/login.jsp").forward(req, resp);
        }
    }

    private String safe(String s) { return s == null ? "" : s.trim(); }
}