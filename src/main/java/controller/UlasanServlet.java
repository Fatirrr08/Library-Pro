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
        String idBukuParam = request.getParameter("idBuku");

        // ==================== ALUR 1: LOGIKA KHUSUS ROLE ADMIN ====================
        if ("admin".equalsIgnoreCase(user.getLevel())) {
            
            // 1A. Aksi Hapus Moderasi oleh Admin
            if ("delete".equals(action)) {
                try {
                    int idUlasan = Integer.parseInt(request.getParameter("id"));
                    boolean deleted = ulasanDAO.deleteUlasan(idUlasan);
                    
                    if (deleted) {
                        response.sendRedirect(request.getContextPath() + "/ulasan?status=deleted");
                    } else {
                        response.sendRedirect(request.getContextPath() + "/ulasan?status=fail");
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    response.sendRedirect(request.getContextPath() + "/ulasan?status=fail");
                }
                return;
            }
            
            // 1B. Tampilan Default Admin: Mengambil Semua Ulasan dari Seluruh User
            try {
                List<Ulasan> semuaUlasan = ulasanDAO.getAllUlasan(); 
                request.setAttribute("semuaUlasan", semuaUlasan);
                
                // Pastikan file ini ada di folder webapp/admin/KelolaUlasan.jsp
                request.getRequestDispatcher("/admin/KelolaUlasan.jsp").forward(request, response);
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect(request.getContextPath() + "/dashboard");
            }
            return; // Menghentikan eksekusi agar tidak bocor ke alur Anggota di bawah
        }

        // ==================== ALUR 2: KHUSUS ROLE ANGGOTA ====================
        if ("anggota".equalsIgnoreCase(user.getLevel())) {
            
            // 2A. Modal Edit Form Ulasan (Role Anggota)
            if ("edit".equals(action)) {
                try {
                    int idBuku = Integer.parseInt(idBukuParam);
                    Buku buku = bukuDAO.getBukuById(idBuku);
                    Ulasan editUlasan = ulasanDAO.getUlasanByUserAndBuku(user.getIdUser(), idBuku);
                    
                    if (buku != null && editUlasan != null) {
                        request.setAttribute("buku", buku);
                        request.setAttribute("editUlasan", editUlasan); 
                        request.getRequestDispatcher("/anggota/ulasan.jsp").forward(request, response);
                        return;
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }

            // 2B. Menulis Baru (Jika membawa idBukuParam)
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

            // 2C. Tampilan Default Anggota: History Ulasan Saya
            List<Ulasan> historyUlasan = ulasanDAO.getUlasanByUser(user.getIdUser());
            request.setAttribute("historyUlasan", historyUlasan);
            request.getRequestDispatcher("/anggota/ulasan.jsp").forward(request, response);
        } else {
            // Jika level tidak dikenali
            response.sendRedirect(request.getContextPath() + "/login.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Method doPost Anda sudah 100% Sempurna, tidak perlu diubah.
        // ... (tetap gunakan kode doPost bawaan Anda sebelumnya) ...
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");
        
        String idUlasanStr = request.getParameter("idUlasan"); 
        String idBukuStr = request.getParameter("idBuku");
        String ratingStr = request.getParameter("rating");
        String ulasanText = request.getParameter("ulasan");

        if (idBukuStr != null && ratingStr != null && ulasanText != null) {
            try {
                int idBuku = Integer.parseInt(idBukuStr);
                int rating = Integer.parseInt(ratingStr);

                Ulasan ulasanObj = new Ulasan();
                ulasanObj.setIdUser(user.getIdUser());
                ulasanObj.setIdBuku(idBuku);
                ulasanObj.setRating(rating);
                ulasanObj.setUlasan(ulasanText);

                boolean success = false;

                if (idUlasanStr == null || idUlasanStr.isEmpty()) {
                    Ulasan existingUlasan = ulasanDAO.getUlasanByUserAndBuku(user.getIdUser(), idBuku);
                    if (existingUlasan != null) {
                        response.sendRedirect(request.getContextPath() + "/ulasan?status=duplicate");
                        return;
                    }
                    success = ulasanDAO.insertUlasan(ulasanObj); 
                } else {
                    int idUlasan = Integer.parseInt(idUlasanStr);
                    ulasanObj.setIdUlasan(idUlasan);
                    success = ulasanDAO.updateUlasan(ulasanObj); 
                }

                if (success) {
                    response.sendRedirect(request.getContextPath() + "/ulasan?status=success");
                } else {
                    response.sendRedirect(request.getContextPath() + "/ulasan?status=fail");
                }
            } catch (Exception e) {
                e.printStackTrace();
                String errorMsg = e.getMessage();
                if (errorMsg != null && (errorMsg.contains("1062") || errorMsg.toLowerCase().contains("duplicate"))) {
                    response.sendRedirect(request.getContextPath() + "/ulasan?status=duplicate");
                } else {
                    response.sendRedirect(request.getContextPath() + "/ulasan?status=fail");
                }
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/dashboard");
        }
    }
}