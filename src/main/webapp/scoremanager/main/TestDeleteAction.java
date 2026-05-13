package scoremanager.main;

import java.util.List;
import java.util.Map;

import bean.Teacher;
import dao.TestDao;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import tool.Action;

public class TestDeleteAction extends Action {
    @Override
    public void execute(HttpServletRequest req, HttpServletResponse res) throws Exception {

        HttpSession session = req.getSession();
        Teacher teacher = (Teacher) session.getAttribute("user");

        String studentNo = req.getParameter("student_no");
        String subjectCd = req.getParameter("subject_cd");
        String schoolCd  = teacher.getSchool().getSchoolCd();

        TestDao dao = new TestDao();
        List<Map<String, Object>> tests = dao.filterForDelete(studentNo, subjectCd, schoolCd);

        req.setAttribute("tests",      tests);
        req.setAttribute("student_no", studentNo);
        req.setAttribute("subject_cd", subjectCd);
        req.setAttribute("school_cd",  schoolCd);

        req.getRequestDispatcher("test_delete.jsp").forward(req, res);
    }
}
