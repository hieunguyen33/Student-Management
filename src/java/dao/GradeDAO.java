package dao;

import model.Grade;
import util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class GradeDAO {

    // ── Lấy toàn bộ điểm của 1 sinh viên ─────────────────────────────────────
    public List<Grade> getGradesByStudentId(int studentId) {
        List<Grade> list = new ArrayList<>();
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(
                "SELECT g.*, s.subject_code, s.subject_name, s.credits, " +
                "       st.name AS student_name " +
                "FROM grades g " +
                "JOIN subjects s  ON g.subject_id  = s.id " +
                "JOIN students st ON g.student_id  = st.id " +
                "WHERE g.student_id = ? " +
                "ORDER BY s.subject_code");
            ps.setInt(1, studentId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
            rs.close(); ps.close();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally { DBConnection.close(conn); }
        return list;
    }

    // ── Lấy điểm 1 môn của 1 sinh viên ───────────────────────────────────────
    public Grade getGrade(int studentId, int subjectId) {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(
                "SELECT g.*, s.subject_code, s.subject_name, s.credits, " +
                "       st.name AS student_name " +
                "FROM grades g " +
                "JOIN subjects s  ON g.subject_id = s.id " +
                "JOIN students st ON g.student_id = st.id " +
                "WHERE g.student_id=? AND g.subject_id=?");
            ps.setInt(1, studentId);
            ps.setInt(2, subjectId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapRow(rs);
            rs.close(); ps.close();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally { DBConnection.close(conn); }
        return null;
    }

    // ── Lưu điểm (thêm mới hoặc cập nhật) ────────────────────────────────────
    public boolean saveGrade(int studentId, int subjectId,
                             Float attendance, Float midterm, Float finalExam) {
        // Tính điểm tổng kết: CC*10% + GK*30% + CK*60%
        Float finalScore = null;
        String letterGrade = null;
        Float gpaPoint = null;

        if (attendance != null && midterm != null && finalExam != null) {
            finalScore  = Math.round((attendance * 0.1f + midterm * 0.3f + finalExam * 0.6f) * 100) / 100.0f;
            letterGrade = calcLetterGrade(finalScore);
            gpaPoint    = calcGpa(finalScore);
        }

        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            // INSERT ... ON DUPLICATE KEY UPDATE (upsert)
            PreparedStatement ps = conn.prepareStatement(
                "INSERT INTO grades(student_id,subject_id,attendance,midterm,final_exam," +
                "                   final_score,letter_grade,gpa_point) " +
                "VALUES(?,?,?,?,?,?,?,?) " +
                "ON DUPLICATE KEY UPDATE " +
                "attendance=VALUES(attendance), midterm=VALUES(midterm), " +
                "final_exam=VALUES(final_exam), final_score=VALUES(final_score), " +
                "letter_grade=VALUES(letter_grade), gpa_point=VALUES(gpa_point)");
            ps.setInt(1, studentId);
            ps.setInt(2, subjectId);
            setFloatOrNull(ps, 3, attendance);
            setFloatOrNull(ps, 4, midterm);
            setFloatOrNull(ps, 5, finalExam);
            setFloatOrNull(ps, 6, finalScore);
            if (letterGrade != null) ps.setString(7, letterGrade); else ps.setNull(7, Types.VARCHAR);
            setFloatOrNull(ps, 8, gpaPoint);

            boolean ok = ps.executeUpdate() > 0;
            ps.close(); return ok;
        } catch (SQLException e) {
            e.printStackTrace(); return false;
        } finally { DBConnection.close(conn); }
    }

    public boolean deleteGrade(int studentId, int subjectId) {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(
                "DELETE FROM grades WHERE student_id=? AND subject_id=?");
            ps.setInt(1, studentId);
            ps.setInt(2, subjectId);
            boolean ok = ps.executeUpdate() > 0;
            ps.close(); return ok;
        } catch (SQLException e) {
            e.printStackTrace(); return false;
        } finally { DBConnection.close(conn); }
    }

    // ── Tính GPA tích luỹ của sinh viên ──────────────────────────────────────
    public Float calcCumulativeGpa(int studentId) {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(
                "SELECT SUM(g.gpa_point * s.credits) / SUM(s.credits) AS cum_gpa " +
                "FROM grades g " +
                "JOIN subjects s ON g.subject_id = s.id " +
                "WHERE g.student_id=? AND g.gpa_point IS NOT NULL");
            ps.setInt(1, studentId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                float gpa = rs.getFloat("cum_gpa");
                return rs.wasNull() ? null : Math.round(gpa * 100) / 100.0f;
            }
            rs.close(); ps.close();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally { DBConnection.close(conn); }
        return null;
    }

    // ── Thống kê cho Dashboard ────────────────────────────────────────────────
    public int countPassedStudents() {
        return countByGrade("A") + countByGrade("B") + countByGrade("C");
    }

    public int countByGrade(String grade) {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(
                "SELECT COUNT(DISTINCT student_id) FROM grades WHERE letter_grade=?");
            ps.setString(1, grade);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
            rs.close(); ps.close();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally { DBConnection.close(conn); }
        return 0;
    }

    public List<Grade> getTopStudents(int limit) {
        List<Grade> list = new ArrayList<>();
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(
                "SELECT st.name AS student_name, st.class_name, " +
                "       SUM(g.gpa_point * s.credits) / SUM(s.credits) AS cum_gpa, " +
                "       NULL AS subject_code, NULL AS subject_name, 0 AS credits, " +
                "       0 AS id, st.id AS student_id, 0 AS subject_id " +
                "FROM grades g " +
                "JOIN students st ON g.student_id = st.id " +
                "JOIN subjects s  ON g.subject_id = s.id " +
                "WHERE g.gpa_point IS NOT NULL " +
                "GROUP BY st.id, st.name, st.class_name " +
                "ORDER BY cum_gpa DESC " +
                "LIMIT ?");
            ps.setInt(1, limit);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Grade g = new Grade();
                g.setStudentName(rs.getString("student_name"));
                float gpa = rs.getFloat("cum_gpa");
                g.setGpaPoint(rs.wasNull() ? null : Math.round(gpa * 100) / 100.0f);
                list.add(g);
            }
            rs.close(); ps.close();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally { DBConnection.close(conn); }
        return list;
    }

    // ── Helpers tính điểm ────────────────────────────────────────────────────
    private String calcLetterGrade(float score) {
        if (score >= 9.0) return "A";
        if (score >= 8.0) return "B";
        if (score >= 7.0) return "B";
        if (score >= 6.5) return "C";
        if (score >= 5.5) return "C";
        if (score >= 5.0) return "D";
        return "F";
    }

    private float calcGpa(float score) {
        if (score >= 9.0) return 4.0f;
        if (score >= 8.5) return 3.7f;
        if (score >= 8.0) return 3.5f;
        if (score >= 7.5) return 3.0f;
        if (score >= 7.0) return 2.5f;
        if (score >= 6.5) return 2.3f;
        if (score >= 6.0) return 2.0f;
        if (score >= 5.5) return 1.5f;
        if (score >= 5.0) return 1.0f;
        return 0.0f;
    }

    private void setFloatOrNull(PreparedStatement ps, int idx, Float val) throws SQLException {
        if (val != null) ps.setFloat(idx, val);
        else ps.setNull(idx, Types.FLOAT);
    }

    private Grade mapRow(ResultSet rs) throws SQLException {
        Grade g = new Grade();
        g.setId(rs.getInt("id"));
        g.setStudentId(rs.getInt("student_id"));
        g.setSubjectId(rs.getInt("subject_id"));
        g.setStudentName(rs.getString("student_name"));
        g.setSubjectCode(rs.getString("subject_code"));
        g.setSubjectName(rs.getString("subject_name"));
        g.setCredits(rs.getInt("credits"));

        float att = rs.getFloat("attendance");
        g.setAttendance(rs.wasNull() ? null : att);
        float mid = rs.getFloat("midterm");
        g.setMidterm(rs.wasNull() ? null : mid);
        float fin = rs.getFloat("final_exam");
        g.setFinalExam(rs.wasNull() ? null : fin);
        float fs = rs.getFloat("final_score");
        g.setFinalScore(rs.wasNull() ? null : fs);
        g.setLetterGrade(rs.getString("letter_grade"));
        float gpa = rs.getFloat("gpa_point");
        g.setGpaPoint(rs.wasNull() ? null : gpa);
        return g;
    }
}