<%-- 成績情報削除確認 --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
    import="java.util.*,bean.*" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    @SuppressWarnings("unchecked")
    List<Map<String,Object>> tests = (List<Map<String,Object>>) request.getAttribute("tests");
    String studentNo = (String) request.getAttribute("student_no");
    String subjectCd = (String) request.getAttribute("subject_cd");
    String schoolCd  = (String) request.getAttribute("school_cd");
%>
<c:import url="/common/base.jsp">
    <c:param name="title">得点管理システム</c:param>
    <c:param name="content">
        <section class="me-4">
            <h2 class="h3 mb-3 fw-normal bg-secondary bg-opacity-10 py-2 px-4">成績情報削除</h2>
            <div class="px-4 py-3">
                <% if (tests != null && !tests.isEmpty()) { %>
                    <p>以下の成績を削除してもよいですか？</p>
                    <table class="table table-bordered w-auto mb-4">
                        <thead class="table-light">
                            <tr><th>学生番号</th><th>科目コード</th><th>回数</th><th>点数</th></tr>
                        </thead>
                        <tbody>
                            <% for (Map<String,Object> t : tests) { %>
                            <tr>
                                <td><%= studentNo %></td>
                                <td><%= subjectCd %></td>
                                <td><%= t.get("no") %>回</td>
                                <td><%= t.get("point") != null ? t.get("point") : "-" %></td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                    <form method="post" action="TestDeleteExecute.action">
                        <input type="hidden" name="student_no" value="<%= studentNo %>">
                        <input type="hidden" name="subject_cd" value="<%= subjectCd %>">
                        <button type="submit" class="btn btn-danger me-2">削除</button>
                        <a href="javascript:history.back()" class="btn btn-outline-secondary">戻る</a>
                    </form>
                <% } else { %>
                    <p class="text-danger">対象の成績情報が見つかりませんでした。</p>
                    <a href="TestList.action">成績参照に戻る</a>
                <% } %>
            </div>
        </section>
    </c:param>
</c:import>
