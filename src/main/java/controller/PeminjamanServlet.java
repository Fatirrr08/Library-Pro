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

        if ("admin".equalsIgnoreCase(user.getLevel())) {
            // Admin Actions
            if ("kembalikan".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                peminjamanDAO.kembalikan(id);
                response.sendRedirect(request.getContextPath() + "/peminjaman");
            } else {
                List<Peminjaman> daftarPeminjaman = peminjamanDAO.getAllPeminjaman();
                List<Buku> daftarBuku = bukuDAO.getAllBuku();
                List<User> daftarUser = userDAO.getAllUser();

                request.setAttribute("daftarPeminjaman", daftarPeminjaman);
                request.setAttribute("daftarBuku", daftarBuku);
                request.setAttribute("daftarUser", daftarUser);

                request.getRequestDispatcher("/admin/peminjaman.jsp").forward(request, response);
            }
        } else {
            // Anggota Actions
            if ("pinjam".equals(action)) {
                int idBuku = Integer.parseInt(request.getParameter("idBuku"));
                boolean success = peminjamanDAO.pinjam(user.getIdUser(), idBuku);
                if (success) {
                    response.sendRedirect(request.getContextPath() + "/peminjaman?status=success");
                } else {
                    response.sendRedirect(request.getContextPath() + "/peminjaman?status=fail");
                }
            } else if ("kembalikan".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                peminjamanDAO.kembalikan(id);
                response.sendRedirect(request.getContextPath() + "/peminjaman");
            } else {
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

        // Only Admin can record manual borrowing via POST
        if ("admin".equalsIgnoreCase(user.getLevel())) {
            int idUser = Integer.parseInt(request.getParameter("idUser"));
            int idBuku = Integer.parseInt(request.getParameter("idBuku"));

            peminjamanDAO.pinjam(idUser, idBuku);
        }

        response.sendRedirect(request.getContextPath() + "/peminjaman");
    }
}
