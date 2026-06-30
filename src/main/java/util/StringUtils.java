package util;

public class StringUtils {

    public static String escapeHtml(String input) {
        if (input == null) return "";
        return input
                .replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;")
                .replace("'", "&#39;");
    }

    public static String escapeHtml(Object input) {
        return input == null ? "" : escapeHtml(input.toString());
    }
}
