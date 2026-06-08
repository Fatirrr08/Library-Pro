package dao;

import config.DBConnection;
import interfaces.Transaksi;
import model.Peminjaman;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

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
            conn.setAutoCommit(false); // Begin Transaction

            // 1. Check stock of book
            String checkStockSql = "SELECT jml_buku FROM buku WHERE id_buku = ?";
            ps = conn.prepareStatement(checkStockSql);
            ps.setInt(1, idBuku);
            rs = ps.executeQuery();

            int stokBuku = -1;
            if (rs.next()) {
                stokBuku = rs.getInt("jml_buku");
            }
            int userId = idUser;
            System.out.println("ID Buku = " + idBuku);
            System.out.println("Stok Buku = " + stokBuku);
            System.out.println("User ID = " + userId);

            if (stokBuku > 0) {
                // 2. Reduce stock by 1
                String updateStockSql = "UPDATE buku SET jml_buku = jml_buku - 1 WHERE id_buku = ?";
                PreparedStatement psUpdate = conn.prepareStatement(updateStockSql);
                psUpdate.setInt(1, idBuku);
                psUpdate.executeUpdate();
                psUpdate.close();

                // 3. Insert Peminjaman record
                String insertBorrowSql = "INSERT INTO peminjaman (id_user, id_buku, tanggal_pinjam, status) VALUES (?, ?, CURRENT_DATE, 'dipinjam')";
                PreparedStatement psInsert = conn.prepareStatement(insertBorrowSql);
                psInsert.setInt(1, idUser);
                psInsert.setInt(2, idBuku);
                psInsert.executeUpdate();
                psInsert.close();

                conn.commit(); // Commit Transaction
                success = true;
            }
        } catch (Exception e) {
            if (conn != null) {
                try {
                    conn.rollback(); // Rollback if error
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            e.printStackTrace();
        } finally {
            try {
                if (rs != null)
                    rs.close();
                if (ps != null)
                    ps.close();
                if (conn != null)
                    conn.close();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
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

            // 1. Fetch borrowing info (to know id_buku and check if not already returned)
            String getBorrowInfoSql = "SELECT id_buku, status FROM peminjaman WHERE id_peminjaman = ?";
            ps = conn.prepareStatement(getBorrowInfoSql);
            ps.setInt(1, idPeminjaman);
            rs = ps.executeQuery();

            if (rs.next()) {
                String status = rs.getString("status");
                int idBuku = rs.getInt("id_buku");

                if ("dipinjam".equalsIgnoreCase(status)) {
                    // 2. Update Peminjaman record (tanggal_kembali = CURRENT_DATE, status =
                    // 'dikembalikan')
                    String updateBorrowSql = "UPDATE peminjaman SET tanggal_kembali = CURRENT_DATE, status = 'dikembalikan' WHERE id_peminjaman = ?";
                    PreparedStatement psUpdateBorrow = conn.prepareStatement(updateBorrowSql);
                    psUpdateBorrow.setInt(1, idPeminjaman);
                    psUpdateBorrow.executeUpdate();
                    psUpdateBorrow.close();

                    // 3. Increase stock of book by 1
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
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            e.printStackTrace();
        } finally {
            try {
                if (rs != null)
                    rs.close();
                if (ps != null)
                    ps.close();
                if (conn != null)
                    conn.close();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
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
                list.add(p);
            }
            rs.close();
            st.close();
            conn.close();
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
                list.add(p);
            }
            rs.close();
            ps.close();
            conn.close();
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
            rs.close();
            st.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return total;
    }

    public int getTotalActivePeminjamanByUser(int idUser) {
        int total = 0;
        try {
            Connection conn = DBConnection.getConnection();
            String sql = "SELECT COUNT(*) AS total FROM peminjaman WHERE id_user = ? AND status = 'dipinjam'";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, idUser);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                total = rs.getInt("total");
            }
            rs.close();
            ps.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return total;
    }
}
