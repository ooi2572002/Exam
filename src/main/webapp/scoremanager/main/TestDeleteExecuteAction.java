package scoremanager.main;

import bean.Teacher;
import dao.TestDao;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import tool.Action;

public class TestDeleteExecuteAction extends Action {
    @Override
    public void execute(HttpServletRequest req, HttpServletResponse res) throws Exception {

        HttpSession session = req.getSession();
        Teacher teacher = (Teacher) session.getAttribute("user");

        String studentNo = req.getParameter("student_no");
        String subjectCd = req.getParameter("subject_cd");
        String schoolCd  = teacher.getSchool().getSchoolCd();

        TestDao dao = new TestDao();
        dao.deleteAll(studentNo, subjectCd, schoolCd);

        req.getRequestDispatcher("test_delete_done.jsp").forward(req, res);
    }
}
