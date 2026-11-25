package com.fliq.fliq.login;

import com.fliq.fliq.signup.SignupDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/login")
public class LoginC extends HttpServlet {
    public void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
            // 로그인 체크 로직
        if (SignupDAO.loginCheck(request)) {
            response.sendRedirect(request.getContextPath() + "/home");
        } else {
            request.getRequestDispatcher("/user/login.jsp")
                    .forward(request, response);
        }
    }

    // 폼에서 제출한 이메일과 비밀번호로 기존 DAO에 로그인을 요청.
    public void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {

        request.setCharacterEncoding("UTF-8");

        // 로그아웃 요청이면 여기서 처리하고 종료한다.
        if ("logout".equals(request.getParameter("action"))) {
            SignupDAO.logout(request);
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }
        // 로그인 처리
        SignupDAO.login(request);

        if (SignupDAO.loginCheck(request)) {
            // 성공하면 홈으로 이동한다.
            response.sendRedirect(request.getContextPath() + "/home");
        } else {
            // 실패하면 DAO가 담은 msg와 함께 로그인 폼을 다시 보여줌
            request.getRequestDispatcher("/user/login.jsp")
                    .forward(request, response);
        }
    }
}