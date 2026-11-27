<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>상품 상세 | FLIQ</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/home.css">
</head>
<body>
<div class="fliq-page">
    <header class="fliq-header">
        <a class="fliq-logo" href="${pageContext.request.contextPath}/home">FLIQ</a>
    </header>

    <main class="fliq-main">
        <h1><c:out value="${product.p_title}"/></h1>

        <%-- 사진이 등록된 상품만 이미지를 보여준다. --%>
        <c:if test="${not empty product.pi_storage}">
            <img src="${pageContext.request.contextPath}/<c:out value='${product.pi_storage}'/>"
                 alt="상품 사진"
                 style="max-width: 100%; width: 400px; height: auto;">
        </c:if>

        <c:if test="${empty product.pi_storage}">
            <p>사진 없음</p>
        </c:if>

        <p>가격 <strong>${product.p_sale_price}원</strong></p>

        <c:if test="${product.p_sale_status eq 'AVAILABLE'}">
            <p>판매 중</p>
        </c:if>
        <c:if test="${product.p_sale_status eq 'RESERVED'}">
            <p>예약 중</p>
        </c:if>
        <c:if test="${product.p_sale_status eq 'SOLD'}">
            <p>판매 완료</p>
        </c:if>
        <c:if test="${product.p_sale_status eq 'TRADED'}">
            <p>교환 완료</p>
        </c:if>
        <c:if test="${product.p_sale_status eq 'ENDED'}">
            <p>거래 종료</p>
        </c:if>

        <c:if test="${product.p_trade_ok eq 'Y'}">
            <p>교환 가능</p>
        </c:if>

        <h2>상품 설명</h2>
        <c:if test="${not empty product.p_description}">
            <p style="white-space: pre-line;"><c:out value="${product.p_description}"/></p>
        </c:if>
        <c:if test="${empty product.p_description}">
            <p>등록된 설명이 없습니다.</p>
        </c:if>

        <a class="fliq-button" href="${pageContext.request.contextPath}/sell#product-list">
            일반판매 목록
        </a>
    </main>
</div>
</body>
</html>