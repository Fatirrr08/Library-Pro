package controller;

import dao.BukuDAO;
import dao.UlasanDAO;
import model.Buku;
import model.Ulasan;
import model.User;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/ulasan")
public class UlasanServlet extends HttpServlet {

    private UlasanDAO ulasanDAO = new UlasanDAO();
    private BukuDAO bukuDAO = new BukuDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");
        String idBukuParam = request.getParameter("idBuku");

        // MODE 1: Jika ada parameter idBuku, berarti user mau MENULIS ULASAN BARU
        if (idBukuParam != null && !idBukuParam.isEmpty()) {
            try {
                int idBuku = Integer.parseInt(idBukuParam);
                Buku buku = bukuDAO.getBukuById(idBuku);
                if (buku != null) {
                    request.setAttribute("buku", buku);
                    request.getRequestDispatcher("/anggota/ulasan.jsp").forward(request, response);
                    return;
                }
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }

        // MODE 2: Jika TIDAK ADA parameter idBuku, berarti menampilkan HISTORY ULASAN SAYA
        List<Ulasan> historyUlasan = ulasanDAO.getUlasanByUser(user.getIdUser());
        request.setAttribute("historyUlasan", historyUlasan);
        
        request.getRequestDispatcher("/anggota/ulasan.jsp").forward(request, response);
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
        
        // Ambil data dari form submit ulasan
        String idBukuStr = request.getParameter("idBuku");
        String ratingStr = request.getParameter("rating");
        String ulasanText = request.getParameter("ulasan");

        if (idBukuStr != null && ratingStr != null && ulasanText != null) {
            try {
                int idBuku = Integer.parseInt(idBukuStr);
                int rating = Integer.parseInt(ratingStr);

                Ulasan ulasanBaru = new Ulasan();
                ulasanBaru.setIdUser(user.getIdUser());
                ulasanBaru.setIdBuku(idBuku);
                ulasanBaru.setRating(rating);
                ulasanBaru.setUlasan(ulasanText);

                // Simpan ke Database via DAO
                boolean success = ulasanDAO.insertUlasan(ulasanBaru);

                if (success) {
                    // Jika sukses, lempar ke halaman history ulasan ini
                    response.sendRedirect(request.getContextPath() + "/ulasan");
                } else {
                    request.setAttribute("errorMessage", "Gagal menyimpan ulasan. Anda mungkin sudah mengulas buku ini.");
                    doGet(request, response);
                }
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect(request.getContextPath() + "/dashboard");
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/dashboard");
        }
    }
}