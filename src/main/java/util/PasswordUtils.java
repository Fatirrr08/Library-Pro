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
        // jBCrypt hanya support $2a$ dan $2y$, bukan $2b$ — konversi jika perlu
        String normalized = hashedPassword.startsWith("$2b$") ? "$2y$" + hashedPassword.substring(4) : hashedPassword;
        return BCrypt.checkpw(plainPassword, normalized);
    }

    public static boolean isHashed(String password) {
        return password != null && (password.startsWith("$2a$") || password.startsWith("$2b$") || password.startsWith("$2y$"));
    }
}
