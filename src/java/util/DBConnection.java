package util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * Utility class for creating JDBC connections to MySQL
 */
public class DBConnection {

    // ── Connection constants – change to match your environment ──────────────
    private static final String DRIVER   = "com.mysql.cj.jdbc.Driver";
    private static final String URL = "jdbc:mysql://localhost:3306/student_db" +
        "?useSSL=false&useUnicode=true&characterEncoding=UTF-8";
                                         
    private static final String USERNAME = "root";
    private static final String PASSWORD = "";   // ← set your MySQL password here

    // ── Static initializer – load driver once ────────────────────────────────
    static {
        try {
            Class.forName(DRIVER);
        } catch (ClassNotFoundException e) {
            System.err.println("[DBConnection] Driver not found: " + e.getMessage());
            throw new ExceptionInInitializerError(e);
        }
    }

    /**
     * Returns a new Connection. Caller is responsible for closing it.
     */
    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USERNAME, PASSWORD);
    }

    /**
     * Quietly closes a connection (null-safe).
     */
    public static void close(Connection conn) {
        if (conn != null) {
            try {
                conn.close();
            } catch (SQLException e) {
                System.err.println("[DBConnection] Error closing connection: " + e.getMessage());
            }
        }
    }
}