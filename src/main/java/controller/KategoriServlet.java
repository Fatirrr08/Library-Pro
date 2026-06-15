package controller;

import dao.KategoriDAO;
import model.Kategori;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/kategori")
public class KategoriServlet extends HttpServlet {

    private KategoriDAO dao = new KategoriDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("delete".equals(action)) {
            try {
                int id = Integer.parseInt(request.getParameter("id"));
                boolean success = dao.delete(id); // Asumsi method delete mengembalikan boolean
                
                if (success) {
                    response.sendRedirect(request.getContextPath() + "/kategori?status=deleted");
                } else {
                    response.sendRedirect(request.getContextPath() + "/kategori?status=fail");
                }
            } catch (Exception e) {
                e.printStackTrace();
                // Mengarahkan ke status fail jika gagal (misal data integrity constraint dsb)
                response.sendRedirect(request.getContextPath() + "/kategori?status=fail");
            }
        } else if ("edit".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            Kategori kategori = dao.getKategoriById(id);
            List<Kategori> daftarKategori = dao.getAllKategori();

            request.setAttribute("editKategori", kategori);
            request.setAttribute("daftarKategori", daftarKategori);

            request.getRequestDispatcher("/admin/kategori.jsp").forward(request, response);
        } else {
            List<Kategori> daftarKategori = dao.getAllKategori();
            request.setAttribute("daftarKategori", daftarKategori);
            request.getRequestDispatcher("/admin/kategori.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        String idStr = request.getParameter("idKategori");
        String namaKategori = request.getParameter("namaKategori");

        Kategori kategori = new Kategori();
        kategori.setNamaKategori(namaKategori);
        
        boolean isSuccess = false;

        try {
            if ("update".equals(action) || (idStr != null && !idStr.isEmpty())) {
                int id = Integer.parseInt(idStr);
                kategori.setIdKategori(id);
                isSuccess = dao.update(kategori); // Asumsi method update mengembalikan boolean
            } else {
                isSuccess = dao.insert(kategori); // Asumsi method insert mengembalikan boolean
            }
            
            if (isSuccess) {
                response.sendRedirect(request.getContextPath() + "/kategori?status=success");
            } else {
                response.sendRedirect(request.getContextPath() + "/kategori?status=fail");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/kategori?status=fail");
        }
    }
}