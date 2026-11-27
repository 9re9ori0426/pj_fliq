<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:choose>
<%--  경매상품이없을때 띄우는 로직  --%>
    <c:when test="${empty a}">
        <p>경매 상품을 찾을 수 없습니다.</p>
    </c:when>
    <c:otherwise>
        <%-- 클릭한 그 상품 한건을 표시해주게끔 띄워주기 --%>
        <h2 class="fliq-section-title"><c:out value="${a.title}"/></h2>
        <p><c:out value="${a.description}"/></p>
        <p>시작가 <fmt:formatNumber value="${a.startPrice}" pattern="#,##0"/>원</p>
    </c:otherwise>
</c:choose>