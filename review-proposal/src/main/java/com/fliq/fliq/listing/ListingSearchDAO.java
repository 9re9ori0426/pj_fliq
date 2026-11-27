package com.fliq.fliq.listing;

import com.fliq.fliq.MyBatisDB;
import org.apache.ibatis.session.SqlSession;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public class ListingSearchDAO {

    public static  final ListingSearchDAO LDAO = new ListingSearchDAO();
    private ListingSearchDAO() {
    }

    public void recentProducts(HttpServletRequest request) throws IOException {
        SqlSession ss = MyBatisDB.connect();
        try {
            List<ListingSearchDTO> products = ss.selectList("productMapper.recentProducts");

            // 최근 상품 목록을 index.jsp에서 읽을 수 있게 담아 둔다.
            request.setAttribute("products", products);
        } finally {
            ss.close();
        }
    }
    public void listProducts(HttpServletRequest request, String saleType) throws IOException {
        try (SqlSession session = MyBatisDB.connect()) {
            List<ListingSearchDTO> products = session.selectList(
                    "productMapper.listProducts", Collections.singletonMap("saleType", saleType));
            request.setAttribute("products", products);
        }
    }

    public void listingSearch(HttpServletRequest request) throws IOException {
        String keyword = request.getParameter("keyword");
            // 검색어 없이 검색한 경우 빈 목록 전달
        if (keyword == null) {
            keyword = "";
        }
        keyword = keyword.trim();

        List<ListingSearchDTO> products = new ArrayList<>();

        if (!keyword.isEmpty()) {
            // 검색어 앞뒤에 %를 붙여 상품명이나 설명의 중간에 있는 단어도 찾는다.
            String pattern = "%" + keyword + "%";
            SqlSession ss = MyBatisDB.connect();
            try {
                // 매퍼 ID는 namespace.selectId 형식이다. pattern은 SQL의 #{pattern}에 전달한다.
                products = ss.selectList("productMapper.searchProducts", pattern);
            } finally {
                // 조회 중 예외가 발생해도 세션은 닫는다.
                ss.close();
            }
        }

        // ListingC가 검색 결과 JSP로 forward할 때 사용하는 요청 속성이다.
        request.setAttribute("keyword", keyword);
        request.setAttribute("products", products);
        // 현재 검색으로 조회한 상품 수를 결과 화면에 전달한다.
        request.setAttribute("resultCount", products.size());
    }
}
