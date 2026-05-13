package scoremanager.main;

import bean.Student;
import bean.Teacher;
import dao.StudentDao;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import tool.Action;

public class StudentUpdateExecuteAction extends Action {

    @Override
    public void execute(HttpServletRequest req, HttpServletResponse res) throws Exception {

        HttpSession session = req.getSession();
        Teacher teacher = (Teacher) session.getAttribute("user");

        String student_no   = req.getParameter("no");
        String student_name = req.getParameter("name");
        int ent_year        = Integer.parseInt(req.getParameter("ent_year"));
        String class_num    = req.getParameter("class_num");
        boolean isAttend    = Boolean.parseBoolean(req.getParameter("isAttend"));

        // 入力保持用 Student
        Student student = new Student();
        student.setStudentNo(student_no);
        student.setStudentName(student_name);
        student.setEntYear(ent_year);
        student.setClassNum(class_num);
        student.setAttend(isAttend);
        student.setSchool(teacher.getSchool());

        // 氏名未入力エラー
        if (student_name == null || student_name.isEmpty()) {
            req.setAttribute("error", "このフィールドを入力して下さい");
            req.setAttribute("student", student);
            req.getRequestDispatcher("student_update.jsp").forward(req, res);
            return;
        }

        // 更新処理
        StudentDao dao = new StudentDao();
        dao.update(student);

        req.getRequestDispatcher("student_update_done.jsp").forward(req, res);
    }
}
