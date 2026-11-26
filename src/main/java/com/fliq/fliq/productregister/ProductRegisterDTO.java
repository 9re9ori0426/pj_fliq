package com.fliq.fliq.productregister;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Date;

@AllArgsConstructor
@NoArgsConstructor
@Data

public class ProductRegisterDTO {
    private int p_id;
    private long p_users_id;        // 로그인한 판매자의 회원 번호
    private long p_category_id;     // 폼에서 선택한 카테고리 번호
    private String p_sale_type;
    private String p_trade_ok;      // 교환 허용 Y, 미허용 N
    private String p_title;         // 상품명
    private String p_description;   // 상품 설명
    private long p_sale_price;      // 일반판매 가격
    private String p_sale_status;        // 상태
    private Date p_created_at;
    private Date p_update_at;
    private Date p_deleted_at;
    private String pi_storage;  // 서버에 저장한 대표 이미지의 파일 키
    private int pi_product_id;
}
