package com.fliq.fliq.chat;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@AllArgsConstructor
@NoArgsConstructor
@Data
public class ChatMessageDTO {
    private long cm_id;
    private long cm_sender_id;
    private String cm_text_body;
}
