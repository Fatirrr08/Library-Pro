package controller;

import dao.*;
import model.Buku;
import model.User;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {

    private BukuDAO bukuDAO = new BukuDAO();
    private KategoriDAO kategoriDAO = new KategoriDAO();
    private UserDAO userDAO = new UserDAO();
    private PeminjamanDAO peminjamanDAO = new PeminjamanDAO();
    private FavoritDAO favoritDAO = new FavoritDAO();
    private UlasanDAO ulasanDAO = new UlasanDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");

        if ("admin".equalsIgnoreCase(user.getLevel())) {
            // Get stats for Admin
            int totalBuku = bukuDAO.getTotalBuku();
            int totalKategori = kategoriDAO.getTotalKategori();
            int totalUser = userDAO.getTotalUser();
            int totalPeminjaman = peminjamanDAO.getTotalPeminjaman();
            List<Buku> daftarBuku = bukuDAO.getLatestBuku(5); // 5 recent books

            request.setAttribute("totalBuku", totalBuku);
            request.setAttribute("totalKategori", totalKategori);
            request.setAttribute("totalUser", totalUser);
            request.setAttribute("totalPeminjaman", totalPeminjaman);
            request.setAttribute("daftarBuku", daftarBuku);

            request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);
        } else if ("anggota".equalsIgnoreCase(user.getLevel())) {
            // Get stats for Anggota
            int userId = user.getIdUser();
            int totalBuku = bukuDAO.getTotalBuku();
            int totalPinjamSaya = peminjamanDAO.getTotalActivePeminjamanByUser(userId);
            int totalFavoritSaya = favoritDAO.getTotalFavoritByUser(userId);
            int totalUlasanSaya = ulasanDAO.getTotalUlasanByUser(userId);
            List<Buku> daftarBuku = bukuDAO.getLatestBuku(5);

            request.setAttribute("totalBuku", totalBuku);
            request.setAttribute("totalPinjamSaya", totalPinjamSaya);
            request.setAttribute("totalFavoritSaya", totalFavoritSaya);
            request.setAttribute("totalUlasanSaya", totalUlasanSaya);
            request.setAttribute("daftarBuku", daftarBuku);

            request.getRequestDispatcher("/anggota/dashboard.jsp").forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
        }
    }
}