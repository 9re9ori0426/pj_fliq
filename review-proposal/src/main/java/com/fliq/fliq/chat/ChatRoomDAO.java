package com.fliq.fliq.chat;

import com.fliq.fliq.MyBatisDB;
import org.apache.ibatis.session.SqlSession;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ChatRoomDAO {
    public static List<ChatRoomDTO> listForUser(long userId) throws IOException {
        try (SqlSession session = MyBatisDB.connect()) {
            return session.selectList("chatMapper.listChatRoomsForUser", userId);
        }
    }

    public static ChatRoomDTO findForUser(long roomId, long userId) throws IOException {
        Map<String, Long> params = new HashMap<>();
        params.put("roomId", roomId);
        params.put("userId", userId);
        try (SqlSession session = MyBatisDB.connect()) {
            return session.selectOne("chatMapper.findChatRoomByRoomId", params);
        }
    }
}
