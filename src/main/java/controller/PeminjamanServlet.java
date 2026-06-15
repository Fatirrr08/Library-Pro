package controller;

import dao.BukuDAO;
import dao.PeminjamanDAO;
import dao.UserDAO;
import model.Buku;
import model.Peminjaman;
import model.User;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/peminjaman")
public class PeminjamanServlet extends HttpServlet {

    private PeminjamanDAO peminjamanDAO = new PeminjamanDAO();
    private BukuDAO bukuDAO = new BukuDAO();
    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");
        String action = request.getParameter("action");
        String idParam = request.getParameter("id");

        if ("admin".equalsIgnoreCase(user.getLevel())) {
            // ==================== ALUR ADMIN ACTIONS ====================
            if (action != null && idParam != null) {
                try {
                    int id = Integer.parseInt(idParam);
                    
                    if ("setujui".equals(action)) {
                        peminjamanDAO.verifikasiPeminjaman(id, "disetujui");
                    } else if ("tolak".equals(action)) {
                        peminjamanDAO.verifikasiPeminjaman(id, "ditolak");
                    } else if ("kembalikan".equals(action)) {
                        peminjamanDAO.kembalikan(id); // Mengisi tgl_kembali aktual & merestore stok
                    }
                } catch (NumberFormatException e) {
                    e.printStackTrace();
                }
                response.sendRedirect(request.getContextPath() + "/peminjaman");
                return;
            }
            
            // Jika tidak ada action, tampilkan semua data ke halaman panel admin
            List<Peminjaman> daftarPeminjaman = peminjamanDAO.getAllPeminjaman();
            List<Buku> daftarBuku = bukuDAO.getAllBuku();
            List<User> daftarUser = userDAO.getAllUser();

            request.setAttribute("daftarPeminjaman", daftarPeminjaman);
            request.setAttribute("daftarBuku", daftarBuku);
            request.setAttribute("daftarUser", daftarUser);

            request.getRequestDispatcher("/admin/peminjaman.jsp").forward(request, response);
            
        } else {
            // ==================== ALUR ANGGOTA ACTIONS ====================
            if ("pinjam".equals(action)) {
                int idBuku = Integer.parseInt(request.getParameter("idBuku"));
                
                // Mendaftarkan peminjaman (Default status di DB otomatis menjadi 'menunggu')
                boolean success = peminjamanDAO.pinjam(user.getIdUser(), idBuku);
                if (success) {
                    response.sendRedirect(request.getContextPath() + "/peminjaman?status=success");
                } else {
                    response.sendRedirect(request.getContextPath() + "/peminjaman?status=fail");
                }
            } else if ("kembalikan".equals(action)) {
                // Opsi pengembalian mandiri oleh user (jika diperbolehkan sistem Anda)
                try {
                    int id = Integer.parseInt(idParam);
                    peminjamanDAO.kembalikan(id);
                } catch (NumberFormatException e) {
                    e.printStackTrace();
                }
                response.sendRedirect(request.getContextPath() + "/peminjaman");
            } else {
                // Menampilkan riwayat milik anggota itu sendiri
                List<Peminjaman> daftarPeminjamanSaya = peminjamanDAO.getPeminjamanByUser(user.getIdUser());
                request.setAttribute("daftarPeminjaman", daftarPeminjamanSaya);
                request.getRequestDispatcher("/anggota/peminjaman.jsp").forward(request, response);
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");

        // Hanya Admin yang dapat memicu pembuatan log manual langsung lewat form input POST
        if ("admin".equalsIgnoreCase(user.getLevel())) {
            try {
                int idUser = Integer.parseInt(request.getParameter("idUser"));
                int idBuku = Integer.parseInt(request.getParameter("idBuku"));

                // Daftarkan peminjaman langsung
                peminjamanDAO.pinjam(idUser, idBuku);
                
                // Tips Opsional: Jika pencatatan admin mandiri ingin langsung berstatus 'disetujui' tanpa verifikasi lagi,
                // Anda bisa mengambil ID peminjaman terakhir lalu otomatis menjalankan:
                // peminjamanDAO.verifikasiPeminjaman(idTerakhir, "disetujui");
                
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }

        response.sendRedirect(request.getContextPath() + "/peminjaman");
    }
}