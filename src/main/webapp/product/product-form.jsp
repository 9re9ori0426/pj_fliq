<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>상품 등록 | FLIQ</title>

    <%-- 홈의 공통 색상과 버튼을 먼저 불러오고, 등록 화면 스타일을 적용한다. --%>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/home.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/product-register-form.css">
</head>
<body>
<div class="fliq-page register-page">

    <header class="fliq-header">
        <a class="fliq-logo" href="${pageContext.request.contextPath}/home">FLIQ</a>
    </header>

    <main class="register-content">
        <section class="register-card">
            <h1>상품 등록</h1>

            <%-- 컨트롤러와 DAO에서 전달한 등록 결과를 표시한다. --%>
            <c:if test="${registerSuccess}">
                <p class="register-status register-success" role="status">상품이 등록되었습니다.</p>
            </c:if>

            <c:if test="${not empty error}">
                <p class="register-status register-error" role="alert">
                    <c:out value="${error}"/>
                </p>
            </c:if>

            <%-- 사진과 상품 정보를 함께 보내므로 multipart/form-data를 사용한다. --%>
            <form class="register-form"
                  action="${pageContext.request.contextPath}/product-register"
                  method="post" enctype="multipart/form-data">

                <div class="register-info">
                    <label class="register-field">
                        대표 이미지
                        <input type="file" id="product-image-file" name="file"
                               accept="image/jpeg,image/png">
                    </label>

                    <%-- 사진을 선택하면 기존 JS가 hidden을 해제하고 미리보기를 보여준다. --%>
                    <img id="product-image-preview" class="register-image"
                         alt="선택한 상품 사진" hidden>

                    <label class="register-field">
                        상품명
                        <input type="text" name="title" maxlength="30" required
                               value="<c:out value='${param.title}'/>">
                    </label>

                    <label class="register-field">
                        상품 설명
                        <textarea name="description" maxlength="500"><c:out value="${param.description}"/></textarea>
                    </label>

                    <label class="register-field">
                        카테고리
                        <select name="categoryId" id="category" required>
                            <option value="">카테고리 선택</option>
                            <%-- 이름은 화면에 표시하고, 선택한 번호를 DAO에 보낸다. --%>
                            <c:forEach items="${categories}" var="ca">
                                <option value="${ca.c_id}"><c:out value="${ca.c_name}"/></option>
                            </c:forEach>
                        </select>
                    </label>
                </div>

                <div class="register-sale">
                    <%-- fieldset은 관련 선택지를 묶고, legend는 묶음의 제목을 표시한다. --%>
                    <fieldset class="register-choice">
                        <legend>거래 방식</legend>
                        <div class="register-options">
                            <label>
                                <input type="radio" name="productType" value="SALE" checked>
                                일반판매
                            </label>

                            <%-- 경매 등록 기능이 연결되면 disabled를 해제한다. --%>
                            <label class="register-option-disabled">
                                <input type="radio" name="productType" value="AUCTION" disabled>
                                경매 (준비 중)
                            </label>
                        </div>
                    </fieldset>

                    <label class="register-field">
                        판매가 (원)
                        <input type="number" name="price" min="0" max="9999999999"
                               step="1" required value="<c:out value='${param.price}'/>">
                    </label>

                    <fieldset class="register-choice">
                        <legend>교환 여부</legend>
                        <div class="register-options">
                            <label>
                                <input type="radio" name="trade" value="Y" checked>
                                교환 허용
                            </label>
                            <label>
                                <input type="radio" name="trade" value="N">
                                교환 불가
                            </label>
                        </div>
                    </fieldset>
                </div>

                <div class="register-actions">
                    <a class="fliq-button" href="${pageContext.request.contextPath}/home">홈으로</a>
                    <button type="submit" class="fliq-button fliq-button--primary">상품 등록</button>
                </div>
            </form>
        </section>
    </main>
</div>

<%-- 현재 프로젝트에 저장된 이미지 미리보기 JS 파일명이다. --%>
<script src="${pageContext.request.contextPath}/product-reg/proudct-form.js"></script>
</body>
</html>