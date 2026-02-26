package model;

public class Subject {
    private int    id;
    private String subjectCode;
    private String subjectName;
    private int    credits;

    public Subject() {}

    public Subject(int id, String subjectCode, String subjectName, int credits) {
        this.id          = id;
        this.subjectCode = subjectCode;
        this.subjectName = subjectName;
        this.credits     = credits;
    }

    public int    getId()          { return id; }
    public String getSubjectCode() { return subjectCode; }
    public String getSubjectName() { return subjectName; }
    public int    getCredits()     { return credits; }

    public void setId(int id)                   { this.id = id; }
    public void setSubjectCode(String code)     { this.subjectCode = code; }
    public void setSubjectName(String name)     { this.subjectName = name; }
    public void setCredits(int credits)         { this.credits = credits; }
}