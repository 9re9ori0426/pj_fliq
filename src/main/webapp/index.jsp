<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>FLIQ</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/home.css?v=4834f92b">
    <%-- 상품 목록 스타일은 공통 홈 스타일 다음에 불러온다. --%>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/product-list.css?v=10b5c5e8">
</head>
<body>

<div class="fliq-page">
    <header class="fliq-header">
        <a id="home" class="fliq-logo" href="home" aria-label="FLIQ 홈">FLIQ</a>


        <%-- 검색창과 버튼을 같은 폼에 두고 ProductSearchC로 보낸다. --%>
        <form class="fliq-search" action="product-search">
            <label class="fliq-visually-hidden" for="keyword">상품명 또는 설명 검색</label>
            <input id="keyword" type="text" name="keyword" placeholder="상품명 또는 설명 검색">
            <button id="search" class="fliq-button fliq-button--primary">검색</button>
        </form>

        <nav class="fliq-account" aria-label="회원 메뉴">
            <%-- 로그인 코드가 세션에 저장한 user로 회원 메뉴를 구분한다. --%>
            <c:choose>
                <c:when test="${not empty sessionScope.user}">
                    <span><c:out value="${sessionScope.user.u_nickname}"/>님</span>
                    <a class="fliq-button" href="chat">채팅방</a>
                    <a class="fliq-button" href="product-register">상품 등록</a>

                    <%-- 로그인 컨트롤러에 로그아웃 요청을 보낸다. --%>
                    <form action="login" method="post">
                        <button class="fliq-button"
                                name="action" value="logout">로그아웃</button>
                    </form>
                </c:when>
                <c:otherwise>
                    <a id="login" class="fliq-button" href="login">로그인</a>
                    <a id="signup" class="fliq-button" href="sign-up">회원가입</a>
                </c:otherwise>
            </c:choose>
        </nav>
    </header>

    <main class="fliq-main">
        <section class="fliq-hero" aria-labelledby="hero-title">
            <h1 id="hero-title">사고 · 입찰하고 · 바꾸다</h1>
            <p>일반판매와 경매 상품을 둘러보고 1:1 교환을 제안해 보세요.</p>
            <a id="browse-products" class="fliq-button fliq-button--primary"
               href="home#product-list">상품 둘러보기</a>
        </section>


        <nav class="fliq-filters" aria-label="판매 방식">
            <a id="filter-all" class="fliq-button" href="home#product-list"
               aria-current="${empty content and not saleOnly and empty keyword}">전체</a>
            <a id="filter-sale" class="fliq-button fliq-filter-sale" href="sell#product-list"
               aria-current="${saleOnly eq true}">일반판매</a>
            <a id="filter-auction" class="fliq-button fliq-filter-auction" href="auction"
               aria-current="${not empty content}">경매</a>
        </nav>

        <c:choose>
            <c:when test="${not empty content}">
                <jsp:include page="${content}"/>
            </c:when>
            <c:otherwise>
                <jsp:include page="/WEB-INF/views/product-feed.jsp"/>
            </c:otherwise>
        </c:choose>
    </main>
</div>
</body>
</html>
