<%-- 科目別成績一覧 (GRMR002) --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
    import="java.util.*,java.time.*,bean.*,dao.*" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%
    Teacher teacher = (Teacher) session.getAttribute("user");

    int currentYear = LocalDate.now().getYear();
    List<Integer> entYearSet = new ArrayList<>();
    for (int i = currentYear - 10; i <= currentYear; i++) entYearSet.add(i);

    ClassNumDao classNumDao = new ClassNumDao();
    List<String> classNumSet = classNumDao.filter(teacher.getSchool());

    SubjectDao subjectDao = new SubjectDao();
    List<Subject> subjects = subjectDao.filter(teacher.getSchool());

    String entYearStr = request.getParameter("entYear");
    String classNum   = request.getParameter("classNum");
    String subjectCd  = request.getParameter("subjectCd");

    String searchError = null;
    List<TestListSubject> testList = null;
    String subjectName = "";

    if (entYearStr == null || entYearStr.isEmpty() ||
        classNum == null || classNum.isEmpty() ||
        subjectCd == null || subjectCd.isEmpty()) {
        searchError = "入学年度・クラス・科目をすべて選択してください";
    } else {
        int entYear = Integer.parseInt(entYearStr);
        TestListSubjectDao dao = new TestListSubjectDao();
        testList = dao.filter(entYear, classNum, subjectCd);
        if (testList.isEmpty()) {
            searchError = "該当する成績情報が存在しませんでした";
        } else {
            Subject sub = subjectDao.get(teacher.getSchool(), subjectCd);
            if (sub != null) subjectName = sub.getSubjectName();
        }
    }

    pageContext.setAttribute("entYearSet", entYearSet);
    pageContext.setAttribute("classNumSet", classNumSet);
    pageContext.setAttribute("subjectList", subjects);
    pageContext.setAttribute("entYear", entYearStr);
    pageContext.setAttribute("classNum", classNum);
    pageContext.setAttribute("subjectCd", subjectCd);
%>
<c:import url="/common/base.jsp">
    <c:param name="title">得点管理システム</c:param>
    <c:param name="content">
        <section class="me-4">
            <h2 class="h3 mb-3 fw-normal bg-secondary bg-opacity-10 py-2 px-4">科目別成績一覧</h2>

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
                    <% if (searchError != null) { %>
                        <div class="text-danger small mt-1"><%= searchError %></div>
                    <% } %>
                </form>
            </div>

            <% if (testList != null && !testList.isEmpty()) { %>
                <div class="px-3 mb-2 fw-bold">科目名:<%= subjectName %></div>
                
                <table class="table table-hover table-bordered mx-3" style="width:calc(100% - 2rem)">
                    <thead class="table-light">
                        <tr><th>入学年度</th><th>クラス</th><th>学生番号</th><th>氏名</th><th>1回の点数</th><th>2回の点数</th></tr>
                    </thead>
                    <tbody>
                        <% for (TestListSubject t : testList) {
                            Map<Integer,Integer> pts = t.getPoints();
                            Integer p1 = pts.get(1);
                            Integer p2 = pts.get(2);
                        %>
                        <tr>
                            <td><%= t.getEntYear() %></td>
                            <td><%= t.getClassNum() %></td>
                            <td><%= t.getSutudentNo() %></td>
                            <td><%= t.getStudentName() %></td>
                            <td><%= p1 != null ? p1 : "-" %></td>
                            <td><%= p2 != null ? p2 : "-" %></td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            <% } %>

            <div class="px-3 mt-3"><a href="TestList.action">成績参照検索に戻る</a></div>
        </section>
    </c:param>
</c:import>
