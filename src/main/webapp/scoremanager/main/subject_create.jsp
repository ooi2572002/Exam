<%-- 科目登録 (SBJM002) --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:import url="/common/base.jsp">
    <c:param name="title">得点管理システム</c:param>
    <c:param name="content">
        <section class="me-4">
            <h2 class="h3 mb-3 fw-normal bg-secondary bg-opacity-10 py-2 px-4">科目情報登録</h2>

            <form action="SubjectCreateExecute.action" method="get" class="px-4">

                <div class="mb-3">
                    <label class="form-label">科目コード</label>
                    <input class="form-control" type="text" name="cd"
                           value="${cd}" maxlength="3"
                           placeholder="科目コードを入力してください" required>
                    <c:if test="${not empty errors}">
                        <div class="text-danger small mt-1">${errors.get("1")}</div>
                    </c:if>
                </div>

                <div class="mb-3">
                    <label class="form-label">科目名</label>
                    <input class="form-control" type="text" name="name"
                           value="${name}" maxlength="20"
                           placeholder="科目名を入力してください" required>
                </div>

                <div class="mb-2">
                    <button type="submit" class="btn btn-primary">登録</button>
                </div>
                <a href="SubjectList.action">戻る</a>

            </form>
        </section>
    </c:param>
</c:import>
