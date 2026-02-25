package dao;

import model.User;
import util.DBConnection;
import util.PasswordUtil;

import java.sql.*;

/**
 * DAO xử lý tài khoản đăng nhập từ database
 */
public class UserDAO {

    /**
     * Đăng nhập - kiểm tra username + password (MD5)
     * Trả về User nếu đúng, null nếu sai
     */
    public User login(String username, String password) {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(
                "SELECT * FROM users WHERE username = ?");
            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                String storedHash = rs.getString("password");
                // Kiểm tra mật khẩu
                if (PasswordUtil.verify(password, storedHash)) {
                    return mapRow(rs);
                }
            }
            rs.close();
            ps.close();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(conn);
        }
        return null; // Sai thông tin
    }

    /**
     * Lấy user theo username
     */
    public User findByUsername(String username) {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(
                "SELECT * FROM users WHERE username = ?");
            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapRow(rs);
            rs.close();
            ps.close();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(conn);
        }
        return null;
    }

    private User mapRow(ResultSet rs) throws SQLException {
        return new User(
            rs.getInt("id"),
            rs.getString("username"),
            rs.getString("password"),
            rs.getString("full_name"),
            rs.getString("role")
        );
    }
}