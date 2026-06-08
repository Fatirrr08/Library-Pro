package interfaces;

public interface Transaksi {
    boolean pinjam(int idUser, int idBuku);
    boolean kembalikan(int idPeminjaman);
}
