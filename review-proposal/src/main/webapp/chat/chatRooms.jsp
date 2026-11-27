<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>채팅방 | FLIQ</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/home.css">
</head>
<body>
<main class="fliq-page">
    <a href="${pageContext.request.contextPath}/home">홈</a>
    <h1>내 채팅방</h1>
    <c:if test="${empty rooms}"><p>참여 중인 채팅방이 없습니다.</p></c:if>
    <c:if test="${not empty rooms}">
        <ul>
            <c:forEach var="room" items="${rooms}">
                <c:url var="roomUrl" value="/chat">
                    <c:param name="roomId" value="${room.cr_id}"/>
                </c:url>
                <li><a href="<c:out value='${roomUrl}'/>">상품 <c:out value="${room.cr_product_id}"/> 채팅방</a></li>
            </c:forEach>
        </ul>
    </c:if>
</main>
</body>
</html>
