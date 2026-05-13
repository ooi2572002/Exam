<%-- 学生変更完了 (STDM005) --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
    import="bean.*,dao.*" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    Teacher teacher = (Teacher) session.getAttribute("user");

    String studentNo   = request.getParameter("no");
    String studentName = request.getParameter("name");
    String entYearStr  = request.getParameter("ent_year");
    String classNum    = request.getParameter("class_num");
    String isAttendStr = request.getParameter("isAttend");

    // 氏名未入力エラー → 変更画面に戻る
    if (studentName == null || studentName.trim().isEmpty()) {
        response.sendRedirect("StudentUpdate.action?student_No=" + studentNo);
        return;
    }

    Student student = new Student();
    student.setStudentNo(studentNo);
    student.setStudentName(studentName.trim());
    student.setEntYear(entYearStr != null ? Integer.parseInt(entYearStr) : 0);
    student.setClassNum(classNum);
    student.setAttend("true".equals(isAttendStr));
    student.setSchool(teacher.getSchool());

    StudentDao dao = new StudentDao();
    dao.update(student);
%>
<c:import url="/common/base.jsp">
    <c:param name="title">得点管理システム</c:param>
    <c:param name="content">
        <section class="me-4">
            <h2 class="h3 mb-3 fw-normal bg-secondary bg-opacity-10 py-2 px-4">学生情報変更</h2>
            <div class="px-4 py-3">
                <div class="alert alert-success py-2 mb-3 text-center">変更が完了しました</div>
                <a href="StudentList.action">学生一覧</a>
            </div>
        </section>
    </c:param>
</c:import>
