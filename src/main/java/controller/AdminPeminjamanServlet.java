package controller;

import dao.PeminjamanDAO;
import model.Peminjaman;
import model.User;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/admin/peminjaman")
public class AdminPeminjamanServlet extends HttpServlet {
    private PeminjamanDAO peminjamanDAO = new PeminjamanDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        User loggedUser = (session != null) ? (User) session.getAttribute("user") : null;
        
        if (loggedUser == null || !"admin".equalsIgnoreCase(loggedUser.getLevel())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String action = request.getParameter("action");
        String idStr = request.getParameter("id");

        // Proses Verifikasi Persetujuan atau Penolakan
        if (action != null && idStr != null) {
            try {
                int idPinjam = Integer.parseInt(idStr);
                if ("setujui".equals(action)) {
                    peminjamanDAO.verifikasiPeminjaman(idPinjam, "disetujui");
                } else if ("tolak".equals(action)) {
                    peminjamanDAO.verifikasiPeminjaman(idPinjam, "ditolak");
                }
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
            response.sendRedirect(request.getContextPath() + "/admin/peminjaman?status=updated");
            return;
        }

        // Tampilkan list ke halaman kelola admin
        List<Peminjaman> listAll = peminjamanDAO.getAllPeminjaman();
        request.setAttribute("daftarPeminjamanFull", listAll);
        request.getRequestDispatcher("/admin/kelola_peminjaman.jsp").forward(request, response);
    }
}