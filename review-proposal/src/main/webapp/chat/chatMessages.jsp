<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>채팅 메시지 | FLIQ</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/home.css">
</head>
<body>
<main class="fliq-page">
    <a href="${pageContext.request.contextPath}/chat">채팅방 목록</a>
    <h1>채팅 메시지</h1>
    <c:if test="${not empty room}">
        <p>상품 번호 <c:out value="${room.cr_product_id}"/></p>
    </c:if>
    <c:if test="${empty messages}"><p>표시할 메시지가 없습니다.</p></c:if>
    <c:if test="${not empty messages}">
        <ol>
            <c:forEach var="message" items="${messages}">
                <li>회원 <c:out value="${message.cm_sender_id}"/> · <c:out value="${message.cm_text_body}"/></li>
            </c:forEach>
        </ol>
    </c:if>
</main>
</body>
</html>
