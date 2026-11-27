package com.fliq.fliq.chat;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@AllArgsConstructor
@NoArgsConstructor
@Data
public class ChatRoomDTO {
//  CHAT_ROOM 정보
    private long cr_id;
    private long cr_product_id;
    private long cr_seller_id;
    private long cr_buyer_id;
//  PRODUCT 정보
    private String p_title;
    private String p_sale_status;
    private String pi_storage;
    private Long display_price;
    private String price_label; // 판매가, 현재 경매가, 시작가, 낙찰가
}
