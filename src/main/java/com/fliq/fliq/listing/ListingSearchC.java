package com.fliq.fliq.listing;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/product-listing")
public class ListingSearchC extends HttpServlet {

    public void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {

        ListingSearchDAO.LDAO.listingSearch(request);

        // 검색어가 비어 있으면 홈에서 최근 상품을 조회하도록 이동한다.
        if ("".equals(request.getAttribute("keyword"))) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }
        // 검색어가 있으면 조회 결과를 같은 요청으로 index.jsp에 전달한다.
        request.getRequestDispatcher("/index.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

    }
}