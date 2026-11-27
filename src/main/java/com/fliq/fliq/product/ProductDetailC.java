package com.fliq.fliq.product;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/product-detail")
public class ProductDetailC extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 목록에서 상품을 누르면 주소에 ?productId=상품번호가 붙음
        String idText = request.getParameter("productId");

        long productId;
        try {
            productId = Long.parseLong(idText);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        if (productId <= 0) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        // DAO에서 일반판매 상품을 조회해서 request의 "product"에 담음
        ProductDetailDAO.LDAO.selectProductDetail(request, productId);

        // 없는 상품이거나 삭제된 상품이면 404
        if (request.getAttribute("product") == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        request.getRequestDispatcher("/WEB-INF/views/product-detail.jsp")
                .forward(request, response);
    }
}