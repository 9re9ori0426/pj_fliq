<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>회원가입 | FLIQ</title>
    <%-- 공통 스타일 다음에 로그인·회원가입 스타일을 불러온다. --%>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/home.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/auth.css">
</head>
<body class="fliq-auth">
<div class="fliq-auth__shell">
    <header class="fliq-auth__header">
        <a class="fliq-logo" href="${pageContext.request.contextPath}/home" aria-label="FLIQ 홈">FLIQ</a>
    </header>

    <main class="fliq-auth__card">
        <h1 class="fliq-auth__title">회원가입</h1>
        <%-- 가입에 실패했을 때 DAO가 보낸 메시지를 표시한다. --%>
        <c:if test="${not empty msg}">
            <p class="fliq-auth__message"><c:out value="${msg}"/></p>
        </c:if>

        <form class="fliq-auth__form" action="${pageContext.request.contextPath}/sign-up" method="post">
            <label class="fliq-auth__field">
                이메일
                <input type="text" name="u_email" autocomplete="username">
            </label>

            <label class="fliq-auth__field">
                비밀번호
                <input type="password" name="u_password" autocomplete="new-password">
            </label>

            <label class="fliq-auth__field">
                닉네임
                <input type="text" name="u_nickname" autocomplete="nickname">
            </label>

            <button type="submit" class="fliq-button fliq-button--primary fliq-auth__submit">가입하기</button>
        </form>

        <p class="fliq-auth__footer">
            이미 계정이 있나요?
            <a href="${pageContext.request.contextPath}/login">로그인</a>
        </p>
    </main>
</div>
</body>
</html>

