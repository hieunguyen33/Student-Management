package model;

public class Grade {
    private int    id;
    private int    studentId;
    private int    subjectId;
    private String studentName;   // JOIN từ students
    private String subjectCode;   // JOIN từ subjects
    private String subjectName;   // JOIN từ subjects
    private int    credits;       // JOIN từ subjects
    private Float  attendance;    // Chuyên cần  (hệ số 1)
    private Float  midterm;       // Giữa kỳ     (hệ số 2)
    private Float  finalExam;     // Cuối kỳ     (hệ số 3)
    private Float  finalScore;    // Tổng kết    (tự tính)
    private String letterGrade;   // A B C D F
    private Float  gpaPoint;      // 0.0 - 4.0

    public Grade() {}

    // ── Getters ──────────────────────────────────────────────────────────────
    public int    getId()          { return id; }
    public int    getStudentId()   { return studentId; }
    public int    getSubjectId()   { return subjectId; }
    public String getStudentName() { return studentName; }
    public String getSubjectCode() { return subjectCode; }
    public String getSubjectName() { return subjectName; }
    public int    getCredits()     { return credits; }
    public Float  getAttendance()  { return attendance; }
    public Float  getMidterm()     { return midterm; }
    public Float  getFinalExam()   { return finalExam; }
    public Float  getFinalScore()  { return finalScore; }
    public String getLetterGrade() { return letterGrade; }
    public Float  getGpaPoint()    { return gpaPoint; }

    // ── Setters ──────────────────────────────────────────────────────────────
    public void setId(int id)                   { this.id = id; }
    public void setStudentId(int studentId)     { this.studentId = studentId; }
    public void setSubjectId(int subjectId)     { this.subjectId = subjectId; }
    public void setStudentName(String name)     { this.studentName = name; }
    public void setSubjectCode(String code)     { this.subjectCode = code; }
    public void setSubjectName(String name)     { this.subjectName = name; }
    public void setCredits(int credits)         { this.credits = credits; }
    public void setAttendance(Float attendance) { this.attendance = attendance; }
    public void setMidterm(Float midterm)       { this.midterm = midterm; }
    public void setFinalExam(Float finalExam)   { this.finalExam = finalExam; }
    public void setFinalScore(Float finalScore) { this.finalScore = finalScore; }
    public void setLetterGrade(String lg)       { this.letterGrade = lg; }
    public void setGpaPoint(Float gpaPoint)     { this.gpaPoint = gpaPoint; }

    // ── Helper: màu badge theo xếp loại ──────────────────────────────────────
    public String getGradeBadgeColor() {
        if (letterGrade == null) return "secondary";
        switch (letterGrade) {
            case "A":  return "success";
            case "B":  return "primary";
            case "C":  return "warning";
            case "D":  return "orange";
            default:   return "danger";
        }
    }

    // ── Helper: tên xếp loại ─────────────────────────────────────────────────
    public String getRankName() {
        if (finalScore == null) return "Chưa có điểm";
        if (finalScore >= 9.0) return "Xuất sắc";
        if (finalScore >= 8.0) return "Giỏi";
        if (finalScore >= 7.0) return "Khá";
        if (finalScore >= 5.0) return "Trung bình";
        return "Yếu/Kém";
    }
}