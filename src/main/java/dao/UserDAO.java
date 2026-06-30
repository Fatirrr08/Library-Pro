package dao;

import config.DBConnection;
import model.User;
import model.Admin;
import model.Anggota;
import model.enums.UserLevel;
import util.PasswordUtils;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class UserDAO extends BaseDAO {

    @Override
    public String getEntityName() {
        return "User";
    }

    public User login(String username, String password) {
        User user = null;
        String sql = "SELECT * FROM user WHERE username=?";
        try (Connection conn = DBConnection.getConnection()) {
            if (conn == null) return null;
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, username);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        String storedPassword = rs.getString("password");
                        if (!PasswordUtils.verify(password, storedPassword)) {
                            return null;
                        }
                        String levelStr = rs.getString("level");
                        if (UserLevel.ADMIN.getValue().equalsIgnoreCase(levelStr)) {
                            user = new Admin();
                        } else {
                            user = new Anggota();
                        }
                        user.setIdUser(rs.getInt("id_user"));
                        user.setUsername(rs.getString("username"));
                        user.setPassword(storedPassword);
                        user.setEmail(rs.getString("email"));
                        user.setNamaLengkap(rs.getString("nama_lengkap"));
                        user.setAlamat(rs.getString("alamat"));
                        user.setLevel(rs.getString("level"));
                        user.setFotoProfil(rs.getString("foto_profil"));
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return user;
    }

    public boolean checkUsernameExists(String username) {
        boolean exists = false;
        String sql = "SELECT id_user FROM user WHERE username=?";
        try (Connection conn = DBConnection.getConnection()) {
            if (conn == null) return false;
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, username);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        exists = true;
                    }
                }
            }
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
        String sql = "INSERT INTO user (username, password, email, nama_lengkap, alamat, level, security_question, security_answer) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection()) {
            if (conn == null) return false;
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, user.getUsername());
                String password = PasswordUtils.isHashed(user.getPassword()) ? user.getPassword() : PasswordUtils.hash(user.getPassword());
                ps.setString(2, password);
                ps.setString(3, user.getEmail());
                ps.setString(4, user.getNamaLengkap());
                ps.setString(5, user.getAlamat());
                ps.setString(6, user.getLevel() == null ? "anggota" : user.getLevel());
                ps.setString(7, user.getSecurityQuestion());
                ps.setString(8, user.getSecurityAnswer());
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

    public List<User> getAllUser() {
        List<User> list = new ArrayList<>();
        String sql = "SELECT * FROM user";
        try (Connection conn = DBConnection.getConnection()) {
            if (conn == null) return list;
            try (Statement st = conn.createStatement();
                 ResultSet rs = st.executeQuery(sql)) {
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
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public User getUserById(int id) {
        User user = null;
        String sql = "SELECT * FROM user WHERE id_user=?";
        try (Connection conn = DBConnection.getConnection()) {
            if (conn == null) return null;
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, id);
                try (ResultSet rs = ps.executeQuery()) {
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
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return user;
    }

    public boolean update(User user) {
        boolean success = false;
        String sql = "UPDATE user SET username=?, password=?, email=?, nama_lengkap=?, alamat=?, level=? WHERE id_user=?";
        try (Connection conn = DBConnection.getConnection()) {
            if (conn == null) return false;
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, user.getUsername());
                String password = PasswordUtils.isHashed(user.getPassword()) ? user.getPassword() : PasswordUtils.hash(user.getPassword());
                ps.setString(2, password);
                ps.setString(3, user.getEmail());
                ps.setString(4, user.getNamaLengkap());
                ps.setString(5, user.getAlamat());
                ps.setString(6, user.getLevel());
                ps.setInt(7, user.getIdUser());
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

    public boolean updateProfile(User user) {
        boolean success = false;
        try (Connection conn = DBConnection.getConnection()) {
            if (conn == null) return false;
            if (user.getPassword() != null && !user.getPassword().isEmpty()) {
                String sql = "UPDATE user SET password=?, email=?, nama_lengkap=?, alamat=?, foto_profil=? WHERE id_user=?";
                try (PreparedStatement ps = conn.prepareStatement(sql)) {
                    ps.setString(1, PasswordUtils.isHashed(user.getPassword()) ? user.getPassword() : PasswordUtils.hash(user.getPassword()));
                    ps.setString(2, user.getEmail());
                    ps.setString(3, user.getNamaLengkap());
                    ps.setString(4, user.getAlamat());
                    ps.setString(5, user.getFotoProfil());
                    ps.setInt(6, user.getIdUser());
                    int rows = ps.executeUpdate();
                    if (rows > 0) {
                        success = true;
                    }
                }
            } else {
                String sql = "UPDATE user SET email=?, nama_lengkap=?, alamat=?, foto_profil=? WHERE id_user=?";
                try (PreparedStatement ps = conn.prepareStatement(sql)) {
                    ps.setString(1, user.getEmail());
                    ps.setString(2, user.getNamaLengkap());
                    ps.setString(3, user.getAlamat());
                    ps.setString(4, user.getFotoProfil());
                    ps.setInt(5, user.getIdUser());
                    int rows = ps.executeUpdate();
                    if (rows > 0) {
                        success = true;
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return success;
    }

    public boolean delete(int id) {
        boolean success = false;
        String sql = "DELETE FROM user WHERE id_user=?";
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

    public User findByUsername(String username) {
        User user = null;
        String sql = "SELECT * FROM user WHERE username=?";
        try (Connection conn = DBConnection.getConnection()) {
            if (conn == null) return null;
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, username);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        user = new User();
                        user.setIdUser(rs.getInt("id_user"));
                        user.setUsername(rs.getString("username"));
                        user.setEmail(rs.getString("email"));
                        user.setSecurityQuestion(rs.getString("security_question"));
                        user.setSecurityAnswer(rs.getString("security_answer"));
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return user;
    }

    public boolean updatePassword(int userId, String newPassword) {
        boolean success = false;
        String hashed = PasswordUtils.hash(newPassword);
        String sql = "UPDATE user SET password=? WHERE id_user=?";
        try (Connection conn = DBConnection.getConnection()) {
            if (conn == null) return false;
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, hashed);
                ps.setInt(2, userId);
                int rows = ps.executeUpdate();
                if (rows > 0) success = true;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return success;
    }

    public int getTotalUser() {
        int total = 0;
        String sql = "SELECT COUNT(*) AS total FROM user";
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
