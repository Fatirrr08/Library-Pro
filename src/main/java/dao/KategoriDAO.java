package dao;

import config.DBConnection;
import model.Kategori;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class KategoriDAO extends BaseDAO {

    @Override
    public String getEntityName() {
        return "Kategori";
    }

    public boolean insert(Kategori kategori) {
        boolean success = false;
        String sql = "INSERT INTO kategori (nama_kategori) VALUES (?)";
        try (Connection conn = DBConnection.getConnection()) {
            if (conn == null) return false;
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, kategori.getNamaKategori());
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

    public List<Kategori> getAllKategori() {
        List<Kategori> list = new ArrayList<>();
        String sql = "SELECT * FROM kategori";
        try (Connection conn = DBConnection.getConnection()) {
            if (conn == null) return list;
            try (Statement st = conn.createStatement();
                 ResultSet rs = st.executeQuery(sql)) {
                while (rs.next()) {
                    Kategori kategori = new Kategori();
                    kategori.setIdKategori(rs.getInt("id_kategori"));
                    kategori.setNamaKategori(rs.getString("nama_kategori"));
                    list.add(kategori);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public Kategori getKategoriById(int id) {
        Kategori kategori = null;
        String sql = "SELECT * FROM kategori WHERE id_kategori=?";
        try (Connection conn = DBConnection.getConnection()) {
            if (conn == null) return null;
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, id);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        kategori = new Kategori();
                        kategori.setIdKategori(rs.getInt("id_kategori"));
                        kategori.setNamaKategori(rs.getString("nama_kategori"));
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return kategori;
    }

    public boolean update(Kategori kategori) {
        boolean success = false;
        String sql = "UPDATE kategori SET nama_kategori=? WHERE id_kategori=?";
        try (Connection conn = DBConnection.getConnection()) {
            if (conn == null) return false;
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, kategori.getNamaKategori());
                ps.setInt(2, kategori.getIdKategori());
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
        String sql = "DELETE FROM kategori WHERE id_kategori=?";
        try (Connection conn = DBConnection.getConnection()) {
            if (conn == null) return false;
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, id);
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

    public int getTotalKategori() {
        int total = 0;
        String sql = "SELECT COUNT(*) AS total FROM kategori";
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
}
