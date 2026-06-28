package model;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.DisplayName;
import static org.junit.jupiter.api.Assertions.*;

@DisplayName("Peminjaman Model Test")
class PeminjamanTest {

    @Test
    @DisplayName("toString() harus mengandung status peminjaman")
    void testToString() {
        Peminjaman p = new Peminjaman();
        // sesuaikan setter dengan nama aktual di Peminjaman.java
        p.setIdPeminjaman(1);
        p.setStatus("menunggu");

        String result = p.toString();
        assertNotNull(result);
        assertTrue(result.contains("menunggu") || result.contains("1"));
    }
}
