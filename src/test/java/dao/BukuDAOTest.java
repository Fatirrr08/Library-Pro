package dao;

import model.Buku;
import org.junit.jupiter.api.*;
import static org.junit.jupiter.api.Assertions.*;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.List;

/**
 * Integration test untuk BukuDAO.
 * Test ini hit DB asli — pastikan env vars DB sudah di-set sebelum run.
 *
 * Strategy cleanup: setiap test data yang diinsert diberi penanda unik
 * ("TEST_DATA_") dan dihapus di @AfterEach supaya tidak polusi data real.
 */
@Tag("integration")
@DisplayName("BukuDAO Integration Test")
class BukuDAOTest {

    private BukuDAO dao;
    private static final String TEST_MARKER = "TEST_DATA_JUNIT";

    @BeforeEach
    void setUp() {
        dao = new BukuDAO();
    }

    @AfterEach
    void tearDown() {
        // Hapus semua data test yang dibuat — wajib jalan setelah setiap test
        String sql = "DELETE FROM buku WHERE judul LIKE '%" + TEST_MARKER + "%'";
        try (Connection conn = config.DBConnection.getConnection()) {
            if (conn != null) {
                try (PreparedStatement ps = conn.prepareStatement(sql)) {
                    ps.executeUpdate();
                }
            }
        } catch (SQLException e) {
            System.err.println("Warning: tearDown gagal membersihkan test data: " + e.getMessage());
        }
    }

    @Test
    @DisplayName("getAllBuku() harus return list (boleh kosong, tidak boleh null)")
    void testGetAllBukuNotNull() {
        List<Buku> result = dao.getAllBuku();
        assertNotNull(result, "getAllBuku() tidak boleh return null");
    }

    @Test
    @DisplayName("insert() harus berhasil eksekusi tanpa throw exception")
    void testInsert() {
        Buku buku = new Buku();
        // sesuaikan setter dan nilai dengan schema aktual
        // PENTING: judul harus mengandung TEST_MARKER supaya tearDown bersih
        buku.setJudul("Judul " + TEST_MARKER);
        buku.setPenulis("Penulis Test");
        buku.setPenerbit("Penerbit Test");
        buku.setTahunTerbit(2023);
        buku.setJmlBuku(5);
        buku.setIsbn("123-TEST");
        buku.setAbstraksi("Test abstr");
        
        // id_kategori boleh null/kosong tapi jika diset pastikan ada
        // kita tidak usah set id_kategori jika tidak yakin tabel kategori sudah terisi
        
        assertDoesNotThrow(() -> {
            dao.insert(buku);
        }, "insert() tidak boleh throw exception jika insert berhasil");
    }

    @Test
    @DisplayName("getBukuById() harus throw BookNotFoundException jika ID tidak ada")
    void testGetBukuByIdNotFound() {
        // ID 999999 hampir pasti tidak ada di DB
        assertThrows(exception.BookNotFoundException.class, () -> {
            dao.getBukuById(999999);
        }, "[OOP: Custom Exception] getBukuById harus throw BookNotFoundException jika tidak ditemukan");
    }
}
