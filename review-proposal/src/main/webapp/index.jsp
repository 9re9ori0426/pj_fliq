<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>FLIQ</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/home.css">
    <%-- 상품 목록 스타일은 공통 홈 스타일 다음에 불러온다. --%>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/product-list.css">
</head>
<body>

<div class="fliq-page">
    <header class="fliq-header">
        <a id="home" class="fliq-logo" href="${pageContext.request.contextPath}/home" aria-label="FLIQ 홈">FLIQ</a>


        <%-- 검색창과 버튼을 같은 폼에 두고 ListingSearchC로 보낸다. --%>
        <form class="fliq-search" action="${pageContext.request.contextPath}/product-listing">
            <label class="fliq-visually-hidden" for="keyword">상품명 또는 설명 검색</label>
            <input id="keyword" type="text" name="keyword" placeholder="상품명 또는 설명 검색">
            <button id="search" class="fliq-button fliq-button--primary">검색</button>
        </form>

        <nav class="fliq-account" aria-label="회원 메뉴">
            <%-- 로그인 코드가 세션에 저장한 user로 회원 메뉴를 구분한다. --%>
            <c:choose>
                <c:when test="${not empty sessionScope.user}">
                    <span><c:out value="${sessionScope.user.u_nickname}"/>님</span>
                    <a class="fliq-button" href="${pageContext.request.contextPath}/product-register">상품 등록</a>
                    <a class="fliq-button" href="${pageContext.request.contextPath}/chat">채팅</a>

                    <%-- 로그인 컨트롤러에 로그아웃 요청을 보낸다. --%>
                    <form action="${pageContext.request.contextPath}/login" method="post">
                        <button class="fliq-button"
                                name="action" value="logout">로그아웃</button>
                    </form>
                </c:when>
                <c:otherwise>
                    <a id="login" class="fliq-button" href="${pageContext.request.contextPath}/login">로그인</a>
                    <a id="signup" class="fliq-button" href="${pageContext.request.contextPath}/sign-up">회원가입</a>
                </c:otherwise>
            </c:choose>
        </nav>
    </header>

    <main class="fliq-main">
        <section class="fliq-hero" aria-labelledby="hero-title">
            <h1 id="hero-title">사고 · 입찰하고 · 바꾸다</h1>
            <p>일반판매와 경매 상품을 둘러보고 1:1 교환을 제안해 보세요.</p>
            <a id="browse-products" class="fliq-button fliq-button--primary"
               href="<c:url value='/product-listing?view=all'/>">상품 둘러보기</a>
        </section>


        <nav class="fliq-filters" aria-label="판매 방식">
            <a id="filter-all" class="fliq-button fliq-button--primary"
               href="<c:url value='/product-listing?view=all'/>">전체</a>
            <a id="filter-sale" class="fliq-button fliq-filter-sale"
               href="<c:url value='/product-listing?view=sale'/>">일반판매</a>
            <a id="filter-auction" class="fliq-button fliq-filter-auction"
               href="${pageContext.request.contextPath}/auction">경매</a>
        </nav>

        <section class="fliq-product-list" aria-labelledby="recent-title">
            <h2 id="recent-title" class="fliq-section-title">
                <%-- 검색어가 있으면 검색 결과 건수를, 홈에서는 최근 등록 상품 제목을 표시한다. --%>
                <c:choose>
                    <c:when test="${not empty keyword}">
                        ‘<c:out value="${keyword}" />’ 검색 결과 <c:out value="${resultCount}" />건
                    </c:when>
                    <c:when test="${listingView eq 'all'}">전체 상품</c:when>
                    <c:when test="${listingView eq 'sale'}">일반판매 상품</c:when>
                    <c:when test="${listingView eq 'auction'}">경매 상품</c:when>
                    <c:otherwise>
                        최근 등록 상품
                    </c:otherwise>
                </c:choose>
            </h2>

            <%-- 상품 최대 3개까지만 보여주게끔 표시 상품쪽에선
            request.setAttribute("products", products);
            request.getRequestDispatcher("/index.jsp").forward(request, response);
            로 넘겨주면 됨--%>
            <div class="fliq-product-grid">
                <%-- 메인과 검색에서 받은 상품 목록을 같은 카드로 표시한다. --%>
                <c:forEach var="product" items="${products}">
                    <article class="fliq-card">
                        <div class="fliq-card__thumbnail">
                            <c:choose>
                                <c:when test="${not empty product.pi_storage}">
                                    <%-- DB에 저장한 경로 앞에 FLIQ 배포 주소를 붙인다. --%>
                                    <c:url var="productImageUrl" value="/${product.pi_storage}"/>
                                    <img class="fliq-card__image"
                                         src="<c:out value='${productImageUrl}'/>"
                                         alt="<c:out value='${product.p_title}'/>">
                                </c:when>
                                <c:otherwise>
                                    <span>사진 없음</span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <div class="fliq-card__body">
                            <h3 class="fliq-card__title"><c:out value="${product.p_title}"/></h3>
                            <c:choose>
                                <c:when test="${product.p_sale_type eq 'SALE'}">
                                    <p class="fliq-card__price">
                                        <%-- 가격을 15,000처럼 세 자리씩 끊어 표시한다. --%>
                                        <fmt:formatNumber value="${product.p_sale_price}" pattern="#,##0"/>원
                                    </p>
                                </c:when>
                                <c:otherwise>
                                    <p class="fliq-card__type">경매</p>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </article>
                </c:forEach>

                <c:if test="${empty products}">
                    <c:choose>
                        <c:when test="${not empty keyword}">
                            <p class="fliq-product-list__empty">검색 결과가 없습니다.</p>
                        </c:when>
                        <c:otherwise>
                            <p class="fliq-product-list__empty">등록된 상품이 없습니다.</p>
                        </c:otherwise>
                    </c:choose>
                </c:if>
            </div>
        </section>
    </main>
</div>
</body>
</html>