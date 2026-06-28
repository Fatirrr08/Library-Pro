package exception;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.DisplayName;
import static org.junit.jupiter.api.Assertions.*;

@DisplayName("BookNotFoundException Test")
class BookNotFoundExceptionTest {

    @Test
    @DisplayName("Exception harus menyimpan bookId dengan benar")
    void testBookIdField() {
        BookNotFoundException ex = new BookNotFoundException(42);
        assertEquals(42, ex.getBookId());
    }

    @Test
    @DisplayName("Exception message harus mengandung bookId")
    void testMessage() {
        BookNotFoundException ex = new BookNotFoundException(42);
        assertTrue(ex.getMessage().contains("42"),
            "Pesan exception harus menyebut ID buku yang tidak ditemukan");
    }

    @Test
    @DisplayName("Exception harus instanceof RuntimeException (unchecked)")
    void testIsRuntimeException() {
        BookNotFoundException ex = new BookNotFoundException(1);
        assertInstanceOf(RuntimeException.class, ex,
            "[OOP: Inheritance] BookNotFoundException extends RuntimeException");
    }

    @Test
    @DisplayName("Exception harus bisa di-throw dan di-catch")
    void testThrowAndCatch() {
        assertThrows(BookNotFoundException.class, () -> {
            throw new BookNotFoundException(99);
        });
    }
}
