// package config;

// import java.sql.Connection;
// import java.sql.DriverManager;

// public class DBConnection {

//     private static final String URL =
//             "jdbc:mysql://localhost:3306/librarymanagamentsystem";

//     private static final String USER =
//             "root";

//     private static final String PASSWORD =
//             "";

//     public static Connection getConnection() {

//         Connection conn = null;

//         try {

//             Class.forName(
//                     "com.mysql.cj.jdbc.Driver");

//             conn =
//                     DriverManager.getConnection(
//                             URL,
//                             USER,
//                             PASSWORD);

//             System.out.println(
//                     "===== DATABASE CONNECTED =====");

//         } catch (Exception e) {

//             System.out.println(
//                     "===== DATABASE GAGAL TERHUBUNG =====");

//             e.printStackTrace();
//         }

//         return conn;
//     }
// }
package config;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnection {
        public static Connection getConnection() {
                Connection conn = null;
                try {
                // 1. Membaca seluruh kredensial murni dari Environment Variables (Sistem Cloud / Tomcat)
                String host = System.getenv("MYSQL_HOST");
                String port = System.getenv("MYSQL_PORT");
                String db   = System.getenv("MYSQL_DB");
                String user = System.getenv("MYSQL_USER");
                String pass = System.getenv("MYSQL_PASSWORD");

                // 2. Validasi untuk memastikan variabel lingkungan sudah terisi sebelum melakukan koneksi
                if (host == null || port == null || db == null || user == null || pass == null) {
                        System.out.println("⚠️ ERROR: Kredensial Database tidak ditemukan di Environment Variables!");
                        return null;
                }

                // 3. Menyusun URL JDBC menggunakan parameter SSL Mode yang diwajibkan oleh TiDB Cloud
                String url = "jdbc:mysql://" + host + ":" + port + "/" + db + "?sslMode=REQUIRED&trustServerCertificate=true";

                // 4. Loading Driver dan Membuka Koneksi
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection(url, user, pass);
                
                System.out.println("===== DATABASE CONNECTED SAFELY VIA ENVIRONMENT VARIABLES =====");
                } catch (Exception e) {
                System.out.println("===== DATABASE CONNECTION FAILED =====");
                e.printStackTrace();
                }
                return conn;
        }
}