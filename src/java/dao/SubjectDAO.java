package dao;

import model.Subject;
import util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class SubjectDAO {

    public List<Subject> getAllSubjects() {
        List<Subject> list = new ArrayList<>();
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(
                "SELECT * FROM subjects ORDER BY subject_code");
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
            rs.close(); ps.close();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally { DBConnection.close(conn); }
        return list;
    }

    public Subject getSubjectById(int id) {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(
                "SELECT * FROM subjects WHERE id=?");
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapRow(rs);
            rs.close(); ps.close();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally { DBConnection.close(conn); }
        return null;
    }

    public boolean addSubject(Subject s) {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(
                "INSERT INTO subjects(subject_code,subject_name,credits) VALUES(?,?,?)");
            ps.setString(1, s.getSubjectCode());
            ps.setString(2, s.getSubjectName());
            ps.setInt(3, s.getCredits());
            boolean ok = ps.executeUpdate() > 0;
            ps.close(); return ok;
        } catch (SQLException e) {
            e.printStackTrace(); return false;
        } finally { DBConnection.close(conn); }
    }

    public boolean updateSubject(Subject s) {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(
                "UPDATE subjects SET subject_code=?,subject_name=?,credits=? WHERE id=?");
            ps.setString(1, s.getSubjectCode());
            ps.setString(2, s.getSubjectName());
            ps.setInt(3, s.getCredits());
            ps.setInt(4, s.getId());
            boolean ok = ps.executeUpdate() > 0;
            ps.close(); return ok;
        } catch (SQLException e) {
            e.printStackTrace(); return false;
        } finally { DBConnection.close(conn); }
    }

    public boolean deleteSubject(int id) {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(
                "DELETE FROM subjects WHERE id=?");
            ps.setInt(1, id);
            boolean ok = ps.executeUpdate() > 0;
            ps.close(); return ok;
        } catch (SQLException e) {
            e.printStackTrace(); return false;
        } finally { DBConnection.close(conn); }
    }

    public boolean isCodeTaken(String code, int excludeId) {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(
                "SELECT COUNT(*) FROM subjects WHERE subject_code=? AND id<>?");
            ps.setString(1, code);
            ps.setInt(2, excludeId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1) > 0;
            rs.close(); ps.close();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally { DBConnection.close(conn); }
        return false;
    }

    private Subject mapRow(ResultSet rs) throws SQLException {
        return new Subject(
            rs.getInt("id"),
            rs.getString("subject_code"),
            rs.getString("subject_name"),
            rs.getInt("credits")
        );
    }
}