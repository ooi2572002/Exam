package scoremanager.main;

import bean.Subject;
import bean.Teacher;
import dao.SubjectDao;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import tool.Action;

public class SubjectUpdateAction extends Action {

    @Override
    public void execute(HttpServletRequest req, HttpServletResponse res) throws Exception {

        HttpSession session = req.getSession();
        Teacher teacher = (Teacher) session.getAttribute("user");

        String subjectCd = req.getParameter("subject_cd");

        SubjectDao subjectDao = new SubjectDao();
        Subject subject = subjectDao.get(teacher.getSchool(), subjectCd);

        req.setAttribute("subject", subject);

        req.getRequestDispatcher("subject_update.jsp").forward(req, res);
    }
}
