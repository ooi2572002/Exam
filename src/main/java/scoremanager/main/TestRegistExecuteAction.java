package scoremanager.main;

import java.util.List;
import java.util.Map;

import bean.Subject;
import bean.Teacher;
import dao.SubjectDao;
import dao.TestDao;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import tool.Action;

public class TestRegistExecuteAction extends Action {

    @Override
    public void execute(HttpServletRequest req, HttpServletResponse res) throws Exception {

        HttpSession session = req.getSession();
        Teacher teacher = (Teacher) session.getAttribute("user");
        String schoolCd = teacher.getSchool().getSchoolCd();

        // TestRegistExecuteAction は test_regist.jsp にforwardするだけ
        // ロジックはすべてJSP側のスクリプトレットで処理する
        req.getRequestDispatcher("test_regist.jsp").forward(req, res);
    }
}
