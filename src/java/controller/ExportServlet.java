package controller;

import dao.StudentDAO;
import model.Student;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.*;
import java.util.List;

/**
 * Export danh sách sinh viên ra file CSV
 * Không cần thư viện ngoài
 */
public class ExportServlet extends HttpServlet {

    private StudentDAO dao;

    @Override
    public void init() { dao = new StudentDAO(); }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        List<Student> students = dao.getAllStudents();

        // ── Set response headers để trình duyệt tải file xuống ──
        resp.setContentType("text/csv; charset=UTF-8");
        resp.setCharacterEncoding("UTF-8");
        resp.setHeader("Content-Disposition",
            "attachment; filename=\"danh-sach-sinh-vien.csv\"");

        // ── Ghi dữ liệu ──
        PrintWriter writer = resp.getWriter();

        // BOM UTF-8 để Excel mở đúng tiếng Việt
        writer.write('\uFEFF');

        // Header
        writer.println("STT,Họ và Tên,Email,Ngày Sinh,Giới Tính,Lớp,Số Điện Thoại,Địa Chỉ");

        // Data rows
        int stt = 1;
        for (Student s : students) {
            writer.printf("%d,%s,%s,%s,%s,%s,%s,\"%s\"%n",
                stt++,
                escapeCsv(s.getName()),
                escapeCsv(s.getEmail()),
                escapeCsv(s.getDob()),
                escapeCsv(s.getGender()),
                escapeCsv(s.getClassName()),
                escapeCsv(s.getPhone()),
                escapeCsv(s.getAddress())
            );
        }

        writer.flush();
    }

    /**
     * Escape ký tự đặc biệt trong CSV
     */
    private String escapeCsv(String value) {
        if (value == null) return "";
        // Nếu có dấu phẩy, xuống dòng hoặc ngoặc kép → bọc trong ngoặc kép
        if (value.contains(",") || value.contains("\n") || value.contains("\"")) {
            value = value.replace("\"", "\"\"");
            return "\"" + value + "\"";
        }
        return value;
    }
}