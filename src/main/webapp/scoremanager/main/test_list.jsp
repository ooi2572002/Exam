<%-- 成績参照検索 (GRMR001) --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
    import="java.util.*,java.time.*,bean.*,dao.*" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    Teacher teacher = (Teacher) session.getAttribute("user");

    int currentYear = LocalDate.now().getYear();
    List<Integer> entYearSet = new ArrayList<>();
    for (int i = currentYear - 10; i <= currentYear; i++) entYearSet.add(i);

    ClassNumDao classNumDao = new ClassNumDao();
    List<String> classNumSet = classNumDao.filter(teacher.getSchool());

    SubjectDao subjectDao = new SubjectDao();
    List<Subject> subjects = subjectDao.filter(teacher.getSchool());

    pageContext.setAttribute("entYearSet", entYearSet);
    pageContext.setAttribute("classNumSet", classNumSet);
    pageContext.setAttribute("subjectList", subjects);
    pageContext.setAttribute("entYear", request.getParameter("entYear"));
    pageContext.setAttribute("classNum", request.getParameter("classNum"));
    pageContext.setAttribute("subjectCd", request.getParameter("subjectCd"));
    pageContext.setAttribute("studentNo", request.getParameter("studentNo"));
%>
<c:import url="/common/base.jsp">
    <c:param name="title">得点管理システム</c:param>
    <c:param name="content">
        <section class="me-4">
            <h2 class="h3 mb-3 fw-normal bg-secondary bg-opacity-10 py-2 px-4">成績参照</h2>

            <div class="border mx-3 mb-3 p-3 rounded">
                <p class="fw-bold mb-2">科目情報</p>
                <form method="get" action="TestListSubjectExecute.action">
                    <div class="row mb-2 align-items-end">
                        <div class="col-3">
                            <label class="form-label">入学年度</label>
                            <select class="form-select" name="entYear">
                                <option value="">--------</option>
                                <c:forEach var="y" items="${entYearSet}">
                                    <option value="${y}" <c:if test="${y == entYear}">selected</c:if>>${y}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-3">
                            <label class="form-label">クラス</label>
                            <select class="form-select" name="classNum">
                                <option value="">--------</option>
                                <c:forEach var="cn" items="${classNumSet}">
                                    <option value="${cn}" <c:if test="${cn == classNum}">selected</c:if>>${cn}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-4">
                            <label class="form-label">科目</label>
                            <select class="form-select" name="subjectCd">
                                <option value="">--------</option>
                                <c:forEach var="s" items="${subjectList}">
                                    <option value="${s.subjectCd}" <c:if test="${s.subjectCd == subjectCd}">selected</c:if>>${s.subjectName}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-2">
                            <button class="btn btn-secondary w-100">検索</button>
                        </div>
                    </div>
                </form>
            </div>

            <div class="border mx-3 mb-3 p-3 rounded">
                <p class="fw-bold mb-2">学生情報</p>
                <form method="get" action="TestListStudentExecute.action">
                    <div class="row align-items-end">
                        <div class="col-4">
                            <label class="form-label">学生番号</label>
                            <input type="text" class="form-control" name="studentNo"
                                   value="${studentNo}" maxlength="10"
                                   placeholder="学生番号を入力してください">
                        </div>
                        <div class="col-2">
                            <button class="btn btn-secondary w-100">検索</button>
                        </div>
                    </div>
                </form>
            </div>

            <div class="px-3 text-muted small">
                ※ 科目情報または学生番号のいずれかで検索してください。
            </div>
        </section>
    </c:param>
</c:import>
