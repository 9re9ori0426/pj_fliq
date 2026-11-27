package com.fliq.fliq.chat;

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
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        HttpSession session = request.getSession(false);
        SignupDTO user = session == null ? null : (SignupDTO) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String roomParameter = request.getParameter("roomId");
        if (roomParameter == null) {
            request.setAttribute("rooms", ChatRoomDAO.listForUser(user.getU_id()));
            request.getRequestDispatcher("/chat/chatRooms.jsp").forward(request, response);
            return;
        }

        long roomId;
        try {
            roomId = Long.parseLong(roomParameter);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }
        if (roomId <= 0) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        ChatRoomDTO room = ChatRoomDAO.findForUser(roomId, user.getU_id());
        if (room == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }
        request.setAttribute("room", room);
        request.setAttribute("messages", ChatMessageDAO.listForRoom(roomId));
        request.getRequestDispatcher("/chat/chatMessages.jsp").forward(request, response);
    }
}
