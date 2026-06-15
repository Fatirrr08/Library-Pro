package dao;

import config.DBConnection;
import interfaces.Transaksi;
import model.Peminjaman;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;

public class PeminjamanDAO implements Transaksi {

    private BukuDAO bukuDAO = new BukuDAO();

    @Override
    public boolean pinjam(int idUser, int idBuku) {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        boolean success = false;

        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            String checkStockSql = "SELECT jml_buku FROM buku WHERE id_buku = ?";
            ps = conn.prepareStatement(checkStockSql);
            ps.setInt(1, idBuku);
            rs = ps.executeQuery();

            int stokBuku = 0;
            if (rs.next()) {
                stokBuku = rs.getInt("jml_buku");
            }
            
            rs.close();
            ps.close();

            if (stokBuku > 0) {
                // SEKARANG: tanggal_pinjam langsung diisi CURRENT_DATE saat mengajukan
                String insertBorrowSql = "INSERT INTO peminjaman (id_user, id_buku, tanggal_pinjam, tanggal_tenggat, tanggal_kembali, status, denda) VALUES (?, ?, CURRENT_DATE, NULL, NULL, 'menunggu', 0)";
                ps = conn.prepareStatement(insertBorrowSql);
                ps.setInt(1, idUser);
                ps.setInt(2, idBuku);
                ps.executeUpdate();

                conn.commit();
                success = true;
            }
        } catch (Exception e) {
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            }
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            } catch (SQLException ex) { ex.printStackTrace(); }
        }
        return success;
    }

    // Fungsi Otoritas Verifikasi untuk Admin (Setujui / Tolak)
    public boolean verifikasiPeminjaman(int idPeminjaman, String statusBaru) {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        boolean success = false;

        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            if ("disetujui".equalsIgnoreCase(statusBaru)) {
                String getBukuSql = "SELECT id_buku FROM peminjaman WHERE id_peminjaman = ?";
                ps = conn.prepareStatement(getBukuSql);
                ps.setInt(1, idPeminjaman);
                rs = ps.executeQuery();
                
                if (rs.next()) {
                    int idBuku = rs.getInt("id_buku");
                    
                    String updateStockSql = "UPDATE buku SET jml_buku = jml_buku - 1 WHERE id_buku = ? AND jml_buku > 0";
                    PreparedStatement psStock = conn.prepareStatement(updateStockSql);
                    psStock.setInt(1, idBuku);
                    int rowsUpdated = psStock.executeUpdate();
                    psStock.close();
                    
                    if (rowsUpdated == 0) {
                        conn.rollback();
                        return false;
                    }
                }
                
                // ALUR BARU: Ambil tanggal hari ini (saat admin ACC)
                LocalDate tanggalAccHariIni = LocalDate.now();
                LocalDate batasKembali = tanggalAccHariIni.plusMonths(1); // Tenggat dihitung dari tanggal ACC

                // Jalankan UPDATE untuk memperbarui tanggal_pinjam lama menjadi tanggal_pinjam baru (waktu ACC)
                String updateStatusSql = "UPDATE peminjaman SET status = ?, tanggal_pinjam = ?, tanggal_tenggat = ? WHERE id_peminjaman = ?";
                PreparedStatement psStatus = conn.prepareStatement(updateStatusSql);
                psStatus.setString(1, statusBaru.toLowerCase());
                psStatus.setDate(2, Date.valueOf(tanggalAccHariIni)); // Mengganti tanggal pengajuan dengan tanggal ACC
                psStatus.setDate(3, Date.valueOf(batasKembali));
                psStatus.setInt(4, idPeminjaman);
                psStatus.executeUpdate();
                psStatus.close();

            } else {
                // Jika ditolak, cukup ubah status menjadi ditolak tanpa merubah tanggal pengajuan awal
                String updateStatusSql = "UPDATE peminjaman SET status = ? WHERE id_peminjaman = ?";
                PreparedStatement psStatus = conn.prepareStatement(updateStatusSql);
                psStatus.setString(1, statusBaru.toLowerCase());
                psStatus.setInt(2, idPeminjaman);
                psStatus.executeUpdate();
                psStatus.close();
            }

            conn.commit();
            success = true;
        } catch (Exception e) {
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            }
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            } catch (SQLException ex) { ex.printStackTrace(); }
        }
        return success;
    }

    @Override
    public boolean kembalikan(int idPeminjaman) {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        boolean success = false;

        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false); // Begin Transaction

            // 1. Ambil info peminjaman (ambil id_buku, tanggal_tenggat untuk mengunci denda akhir)
            String getBorrowInfoSql = "SELECT id_buku, tanggal_tenggat, status FROM peminjaman WHERE id_peminjaman = ?";
            ps = conn.prepareStatement(getBorrowInfoSql);
            ps.setInt(1, idPeminjaman);
            rs = ps.executeQuery();

            if (rs.next()) {
                String status = rs.getString("status");
                int idBuku = rs.getInt("id_buku");
                Date tglTenggat = rs.getDate("tanggal_tenggat");

                // Hanya buku berstatus 'disetujui' yang bisa dikembalikan
                if ("disetujui".equalsIgnoreCase(status)) {
                    
                    // Hitung denda final saat dikembalikan berdasarkan kolom tanggal_tenggat database
                    double dendaFinal = 0;
                    if (tglTenggat != null) {
                        LocalDate batasKembali = tglTenggat.toLocalDate();
                        LocalDate hariIni = LocalDate.now();
                        
                        if (hariIni.isAfter(batasKembali)) {
                            long selisihHari = ChronoUnit.DAYS.between(batasKembali, hariIni);
                            dendaFinal = selisihHari * 1000.0; // Rp 1.000 per hari terlambat
                        }
                    }

                    // 2. Update record peminjaman (tanggal_kembali = CURRENT_DATE, status = 'dikembalikan', denda dikunci)
                    String updateBorrowSql = "UPDATE peminjaman SET tanggal_kembali = CURRENT_DATE, status = 'dikembalikan', denda = ? WHERE id_peminjaman = ?";
                    PreparedStatement psUpdateBorrow = conn.prepareStatement(updateBorrowSql);
                    psUpdateBorrow.setDouble(1, dendaFinal);
                    psUpdateBorrow.setInt(2, idPeminjaman);
                    psUpdateBorrow.executeUpdate();
                    psUpdateBorrow.close();

                    // 3. Kembalikan jumlah stok buku perpustakaan (+1)
                    String updateStockSql = "UPDATE buku SET jml_buku = jml_buku + 1 WHERE id_buku = ?";
                    PreparedStatement psUpdateStock = conn.prepareStatement(updateStockSql);
                    psUpdateStock.setInt(1, idBuku);
                    psUpdateStock.executeUpdate();
                    psUpdateStock.close();

                    conn.commit(); // Commit Transaction
                    success = true;
                }
            }
        } catch (Exception e) {
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            }
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            } catch (SQLException ex) { ex.printStackTrace(); }
        }
        return success;
    }

    public List<Peminjaman> getAllPeminjaman() {
        List<Peminjaman> list = new ArrayList<>();
        try {
            Connection conn = DBConnection.getConnection();
            String sql = "SELECT p.*, u.username, u.nama_lengkap, b.judul AS judul_buku " +
                        "FROM peminjaman p " +
                        "JOIN user u ON p.id_user = u.id_user " +
                        "JOIN buku b ON p.id_buku = b.id_buku " +
                        "ORDER BY p.id_peminjaman DESC";
            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery(sql);
            
            LocalDate hariIni = LocalDate.now();

            while (rs.next()) {
                Peminjaman p = new Peminjaman();
                p.setIdPeminjaman(rs.getInt("id_peminjaman"));
                p.setIdUser(rs.getInt("id_user"));
                p.setIdBuku(rs.getInt("id_buku"));
                p.setTanggalPinjam(rs.getDate("tanggal_pinjam"));
                p.setTanggalKembali(rs.getDate("tanggal_kembali"));
                p.setStatus(rs.getString("status"));
                p.setUsername(rs.getString("username"));
                p.setNamaLengkap(rs.getString("nama_lengkap"));
                p.setJudulBuku(rs.getString("judul_buku"));
                
                // PEMBARUAN: Ambil data tanggal_tenggat langsung dari database
                p.setTanggalTenggat(rs.getDate("tanggal_tenggat"));
                
                double dendaTampil = rs.getDouble("denda");

                // HITUNG DENDA OTOMATIS BERJALAN (REAL-TIME) JIKA SEDANG DIPINJAM & LEWAT TENGGAT
                if ("disetujui".equalsIgnoreCase(p.getStatus()) && p.getTanggalTenggat() != null) {
                    LocalDate batasKembali = p.getTanggalTenggat().toLocalDate();
                    
                    if (hariIni.isAfter(batasKembali)) {
                        long selisihHari = ChronoUnit.DAYS.between(batasKembali, hariIni);
                        dendaTampil = selisihHari * 1000.0;
                    }
                }

                p.setDenda(dendaTampil);
                list.add(p);
            }
            rs.close(); st.close(); conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Peminjaman> getPeminjamanByUser(int idUser) {
        List<Peminjaman> list = new ArrayList<>();
        try {
            Connection conn = DBConnection.getConnection();
            String sql = "SELECT p.*, u.username, u.nama_lengkap, b.judul AS judul_buku " +
                        "FROM peminjaman p " +
                        "JOIN user u ON p.id_user = u.id_user " +
                        "JOIN buku b ON p.id_buku = b.id_buku " +
                        "WHERE p.id_user = ? " +
                        "ORDER BY p.id_peminjaman DESC";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, idUser);
            ResultSet rs = ps.executeQuery();
            
            LocalDate hariIni = LocalDate.now();

            while (rs.next()) {
                Peminjaman p = new Peminjaman();
                p.setIdPeminjaman(rs.getInt("id_peminjaman"));
                p.setIdUser(rs.getInt("id_user"));
                p.setIdBuku(rs.getInt("id_buku"));
                p.setTanggalPinjam(rs.getDate("tanggal_pinjam"));
                p.setTanggalKembali(rs.getDate("tanggal_kembali"));
                p.setStatus(rs.getString("status"));
                p.setUsername(rs.getString("username"));
                p.setNamaLengkap(rs.getString("nama_lengkap"));
                p.setJudulBuku(rs.getString("judul_buku"));
                
                // PEMBARUAN: Ambil data tanggal_tenggat langsung dari database
                p.setTanggalTenggat(rs.getDate("tanggal_tenggat"));
                
                double dendaTampil = rs.getDouble("denda");

                // Hitung denda real-time agar user juga bisa melihat denda berjalan mereka di dashboard-nya
                if ("disetujui".equalsIgnoreCase(p.getStatus()) && p.getTanggalTenggat() != null) {
                    LocalDate batasKembali = p.getTanggalTenggat().toLocalDate();
                    
                    if (hariIni.isAfter(batasKembali)) {
                        long selisihHari = ChronoUnit.DAYS.between(batasKembali, hariIni);
                        dendaTampil = selisihHari * 1000.0;
                    }
                }

                p.setDenda(dendaTampil);
                list.add(p);
            }
            rs.close(); ps.close(); conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public int getTotalPeminjaman() {
        int total = 0;
        try {
            Connection conn = DBConnection.getConnection();
            String sql = "SELECT COUNT(*) AS total FROM peminjaman";
            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery(sql);
            if (rs.next()) {
                total = rs.getInt("total");
            }
            rs.close(); st.close(); conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return total;
    }

    public int getTotalActivePeminjamanByUser(int idUser) {
        int total = 0;
        try {
            Connection conn = DBConnection.getConnection();
            String sql = "SELECT COUNT(*) AS total FROM peminjaman WHERE id_user = ? AND status = 'disetujui'";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, idUser);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                total = rs.getInt("total");
            }
            rs.close(); ps.close(); conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return total;
    }

    // Method untuk menghitung total buku yang SEDANG DIPINJAM (Status: disetujui)
    public int getTotalActivePeminjaman() {
        int total = 0;
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT COUNT(*) AS total FROM peminjaman WHERE status = 'disetujui'";
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            if (rs.next()) {
                total = rs.getInt("total");
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }
        return total;
    }

    // Method untuk menghitung total pengajuan yang BELUM DI-ACC (Status: menunggu)
    public int getTotalMenungguValidasi() {
        int total = 0;
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT COUNT(*) AS total FROM peminjaman WHERE status = 'menunggu'";
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            if (rs.next()) {
                total = rs.getInt("total");
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }
        return total;
    }
}