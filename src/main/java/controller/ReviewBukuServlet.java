package controller;

import dao.BukuDAO;
import dao.UlasanDAO;
import model.Buku;
import model.Ulasan;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/review-buku") // Menggunakan URL yang spesifik
public class ReviewBukuServlet extends HttpServlet {

    private BukuDAO bukuDAO = new BukuDAO();
    private UlasanDAO ulasanDAO = new UlasanDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String idBukuStr = request.getParameter("idBuku");
        if (idBukuStr != null && !idBukuStr.isEmpty()) {
            try {
                int idBuku = Integer.parseInt(idBukuStr);
                
                Buku buku = bukuDAO.getBukuById(idBuku);
                List<Ulasan> ulasanPublik = ulasanDAO.getUlasanByBuku(idBuku);
                double rataRata = ulasanDAO.getRataRataRatingBuku(idBuku);

                request.setAttribute("buku", buku);
                request.setAttribute("ulasanPublik", ulasanPublik);
                request.setAttribute("rataRataRating", rataRata);

                // Diarahkan ke file JSP yang baru dan spesifik
                request.getRequestDispatcher("/anggota/RiviewBuku.jsp").forward(request, response);
                return;
                
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }
        response.sendRedirect(request.getContextPath() + "/dashboard");
    }
}