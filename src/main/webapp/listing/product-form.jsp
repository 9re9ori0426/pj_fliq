<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>상품 등록 | FLIQ</title>
    <%-- /product-register에서 열어도 홈과 같은 CSS를 불러온다. --%>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/home.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/product-register-form.css">
</head>
<body>
<div class="fliq-page register-page">
    <header class="fliq-header">
        <a class="fliq-logo" href="${pageContext.request.contextPath}/home" aria-label="FLIQ 홈">FLIQ</a>
    </header>

    <main class="register-content">
        <section class="register-card" aria-labelledby="register-title">
            <h1 id="register-title">일반판매 상품 등록</h1>
            <p class="register-note">현재 등록하는 상품은 실습 판매자 계정에 저장됩니다.</p>

            <%-- 컨트롤러가 등록 성공을 전달한 경우 완료 문구를 보여준다. --%>
            <c:if test="${registerSuccess}">
                <p class="register-status register-success" role="status">상품이 등록되었습니다.</p>
            </c:if>

            <%-- DAO가 담은 오류를 등록 폼 위에 보여준다. --%>
            <c:if test="${not empty error}">
                <p class="register-status register-error" role="alert"><c:out value="${error}"/></p>
            </c:if>

            <%-- 입력값을 ProductRegisterC의 doPost()로 보낸다. --%>

            <form action="${pageContext.request.contextPath}/product-register" method="post" enctype="multipart/form-data">
                <%-- DAO에서 getFilesystemName("file")로 대표 이미지 파일을 받는다. --%>
                <label class="register-field">대표 이미지
                    <input type="file" id="product-image-file" name="file"
                           accept="image/jpeg,image/png">
                </label>

                <%-- 사진을 고르면 미리보기 주소를 넣고 이미지를 표시한다. --%>
                <img id="product-image-preview" class="register-image"
                     alt="선택한 상품 사진" hidden>
                <%-- 저장 실패로 폼에 돌아오면 직전에 입력한 값을 다시 보여준다. --%>
                <label class="register-field">상품명
                    <input type="text" name="title" maxlength="30" required
                           value="<c:out value='${param.title}'/>">
                </label>

                <label class="register-field">설명
                    <textarea name="description" maxlength="500"><c:out value="${param.description}"/></textarea>
                </label>

                <label class="register-field">카테고리 번호
                    <input type="number" name="categoryId" min="1" step="1" required
                           value="<c:out value='${param.categoryId}'/>">
                </label>

                <label class="register-field">판매가 (원)
                    <input type="number" name="price" min="0" max="9999999999" step="1" required
                           value="<c:out value='${param.price}'/>">
                </label>

                <div class="register-actions">
                    <button type="submit" class="fliq-button fliq-button--primary">상품 등록</button>
                    <a class="fliq-button" href="${pageContext.request.contextPath}/home">홈으로</a>
                </div>
            </form>
        </section>
    </main>
</div>
<%-- 사진 입력칸과 미리보기 태그가 만들어진 뒤 실행한다. --%>
<script src="${pageContext.request.contextPath}/product-reg/proudct-form.js"></script>
</body>
</html>
