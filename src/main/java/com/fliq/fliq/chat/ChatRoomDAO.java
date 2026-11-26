package com.fliq.fliq.chat;

import com.fliq.fliq.MyBatisDB;
import org.apache.ibatis.session.SqlSession;

import javax.servlet.http.HttpServletRequest;
import java.util.List;

public class ChatRoomDAO {

    public static void getChatRoomById(HttpServletRequest request, long roomId) {
        try (SqlSession ss = MyBatisDB.connect()) {
            ChatRoomDTO room = ss.selectOne("chatMapper.findChatRoomByRoomId", roomId);
            request.setAttribute("room", room);
        }
        catch (Exception e) {
            e.printStackTrace();
        }
    }
}
