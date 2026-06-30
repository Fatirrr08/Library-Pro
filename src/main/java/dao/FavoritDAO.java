package dao;

import config.DBConnection;
import model.Favorit;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class FavoritDAO extends BaseDAO {

    @Override
    public String getEntityName() {
        return "Favorit";
    }

    public boolean addFavorit(int idUser, int idBuku) {
        boolean success = false;
        String sql = "INSERT INTO favorit (id_user, id_buku) VALUES (?, ?) " +
                     "ON DUPLICATE KEY UPDATE id_user=id_user";
        try (Connection conn = DBConnection.getConnection()) {
            if (conn == null) return false;
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, idUser);
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

    public boolean removeFavorit(int idUser, int idBuku) {
        boolean success = false;
        String sql = "DELETE FROM favorit WHERE id_user = ? AND id_buku = ?";
        try (Connection conn = DBConnection.getConnection()) {
            if (conn == null) return false;
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, idUser);
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

    public List<Favorit> getFavoritByUser(int idUser) {
        List<Favorit> list = new ArrayList<>();
        String sql = "SELECT f.*, b.judul AS judul_buku, b.penulis, b.penerbit, b.foto_buku " +
                     "FROM favorit f " +
                     "JOIN buku b ON f.id_buku = b.id_buku " +
                     "WHERE f.id_user = ? " +
                     "ORDER BY f.id_favorit DESC";
        try (Connection conn = DBConnection.getConnection()) {
            if (conn == null) return list;
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, idUser);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        Favorit fav = new Favorit();
                        fav.setIdFavorit(rs.getInt("id_favorit"));
                        fav.setIdUser(rs.getInt("id_user"));
                        fav.setIdBuku(rs.getInt("id_buku"));
                        fav.setJudulBuku(rs.getString("judul_buku"));
                        fav.setPenulis(rs.getString("penulis"));
                        fav.setPenerbit(rs.getString("penerbit"));
                        fav.setFotoBuku(rs.getString("foto_buku"));
                        list.add(fav);
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean isFavorit(int idUser, int idBuku) {
        boolean fav = false;
        String sql = "SELECT id_favorit FROM favorit WHERE id_user = ? AND id_buku = ?";
        try (Connection conn = DBConnection.getConnection()) {
            if (conn == null) return false;
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, idUser);
                ps.setInt(2, idBuku);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        fav = true;
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return fav;
    }

    public int getTotalFavoritByUser(int idUser) {
        int total = 0;
        String sql = "SELECT COUNT(*) AS total FROM favorit WHERE id_user = ?";
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
}
