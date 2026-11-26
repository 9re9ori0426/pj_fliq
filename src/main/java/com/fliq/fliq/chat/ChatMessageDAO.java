package com.fliq.fliq.chat;

import com.fliq.fliq.MyBatisDB;
import org.apache.ibatis.session.SqlSession;

import javax.servlet.http.HttpServletRequest;
import java.util.List;

public class ChatMessageDAO {

//  room id를 받아서 select로 조회된 메시지들을 attribute로 보냄.
    public static void getChatMessagesByRoomId(HttpServletRequest request, long roomId) {
        try (SqlSession ss = MyBatisDB.connect()) {
            List<ChatMessageDTO> messages = ss.selectList("chatMapper.findChatMessagesByRoomId", roomId);
            request.setAttribute("messages", messages);
        }
        catch (Exception e) {
            e.printStackTrace();
        }
    }
}
