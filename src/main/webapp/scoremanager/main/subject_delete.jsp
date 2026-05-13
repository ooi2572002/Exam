<%-- 科目削除 (SBJM006) --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:import url="/common/base.jsp">
    <c:param name="title">得点管理システム</c:param>
    <c:param name="scripts"></c:param>
    <c:param name="content">
        <section class="me-4">
            <h2 class="h3 mb-3 fw-normal bg-secondary bg-opacity-10 py-2 px-4">科目情報削除</h2>
            <div class="px-4 py-3">
                <p>「${subject.subjectName}（${subject.subjectCd}）」を削除してもよろしいですか。</p>
                <form action="SubjectDeleteExecute.action" method="post">
                    <input type="hidden" name="subject_cd"   value="${subject.subjectCd}">
                    <input type="hidden" name="subject_name" value="${subject.subjectName}">
                    <button type="submit" class="btn btn-danger me-2">削除</button>
                    <a href="SubjectList.action" class="btn btn-outline-secondary">戻る</a>
                </form>
            </div>
        </section>
    </c:param>
</c:import>
