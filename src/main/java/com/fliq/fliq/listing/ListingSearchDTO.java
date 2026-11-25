package com.fliq.fliq.listing;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

// MyBatis가 조회 결과를 담을 수 있도록 PRODUCT의 컬럼명과 필드명을 맞춘다.
@Data
@AllArgsConstructor
@NoArgsConstructor
public class ListingSearchDTO {
    private long p_id;       // 상품 상세 조회에 넘길 상품 번호
    private String p_title;  // 검색 결과 카드에 표시할 상품명

    private String p_sale_type; // 일반 판매와 경매 구분
    private long p_sale_price; // 일반판매 가격
    private String pi_storage; // DB에 저장된 대표 이미지 경로
}