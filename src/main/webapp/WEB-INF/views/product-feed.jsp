<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<section id="product-list" class="fliq-product-list" aria-labelledby="product-list-title">
    <h2 id="product-list-title" class="fliq-section-title">
        <c:choose>
            <c:when test="${not empty keyword}">
                ‘<c:out value="${keyword}"/>’ 검색 결과 <c:out value="${resultCount}"/>건
            </c:when>
            <c:when test="${saleOnly}">일반판매 상품</c:when>
            <c:otherwise>최근 등록 상품</c:otherwise>
        </c:choose>
    </h2>

    <div class="fliq-product-grid fliq-product-grid--feed">
        <c:forEach var="product" items="${products}">
            <article class="fliq-card">
                <div class="fliq-card__thumbnail">
                    <c:choose>
                        <c:when test="${not empty product.pi_storage}">
                            <c:url var="productImageUrl" value="/${product.pi_storage}"/>
                            <img class="fliq-card__image" loading="lazy"
                                 src="<c:out value='${productImageUrl}'/>"
                                 alt="<c:out value='${product.p_title}'/>">
                        </c:when>
                        <c:otherwise><span>사진 없음</span></c:otherwise>
                    </c:choose>
                </div>
                <div class="fliq-card__body">
                    <h3 class="fliq-card__title">
                        <c:if test="${product.p_sale_type eq 'SALE'}">
                            <c:url var="detailUrl" value="/product-detail">
                                <c:param name="productId" value="${product.p_id}"/>
                            </c:url>

                            <a class="fliq-card__detail-link" href="${detailUrl}">
                                <c:out value="${product.p_title}"/>
                            </a>
                        </c:if>

                        <c:if test="${product.p_sale_type ne 'SALE'}">
                            <c:out value="${product.p_title}"/>
                        </c:if>
                    </h3>
                    <c:choose>
                        <c:when test="${product.p_sale_type eq 'SALE'}">
                            <p class="fliq-card__price">
                                <fmt:formatNumber value="${product.p_sale_price}" pattern="#,##0"/>원
                            </p>
                        </c:when>
                        <c:otherwise><p class="fliq-card__type">경매</p></c:otherwise>
                    </c:choose>
                </div>
            </article>
        </c:forEach>

        <c:if test="${empty products}">
            <p class="fliq-product-list__empty">
                <c:choose>
                    <c:when test="${not empty keyword}">검색 결과가 없습니다.</c:when>
                    <c:when test="${saleOnly}">등록된 일반판매 상품이 없습니다.</c:when>
                    <c:otherwise>등록된 상품이 없습니다.</c:otherwise>
                </c:choose>
            </p>
        </c:if>
    </div>

</section>
