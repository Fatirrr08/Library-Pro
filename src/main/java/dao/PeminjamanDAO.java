package dao;

import config.DBConnection;
import interfaces.Transaksi;
import model.Peminjaman;
import model.enums.StatusPeminjaman;
import exception.BookNotFoundException;
import exception.InsufficientStockException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;

public class PeminjamanDAO extends BaseDAO implements Transaksi {

    @Override
    public String getEntityName() {
        return "Peminjaman";
    }

    private BukuDAO bukuDAO = new BukuDAO();

    @Override
    public boolean pinjam(int idUser, int idBuku) {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        boolean success = false;

        try {
            conn = DBConnection.getConnection();
            if (conn == null) return false;
            conn.setAutoCommit(false);

            String checkStockSql = "SELECT jml_buku FROM buku WHERE id_buku = ?";
            ps = conn.prepareStatement(checkStockSql);
            ps.setInt(1, idBuku);
            rs = ps.executeQuery();

            if (!rs.next()) {
                throw new BookNotFoundException(idBuku);
            }
            
            int stokBuku = rs.getInt("jml_buku");
            if (stokBuku <= 0) {
                throw new InsufficientStockException(idBuku, stokBuku);
            }
            
            rs.close();
            ps.close();

            if (stokBuku > 0) {
                String insertBorrowSql = "INSERT INTO peminjaman (id_user, id_buku, tanggal_pinjam, tanggal_tenggat, tanggal_kembali, status, denda) VALUES (?, ?, CURRENT_DATE, NULL, NULL, ?, 0)";
                ps = conn.prepareStatement(insertBorrowSql);
                ps.setInt(1, idUser);
                ps.setInt(2, idBuku);
                ps.setString(3, StatusPeminjaman.MENUNGGU.getValue());
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

    public boolean verifikasiPeminjaman(int idPeminjaman, String statusBaru) {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        boolean success = false;

        try {
            conn = DBConnection.getConnection();
            if (conn == null) return false;
            conn.setAutoCommit(false);

            if ("disetujui".equalsIgnoreCase(statusBaru) || "dipinjam".equalsIgnoreCase(statusBaru)) {
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
                
                LocalDate tanggalAccHariIni = LocalDate.now();
                LocalDate batasKembali = tanggalAccHariIni.plusMonths(1); 

                String updateStatusSql = "UPDATE peminjaman SET status = ?, tanggal_pinjam = ?, tanggal_tenggat = ? WHERE id_peminjaman = ?";
                PreparedStatement psStatus = conn.prepareStatement(updateStatusSql);
                psStatus.setString(1, StatusPeminjaman.fromValue(statusBaru).getValue());
                psStatus.setDate(2, Date.valueOf(tanggalAccHariIni)); 
                psStatus.setDate(3, Date.valueOf(batasKembali));
                psStatus.setInt(4, idPeminjaman);
                psStatus.executeUpdate();
                psStatus.close();

            } else {
                String updateStatusSql = "UPDATE peminjaman SET status = ? WHERE id_peminjaman = ?";
                PreparedStatement psStatus = conn.prepareStatement(updateStatusSql);
                psStatus.setString(1, StatusPeminjaman.fromValue(statusBaru).getValue());
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
            if (conn == null) return false;
            conn.setAutoCommit(false); 

            String getBorrowInfoSql = "SELECT id_buku, tanggal_tenggat, status FROM peminjaman WHERE id_peminjaman = ?";
            ps = conn.prepareStatement(getBorrowInfoSql);
            ps.setInt(1, idPeminjaman);
            rs = ps.executeQuery();

            if (rs.next()) {
                String status = rs.getString("status");
                int idBuku = rs.getInt("id_buku");
                Date tglTenggat = rs.getDate("tanggal_tenggat");

                if ("disetujui".equalsIgnoreCase(status) || "dipinjam".equalsIgnoreCase(status)) {
                    
                    long dendaFinal = 0;
                    if (tglTenggat != null) {
                        LocalDate batasKembali = tglTenggat.toLocalDate();
                        LocalDate hariIni = LocalDate.now();
                        
                        if (hariIni.isAfter(batasKembali)) {
                            long selisihHari = ChronoUnit.DAYS.between(batasKembali, hariIni);
                            dendaFinal = selisihHari * 1000; 
                        }
                    }

                    String updateBorrowSql = "UPDATE peminjaman SET tanggal_kembali = CURRENT_DATE, status = ?, denda = ? WHERE id_peminjaman = ?";
                    PreparedStatement psUpdateBorrow = conn.prepareStatement(updateBorrowSql);
                    psUpdateBorrow.setString(1, StatusPeminjaman.DIKEMBALIKAN.getValue());
                    psUpdateBorrow.setLong(2, dendaFinal);
                    psUpdateBorrow.setInt(3, idPeminjaman);
                    psUpdateBorrow.executeUpdate();
                    psUpdateBorrow.close();

                    String updateStockSql = "UPDATE buku SET jml_buku = jml_buku + 1 WHERE id_buku = ?";
                    PreparedStatement psUpdateStock = conn.prepareStatement(updateStockSql);
                    psUpdateStock.setInt(1, idBuku);
                    psUpdateStock.executeUpdate();
                    psUpdateStock.close();

                    conn.commit(); 
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
        String sql = "SELECT p.*, u.username, u.nama_lengkap, b.judul AS judul_buku " +
                    "FROM peminjaman p " +
                    "JOIN user u ON p.id_user = u.id_user " +
                    "JOIN buku b ON p.id_buku = b.id_buku " +
                    "ORDER BY p.id_peminjaman DESC";
        try (Connection conn = DBConnection.getConnection()) {
            if (conn == null) return list;
            try (Statement st = conn.createStatement();
                 ResultSet rs = st.executeQuery(sql)) {
                
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
                    
                    p.setTanggalTenggat(rs.getDate("tanggal_tenggat"));
                    
                    long dendaTampil = rs.getLong("denda");

                    if (("disetujui".equalsIgnoreCase(p.getStatus()) || "dipinjam".equalsIgnoreCase(p.getStatus())) && p.getTanggalTenggat() != null) {
                        LocalDate batasKembali = p.getTanggalTenggat().toLocalDate();
                        
                        if (hariIni.isAfter(batasKembali)) {
                            long selisihHari = ChronoUnit.DAYS.between(batasKembali, hariIni);
                            dendaTampil = selisihHari * 1000;
                        }
                    }

                    p.setDenda(dendaTampil);
                    list.add(p);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Peminjaman> getPeminjamanByUser(int idUser) {
        List<Peminjaman> list = new ArrayList<>();
        String sql = "SELECT p.*, u.username, u.nama_lengkap, b.judul AS judul_buku " +
                    "FROM peminjaman p " +
                    "JOIN user u ON p.id_user = u.id_user " +
                    "JOIN buku b ON p.id_buku = b.id_buku " +
                    "WHERE p.id_user = ? " +
                    "ORDER BY p.id_peminjaman DESC";
        try (Connection conn = DBConnection.getConnection()) {
            if (conn == null) return list;
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, idUser);
                try (ResultSet rs = ps.executeQuery()) {
                    
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
                        
                        p.setTanggalTenggat(rs.getDate("tanggal_tenggat"));
                        
                        long dendaTampil = rs.getLong("denda");

                        if (("disetujui".equalsIgnoreCase(p.getStatus()) || "dipinjam".equalsIgnoreCase(p.getStatus())) && p.getTanggalTenggat() != null) {
                            LocalDate batasKembali = p.getTanggalTenggat().toLocalDate();
                            
                            if (hariIni.isAfter(batasKembali)) {
                                long selisihHari = ChronoUnit.DAYS.between(batasKembali, hariIni);
                                dendaTampil = selisihHari * 1000;
                            }
                        }

                        p.setDenda(dendaTampil);
                        list.add(p);
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public int getTotalPeminjaman() {
        int total = 0;
        String sql = "SELECT COUNT(*) AS total FROM peminjaman";
        try (Connection conn = DBConnection.getConnection()) {
            if (conn == null) return 0;
            try (Statement st = conn.createStatement();
                 ResultSet rs = st.executeQuery(sql)) {
                if (rs.next()) {
                    total = rs.getInt("total");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return total;
    }

    public int getTotalActivePeminjamanByUser(int idUser) {
        int total = 0;
        String sql = "SELECT COUNT(*) AS total FROM peminjaman WHERE id_user = ? AND (status = 'disetujui' OR status = 'dipinjam')";
        try (Connection conn = DBConnection.getConnection()) {
            if (conn == null) return 0;
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, idUser);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        total = rs.getInt("total");
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return total;
    }

    public int getTotalActivePeminjaman() {
        int total = 0;
        String sql = "SELECT COUNT(*) AS total FROM peminjaman WHERE status = 'disetujui' OR status = 'dipinjam'";
        try (Connection conn = DBConnection.getConnection()) {
            if (conn == null) return 0;
            try (PreparedStatement ps = conn.prepareStatement(sql);
                 ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    total = rs.getInt("total");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return total;
    }

    public int getTotalMenungguValidasi() {
        int total = 0;
        String sql = "SELECT COUNT(*) AS total FROM peminjaman WHERE status = 'menunggu'";
        try (Connection conn = DBConnection.getConnection()) {
            if (conn == null) return 0;
            try (PreparedStatement ps = conn.prepareStatement(sql);
                 ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    total = rs.getInt("total");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return total;
    }
}
