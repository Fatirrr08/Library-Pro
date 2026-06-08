package dao;

import config.DBConnection;
import model.Ulasan;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class UlasanDAO {

    public boolean addUlasan(Ulasan ulasan) {
        boolean success = false;
        try {
            Connection conn = DBConnection.getConnection();
            String sql = "INSERT INTO ulasan (id_user, id_buku, ulasan, rating) VALUES (?, ?, ?, ?)";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, ulasan.getIdUser());
            ps.setInt(2, ulasan.getIdBuku());
            ps.setString(3, ulasan.getUlasan());
            ps.setInt(4, ulasan.getRating());
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

    public boolean updateUlasan(Ulasan ulasan) {
        boolean success = false;
        try {
            Connection conn = DBConnection.getConnection();
            String sql = "UPDATE ulasan SET ulasan = ?, rating = ? WHERE id_ulasan = ? AND id_user = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, ulasan.getUlasan());
            ps.setInt(2, ulasan.getRating());
            ps.setInt(3, ulasan.getIdUlasan());
            ps.setInt(4, ulasan.getIdUser());
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

    public boolean deleteUlasan(int idUlasan, int idUser) {
        boolean success = false;
        try {
            Connection conn = DBConnection.getConnection();
            String sql = "DELETE FROM ulasan WHERE id_ulasan = ? AND id_user = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, idUlasan);
            ps.setInt(2, idUser);
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

    public List<Ulasan> getUlasanByBuku(int idBuku) {
        List<Ulasan> list = new ArrayList<>();
        try {
            Connection conn = DBConnection.getConnection();
            String sql = "SELECT ul.*, u.username, u.nama_lengkap, b.judul AS judul_buku " +
                         "FROM ulasan ul " +
                         "JOIN user u ON ul.id_user = u.id_user " +
                         "JOIN buku b ON ul.id_buku = b.id_buku " +
                         "WHERE ul.id_buku = ? " +
                         "ORDER BY ul.id_ulasan DESC";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, idBuku);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Ulasan ulasan = new Ulasan();
                ulasan.setIdUlasan(rs.getInt("id_ulasan"));
                ulasan.setIdUser(rs.getInt("id_user"));
                ulasan.setIdBuku(rs.getInt("id_buku"));
                ulasan.setUlasan(rs.getString("ulasan"));
                ulasan.setRating(rs.getInt("rating"));
                ulasan.setUsername(rs.getString("username"));
                ulasan.setNamaLengkap(rs.getString("nama_lengkap"));
                ulasan.setJudulBuku(rs.getString("judul_buku"));
                list.add(ulasan);
            }
            rs.close();
            ps.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public int getTotalUlasanByUser(int idUser) {
        int total = 0;
        try {
            Connection conn = DBConnection.getConnection();
            String sql = "SELECT COUNT(*) AS total FROM ulasan WHERE id_user = ?";
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

    public double getRataRataRatingBuku(int idBuku) {
        double rata = 0.0;
        try {
            Connection conn = DBConnection.getConnection();
            String sql = "SELECT AVG(rating) AS rata FROM ulasan WHERE id_buku = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, idBuku);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                rata = rs.getDouble("rata");
            }
            rs.close();
            ps.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return rata;
    }
}
