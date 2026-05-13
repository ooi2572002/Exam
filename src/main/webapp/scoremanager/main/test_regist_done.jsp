<%-- 成績登録完了 (GRMU002) --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:import url="/common/base.jsp">
    <c:param name="title">得点管理システム</c:param>
    <c:param name="content">
        <section class="me-4">
            <h2 class="h3 mb-3 fw-normal bg-secondary bg-opacity-10 py-2 px-4">成績管理一覧</h2>
            <div class="px-4 py-3">
                <div class="alert alert-success py-2 mb-3 text-center">登録が完了しました</div>
                <a href="TestRegist.action" class="me-4">戻る</a>
                <a href="TestList.action">成績参照</a>
            </div>
        </section>
    </c:param>
</c:import>
