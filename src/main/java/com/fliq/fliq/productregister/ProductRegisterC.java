package com.fliq.fliq.productregister;

import com.fliq.fliq.signup.SignupDTO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/product-register")
public class ProductRegisterC extends HttpServlet {

    public void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {

        // 로그인한 회원에게 등록 폼을 보여준다.
        if (getLoginUser(request) == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // 등록 완료 주소로 들어오면 JSP에서 성공 문구를 보여준다.
        if ("1".equals(request.getParameter("registered"))) {
            request.setAttribute("registerSuccess", true);
        }
        ProductRegisterDAO.selectAllCategory(request);
        request.getRequestDispatcher("/listing/product-form.jsp")
                .forward(request, response);
    }

    public void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {

        // 등록 버튼을 누른 시점에도 로그인 세션이 남아 있는지 확인한다.
        SignupDTO user = getLoginUser(request);
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        request.setCharacterEncoding("UTF-8");

        // 폼 요청과 로그인한 회원의 번호를 DAO에 넘긴다.
        if (ProductRegisterDAO.addProduct(request, user.getU_id())) {
            response.sendRedirect(request.getContextPath() + "/product-register?registered=1");
            return;
        }

        // DAO가 담은 오류 메시지를 같은 요청으로 JSP에 전달한다.
        request.getRequestDispatcher("/listing/product-form.jsp")
                .forward(request, response);
    }

    private SignupDTO getLoginUser(HttpServletRequest request) {
        // 기존 세션만 확인한다. 세션이 없으면 새로 만들지 않는다.
        HttpSession session = request.getSession(false);
        if (session == null) {
            return null;
        }

        // 로그인할 때 user라는 이름으로 담은 회원 정보를 꺼낸다.
        return (SignupDTO) session.getAttribute("user");
    }
}