package com.fliq.fliq.chat;

import com.fliq.fliq.MyBatisDB;
import org.apache.ibatis.session.SqlSession;

import java.io.IOException;
import java.util.List;

public class ChatMessageDAO {
    public static List<ChatMessageDTO> listForRoom(long roomId) throws IOException {
        try (SqlSession session = MyBatisDB.connect()) {
            return session.selectList("chatMapper.findChatMessagesByRoomId", roomId);
        }
    }
}
