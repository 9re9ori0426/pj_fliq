package com.fliq.fliq.chat;

import com.fliq.fliq.signup.SignupDAO;
import com.fliq.fliq.signup.SignupDTO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/chat")
public class ChatC extends HttpServlet {

    public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        // 세션 연결
        HttpSession ss = request.getSession(false);
        // 이전에 user로 정보 받아온거 있는지 확인하고 대입
        SignupDTO user = ss == null ? null : (SignupDTO) ss.getAttribute("user");

        // 로그인 안되어있으면 로그인 컨트롤러로 보냄
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // userId로 사용자가 갖고 있는 채팅방들 불러오기
        ChatRoomDAO.chatRooms(request, user.getU_id());
        // chatRooms.jsp에서 채팅방들 보여줌
        request.getRequestDispatcher("/chat/chatRooms.jsp").forward(request, response);
    }

    public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {

    }

}