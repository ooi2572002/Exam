<%-- 学生別成績一覧 (GRMR003) --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
    import="java.util.*,bean.*,dao.*" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%
    Teacher teacher = (Teacher) session.getAttribute("user");

    String studentNo = request.getParameter("studentNo");

    String studentError = null;
    List<TestListStudent> testList = null;
    String studentName = "";

    if (studentNo == null || studentNo.trim().isEmpty()) {
        studentError = "学生番号を入力してください";
    } else {
        studentNo = studentNo.trim();
        TestListStudentDao dao = new TestListStudentDao();
        testList = dao.filter(studentNo);
        studentName = dao.getStudentName(studentNo);
        if (testList == null || testList.isEmpty()) {
            studentError = "該当する成績情報が存在しませんでした";
        }
    }

    pageContext.setAttribute("studentNo", studentNo);
    pageContext.setAttribute("studentName", studentName);
    pageContext.setAttribute("studentError", studentError);
    pageContext.setAttribute("testList", testList);
%>
<c:import url="/common/base.jsp">
    <c:param name="title">得点管理システム</c:param>
    <c:param name="content">
        <section class="me-4">
            <h2 class="h3 mb-3 fw-normal bg-secondary bg-opacity-10 py-2 px-4">学生別成績一覧</h2>

            <div class="border mx-3 mb-3 p-3 rounded">
                <p class="fw-bold mb-2">学生情報</p>
                <form method="get" action="TestListStudentExecute.action">
                    <div class="row align-items-end">
                        <div class="col-4">
                            <label class="form-label">学生番号</label>
                            <input type="text" class="form-control" name="studentNo"
                                   value="${fn:escapeXml(studentNo)}" maxlength="10"
                                   placeholder="学生番号を入力してください">
                        </div>
                        <div class="col-2">
                            <button class="btn btn-secondary w-100">検索</button>
                        </div>
                    </div>
                </form>
            </div>

            <c:if test="${not empty studentName}">
                <div class="px-3 mb-2">氏名：${studentName}（${studentNo}）</div>
            </c:if>

            <c:choose>
                <c:when test="${not empty studentError}">
                    <div class="px-3 text-danger">${studentError}</div>
                </c:when>
                <c:when test="${not empty testList}">
                    <div class="px-3 mb-2">検索結果：${fn:length(testList)}件</div>
                    <table class="table table-hover table-bordered mx-3" style="width:calc(100% - 2rem)">
                        <thead class="table-light">
                            <tr><th>科目名</th><th>科目コード</th><th>回数</th><th>点数</th></tr>
                        </thead>
                        <tbody>
                            <c:forEach var="t" items="${testList}">
                                <tr>
                                    <td>${t.subjectName}</td>
                                    <td>${t.subjectCd}</td>
                                    <td>${t.num}</td>
                                    <td>${t.point}</td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:when>
            </c:choose>

            <div class="px-3 mt-3"><a href="TestList.action">成績参照検索に戻る</a></div>
        </section>
    </c:param>
</c:import>
