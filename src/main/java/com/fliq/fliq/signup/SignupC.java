package com.fliq.fliq.signup;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/sign-up")
public class SignupC extends HttpServlet {

    public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        request.getRequestDispatcher("/user/signup.jsp").
                forward(request, response);
    }

    public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        request.setCharacterEncoding("UTF-8");
        if (SignupDAO.addUser(request)) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        // 가입에 실패하면 DAO가 담은 메시지를 같은 요청으로 JSP에 전달한다.
        request.getRequestDispatcher("/user/signup.jsp").forward(request, response);
    }
}