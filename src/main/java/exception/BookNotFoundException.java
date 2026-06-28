package exception;

/**
 * [OOP: Custom Exception] Dilempar ketika buku dengan ID tertentu
 * tidak ditemukan di database. Extends RuntimeException supaya
 * tidak memaksa semua caller menulis try-catch (unchecked exception).
 *
 * [OOP: Inheritance] BookNotFoundException mewarisi RuntimeException
 * dan meng-override pesan error dengan konteks domain yang spesifik.
 */
public class BookNotFoundException extends RuntimeException {

    private final int bookId;

    // [OOP: Constructor overloading] dua constructor untuk dua use case
    public BookNotFoundException(int bookId) {
        super("Buku dengan ID " + bookId + " tidak ditemukan.");
        this.bookId = bookId;
    }

    public BookNotFoundException(String message) {
        super(message);
        this.bookId = -1;
    }

    public int getBookId() {
        return bookId;
    }
}
