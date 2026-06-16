package dao;

import config.DBConnection;
import model.Buku;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BukuDAO {

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
            ps.setString(7, buku.getIsbn());       // Ditambahkan untuk admin insert
            ps.setString(8, buku.getAbstraksi()); // Ditambahkan untuk admin insert

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
                
                // DISESUAIKAN: Menarik kolom baru dari database
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
                
                // DISESUAIKAN: Menarik kolom baru dari database
                buku.setIsbn(rs.getString("isbn"));
                buku.setAbstraksi(rs.getString("abstraksi"));
            }
            rs.close();
            ps.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
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
            ps.setString(7, buku.getIsbn());       // Ditambahkan untuk admin update
            ps.setString(8, buku.getAbstraksi()); // Ditambahkan untuk admin update
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

    public boolean delete(int id) {
        boolean success = false;
        try {
            Connection conn = DBConnection.getConnection();
            String sql = "DELETE FROM buku WHERE id_buku=?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
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
                
                // DISESUAIKAN: Menarik kolom baru dari database
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
                
                // DISESUAIKAN: Menarik kolom baru dari database
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