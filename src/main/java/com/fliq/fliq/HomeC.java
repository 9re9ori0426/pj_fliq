package com.fliq.fliq;
import com.fliq.fliq.product.ProductSearchDAO;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet({"", "/home", "/product", "/products", "/sell"})
public class HomeC extends HttpServlet {

    public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        boolean saleOnly = "/sell".equals(request.getServletPath());
        ProductSearchDAO.PDAO.listProducts(request, saleOnly);
        request.setAttribute("saleOnly", saleOnly);
        request.getRequestDispatcher("/index.jsp").forward(request, response);
    }

    public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {

    }

}
