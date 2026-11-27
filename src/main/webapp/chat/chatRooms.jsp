<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title> - Chat Rooms - </title>
</head>
<body>
<h1>${user.u_nickname}'s Chat Rooms</h1>
<hr>

<c:if test="${empty rooms}">
    <p>참여 중인 채팅방이 없습니다.</p>
</c:if>

<ul>
    <c:forEach var="room" items="${rooms}">
        <li>
            <c:choose>
                <c:when test="${not empty room.pi_storage}">
                    <c:url var="imageUrl" value="${room.pi_storage}"/>
                    <img src="<c:out value='${imageUrl}'/>" alt="상품 대표 이미지">
                </c:when>
                <c:otherwise>사진 없음</c:otherwise>
            </c:choose>

            <strong><c:out value="${room.p_title}"/></strong>

            <c:choose>
                <c:when test="${not empty room.display_price}">
                    <c:out value="${room.price_label}"/><br>
                    <fmt:formatNumber value="${room.display_price}" pattern="#,###"/>원 <br>
                </c:when>
                <c:otherwise>가격 정보 없음</c:otherwise>
            </c:choose>

            <span>판매 상태 <c:out value="${room.p_sale_status}"/></span>
            <span>채팅방 <c:out value="${room.cr_id}"/>번</span>
        </li>
    </c:forEach>
</ul>
</body>
</html>
