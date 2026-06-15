package controller;

import dao.BukuDAO;
import dao.KategoriDAO;
import model.Buku;
import model.Kategori;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/buku")
public class BukuServlet extends HttpServlet {

    private BukuDAO dao = new BukuDAO();
    private KategoriDAO kategoriDAO = new KategoriDAO();

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("delete".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            dao.delete(id);
            response.sendRedirect(request.getContextPath() + "/buku?status=deleted");
        } else if ("edit".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            Buku buku = dao.getBukuById(id);
            List<Kategori> daftarKategori = kategoriDAO.getAllKategori();
            List<Buku> daftarBuku = dao.getAllBuku();

            request.setAttribute("editBuku", buku);
            request.setAttribute("daftarKategori", daftarKategori);
            request.setAttribute("daftarBuku", daftarBuku);

            request.getRequestDispatcher("/admin/buku.jsp").forward(request, response);
        } else {
            List<Buku> daftarBuku = dao.getAllBuku();
            List<Kategori> daftarKategori = kategoriDAO.getAllKategori();

            request.setAttribute("daftarBuku", daftarBuku);
            request.setAttribute("daftarKategori", daftarKategori);

            request.getRequestDispatcher("/admin/buku.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        String idStr = request.getParameter("idBuku");

        Buku buku = new Buku();
        buku.setJudul(request.getParameter("judul"));
        buku.setPenulis(request.getParameter("penulis"));
        buku.setPenerbit(request.getParameter("penerbit"));
        buku.setTahunTerbit(Integer.parseInt(request.getParameter("tahun")));
        buku.setJmlBuku(Integer.parseInt(request.getParameter("jumlah")));
        buku.setIdKategori(Integer.parseInt(request.getParameter("idKategori")));

        if ("update".equals(action) || (idStr != null && !idStr.isEmpty())) {
            int id = Integer.parseInt(idStr);
            buku.setIdBuku(id);
            dao.update(buku);
        } else {
            dao.insert(buku);
        }

        response.sendRedirect(request.getContextPath() + "/buku?status=success");
    }
}