package Model;

import java.io.UnsupportedEncodingException;
import java.math.BigInteger;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

public class mahoaMD5 {
	 /**
     * Mã hóa chuỗi text thành MD5
     * @param text - Chuỗi cần mã hóa (mật khẩu)
     * @return Chuỗi đã mã hóa MD5 (dạng hexa)
     */
    public static String encrypt(String text) throws NoSuchAlgorithmException, UnsupportedEncodingException {
        String encryptedText;
        
        // Tạo đối tượng MessageDigest với thuật toán MD5
        MessageDigest md = MessageDigest.getInstance("MD5");
        
        // Chuyển text thành mảng byte UTF-8
        byte[] sourceTextBytes = text.getBytes("UTF-8");
        
        // Mã hóa MD5
        byte[] encryptedTextBytes = md.digest(sourceTextBytes);
        
        // Chuyển mảng byte thành số BigInteger
        BigInteger bigInteger = new BigInteger(1, encryptedTextBytes);
        
        // Chuyển sang chuỗi hexa (hệ 16)
        encryptedText = bigInteger.toString(16);
        
        
        return encryptedText;

    }
}
