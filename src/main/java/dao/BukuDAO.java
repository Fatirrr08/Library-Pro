package dao;

import config.DBConnection;
import model.Buku;

import exception.BookNotFoundException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BukuDAO extends BaseDAO { // [OOP: Inheritance] BukuDAO mewarisi BaseDAO

    @Override
    public String getEntityName() {
        return "Buku"; // [OOP: Abstract Method Implementation] wajib diimplementasi subclass
    }

    public void insert(Buku buku) {
        System.out.println("INSERT BUKU DIJALANKAN");
        try {
            Connection conn = DBConnection.getConnection();
            String sql = "INSERT INTO buku (judul, penulis, penerbit, tahun_terbit, jml_buku, id_kategori, isbn, abstraksi) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
            PreparedStatement ps = conn.prepareStatement(sql);
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
            ps.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public List<Buku> getAllBuku() {
        List<Buku> list = new ArrayList<>();
        try {
            Connection conn = DBConnection.getConnection();
            String sql = "SELECT * FROM buku";
            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery(sql);
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
            rs.close();
            st.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public Buku getBukuById(int id) {
        Buku buku = null;
        try {
            Connection conn = DBConnection.getConnection();
            String sql = "SELECT * FROM buku WHERE id_buku=?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
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
            rs.close();
            ps.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        // [OOP: Custom Exception] lempar jika buku tidak ditemukan
        if (buku == null) {
            throw new BookNotFoundException(id);
        }
        return buku;
    }

    public boolean update(Buku buku) {
        boolean success = false;
        try {
            Connection conn = DBConnection.getConnection();
            String sql = "UPDATE buku SET judul=?, penulis=?, penerbit=?, tahun_terbit=?, jml_buku=?, id_kategori=?, isbn=?, abstraksi=? WHERE id_buku=?";
            PreparedStatement ps = conn.prepareStatement(sql);
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
            ps.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return success;
    }

    // 🌟 SELESAI DISESUAIKAN: Menghapus data transaksional anak terlebih dahulu
    public boolean delete(int id) {
        boolean success = false;
        Connection conn = null;
        PreparedStatement psUlasan = null;
        PreparedStatement psFavorit = null;
        PreparedStatement psPeminjaman = null;
        PreparedStatement psBuku = null;

        try {
            conn = DBConnection.getConnection();
            
            // 1. Bersihkan tabel ulasan yang mereferensikan id_buku ini
            String sqlUlasan = "DELETE FROM ulasan WHERE id_buku=?";
            psUlasan = conn.prepareStatement(sqlUlasan);
            psUlasan.setInt(1, id);
            psUlasan.executeUpdate();

            // 2. Bersihkan tabel favorit yang mereferensikan id_buku ini
            String sqlFavorit = "DELETE FROM favorit WHERE id_buku=?";
            psFavorit = conn.prepareStatement(sqlFavorit);
            psFavorit.setInt(1, id);
            psFavorit.executeUpdate();

            // 3. Bersihkan histori peminjaman yang mereferensikan id_buku ini
            String sqlPeminjaman = "DELETE FROM peminjaman WHERE id_buku=?";
            psPeminjaman = conn.prepareStatement(sqlPeminjaman);
            psPeminjaman.setInt(1, id);
            psPeminjaman.executeUpdate();

            // 4. Baru eksekusi penghapusan data buku utama
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
            // Memastikan penutupan resource stream secara aman
            try {
                if (psUlasan != null) psUlasan.close();
                if (psFavorit != null) psFavorit.close();
                if (psPeminjaman != null) psPeminjaman.close();
                if (psBuku != null) psBuku.close();
                if (conn != null) conn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return success;
    }

    public List<Buku> searchBuku(String query) {
        List<Buku> list = new ArrayList<>();
        try {
            Connection conn = DBConnection.getConnection();
            String sql = "SELECT * FROM buku WHERE judul LIKE ? OR penulis LIKE ? OR penerbit LIKE ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            String searchPattern = "%" + query + "%";
            ps.setString(1, searchPattern);
            ps.setString(2, searchPattern);
            ps.setString(3, searchPattern);
            ResultSet rs = ps.executeQuery();
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
            rs.close();
            ps.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Buku> getLatestBuku(int limit) {
        List<Buku> list = new ArrayList<>();
        try {
            Connection conn = DBConnection.getConnection();
            String sql = "SELECT * FROM buku ORDER BY id_buku DESC LIMIT ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, limit);
            ResultSet rs = ps.executeQuery();
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
            rs.close();
            ps.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public int getTotalBuku() {
        int total = 0;
        try {
            Connection conn = DBConnection.getConnection();
            String sql = "SELECT COUNT(*) AS total FROM buku";
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

    public boolean updateStok(int idBuku, int change) {
        boolean success = false;
        try {
            Connection conn = DBConnection.getConnection();
            String sql = "UPDATE buku SET jml_buku = jml_buku + ? WHERE id_buku = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, change);
            ps.setInt(2, idBuku);
            int rows = ps.executeUpdate();
            if (rows > 0) {
                success = true;
            }
            ps.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return success;
    }
}