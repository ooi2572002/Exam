<%-- 科目変更 (SBJM004) --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
    import="bean.*,dao.*" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    Teacher teacher = (Teacher) session.getAttribute("user");

    String subjectCd   = request.getParameter("subject_cd");
    String subjectName = request.getParameter("subject_name");
    String action      = request.getParameter("action");
    String errorMsg    = null;
    String notFoundMsg = null;

    if ("update".equals(action)) {
        if (subjectName == null || subjectName.trim().isEmpty()) {
            errorMsg = "科目名を入力してください";
        } else {
            SubjectDao dao = new SubjectDao();
            Subject existing = dao.get(teacher.getSchool(), subjectCd);
            if (existing == null) {
                notFoundMsg = "科目が存在しません";
            } else {
                Subject subject = new Subject();
                subject.setSubjectCd(subjectCd);
                subject.setSubjectName(subjectName.trim());
                subject.setSchool(teacher.getSchool());
                dao.save(subject);
                response.sendRedirect("subject_update_done.jsp");
                return;
            }
        }
    }

    if (subjectName == null && subjectCd != null) {
        SubjectDao dao = new SubjectDao();
        Subject sub = dao.get(teacher.getSchool(), subjectCd);
        if (sub != null) subjectName = sub.getSubjectName();
    }
%>
<c:import url="/common/base.jsp">
    <c:param name="title">得点管理システム</c:param>
    <c:param name="content">
        <section class="me-4">
            <h2 class="h3 mb-3 fw-normal bg-secondary bg-opacity-10 py-2 px-4">科目情報変更</h2>

            <form action="SubjectUpdate.action" method="get" class="px-4">
                <input type="hidden" name="action" value="update">

                <div class="mb-3">
                    <label class="form-label">科目コード</label>
                    <input class="form-control" type="text"
                           value="<%= subjectCd != null ? subjectCd : "" %>"
                           readonly disabled>
                    <input type="hidden" name="subject_cd" value="<%= subjectCd != null ? subjectCd : "" %>">
                </div>

                <% if (notFoundMsg != null) { %>
                    <div class="text-danger small mb-2"><%= notFoundMsg %></div>
                <% } %>

                <div class="mb-1">
                    <label class="form-label">科目名</label>
                    <input class="form-control" type="text" name="subject_name"
                           value="<%= subjectName != null ? subjectName : "" %>"
                           maxlength="20" placeholder="科目名を入力してください" required>
                </div>

                <% if (errorMsg != null) { %>
                    <div class="text-danger small mb-2"><%= errorMsg %></div>
                <% } %>

                <div class="mb-2 mt-3">
                    <button type="submit" class="btn btn-primary">変更</button>
                </div>
                <a href="SubjectList.action">戻る</a>

            </form>
        </section>
    </c:param>
</c:import>
