package util;

import org.mindrot.jbcrypt.BCrypt;

public class PasswordUtils {

    public static String hash(String plainPassword) {
        return BCrypt.hashpw(plainPassword, BCrypt.gensalt());
    }

    public static boolean verify(String plainPassword, String hashedPassword) {
        if (hashedPassword == null) return false;
        if (!hashedPassword.startsWith("$2a$") && !hashedPassword.startsWith("$2b$")) {
            return hashedPassword.equals(plainPassword);
        }
        return BCrypt.checkpw(plainPassword, hashedPassword);
    }

    public static boolean isHashed(String password) {
        return password != null && (password.startsWith("$2a$") || password.startsWith("$2b$"));
    }
}
