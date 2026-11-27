package com.fliq.fliq.productregister;

import com.fliq.fliq.MyBatisDB;
import com.oreilly.servlet.MultipartRequest;
import com.oreilly.servlet.multipart.DefaultFileRenamePolicy;
import org.apache.ibatis.session.SqlSession;

import javax.servlet.http.HttpServletRequest;
import java.io.File;
import java.nio.file.Files;

public class ProductRegisterDAO {

    // 컨트롤러가 로그인 세션에서 꺼낸 회원 번호를 sellerId로 받는다.
    public static boolean addProduct(HttpServletRequest request, long sellerId) {
        SqlSession ss = null;
        File uploadDir = null;
        File imageFile = null;
        boolean commitStarted = false;

        try {
            // 첨부 파일을 읽는 동안 사용할 임시 폴더를 만든다.
            uploadDir = Files.createTempDirectory("fliq-product-").toFile();

            // 상품 정보와 첨부 파일이 함께 들어오는 폼을 읽는다.
            // 등록 요청 전체는 5MB까지 받는다.
            MultipartRequest mr = new MultipartRequest(
                    request, uploadDir.getAbsolutePath(),
                    5 * 1024 * 1024, "UTF-8", new DefaultFileRenamePolicy()
            );

            String title = mr.getParameter("title");
            String description = mr.getParameter("description");

            if (title == null || title.trim().isEmpty() || title.trim().length() > 30) {
                request.setAttribute("error", "상품명을 1~30자로 입력해 주세요.");
                return false;
            }
            title = title.trim();

            // 비어 있는 설명은 매퍼에서 문자 타입의 NULL로 저장한다.
            if (description != null && description.trim().isEmpty()) {
                description = null;
            }
            if (description != null && description.length() > 500) {
                request.setAttribute("error", "설명은 500자까지 입력할 수 있습니다.");
                return false;
            }

            // 폼에서 문자열로 받은 카테고리 번호와 판매가를 숫자로 바꾼다.
            long categoryId = Long.parseLong(mr.getParameter("categoryId"));
            long price = Long.parseLong(mr.getParameter("price"));
            String productType = mr.getParameter("productType");
            String tradeOk = mr.getParameter("trade");
            if (categoryId <= 0 || price < 0 || price > 9999999999L) {
                request.setAttribute("error", "카테고리 번호와 판매가 범위를 확인해 주세요.");
                return false;
            }

            ss = MyBatisDB.connect();



            // JSP의 name="file"로 올라온 사진이 있으면 공개 이미지 폴더에 보관한다.
            File uploadedFile = mr.getFile("file");
            String imagePath = null;
            if (uploadedFile != null) {
                imageFile = ProductRegisterImage.save(uploadedFile);
                imagePath = "productFile/" + imageFile.getName();
            }

            ProductRegisterDTO product = new ProductRegisterDTO();
            product.setP_users_id(sellerId);
            product.setP_category_id(categoryId);
            product.setP_sale_type(productType);
            product.setP_trade_ok(tradeOk);
            product.setP_title(title);
            product.setP_description(description);
            product.setP_sale_price(price);
            product.setPi_storage(imagePath);

            System.out.println(product);

            if (ss.insert("productMapper.insertProduct", product) == 1) {
//                 상품이 먼저 있어야 그 상품 번호를 PRODUCT_IMAGE에서 참조할 수 있다.
                int p_id = product.getP_id();
                product.setPi_product_id(p_id);
                if (imagePath != null && ss.insert("productMapper.insertProductImage", product) != 1) {
                    request.setAttribute("error", "대표 이미지 정보를 저장하지 못했습니다.");
                    return false;
                }

//                 상품과 이미지 경로를 한 번에 확정한다.
                commitStarted = true;
                ss.commit();
                System.out.println("add complete");
                return true;
            }
        } catch (NumberFormatException e) {
            request.setAttribute("error", "카테고리 번호와 판매가는 정수로 입력해 주세요.");
            return false;
        } catch (IllegalArgumentException e) {
            request.setAttribute("error", e.getMessage());
            return false;
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
//                 커밋되지 않은 INSERT는 세션을 닫을 때 롤백된다.
                if (ss != null) {
                    ss.close();
                }
            } finally {
//                 DB가 커밋을 받기 전에 실패한 경우 새로 만든 이미지도 지운다.
                if (!commitStarted && imageFile != null) {
                    ProductRegisterImage.delete(imageFile);
                }
                ProductRegisterImage.clearUploads(uploadDir);
            }
        }

        request.setAttribute("error", "상품을 저장하지 못했습니다. 다시 시도해 주세요.");
        return false;
    }

    public static void selectAllCategory(HttpServletRequest request) {

        try (SqlSession ss = MyBatisDB.connect()) {
           request.setAttribute("categories",ss.selectList("productMapper.selectAllCategory"));
            System.out.println(request.getAttribute("categories"));
        } catch (Exception e) {
            e.printStackTrace();
        }


    }
}