package com.fliq.fliq.chat;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@AllArgsConstructor
@NoArgsConstructor
@Data
public class ChatRoomDTO {
    private long cr_id;
    private long cr_product_id;
    private long cr_seller_id;
    private long cr_buyer_id;
}
