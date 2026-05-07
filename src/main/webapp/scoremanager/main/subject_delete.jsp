<%-- 学生一覧JSP --%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<c:import url="/common/base.jsp" >
	<c:param name="title">
		得点管理システム</c:param>

	<c:param name="scripts"></c:param>

	<c:param name="content">
		<section class="me=4">
			<h2 class="h3 mb-3 fw-norma bg-secondary bg-opacity-10 py-2 px-4">科目情報削除</h2>
			<label><p>「${subject.subjectName }(${subject.subjectCd})」を削除してもよろしいですか。</p></label>
			<form action="SubjectDeleteExecute.action" method="post">

    		<input type="hidden" name="subject_cd" value="${subject.subjectCd}">
    		<input type="hidden" name="subject_name" value="${subject.subjectName}">

    		<input type="submit" class="btn btn-danger" value="削除">
			<br>
			<br>
			<br>
    		<a href="SubjectList.action">戻る</a>
			</form>
			</section>
			</c:param>
			</c:import>