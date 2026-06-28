package model;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.DisplayName;
import static org.junit.jupiter.api.Assertions.*;

@DisplayName("Buku Model Test")
class BukuTest {

    private Buku buku;

    @BeforeEach
    void setUp() {
        buku = new Buku();
        // sesuaikan setter name dengan aktual di Buku.java
        buku.setIdBuku(1);
        buku.setJudul("Pemrograman Java");
        buku.setPenulis("John Doe");
    }

    @Test
    @DisplayName("Getter harus return nilai yang di-set")
    void testGetterSetter() {
        assertEquals(1, buku.getIdBuku());
        assertEquals("Pemrograman Java", buku.getJudul());
        assertEquals("John Doe", buku.getPenulis());
    }

    @Test
    @DisplayName("toString() harus mengandung judul buku")
    void testToString() {
        String result = buku.toString();
        assertNotNull(result);
        assertTrue(result.contains("Pemrograman Java"),
            "toString() harus mengandung judul buku");
        assertTrue(result.contains("1"),
            "toString() harus mengandung ID buku");
    }
}
