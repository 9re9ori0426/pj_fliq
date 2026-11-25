<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%-- 상품 목록을 반복하고 검색어를 출력할 JSTL 태그를 등록한다. --%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

h1>검색 결과</h1>

<%-- 검색어가 있을 때 입력한 단어와 조회 건수를 표시한다. --%>
<c:if test="${not empty keyword}">
    <p>‘<c:out value="${keyword}" />’ 검색 결과 <c:out value="${resultCount}" />건</p>
</c:if>

<%-- 상품 한 건당 상품명과 판매 정보를 한 묶음으로 표시한다. --%>
<c:forEach var="product" items="${products}">
    <article>
        <h2><c:out value="${product.p_title}" /></h2>

            <%-- eq는 두 값이 같은지 비교한다. 일반판매 상품에 판매가를 표시한다. --%>
        <c:if test="${product.p_sale_type eq 'SALE'}">
            <p>일반판매 · <c:out value="${product.p_sale_price}" />원</p>
        </c:if>

        <c:if test="${product.p_sale_type eq 'AUCTION'}">
            <p>경매</p>
        </c:if>

        <c:if test="${product.p_trade_ok eq 'Y'}">
            <p>교환 허용</p>
        </c:if>
    </article>
</c:forEach>

<c:if test="${not empty keyword and empty products}">
    <p>검색 결과가 없습니다.</p>
</c:if>