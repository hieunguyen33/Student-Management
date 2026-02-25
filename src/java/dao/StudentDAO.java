package dao;

import model.Student;
import util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class StudentDAO {

    // ── Đếm tổng số sinh viên (dùng cho pagination) ───────────────────────────
    public int countAll() {
        return count("", "");
    }

    public int countByKeyword(String field, String keyword) {
        return count(field, keyword);
    }

    private int count(String field, String keyword) {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            String sql;
            PreparedStatement ps;
            if (keyword == null || keyword.isEmpty()) {
                sql = "SELECT COUNT(*) FROM students";
                ps  = conn.prepareStatement(sql);
            } else {
                sql = "SELECT COUNT(*) FROM students WHERE " + getSafeField(field) + " LIKE ?";
                ps  = conn.prepareStatement(sql);
                ps.setString(1, "%" + keyword + "%");
            }
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
            rs.close(); ps.close();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(conn);
        }
        return 0;
    }

    // ── Lấy danh sách có phân trang ───────────────────────────────────────────
    public List<Student> getStudentsPaged(int page, int pageSize) {
        return getStudentsPagedSearch(page, pageSize, "", "");
    }

    public List<Student> getStudentsPagedSearch(int page, int pageSize,
                                                 String field, String keyword) {
        List<Student> list   = new ArrayList<>();
        int           offset = (page - 1) * pageSize;
        Connection    conn   = null;
        try {
            conn = DBConnection.getConnection();
            String sql;
            PreparedStatement ps;
            if (keyword == null || keyword.isEmpty()) {
                sql = "SELECT * FROM students ORDER BY id DESC LIMIT ? OFFSET ?";
                ps  = conn.prepareStatement(sql);
                ps.setInt(1, pageSize);
                ps.setInt(2, offset);
            } else {
                sql = "SELECT * FROM students WHERE " + getSafeField(field) +
                      " LIKE ? ORDER BY id DESC LIMIT ? OFFSET ?";
                ps  = conn.prepareStatement(sql);
                ps.setString(1, "%" + keyword + "%");
                ps.setInt(2, pageSize);
                ps.setInt(3, offset);
            }
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
            rs.close(); ps.close();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(conn);
        }
        return list;
    }

    // ── CRUD cơ bản ───────────────────────────────────────────────────────────
    public List<Student> getAllStudents() {
        List<Student> list = new ArrayList<>();
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(
                "SELECT * FROM students ORDER BY id DESC");
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
            rs.close(); ps.close();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(conn);
        }
        return list;
    }

    public Student getStudentById(int id) {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(
                "SELECT * FROM students WHERE id = ?");
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapRow(rs);
            rs.close(); ps.close();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(conn);
        }
        return null;
    }

    public boolean addStudent(Student s) {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(
                "INSERT INTO students(name,email,dob,gender,class_name,phone,address)" +
                " VALUES(?,?,?,?,?,?,?)");
            ps.setString(1, s.getName());
            ps.setString(2, s.getEmail());
            ps.setString(3, nullIfEmpty(s.getDob()));
            ps.setString(4, s.getGender());
            ps.setString(5, s.getClassName());
            ps.setString(6, s.getPhone());
            ps.setString(7, s.getAddress());
            boolean ok = ps.executeUpdate() > 0;
            ps.close();
            return ok;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            DBConnection.close(conn);
        }
    }

    public boolean updateStudent(Student s) {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(
                "UPDATE students SET name=?,email=?,dob=?,gender=?," +
                "class_name=?,phone=?,address=? WHERE id=?");
            ps.setString(1, s.getName());
            ps.setString(2, s.getEmail());
            ps.setString(3, nullIfEmpty(s.getDob()));
            ps.setString(4, s.getGender());
            ps.setString(5, s.getClassName());
            ps.setString(6, s.getPhone());
            ps.setString(7, s.getAddress());
            ps.setInt(8, s.getId());
            boolean ok = ps.executeUpdate() > 0;
            ps.close();
            return ok;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            DBConnection.close(conn);
        }
    }

    public boolean deleteStudent(int id) {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(
                "DELETE FROM students WHERE id=?");
            ps.setInt(1, id);
            boolean ok = ps.executeUpdate() > 0;
            ps.close();
            return ok;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            DBConnection.close(conn);
        }
    }

    public boolean isEmailTaken(String email, int excludeId) {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(
                "SELECT COUNT(*) FROM students WHERE email=? AND id<>?");
            ps.setString(1, email);
            ps.setInt(2, excludeId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1) > 0;
            rs.close(); ps.close();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(conn);
        }
        return false;
    }

    // ── Helpers ───────────────────────────────────────────────────────────────
    private Student mapRow(ResultSet rs) throws SQLException {
        return new Student(
            rs.getInt("id"),
            rs.getString("name"),
            rs.getString("email"),
            rs.getString("dob")        != null ? rs.getString("dob") : "",
            rs.getString("gender")     != null ? rs.getString("gender") : "Nam",
            rs.getString("class_name") != null ? rs.getString("class_name") : "",
            rs.getString("phone")      != null ? rs.getString("phone") : "",
            rs.getString("address")    != null ? rs.getString("address") : ""
        );
    }

    /**
     * Chỉ cho phép tìm kiếm theo các field hợp lệ (tránh SQL Injection ở field name)
     */
    private String getSafeField(String field) {
        switch (field) {
            case "email":      return "email";
            case "phone":      return "phone";
            case "class_name": return "class_name";
            default:           return "name";
        }
    }

    private String nullIfEmpty(String s) {
        return (s == null || s.isEmpty()) ? null : s;
    }
}