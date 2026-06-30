package dao;

import config.DBConnection;
import model.Buku;

import exception.BookNotFoundException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BukuDAO extends BaseDAO {

    @Override
    public String getEntityName() {
        return "Buku";
    }

    public void insert(Buku buku) {
        System.out.println("INSERT BUKU DIJALANKAN");
        String sql = "INSERT INTO buku (judul, penulis, penerbit, tahun_terbit, jml_buku, id_kategori, isbn, abstraksi) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection()) {
            if (conn == null) return;
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, buku.getJudul());
                ps.setString(2, buku.getPenulis());
                ps.setString(3, buku.getPenerbit());
                ps.setInt(4, buku.getTahunTerbit());
                ps.setInt(5, buku.getJmlBuku());
                ps.setInt(6, buku.getIdKategori());
                ps.setString(7, buku.getIsbn());
                ps.setString(8, buku.getAbstraksi());

                int hasil = ps.executeUpdate();
                System.out.println("Data berhasil disimpan : " + hasil);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public List<Buku> getAllBuku() {
        List<Buku> list = new ArrayList<>();
        String sql = "SELECT * FROM buku";
        try (Connection conn = DBConnection.getConnection()) {
            if (conn == null) return list;
            try (Statement st = conn.createStatement();
                 ResultSet rs = st.executeQuery(sql)) {
                while (rs.next()) {
                    Buku buku = new Buku();
                    buku.setIdBuku(rs.getInt("id_buku"));
                    buku.setJudul(rs.getString("judul"));
                    buku.setPenulis(rs.getString("penulis"));
                    buku.setPenerbit(rs.getString("penerbit"));
                    buku.setTahunTerbit(rs.getInt("tahun_terbit"));
                    buku.setJmlBuku(rs.getInt("jml_buku"));
                    buku.setIdKategori(rs.getInt("id_kategori"));
                    buku.setIsbn(rs.getString("isbn"));
                    buku.setAbstraksi(rs.getString("abstraksi"));
                    list.add(buku);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public Buku getBukuById(int id) {
        Buku buku = null;
        String sql = "SELECT * FROM buku WHERE id_buku=?";
        try (Connection conn = DBConnection.getConnection()) {
            if (conn == null) return null;
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, id);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        buku = new Buku();
                        buku.setIdBuku(rs.getInt("id_buku"));
                        buku.setJudul(rs.getString("judul"));
                        buku.setPenulis(rs.getString("penulis"));
                        buku.setPenerbit(rs.getString("penerbit"));
                        buku.setTahunTerbit(rs.getInt("tahun_terbit"));
                        buku.setJmlBuku(rs.getInt("jml_buku"));
                        buku.setIdKategori(rs.getInt("id_kategori"));
                        buku.setIsbn(rs.getString("isbn"));
                        buku.setAbstraksi(rs.getString("abstraksi"));
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        if (buku == null) {
            throw new BookNotFoundException(id);
        }
        return buku;
    }

    public boolean update(Buku buku) {
        boolean success = false;
        String sql = "UPDATE buku SET judul=?, penulis=?, penerbit=?, tahun_terbit=?, jml_buku=?, id_kategori=?, isbn=?, abstraksi=? WHERE id_buku=?";
        try (Connection conn = DBConnection.getConnection()) {
            if (conn == null) return false;
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, buku.getJudul());
                ps.setString(2, buku.getPenulis());
                ps.setString(3, buku.getPenerbit());
                ps.setInt(4, buku.getTahunTerbit());
                ps.setInt(5, buku.getJmlBuku());
                ps.setInt(6, buku.getIdKategori());
                ps.setString(7, buku.getIsbn());
                ps.setString(8, buku.getAbstraksi());
                ps.setInt(9, buku.getIdBuku());
                int rows = ps.executeUpdate();
                if (rows > 0) {
                    success = true;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return success;
    }

    public boolean delete(int id) {
        boolean success = false;
        Connection conn = null;
        PreparedStatement psUlasan = null;
        PreparedStatement psFavorit = null;
        PreparedStatement psPeminjaman = null;
        PreparedStatement psBuku = null;

        try {
            conn = DBConnection.getConnection();
            if (conn == null) return false;

            String sqlUlasan = "DELETE FROM ulasan WHERE id_buku=?";
            psUlasan = conn.prepareStatement(sqlUlasan);
            psUlasan.setInt(1, id);
            psUlasan.executeUpdate();

            String sqlFavorit = "DELETE FROM favorit WHERE id_buku=?";
            psFavorit = conn.prepareStatement(sqlFavorit);
            psFavorit.setInt(1, id);
            psFavorit.executeUpdate();

            String sqlPeminjaman = "DELETE FROM peminjaman WHERE id_buku=?";
            psPeminjaman = conn.prepareStatement(sqlPeminjaman);
            psPeminjaman.setInt(1, id);
            psPeminjaman.executeUpdate();

            String sqlBuku = "DELETE FROM buku WHERE id_buku=?";
            psBuku = conn.prepareStatement(sqlBuku);
            psBuku.setInt(1, id);

            int rows = psBuku.executeUpdate();
            if (rows > 0) {
                success = true;
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (psUlasan != null) psUlasan.close(); } catch (Exception e) { e.printStackTrace(); }
            try { if (psFavorit != null) psFavorit.close(); } catch (Exception e) { e.printStackTrace(); }
            try { if (psPeminjaman != null) psPeminjaman.close(); } catch (Exception e) { e.printStackTrace(); }
            try { if (psBuku != null) psBuku.close(); } catch (Exception e) { e.printStackTrace(); }
            try { if (conn != null) conn.close(); } catch (Exception e) { e.printStackTrace(); }
        }
        return success;
    }

    public List<Buku> searchBuku(String query) {
        List<Buku> list = new ArrayList<>();
        String sql = "SELECT * FROM buku WHERE judul LIKE ? OR penulis LIKE ? OR penerbit LIKE ?";
        try (Connection conn = DBConnection.getConnection()) {
            if (conn == null) return list;
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                String searchPattern = "%" + query + "%";
                ps.setString(1, searchPattern);
                ps.setString(2, searchPattern);
                ps.setString(3, searchPattern);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        Buku buku = new Buku();
                        buku.setIdBuku(rs.getInt("id_buku"));
                        buku.setJudul(rs.getString("judul"));
                        buku.setPenulis(rs.getString("penulis"));
                        buku.setPenerbit(rs.getString("penerbit"));
                        buku.setTahunTerbit(rs.getInt("tahun_terbit"));
                        buku.setJmlBuku(rs.getInt("jml_buku"));
                        buku.setIdKategori(rs.getInt("id_kategori"));
                        buku.setIsbn(rs.getString("isbn"));
                        buku.setAbstraksi(rs.getString("abstraksi"));
                        list.add(buku);
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Buku> getLatestBuku(int limit) {
        List<Buku> list = new ArrayList<>();
        String sql = "SELECT * FROM buku ORDER BY id_buku DESC LIMIT ?";
        try (Connection conn = DBConnection.getConnection()) {
            if (conn == null) return list;
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, limit);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        Buku buku = new Buku();
                        buku.setIdBuku(rs.getInt("id_buku"));
                        buku.setJudul(rs.getString("judul"));
                        buku.setPenulis(rs.getString("penulis"));
                        buku.setPenerbit(rs.getString("penerbit"));
                        buku.setTahunTerbit(rs.getInt("tahun_terbit"));
                        buku.setJmlBuku(rs.getInt("jml_buku"));
                        buku.setIdKategori(rs.getInt("id_kategori"));
                        buku.setIsbn(rs.getString("isbn"));
                        buku.setAbstraksi(rs.getString("abstraksi"));
                        list.add(buku);
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public int getTotalBuku() {
        int total = 0;
        String sql = "SELECT COUNT(*) AS total FROM buku";
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

    public boolean updateStok(int idBuku, int change) {
        boolean success = false;
        String sql = "UPDATE buku SET jml_buku = jml_buku + ? WHERE id_buku = ?";
        try (Connection conn = DBConnection.getConnection()) {
            if (conn == null) return false;
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, change);
                ps.setInt(2, idBuku);
                int rows = ps.executeUpdate();
                if (rows > 0) {
                    success = true;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return success;
    }
}
