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

    String entYear   = request.getParameter("entYear");
    String classNum  = request.getParameter("classNum");
    String subjectCd = request.getParameter("subjectCd");
    String studentNo = request.getParameter("studentNo");
    String subjectError = null;
    String studentError = null;

    boolean subjectSearched = request.getParameter("subjectSearch") != null;
    boolean studentSearched = request.getParameter("studentSearch") != null;

    if (subjectSearched) {
        if (entYear == null || entYear.isEmpty() ||
            classNum == null || classNum.isEmpty() ||
            subjectCd == null || subjectCd.isEmpty()) {
            subjectError = "入学年度とクラスと科目を選択してください";
        } else {
            String params = "entYear=" + java.net.URLEncoder.encode(entYear, "UTF-8")
                          + "&classNum=" + java.net.URLEncoder.encode(classNum, "UTF-8")
                          + "&subjectCd=" + java.net.URLEncoder.encode(subjectCd, "UTF-8");
            response.sendRedirect("TestListSubjectExecute.action?" + params);
            return;
        }
    }

    if (studentSearched) {
        if (studentNo == null || studentNo.trim().isEmpty()) {
            studentError = "学生番号を入力してください";
        } else {
            String params = "studentNo=" + java.net.URLEncoder.encode(studentNo.trim(), "UTF-8")
                          + "&studentSearched=1";
            response.sendRedirect("TestListStudentExecute.action?" + params);
            return;
        }
    }

    pageContext.setAttribute("entYearSet", entYearSet);
    pageContext.setAttribute("classNumSet", classNumSet);
    pageContext.setAttribute("subjectList", subjects);
    pageContext.setAttribute("entYear", entYear);
    pageContext.setAttribute("classNum", classNum);
    pageContext.setAttribute("subjectCd", subjectCd);
    pageContext.setAttribute("studentNo", studentNo);
    pageContext.setAttribute("subjectError", subjectError);
    pageContext.setAttribute("studentError", studentError);
%>
<c:import url="/common/base.jsp">
    <c:param name="title">得点管理システム</c:param>
    <c:param name="content">
        <section class="me-4">
            <h2 class="h3 mb-3 fw-normal bg-secondary bg-opacity-10 py-2 px-4">成績参照</h2>

            <div class="px-4">
                <div class="border p-3 rounded mb-2">

                    <%-- 科目情報 --%>
                    <form method="get" action="TestList.action" class="mb-2">
                        <input type="hidden" name="subjectSearch" value="1">
                        <div class="row align-items-end">
                            <div class="col-auto fw-bold" style="min-width:80px">科目情報</div>
                            <div class="col-auto">
                                <label class="form-label mb-1">入学年度</label>
                                <select class="form-select form-select-sm" name="entYear">
                                    <option value="">--------</option>
                                    <c:forEach var="y" items="${entYearSet}">
                                        <option value="${y}" <c:if test="${y == entYear}">selected</c:if>>${y}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="col-auto">
                                <label class="form-label mb-1">クラス</label>
                                <select class="form-select form-select-sm" name="classNum">
                                    <option value="">--------</option>
                                    <c:forEach var="cn" items="${classNumSet}">
                                        <option value="${cn}" <c:if test="${cn == classNum}">selected</c:if>>${cn}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="col-auto">
                                <label class="form-label mb-1">科目</label>
                                <select class="form-select form-select-sm" name="subjectCd" style="min-width:160px">
                                    <option value="">--------</option>
                                    <c:forEach var="s" items="${subjectList}">
                                        <option value="${s.subjectCd}" <c:if test="${s.subjectCd == subjectCd}">selected</c:if>>${s.subjectName}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="col-auto">
                                <button class="btn btn-secondary btn-sm px-3">検索</button>
                            </div>
                        </div>
                        <c:if test="${not empty subjectError}">
                            <div class="text-danger small mt-1">${subjectError}</div>
                        </c:if>
                    </form>

                    <hr class="my-2">

                    <%-- 学生情報 --%>
                    <form method="get" action="TestList.action">
                        <input type="hidden" name="studentSearch" value="1">
                        <div class="row align-items-end">
                            <div class="col-auto fw-bold" style="min-width:80px">学生情報</div>
                            <div class="col-auto">
                                <label class="form-label mb-1">学生番号</label>
                                <input type="text" class="form-control form-control-sm" name="studentNo"
                                       value="${studentNo}" maxlength="10"
                                       placeholder="学生番号を入力してください" style="min-width:200px">
                            </div>
                            <div class="col-auto">
                                <button class="btn btn-secondary btn-sm px-3">検索</button>
                            </div>
                        </div>
                        <c:if test="${not empty studentError}">
                            <div class="text-danger small mt-1">${studentError}</div>
                        </c:if>
                    </form>

                    <div class="mt-3 small" style="color: #0d6efd;">
                        科目情報を選択または学生情報を入力して検索ボタンをクリックしてください
                    </div>

                </div>
            </div>

        </section>
    </c:param>
</c:import>
