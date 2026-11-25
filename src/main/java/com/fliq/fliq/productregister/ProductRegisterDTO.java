package com.fliq.fliq.productregister;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@AllArgsConstructor
@NoArgsConstructor
@Data

public class ProductRegisterDTO {
    private long p_users_id;        // 로그인한 판매자의 회원 번호
    private long p_category_id;     // 폼에서 선택한 카테고리 번호
    private String p_trade_ok;      // 교환 허용 Y, 미허용 N
    private String p_title;         // 상품명
    private String p_description;   // 상품 설명
    private long p_sale_price;      // 일반판매 가격
    private long p_id;          // 상품과 대표 이미지에 공통으로 사용할 번호
    private String pi_storage;  // 서버에 저장한 대표 이미지의 파일 키
}
