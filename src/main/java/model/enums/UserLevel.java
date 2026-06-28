package model.enums; // [OOP: Enum]

/**
 * [OOP: Enum] Type-safe representation untuk level/role user.
 * Nilai harus match dengan kolom `level` VARCHAR di tabel `user`.
 */
public enum UserLevel {

    ADMIN("admin"),
    ANGGOTA("anggota");

    private final String value; // [OOP: Encapsulation]

    UserLevel(String value) {
        this.value = value;
    }

    public String getValue() {
        return value;
    }

    public static UserLevel fromValue(String value) {
        for (UserLevel l : values()) {
            if (l.value.equalsIgnoreCase(value)) return l;
        }
        return ANGGOTA; // ponytail: default ke anggota untuk unknown values
    }
}
