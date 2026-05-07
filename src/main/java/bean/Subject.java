package bean;

import java.io.Serializable;

public class Subject implements Serializable {

    private String subjectCd;
    private String subjectName;
    private School school;
    

    public String getSubjectCd() {
        return subjectCd;
    }

    public void setSubjectCd(String subjectCd) {
        this.subjectCd = subjectCd;
    }

    public String getSubjectName() {
        return subjectName;
    }

    public void setSubjectName(String subjectName) {
        this.subjectName = subjectName;
    }

public School getSchool() {
	return school;
}

public void setSchool(School school) {
	this.school = school;
}
}