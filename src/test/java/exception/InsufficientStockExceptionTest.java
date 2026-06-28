package exception;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.DisplayName;
import static org.junit.jupiter.api.Assertions.*;

@DisplayName("InsufficientStockException Test")
class InsufficientStockExceptionTest {

    @Test
    @DisplayName("Exception harus menyimpan bookId dan availableStock")
    void testFields() {
        InsufficientStockException ex = new InsufficientStockException(5, 0);
        assertEquals(5, ex.getBookId());
        assertEquals(0, ex.getAvailableStock());
    }

    @Test
    @DisplayName("Exception message harus mengandung info stok")
    void testMessage() {
        InsufficientStockException ex = new InsufficientStockException(5, 0);
        String msg = ex.getMessage();
        assertTrue(msg.contains("5") && msg.contains("0"),
            "Pesan harus menyebut bookId dan stok tersedia");
    }

    @Test
    @DisplayName("Exception harus bisa di-throw dan di-catch")
    void testThrowAndCatch() {
        assertThrows(InsufficientStockException.class, () -> {
            throw new InsufficientStockException(3, 0);
        });
    }
}
