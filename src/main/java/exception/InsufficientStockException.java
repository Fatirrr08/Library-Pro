package exception;

/**
 * [OOP: Custom Exception] Dilempar ketika jumlah stok buku
 * tidak mencukupi untuk melayani permintaan peminjaman.
 *
 * [OOP: Inheritance] Extends RuntimeException (unchecked).
 */
public class InsufficientStockException extends RuntimeException {

    private final int bookId;
    private final int availableStock;

    public InsufficientStockException(int bookId, int availableStock) {
        super("Stok buku ID " + bookId + " tidak mencukupi. Stok tersedia: " + availableStock);
        this.bookId = bookId;
        this.availableStock = availableStock;
    }

    public int getBookId() { return bookId; }
    public int getAvailableStock() { return availableStock; }
}
