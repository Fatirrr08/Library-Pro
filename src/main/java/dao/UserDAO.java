package dao;

import config.DBConnection;
import model.User;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {

    public User login(String username, String password) {
        User user = null;
        try {
            Connection conn = DBConnection.getConnection();
            String sql = "SELECT * FROM user WHERE username=? AND password=?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, username);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                user = new User();
                user.setIdUser(rs.getInt("id_user"));
                user.setUsername(rs.getString("username"));
                user.setPassword(rs.getString("password"));
                user.setEmail(rs.getString("email"));
                user.setNamaLengkap(rs.getString("nama_lengkap"));
                user.setAlamat(rs.getString("alamat"));
                user.setLevel(rs.getString("level"));
                user.setFotoProfil(rs.getString("foto_profil"));
            }
            rs.close();
            ps.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return user;
    }

    public boolean checkUsernameExists(String username) {
        boolean exists = false;
        try {
            Connection conn = DBConnection.getConnection();
            String sql = "SELECT id_user FROM user WHERE username=?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                exists = true;
            }
            rs.close();
            ps.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return exists;
    }

    public boolean register(User user) {
        if (checkUsernameExists(user.getUsername())) {
            return false;
        }
        return insert(user);
    }

    public boolean insert(User user) {
        boolean success = false;
        try {
            Connection conn = DBConnection.getConnection();
            String sql = "INSERT INTO user (username, password, email, nama_lengkap, alamat, level) VALUES (?, ?, ?, ?, ?, ?)";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, user.getUsername());
            ps.setString(2, user.getPassword());
            ps.setString(3, user.getEmail());
            ps.setString(4, user.getNamaLengkap());
            ps.setString(5, user.getAlamat());
            ps.setString(6, user.getLevel() == null ? "anggota" : user.getLevel());
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

    public List<User> getAllUser() {
        List<User> list = new ArrayList<>();
        try {
            Connection conn = DBConnection.getConnection();
            String sql = "SELECT * FROM user";
            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery(sql);
            while (rs.next()) {
                User user = new User();
                user.setIdUser(rs.getInt("id_user"));
                user.setUsername(rs.getString("username"));
                user.setPassword(rs.getString("password"));
                user.setEmail(rs.getString("email"));
                user.setNamaLengkap(rs.getString("nama_lengkap"));
                user.setAlamat(rs.getString("alamat"));
                user.setLevel(rs.getString("level"));
                user.setFotoProfil(rs.getString("foto_profil"));
                list.add(user);
            }
            rs.close();
            st.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public User getUserById(int id) {
        User user = null;
        try {
            Connection conn = DBConnection.getConnection();
            String sql = "SELECT * FROM user WHERE id_user=?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                user = new User();
                user.setIdUser(rs.getInt("id_user"));
                user.setUsername(rs.getString("username"));
                user.setPassword(rs.getString("password"));
                user.setEmail(rs.getString("email"));
                user.setNamaLengkap(rs.getString("nama_lengkap"));
                user.setAlamat(rs.getString("alamat"));
                user.setLevel(rs.getString("level"));
                user.setFotoProfil(rs.getString("foto_profil"));
            }
            rs.close();
            ps.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return user;
    }

    public boolean update(User user) {
        boolean success = false;
        try {
            Connection conn = DBConnection.getConnection();
            String sql = "UPDATE user SET username=?, password=?, email=?, nama_lengkap=?, alamat=?, level=? WHERE id_user=?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, user.getUsername());
            ps.setString(2, user.getPassword());
            ps.setString(3, user.getEmail());
            ps.setString(4, user.getNamaLengkap());
            ps.setString(5, user.getAlamat());
            ps.setString(6, user.getLevel());
            ps.setInt(7, user.getIdUser());
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

    public boolean updateProfile(User user) {
        boolean success = false;
        try {
            Connection conn = DBConnection.getConnection();
            String sql;
            PreparedStatement ps;
            if (user.getPassword() != null && !user.getPassword().isEmpty()) {
                sql = "UPDATE user SET password=?, email=?, nama_lengkap=?, foto_profil=? WHERE id_user=?";
                ps = conn.prepareStatement(sql);
                ps.setString(1, user.getPassword());
                ps.setString(2, user.getEmail());
                ps.setString(3, user.getNamaLengkap());
                ps.setString(4, user.getFotoProfil());
                ps.setInt(5, user.getIdUser());
            } else {
                sql = "UPDATE user SET email=?, nama_lengkap=?, foto_profil=? WHERE id_user=?";
                ps = conn.prepareStatement(sql);
                ps.setString(1, user.getEmail());
                ps.setString(2, user.getNamaLengkap());
                ps.setString(3, user.getFotoProfil());
                ps.setInt(4, user.getIdUser());
            }
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
            String sql = "DELETE FROM user WHERE id_user=?";
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

    public int getTotalUser() {
        int total = 0;
        try {
            Connection conn = DBConnection.getConnection();
            String sql = "SELECT COUNT(*) AS total FROM user";
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
}