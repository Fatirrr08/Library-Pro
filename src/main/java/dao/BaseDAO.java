package dao;

import config.DBConnection;
import java.sql.*;
import java.util.List;

// [OOP: Abstract Class] BaseDAO adalah abstract class yang tidak bisa diinstansiasi langsung.
// Semua DAO konkret harus extends BaseDAO dan menggunakan helper methods di sini.
public abstract class BaseDAO {

    // [OOP: Protected Method] getConnection() tersedia untuk semua subclass
    // tapi tidak bisa diakses dari luar hierarki class ini
    protected Connection getConnection() throws SQLException {
        return DBConnection.getConnection();
    }

    // [OOP: Template Method] closeResources() — template untuk resource cleanup
    // Subclass tidak perlu override ini, tapi bisa menggunakannya
    protected void closeResources(ResultSet rs, PreparedStatement ps, Connection conn) {
        try { if (rs != null) rs.close(); } catch (SQLException e) { e.printStackTrace(); }
        try { if (ps != null) ps.close(); } catch (SQLException e) { e.printStackTrace(); }
        try { if (conn != null) conn.close(); } catch (SQLException e) { e.printStackTrace(); }
    }

    // Overload: tanpa ResultSet (untuk INSERT/UPDATE/DELETE)
    protected void closeResources(PreparedStatement ps, Connection conn) {
        closeResources(null, ps, conn);
    }

    // [OOP: Abstract Method] Setiap DAO wajib punya identifier nama entity-nya
    // Ini juga menunjukkan abstract method yang harus di-override subclass
    public abstract String getEntityName();
}
