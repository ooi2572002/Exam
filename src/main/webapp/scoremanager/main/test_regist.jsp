<%-- 成績管理一覧 (GRMU001) --%>
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

    String f1 = request.getParameter("f1");
    String f2 = request.getParameter("f2");
    String f3 = request.getParameter("f3");
    String f4 = request.getParameter("f4");
    String action = request.getParameter("action");

    Map<String,String> errors = new HashMap<>();
    List<Map<String,Object>> tests = null;
    String subjectName = "";

    if ("search".equals(action)) {
        if (f1 == null || f1.equals("0") || f1.isEmpty()) errors.put("f1", "入学年度を選択してください");
        if (f2 == null || f2.equals("0") || f2.isEmpty()) errors.put("f2", "クラスを選択してください");
        if (f3 == null || f3.equals("0") || f3.isEmpty()) errors.put("f3", "科目を選択してください");
        if (f4 == null || f4.equals("0") || f4.isEmpty()) errors.put("f4", "回数を選択してください");

        if (errors.isEmpty()) {
            TestDao testDao = new TestDao();
            tests = testDao.filterForRegist(teacher.getSchool().getSchoolCd(),
                    Integer.parseInt(f1), f2, f3, Integer.parseInt(f4));
            Subject sub = subjectDao.get(teacher.getSchool(), f3);
            if (sub != null) subjectName = sub.getSubjectName();
        }

    } else if ("regist".equals(action)) {
        String subjectParam = request.getParameter("subject");
        String countParam   = request.getParameter("count");
        String[] registNos  = request.getParameterValues("regist");
        if (subjectParam != null) f3 = subjectParam;
        if (countParam   != null) f4 = countParam;

        if (subjectParam != null && countParam != null && registNos != null) {
            int num = Integer.parseInt(countParam);
            TestDao testDao = new TestDao();

            for (String sno : registNos) {
                String pointStr = request.getParameter("point_" + sno);
                Integer point = null;
                if (pointStr != null && !pointStr.trim().isEmpty()) {
                    try {
                        int p = Integer.parseInt(pointStr.trim());
                        if (p < 0 || p > 100) {
                            errors.put(sno, "0〜100の範囲で入力してください");
                            continue;
                        }
                        point = p;
                    } catch (NumberFormatException e) {
                        errors.put(sno, "数値を入力してください");
                        continue;
                    }
                }
                if (errors.isEmpty()) {
                    testDao.save(sno, teacher.getSchool().getSchoolCd(), subjectParam, num, point);
                }
            }

            if (errors.isEmpty()) {
                response.sendRedirect("test_regist_done.jsp");
                return;
            }

            // エラー時は一覧を再取得して再表示
            int entYear = (f1 != null && !f1.isEmpty() && !f1.equals("0")) ? Integer.parseInt(f1) : 0;
            tests = new TestDao().filterForRegist(teacher.getSchool().getSchoolCd(), entYear, f2, subjectParam, num);
            Subject sub = subjectDao.get(teacher.getSchool(), subjectParam);
            if (sub != null) subjectName = sub.getSubjectName();
        }
    }

    pageContext.setAttribute("entYearSet", entYearSet);
    pageContext.setAttribute("classNumSet", classNumSet);
    pageContext.setAttribute("subjects", subjects);
    pageContext.setAttribute("f1", f1);
    pageContext.setAttribute("f2", f2);
    pageContext.setAttribute("f3", f3);
    pageContext.setAttribute("f4", f4);
    pageContext.setAttribute("errors", errors);
    pageContext.setAttribute("tests", tests);
    pageContext.setAttribute("subjectName", subjectName);
