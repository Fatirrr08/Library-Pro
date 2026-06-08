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
        String action = request.getParameter("action");

        if ("delete".equals(action)) {
            int idUlasan = Integer.parseInt(request.getParameter("id"));
            int idBuku = Integer.parseInt(request.getParameter("idBuku"));
            ulasanDAO.deleteUlasan(idUlasan, user.getIdUser());
            response.sendRedirect(request.getContextPath() + "/ulasan?idBuku=" + idBuku);
        } else {
            String idBukuStr = request.getParameter("idBuku");
            if (idBukuStr == null || idBukuStr.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/anggota/katalog.jsp");
                return;
            }

            int idBuku = Integer.parseInt(idBukuStr);
            Buku buku = bukuDAO.getBukuById(idBuku);
            List<Ulasan> daftarUlasan = ulasanDAO.getUlasanByBuku(idBuku);
            double ratingRataRata = ulasanDAO.getRataRataRatingBuku(idBuku);

            request.setAttribute("buku", buku);
            request.setAttribute("daftarUlasan", daftarUlasan);
            request.setAttribute("ratingRata", ratingRataRata);

            request.getRequestDispatcher("/anggota/ulasan.jsp").forward(request, response);
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
        int idBuku = Integer.parseInt(request.getParameter("idBuku"));
        String ulasanText = request.getParameter("ulasan");
        int rating = Integer.parseInt(request.getParameter("rating"));
        String idUlasanStr = request.getParameter("idUlasan");

        Ulasan ulasan = new Ulasan();
        ulasan.setIdUser(user.getIdUser());
        ulasan.setIdBuku(idBuku);
        ulasan.setUlasan(ulasanText);
        ulasan.setRating(rating);

        if (idUlasanStr != null && !idUlasanStr.isEmpty()) {
            int idUlasan = Integer.parseInt(idUlasanStr);
            ulasan.setIdUlasan(idUlasan);
            ulasanDAO.updateUlasan(ulasan);
        } else {
            ulasanDAO.addUlasan(ulasan);
        }

        response.sendRedirect(request.getContextPath() + "/ulasan?idBuku=" + idBuku);
    }
}
