package scoremanager.main;

import bean.Teacher;
import dao.SubjectDao;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import tool.Action;


public class SubjectDeleteExecuteAction extends Action{
	@Override
	public void execute(HttpServletRequest req, HttpServletResponse res) throws Exception {

    HttpSession session = req.getSession();
    Teacher teacher = (Teacher) session.getAttribute("user");

    String subjectCd = req.getParameter("subject_cd");

    SubjectDao dao = new SubjectDao();

    // ★ DAO の定義に合わせて順番を修正
    dao.delete(teacher.getSchool(), subjectCd);

    req.getRequestDispatcher("subject_delete_done.jsp").forward(req, res);
	}
}