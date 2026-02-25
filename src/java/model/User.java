package model;

/**
 * Model cho tài khoản đăng nhập
 */
public class User {

    private int    id;
    private String username;
    private String password;  // MD5 hash
    private String fullName;
    private String role;      // "admin" hoặc "user"

    public User() {}

    public User(int id, String username, String password,
                String fullName, String role) {
        this.id       = id;
        this.username = username;
        this.password = password;
        this.fullName = fullName;
        this.role     = role;
    }

    // ── Getters & Setters ─────────────────────────────────────────────────────
    public int    getId()       { return id; }
    public String getUsername() { return username; }
    public String getPassword() { return password; }
    public String getFullName() { return fullName; }
    public String getRole()     { return role; }

    public void setId(int id)             { this.id = id; }
    public void setUsername(String u)     { this.username = u; }
    public void setPassword(String p)     { this.password = p; }
    public void setFullName(String fn)    { this.fullName = fn; }
    public void setRole(String role)      { this.role = role; }

    public boolean isAdmin() { return "admin".equals(role); }
}