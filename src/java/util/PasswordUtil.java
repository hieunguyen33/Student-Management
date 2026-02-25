package util;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

/**
 * Tiện ích mã hoá mật khẩu bằng MD5
 * Không cần thêm thư viện ngoài - dùng Java built-in
 */
public class PasswordUtil {

    /**
     * Mã hoá chuỗi thành MD5 hash (32 ký tự hex)
     */
    public static String md5(String input) {
        if (input == null) return "";
        try {
            MessageDigest md = MessageDigest.getInstance("MD5");
            byte[] hashBytes = md.digest(input.getBytes("UTF-8"));
            StringBuilder sb = new StringBuilder();
            for (byte b : hashBytes) {
                sb.append(String.format("%02x", b));
            }
            return sb.toString();
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("MD5 algorithm not found", e);
        } catch (Exception e) {
            throw new RuntimeException("Error hashing password", e);
        }
    }

    /**
     * Kiểm tra mật khẩu plaintext có khớp với hash không
     */
    public static boolean verify(String plaintext, String hash) {
        return md5(plaintext).equals(hash);
    }
}