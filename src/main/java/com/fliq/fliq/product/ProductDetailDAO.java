package com.fliq.fliq.product;

import com.fliq.fliq.MyBatisDB;
import org.apache.ibatis.session.SqlSession;

import javax.servlet.http.HttpServletRequest;
import java.io.IOException;

public class ProductDetailDAO {

    public static final ProductDetailDAO LDAO = new ProductDetailDAO();

    private ProductDetailDAO() {
    }

    public void selectProductDetail(HttpServletRequest request, long productId)
            throws IOException {

        SqlSession ss = MyBatisDB.connect();

        try {
            ProductDetailDTO product =
                    ss.selectOne("productMapper.selectProductDetail", productId);

            request.setAttribute("product", product);
        } finally {
            ss.close();
        }
    }
}