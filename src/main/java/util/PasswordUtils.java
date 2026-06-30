package util;

import org.mindrot.jbcrypt.BCrypt;

public class PasswordUtils {

    public static String hash(String plainPassword) {
        return BCrypt.hashpw(plainPassword, BCrypt.gensalt());
    }

    public static boolean verify(String plainPassword, String hashedPassword) {
        if (hashedPassword == null) return false;
        if (!hashedPassword.startsWith("$2a$") && !hashedPassword.startsWith("$2b$") && !hashedPassword.startsWith("$2y$")) {
            return hashedPassword.equals(plainPassword);
        }
        // jBCrypt 0.4 hanya support $2a$ — konversi $2b$/$2y$ ke $2a$
        String normalized = hashedPassword;
        if (normalized.startsWith("$2b$") || normalized.startsWith("$2y$")) {
            normalized = "$2a$" + normalized.substring(4);
        }
        return BCrypt.checkpw(plainPassword, normalized);
    }

    public static boolean isHashed(String password) {
        return password != null && (password.startsWith("$2a$") || password.startsWith("$2b$") || password.startsWith("$2y$"));
    }
}
