<%-- 科目別成績一覧 (GRMR002) --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
    import="java.util.*,java.time.*,bean.*,dao.*" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    Teacher teacher = (Teacher) session.getAttribute("user");
    String schoolCd = teacher.getSchool().getSchoolCd();

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

    if (entYearStr != null && !entYearStr.isEmpty() &&
        classNum   != null && !classNum.isEmpty() &&
        subjectCd  != null && !subjectCd.isEmpty()) {
        int entYear = Integer.parseInt(entYearStr);
        TestListSubjectDao dao = new TestListSubjectDao();
        testList = dao.filter(entYear, classNum, subjectCd);
        if (testList == null || testList.isEmpty()) {
            searchError = "学生情報が存在しませんでした";
            testList = null;
        } else {
            Subject sub = subjectDao.get(teacher.getSchool(), subjectCd);
            if (sub != null) subjectName = sub.getSubjectName();
        }
    }

    // 学生情報検索
    String studentNo = request.getParameter("studentNo");
    String studentError = null;
    List<TestListStudent> studentTestList = null;
    String studentName = "";

    // 学生番号フォームが送信されたか判定（hidden で entYear 等が来ない場合を考慮）
    boolean studentSearched = request.getParameter("studentSearched") != null;

    if (studentSearched) {
        if (studentNo == null || studentNo.trim().isEmpty()) {
            studentError = "学生番号を入力してください";
        } else {
            studentNo = studentNo.trim();
            TestListStudentDao studentDao = new TestListStudentDao();
            studentTestList = studentDao.filter(studentNo);
            studentName = studentDao.getStudentName(studentNo);
            if (studentTestList == null || studentTestList.isEmpty()) {
                studentError = "成績情報が存在しませんでした";
                studentTestList = null;
            }
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
            <h2 class="h3 mb-3 fw-normal bg-secondary bg-opacity-10 py-2 px-4">成績一覧（科目）</h2>

            <div class="border mx-3 mb-3 p-3 rounded">
                <%-- 科目情報 --%>
                <form method="get" action="TestListSubjectExecute.action">
                    <div class="row mb-2 align-items-end">
                        <div class="col-2 d-flex align-items-center">
                            <span class="fw-bold">科目情報</span>
                        </div>
                        <div class="col-2">
                            <label class="form-label mb-1">入学年度</label>
                            <select class="form-select form-select-sm" name="entYear">
                                <option value="">--------</option>
                                <c:forEach var="y" items="${entYearSet}">
                                    <option value="${y}" <c:if test="${y == entYear}">selected</c:if>>${y}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-2">
                            <label class="form-label mb-1">クラス</label>
                            <select class="form-select form-select-sm" name="classNum">
                                <option value="">--------</option>
                                <c:forEach var="cn" items="${classNumSet}">
                                    <option value="${cn}" <c:if test="${cn == classNum}">selected</c:if>>${cn}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-4">
                            <label class="form-label mb-1">科目</label>
                            <select class="form-select form-select-sm" name="subjectCd">
                                <option value="">--------</option>
                                <c:forEach var="s" items="${subjectList}">
                                    <option value="${s.subjectCd}" <c:if test="${s.subjectCd == subjectCd}">selected</c:if>>${s.subjectName}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-2">
                            <button class="btn btn-secondary btn-sm px-3">検索</button>
                        </div>
                    </div>
                </form>

                <hr class="my-2">

                <%-- 学生情報 --%>
                <form method="get" action="TestListSubjectExecute.action">
                    <input type="hidden" name="entYear"        value="<%= entYearStr != null ? entYearStr : "" %>">
                    <input type="hidden" name="classNum"       value="<%= classNum != null ? classNum : "" %>">
                    <input type="hidden" name="subjectCd"      value="<%= subjectCd != null ? subjectCd : "" %>">
                    <input type="hidden" name="studentSearched" value="1">
                    <div class="row align-items-end">
                        <div class="col-2 d-flex align-items-center">
                            <span class="fw-bold">学生情報</span>
                        </div>
                        <div class="col-4">
                            <label class="form-label mb-1">学生番号</label>
                            <input type="text" class="form-control form-control-sm" name="studentNo"
                                   value="<%= studentNo != null ? studentNo : "" %>"
                                   maxlength="10" placeholder="学生番号を入力してください">
                        </div>
                        <div class="col-2">
                            <button class="btn btn-secondary btn-sm px-3">検索</button>
                        </div>
                    </div>
                </form>
            </div>

            <%-- 科目検索エラー・結果 --%>
            <% if (searchError != null) { %>
                <div class="px-3 mb-3 text-danger small"><%= searchError %></div>
            <% } %>
            <% if (testList != null) { %>
                <div class="px-3 mb-1">科目：<strong><%= subjectName %></strong></div>
                <table class="table table-hover table-bordered mx-3 mb-4" style="width:calc(100% - 2rem)">
                    <thead class="table-light">
                        <tr><th>入学年度</th><th>クラス</th><th>学生番号</th><th>氏名</th><th>1回</th><th>2回</th><th></th></tr>
                    </thead>
                    <tbody>
                        <% for (TestListSubject t : testList) {
                            Map<Integer,Integer> pts = t.getPoints();
                            Integer p1 = pts.get(1);
                            Integer p2 = pts.get(2);
                            String encSno = java.net.URLEncoder.encode(t.getSutudentNo(), "UTF-8");
                            String encScd = java.net.URLEncoder.encode(subjectCd != null ? subjectCd : "", "UTF-8");
                        %>
                        <tr>
                            <td><%= t.getEntYear() %></td>
                            <td><%= t.getClassNum() %></td>
                            <td><%= t.getSutudentNo() %></td>
                            <td><%= t.getStudentName() %></td>
                            <td><%= p1 != null ? p1 : "-" %></td>
                            <td><%= p2 != null ? p2 : "-" %></td>
                            <td>
                                <% if (p1 != null || p2 != null) { %>
                                    <a href="TestDelete.action?student_no=<%= encSno %>&subject_cd=<%= encScd %>"
                                       class="btn btn-danger btn-sm">削除</a>
                                <% } %>
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            <% } %>

            <%-- 学生検索エラー・結果 --%>
            <% if (studentSearched) { %>
                <% if (studentName != null && !studentName.isEmpty()) { %>
                    <div class="px-3 mb-1">氏名：<strong><%= studentName %>（<%= studentNo %>）</strong></div>
                <% } %>
                <% if (studentError != null) { %>
                    <div class="px-3 mb-3 text-danger small"><%= studentError %></div>
                <% } %>
            <% } %>
            <% if (studentTestList != null) { %>
                <table class="table table-hover table-bordered mx-3 mb-4" style="width:calc(100% - 2rem)">
                    <thead class="table-light">
                        <tr><th>科目名</th><th>科目コード</th><th>回数</th><th>点数</th><th></th></tr>
                    </thead>
                    <tbody>
                        <% for (TestListStudent ts : studentTestList) {
                            String encSno = java.net.URLEncoder.encode(studentNo, "UTF-8");
                            String encScd = java.net.URLEncoder.encode(ts.getSubjectCd(), "UTF-8");
                        %>
                        <tr>
                            <td><%= ts.getSubjectName() %></td>
                            <td><%= ts.getSubjectCd() %></td>
                            <td><%= ts.getNum() %>回</td>
                            <td><%= ts.getPoint() %></td>
                            <td>
                                <a href="TestDelete.action?student_no=<%= encSno %>&subject_cd=<%= encScd %>"
                                   class="btn btn-danger btn-sm">削除</a>
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            <% } %>

        </section>
    </c:param>
</c:import>
