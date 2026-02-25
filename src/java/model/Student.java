package model;

/**
 * Student Model - cập nhật thêm: ngày sinh, giới tính, lớp học
 */
public class Student {

    private int    id;
    private String name;
    private String email;
    private String dob;        // Ngày sinh (yyyy-MM-dd)
    private String gender;     // Nam / Nữ / Khác
    private String className;  // Lớp học
    private String phone;
    private String address;

    public Student() {}

    public Student(int id, String name, String email, String dob,
                   String gender, String className,
                   String phone, String address) {
        this.id        = id;
        this.name      = name;
        this.email     = email;
        this.dob       = dob;
        this.gender    = gender;
        this.className = className;
        this.phone     = phone;
        this.address   = address;
    }

    // ── Getters & Setters ─────────────────────────────────────────────────────
    public int    getId()        { return id; }
    public String getName()      { return name; }
    public String getEmail()     { return email; }
    public String getDob()       { return dob; }
    public String getGender()    { return gender; }
    public String getClassName() { return className; }
    public String getPhone()     { return phone; }
    public String getAddress()   { return address; }

    public void setId(int id)              { this.id = id; }
    public void setName(String name)       { this.name = name; }
    public void setEmail(String email)     { this.email = email; }
    public void setDob(String dob)         { this.dob = dob; }
    public void setGender(String gender)   { this.gender = gender; }
    public void setClassName(String cn)    { this.className = cn; }
    public void setPhone(String phone)     { this.phone = phone; }
    public void setAddress(String address) { this.address = address; }
}