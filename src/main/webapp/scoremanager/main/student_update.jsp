<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <title>学生変更</title>
</head>
<body>

<h2>学生情報変更</h2>

<c:if test="${not empty error}">
    <p style="color:red;">${error}</p>
</c:if>

<form action="StudentUpdateExecute.action" method="post">

    学籍番号：
    <input type="text" name="student_No" value="${student.studentNo}" readonly><br>

    氏名：
    <input type="text" name="student_Name" value="${student.studentName}"><br>

    入学年度：
    <input type="number" name="Ent_Year" value="${student.entYear}"><br>

    クラス：
    <input type="text" name="Class_num" value="${student.classNum}"><br>

    在学中：
    <select name="isAttend">
        <option value="true"  ${student.attend ? "selected" : ""}>〇</option>
        <option value="false" ${!student.attend ? "selected" : ""}>×</option>
    </select><br>

    学校コード：
    <input type="text" name="School_cd" value="${student.school.schoolCd}"><br>

    <input type="submit" value="変更">
</form>

<a href="StudentList.action">戻る</a>

</body>
</html>