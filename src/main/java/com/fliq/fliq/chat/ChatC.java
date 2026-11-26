package com.fliq.fliq.chat;

import com.fliq.fliq.signup.SignupDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/chat")
public class ChatC extends HttpServlet {

    public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {

        if (SignupDAO.loginCheck(request)) {
            request.getRequestDispatcher("chatMessages.jsp").forward(request, response);
        }
        else {
            request.getRequestDispatcher("/user/login.jsp").forward(request, response);
        }
    }

    public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {

    }

}