package com.fliq.fliq.product;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@AllArgsConstructor
@NoArgsConstructor
@Data
public class ProductDetailDTO {

    private long p_id;
    private  String p_title;
    private  String p_description;
    private  long p_sale_price;
    private String p_sale_status;
    private String p_trade_ok;
    private String pi_storage;


}
