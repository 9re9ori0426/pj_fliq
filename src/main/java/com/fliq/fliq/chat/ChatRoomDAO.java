package com.fliq.fliq.chat;

import com.fliq.fliq.MyBatisDB;
import org.apache.ibatis.session.SqlSession;

import javax.servlet.http.HttpServletRequest;
import java.util.List;

public class ChatRoomDAO {
    // userId로 채팅방들의 정보를 찾아서 rooms로 넘김
    public static void chatRooms(HttpServletRequest request, long userId) {
        try (SqlSession ss = MyBatisDB.connect()) {
            List<ChatRoomDTO> rooms = ss.selectList("chatMapper.findChatRooms", userId);

            request.setAttribute("rooms", rooms);
        }
        catch (Exception e) {
            e.printStackTrace();
        }
    }
}

