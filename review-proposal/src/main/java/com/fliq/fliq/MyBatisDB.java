package com.fliq.fliq;

import org.apache.ibatis.io.Resources;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.apache.ibatis.session.SqlSessionFactoryBuilder;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

public class MyBatisDB {
    private static SqlSessionFactory factory;

    public static SqlSession connect() throws IOException {
        return getFactory().openSession();
    }

    private static synchronized SqlSessionFactory getFactory() throws IOException {
        if (factory == null) {
            factory = buildFactory();
        }
        return factory;
    }

    private static SqlSessionFactory buildFactory() throws IOException {
        String url = System.getenv("FLIQ_DB_URL");
        String username = System.getenv("FLIQ_DB_USER");
        String password = System.getenv("FLIQ_DB_PASSWORD");
        SqlSessionFactoryBuilder builder = new SqlSessionFactoryBuilder();

        // 환경 변수를 쓰지 않는 기존 로컬 개발 환경의 설정도 읽는다.
        if (url == null && username == null && password == null) {
            try (InputStream input = Resources.getResourceAsStream("config.xml")) {
                return builder.build(input);
            } catch (IOException e) {
                throw new IOException("FLIQ_DB_URL, FLIQ_DB_USER, FLIQ_DB_PASSWORD 또는 로컬 config.xml을 설정해 주세요.", e);
            }
        }

        Properties properties = new Properties();
        properties.setProperty("db.url", required("FLIQ_DB_URL", url));
        properties.setProperty("db.username", required("FLIQ_DB_USER", username));
        properties.setProperty("db.password", required("FLIQ_DB_PASSWORD", password));
        try (InputStream input = Resources.getResourceAsStream("mybatis-config.xml")) {
            return builder.build(input, properties);
        }
    }

    private static String required(String name, String value) throws IOException {
        if (value == null || value.trim().isEmpty()) {
            throw new IOException(name + " 환경 변수를 설정해 주세요.");
        }
        return value;
    }
}
