package scoremanager.main;


import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

import bean.Student;
import bean.Teacher;
import dao.ClassNumDao;
import dao.StudentDao;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import tool.Action;

public class StudentUpdateAction extends Action {

    @Override
    public void execute(HttpServletRequest req, HttpServletResponse res) throws Exception {

        HttpSession session = req.getSession();
        Teacher teacher = (Teacher)session.getAttribute("user");

        // ▼ 学生番号取得
        String studentNo = req.getParameter("student_No");

        // ▼ 学生情報取得
        StudentDao studentDao = new StudentDao();
        Student student = studentDao.get(studentNo);

        // ▼ クラス番号セット（create と同じ）
        ClassNumDao classNumDao = new ClassNumDao();
        List<String> classNumList = classNumDao.filter(teacher.getSchool());

        // ▼ 入学年度セット（create と同じ）
        LocalDate todaysDate = LocalDate.now();
        int year = todaysDate.getYear();

        List<Integer> entYearSet = new ArrayList<>();
        for (int i = year - 10; i < year + 11; i++) {
            entYearSet.add(i);
        }

        // ▼ JSP に渡す
        req.setAttribute("student", student);
        req.setAttribute("class_num_set", classNumList);
        req.setAttribute("ent_year_set", entYearSet);


        req.getRequestDispatcher("student_update.jsp").forward(req, res);
    }
}