package model.enums; // [OOP: Enum] berada di sub-package model.enums

/**
 * [OOP: Enum] Type-safe representation untuk status peminjaman buku.
 * Menggantikan raw String yang rawan typo di PeminjamanDAO.
 */
public enum StatusPeminjaman {

    MENUNGGU("menunggu"),
    DISETUJUI("disetujui"),
    DITOLAK("ditolak"),
    DIPINJAM("dipinjam"),
    DIKEMBALIKAN("dikembalikan");

    // [OOP: Encapsulation] field private, hanya bisa diakses via getter
    private final String value;

    // [OOP: Constructor] enum constructor untuk set value
    StatusPeminjaman(String value) {
        this.value = value;
    }

    public String getValue() {
        return value;
    }

    /**
     * [OOP: Static Method] Factory method untuk parsing String dari DB ke enum.
     * Gunakan ini saat membaca ResultSet dari query peminjaman.
     */
    public static StatusPeminjaman fromValue(String value) {
        for (StatusPeminjaman s : values()) {
            if (s.value.equalsIgnoreCase(value)) return s;
        }
        // ponytail: fallback ke MENUNGGU daripada throw exception,
        // supaya data lama yang tidak dikenal tidak crash aplikasi
        return MENUNGGU;
    }
}
