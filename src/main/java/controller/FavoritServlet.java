package controller;

import dao.FavoritDAO;
import model.Favorit;
import model.User;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/favorit")
public class FavoritServlet extends HttpServlet {

    private FavoritDAO favoritDAO = new FavoritDAO();

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

        if ("add".equals(action)) {
            int idBuku = Integer.parseInt(request.getParameter("idBuku"));
            favoritDAO.addFavorit(user.getIdUser(), idBuku);
            // Redirect back to referring page or catalog
            String referer = request.getHeader("referer");
            if (referer != null && !referer.isEmpty()) {
                response.sendRedirect(referer);
            } else {
                response.sendRedirect(request.getContextPath() + "/anggota/katalog.jsp");
            }
        } else if ("delete".equals(action)) {
            int idBuku = Integer.parseInt(request.getParameter("idBuku"));
            favoritDAO.removeFavorit(user.getIdUser(), idBuku);
            String referer = request.getHeader("referer");
            if (referer != null && referer.contains("katalog")) {
                response.sendRedirect(referer);
            } else {
                response.sendRedirect(request.getContextPath() + "/favorit");
            }
        } else {
            // Render favorites page for member
            List<Favorit> daftarFavorit = favoritDAO.getFavoritByUser(user.getIdUser());
            request.setAttribute("daftarFavorit", daftarFavorit);
            request.getRequestDispatcher("/anggota/favorit.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
