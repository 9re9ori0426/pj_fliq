<%--
  Created by IntelliJ IDEA.
  User: sdedu01
  Date: 2026-11-25
  Time: 오후 3:20
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<section class="fliq-product-list">
    <h2 class="fliq-section-title">경매 상품</h2>

    <%-- 경매상품이 하나도없다면 해당메시지가 띄워지는 if문 로직 --%>
    <c:if test="${empty auctions}">
        <p>등록된 경매 상품이 없습니다.</p>
    </c:if>

    <div class="fliq-product-grid">
        <c:forEach var="item" items="${auctions}">

            <%-- 상품번호 참조해서 url에 /auction-detail?productId=해당상품번호로 넘어가게해주는로직. --%>
            <c:url var="detailUrl" value="/auction-detail">
                <c:param name="productId" value="${item.productId}"/>
            </c:url>

            <a class="fliq-card" href="${detailUrl}">
                <div class="fliq-card__body">
                    <h3 class="fliq-card__title"><c:out value="${item.title}"/></h3>
                        <%-- 매퍼에서 startPrice로 조회한 경매시작가를 #,##0원으로 띄워주는로직 --%>
                    <p class="fliq-card__price">
                        시작가 <fmt:formatNumber value="${item.startPrice}" pattern="#,##0"/>원
                    </p>
                </div>
            </a>
        </c:forEach>
    </div>
</section>