%>
<c:import url="/common/base.jsp">
    <c:param name="title">得点管理システム</c:param>
    <c:param name="content">
        <section class="me-4">
            <h2 class="h3 mb-3 fw-normal bg-secondary bg-opacity-10 py-2 px-4">成績管理一覧</h2>

            <form method="get" action="TestRegist.action" class="px-3 mb-3">
                <input type="hidden" name="action" value="search">
                <div class="border p-3 rounded mb-2">
                <div class="row mb-1">
                    <div class="col-auto" style="width:120px"><label class="form-label mb-1">入学年度</label></div>
                    <div class="col-auto" style="width:100px"><label class="form-label mb-1">クラス</label></div>
                    <div class="col-auto" style="width:200px"><label class="form-label mb-1">科目</label></div>
                    <div class="col-auto" style="width:100px"><label class="form-label mb-1">回数</label></div>
                </div>
                <div class="row align-items-start">
                    <div class="col-auto">
                        <select class="form-select form-select-sm" name="f1" style="width:120px">
                            <option value="0">--------</option>
                            <c:forEach var="y" items="${entYearSet}">
                                <option value="${y}" <c:if test="${y == f1}">selected</c:if>>${y}</option>
                            </c:forEach>
                        </select>
                        <c:if test="${not empty errors.f1}"><div class="text-danger small">${errors.f1}</div></c:if>
                    </div>
                    <div class="col-auto">
                        <select class="form-select form-select-sm" name="f2" style="width:100px">
                            <option value="0">--------</option>
                            <c:forEach var="cn" items="${classNumSet}">
                                <option value="${cn}" <c:if test="${cn == f2}">selected</c:if>>${cn}</option>
                            </c:forEach>
                        </select>
                        <c:if test="${not empty errors.f2}"><div class="text-danger small">${errors.f2}</div></c:if>
                    </div>
                    <div class="col-auto">
                        <select class="form-select form-select-sm" name="f3" style="width:200px">
                            <option value="0">--------</option>
                            <c:forEach var="s" items="${subjects}">
                                <option value="${s.subjectCd}" <c:if test="${s.subjectCd == f3}">selected</c:if>>${s.subjectName}</option>
                            </c:forEach>
                        </select>
                        <c:if test="${not empty errors.f3}"><div class="text-danger small">${errors.f3}</div></c:if>
                    </div>
                    <div class="col-auto">
                        <select class="form-select form-select-sm" name="f4" style="width:100px">
                            <option value="0">--------</option>
                            <option value="1" <c:if test="${f4 == '1'}">selected</c:if>>1</option>
                            <option value="2" <c:if test="${f4 == '2'}">selected</c:if>>2</option>
                        </select>
                        <c:if test="${not empty errors.f4}"><div class="text-danger small">${errors.f4}</div></c:if>
                    </div>
                    <div class="col-auto">
                        <button class="btn btn-secondary btn-sm">検索</button>
                    </div>
                </div>
                </div>
            </form>

            <c:if test="${not empty tests}">
                <form method="post" action="TestRegist.action">
                    <input type="hidden" name="action" value="regist">
                    <input type="hidden" name="f1" value="${f1}">
                    <input type="hidden" name="f2" value="${f2}">
                    <input type="hidden" name="subject" value="${f3}">
                    <input type="hidden" name="count" value="${f4}">

                    <div class="px-3 mb-2"><strong>${subjectName}</strong>（${f4}回目）</div>

                    <table class="table table-hover table-bordered mx-3" style="width:calc(100% - 2rem)">
                        <thead class="table-light">
                            <tr><th>入学年度</th><th>クラス</th><th>学生番号</th><th>氏名</th><th>点数</th></tr>
                        </thead>
                        <tbody>
                            <c:forEach var="t" items="${tests}">
                                <input type="hidden" name="regist" value="${t.studentNo}">
                                <tr>
                                    <td>${t.entYear}</td>
                                    <td>${t.classNum}</td>
                                    <td>${t.studentNo}</td>
                                    <td>${t.studentName}</td>
                                    <td>
                                        <input type="text" class="form-control form-control-sm"
                                               name="point_${t.studentNo}" value="${t.point}"
                                               maxlength="3" style="width:80px">
                                        <c:if test="${not empty errors[t.studentNo]}">
                                            <div class="text-danger small">${errors[t.studentNo]}</div>
                                        </c:if>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                    <div class="px-3 mb-3">
                        <button type="submit" class="btn btn-primary px-4">登録して終了</button>
                    </div>
                </form>
            </c:if>
        </section>
    </c:param>
</c:import>
