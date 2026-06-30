package dao;

import config.DBConnection;
import model.Ulasan;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class UlasanDAO extends BaseDAO {

    @Override
    public String getEntityName() {
        return "Ulasan";
    }

    public boolean insertUlasan(Ulasan ulasan) {
        return addUlasan(ulasan);
    }

    public boolean addUlasan(Ulasan ulasan) {
        boolean success = false;
        String sql = "INSERT INTO ulasan (id_user, id_buku, ulasan, rating) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection()) {
            if (conn == null) return false;
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, ulasan.getIdUser());
                ps.setInt(2, ulasan.getIdBuku());
                ps.setString(3, ulasan.getUlasan());
                ps.setInt(4, ulasan.getRating());
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

    public Ulasan getUlasanByUserAndBuku(int idUser, int idBuku) {
        Ulasan ulasan = null;
        String sql = "SELECT * FROM ulasan WHERE id_user = ? AND id_buku = ?";
        try (Connection conn = DBConnection.getConnection()) {
            if (conn == null) return null;
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, idUser);
                ps.setInt(2, idBuku);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        ulasan = new Ulasan();
                        ulasan.setIdUlasan(rs.getInt("id_ulasan"));
                        ulasan.setIdUser(rs.getInt("id_user"));
                        ulasan.setIdBuku(rs.getInt("id_buku"));
                        ulasan.setUlasan(rs.getString("ulasan"));
                        ulasan.setRating(rs.getInt("rating"));
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return ulasan;
    }

    public List<Ulasan> getUlasanByUser(int idUser) {
        List<Ulasan> list = new ArrayList<>();
        String sql = "SELECT ul.*, b.judul AS judul_buku " +
                     "FROM ulasan ul " +
                     "JOIN buku b ON ul.id_buku = b.id_buku " +
                     "WHERE ul.id_user = ? " +
                     "ORDER BY ul.id_ulasan DESC";
        try (Connection conn = DBConnection.getConnection()) {
            if (conn == null) return list;
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, idUser);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        Ulasan ulasan = new Ulasan();
                        ulasan.setIdUlasan(rs.getInt("id_ulasan"));
                        ulasan.setIdUser(rs.getInt("id_user"));
                        ulasan.setIdBuku(rs.getInt("id_buku"));
                        ulasan.setUlasan(rs.getString("ulasan"));
                        ulasan.setRating(rs.getInt("rating"));
                        ulasan.setJudulBuku(rs.getString("judul_buku"));
                        list.add(ulasan);
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Ulasan> getAllUlasan() {
        List<Ulasan> list = new ArrayList<>();
        String sql = "SELECT ul.*, u.username, u.nama_lengkap, b.judul AS judul_buku " +
                     "FROM ulasan ul " +
                     "JOIN user u ON ul.id_user = u.id_user " +
                     "JOIN buku b ON ul.id_buku = b.id_buku " +
                     "ORDER BY ul.id_ulasan DESC";
        try (Connection conn = DBConnection.getConnection()) {
            if (conn == null) return list;
            try (PreparedStatement ps = conn.prepareStatement(sql);
                 ResultSet rs = ps.executeQuery()) {
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
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean updateUlasan(Ulasan ulasan) {
        boolean success = false;
        String sql = "UPDATE ulasan SET ulasan = ?, rating = ? WHERE id_ulasan = ?";
        try (Connection conn = DBConnection.getConnection()) {
            if (conn == null) return false;
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, ulasan.getUlasan());
                ps.setInt(2, ulasan.getRating());
                ps.setInt(3, ulasan.getIdUlasan());
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

    public boolean deleteUlasan(int idUlasan) {
        boolean success = false;
        String sql = "DELETE FROM ulasan WHERE id_ulasan = ?";
        try (Connection conn = DBConnection.getConnection()) {
            if (conn == null) return false;
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, idUlasan);
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

    public List<Ulasan> getUlasanByBuku(int idBuku) {
        List<Ulasan> list = new ArrayList<>();
        String sql = "SELECT ul.*, u.username, u.nama_lengkap, b.judul AS judul_buku " +
                     "FROM ulasan ul " +
                     "JOIN user u ON ul.id_user = u.id_user " +
                     "JOIN buku b ON ul.id_buku = b.id_buku " +
                     "WHERE ul.id_buku = ? " +
                     "ORDER BY ul.id_ulasan DESC";
        try (Connection conn = DBConnection.getConnection()) {
            if (conn == null) return list;
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, idBuku);
                try (ResultSet rs = ps.executeQuery()) {
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
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public int getTotalUlasanByUser(int idUser) {
        int total = 0;
        String sql = "SELECT COUNT(*) AS total FROM ulasan WHERE id_user = ?";
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

    public double getRataRataRatingBuku(int idBuku) {
        double rata = 0.0;
        String sql = "SELECT AVG(rating) AS rata FROM ulasan WHERE id_buku = ?";
        try (Connection conn = DBConnection.getConnection()) {
            if (conn == null) return 0.0;
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, idBuku);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        rata = rs.getDouble("rata");
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return rata;
    }
}
