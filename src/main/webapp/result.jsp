<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title> - Result - </title>
</head>
<body>
<div class="test-wrap">
    <c:forEach items="${tests}" var="t">
        <div class="items">
            <div>No. ${t.t_no}</div>
            <div>Name : ${t.t_name}</div>
        </div>
        <hr>
    </c:forEach>
</div>
</body>
</html>
