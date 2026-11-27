package com.fliq.fliq.productregister;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.nio.file.Files;
import java.nio.file.LinkOption;
import java.nio.file.NoSuchFileException;
import java.nio.file.Path;

@WebServlet("/productFile/*")
public class ProductImageC extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String path = request.getPathInfo();
        if (path == null || !path.matches("/product-[0-9]+\\.png")) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        Path file = ProductRegisterImage.directory().resolve(path.substring(1));
        if (!Files.isRegularFile(file, LinkOption.NOFOLLOW_LINKS)) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        try (InputStream input = Files.newInputStream(file, LinkOption.NOFOLLOW_LINKS)) {
            response.setContentType("image/png");
            OutputStream output = response.getOutputStream();
            byte[] buffer = new byte[8192];
            int count;
            while ((count = input.read(buffer)) != -1) {
                output.write(buffer, 0, count);
            }
        } catch (NoSuchFileException e) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }
}
