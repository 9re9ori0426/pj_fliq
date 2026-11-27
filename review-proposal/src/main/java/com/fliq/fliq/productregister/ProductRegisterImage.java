package com.fliq.fliq.productregister;

import javax.imageio.ImageIO;
import javax.imageio.ImageReader;
import javax.imageio.stream.ImageInputStream;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Iterator;

class ProductRegisterImage {

    static Path directory() throws IOException {
        String configured = System.getenv("FLIQ_UPLOAD_DIR");
        Path path = configured == null || configured.trim().isEmpty()
                ? Paths.get(System.getProperty("user.home"), ".fliq", "product-images")
                : Paths.get(configured);
        if (!path.isAbsolute()) {
            throw new IOException("FLIQ_UPLOAD_DIR에는 절대 경로를 지정해 주세요.");
        }
        return path.normalize();
    }

    static File save(File uploadedFile) throws IOException {
        BufferedImage image = read(uploadedFile);
        Path folder = Files.createDirectories(directory());

        // 원본 이름 대신 서버가 만든 이름으로 PNG 파일을 저장한다.
        File savedFile = Files.createTempFile(folder, "product-", ".png").toFile();
        boolean saved = false;
        try {
            saved = ImageIO.write(image, "png", savedFile);
            if (!saved) {
                throw new IOException("대표 이미지 파일을 저장하지 못했습니다.");
            }
            return savedFile;
        } finally {
            if (!saved) {
                delete(savedFile);
            }
        }
    }

    private static BufferedImage read(File uploadedFile) throws IOException {
        // 파일 내용에서 이미지 형식과 해상도를 확인한 뒤 실제 픽셀을 읽는다.
        try (ImageInputStream input = ImageIO.createImageInputStream(uploadedFile)) {
            if (input == null) {
                throw new IllegalArgumentException("대표 이미지 파일을 읽을 수 없습니다.");
            }

            Iterator<ImageReader> readers = ImageIO.getImageReaders(input);
            if (!readers.hasNext()) {
                throw new IllegalArgumentException("대표 이미지는 JPG 또는 PNG를 선택해 주세요.");
            }
            ImageReader reader = readers.next();
            try {
                reader.setInput(input);
                String format = reader.getFormatName();
                if (!"JPEG".equalsIgnoreCase(format) && !"PNG".equalsIgnoreCase(format)) {
                    throw new IllegalArgumentException("대표 이미지는 JPG 또는 PNG를 선택해 주세요.");
                }
                if ((long) reader.getWidth(0) * reader.getHeight(0) > 10000000L) {
                    throw new IllegalArgumentException("대표 이미지의 해상도가 너무 큽니다.");
                }
                return reader.read(0);
            } finally {
                reader.dispose();
            }
        }
    }

    static void clearUploads(File folder) {
        if (folder == null) {
            return;
        }
        File[] uploads = folder.listFiles();
        if (uploads != null) {
            for (File upload : uploads) {
                delete(upload);
            }
        }
        delete(folder);
    }

    static void delete(File file) {
        if (!file.delete()) {
            System.err.println("상품 이미지 파일 정리 실패: " + file.getName());
        }
    }
}
