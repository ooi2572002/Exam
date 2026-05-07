package scoremanager.main;

import bean.Subject;
import bean.Teacher;
import dao.SubjectDao;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import tool.Action;

public class SubjectDeleteAction extends Action {
    @Override
    public void execute(HttpServletRequest req, HttpServletResponse res) throws Exception {

        HttpSession session = req.getSession();
        Teacher teacher = (Teacher) session.getAttribute("user");

        String subjectCd = req.getParameter("subject_cd");

        SubjectDao subjectDao = new SubjectDao();

        // ★ 引数の順番を DAO に合わせて修正
        Subject subject = subjectDao.get(teacher.getSchool(), subjectCd);

        req.setAttribute("subject", subject);

        req.getRequestDispatcher("subject_delete.jsp").forward(req, res);
    }
}