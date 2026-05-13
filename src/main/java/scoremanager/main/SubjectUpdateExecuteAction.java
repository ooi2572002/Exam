package scoremanager.main;

import bean.Subject;
import bean.Teacher;
import dao.SubjectDao;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import tool.Action;

public class SubjectUpdateExecuteAction extends Action {

    @Override
    public void execute(HttpServletRequest req, HttpServletResponse res) throws Exception {

        HttpSession session = req.getSession();
        Teacher teacher = (Teacher) session.getAttribute("user");

        String subjectCd   = req.getParameter("subject_cd");
        String subjectName = req.getParameter("subject_name");

        if (subjectName == null || subjectName.trim().isEmpty()) {
            req.getRequestDispatcher("subject_update.jsp").forward(req, res);
            return;
        }

        SubjectDao subjectDao = new SubjectDao();
        Subject existing = subjectDao.get(teacher.getSchool(), subjectCd);
        if (existing == null) {
            req.getRequestDispatcher("subject_update.jsp").forward(req, res);
            return;
        }

        Subject subject = new Subject();
        subject.setSubjectCd(subjectCd);
        subject.setSubjectName(subjectName.trim());
        subject.setSchool(teacher.getSchool());
        subjectDao.save(subject);

        req.getRequestDispatcher("subject_update_done.jsp").forward(req, res);
    }
}
