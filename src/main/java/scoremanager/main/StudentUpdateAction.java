package scoremanager.main;

import bean.Student;
import dao.StudentDao;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import tool.Action;

public class StudentUpdateAction extends Action {

    @Override
    public void execute(HttpServletRequest req, HttpServletResponse res) throws Exception {

        String student_no = req.getParameter("student_No");

        StudentDao dao = new StudentDao();
        Student student = dao.get(student_no);   // ← これが超重要

        req.setAttribute("student", student);

        req.getRequestDispatcher("student_update.jsp").forward(req, res);
    }
}