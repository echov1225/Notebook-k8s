package com.imooc.notebook;

import org.apache.commons.codec.binary.Base64;
import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;

import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;

@SpringBootTest
class NotebookApplicationTests {

    @Test
    void contextLoads() {
    }

    @Test
    void SHA384() {
        File file = new File("/Users/shiwenwei/Life/Study/git/Notebook-k8s/notebook-service/src/main/resources/static/css/bootstrap.min.css");
        String sha384 = getFileSHA1(file, "SHA-256");
        System.out.println("文件 " + file + " SHA384值是:" + sha384);
        Base64 base64 = new Base64();
        System.out.println(base64.encodeAsString(sha384.getBytes(StandardCharsets.UTF_8)));
    }

    private static String getFileSHA1(File file, String hashType) {
        String str = "";
        try {
            str = getHash(file, hashType);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return str;
    }
    private static String getHash(File file, String hashType) throws Exception {
        InputStream fis = new FileInputStream(file);
        byte buffer[] = new byte[1024];
        MessageDigest md5 = MessageDigest.getInstance(hashType);
        for (int numRead = 0; (numRead = fis.read(buffer)) > 0; ) {
            md5.update(buffer, 0, numRead);
        }
        fis.close();
        return toHexString(md5.digest());
    }
    private static String toHexString(byte b[]) {
        StringBuilder sb = new StringBuilder();
        for (byte aB : b) {
            sb.append(Integer.toHexString(aB & 0xFF));
        }
        return sb.toString();
    }
}
