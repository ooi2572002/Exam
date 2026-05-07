<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fn" uri="jakarta.tags.functions"%>

<c:import url="/common/base.jsp">
    <c:param name="title">得点管理システム</c:param>

    <c:param name="content">
        <section class="me-4">

            <h2 class="h3 mb-3 fw-normal bg-secondary bg-opacity-10 py-2 px-4">科目管理</h2>

            <div class="my-2 text-end px-4">
                <a href="SubjectCreate.action">新規登録</a>
            </div>

            <!-- 件数は常に表示 -->
            <div class="px-4">
                検索結果：${fn:length(subjects)}件
            </div>

            <table class="table table-hover mt-2">
                <tr>
                    <th>科目コード</th>
                    <th>科目名</th>
                    <th></th>
                    <th></th>
                </tr>

                <c:choose>

            
                    <c:when test="${not empty subjects}">
                        <c:forEach var="s" items="${subjects}">
                            <tr>
                                <td>${s.subjectCd}</td>
                                <td>${s.subjectName}</td>
                                <td><a href="SubjectUpdate.action?subject_cd=${s.subjectCd}">変更</a></td>
                                <td><a href="SubjectDelete.action?subject_cd=${s.subjectCd}">削除</a></td>
                            </tr>
                        </c:forEach>
                    </c:when>

                    <c:otherwise>
                        <tr>
                            <td colspan="4" class="text-center text-muted"></td>
                        </tr>
                    </c:otherwise>

                </c:choose>
            </table>

        </section>
    </c:param>
</c:import>