package controller;

import dao.BukuDAO;
import dao.KategoriDAO;
import model.Buku;
import model.Kategori;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.List;
import java.util.UUID;

@WebServlet("/buku")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,
    maxFileSize = 2 * 1024 * 1024,
    maxRequestSize = 5 * 1024 * 1024
)
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
            try {
                Buku bukuToDelete = dao.getBukuById(id);
                if (bukuToDelete.getFotoBuku() != null && !bukuToDelete.getFotoBuku().isEmpty()) {
                    String filePath = getServletContext().getRealPath("/") + "uploads" + File.separator + "buku" + File.separator + bukuToDelete.getFotoBuku();
                    File file = new File(filePath);
                    if (file.exists()) file.delete();
                }
            } catch (Exception e) {
                response.sendRedirect(request.getContextPath() + "/buku?status=fail");
                return;
            }
            boolean deleted = dao.delete(id);
            if (deleted) {
                response.sendRedirect(request.getContextPath() + "/buku?status=deleted");
            } else {
                response.sendRedirect(request.getContextPath() + "/buku?status=fail");
            }
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

        // Pembuatan objek model Buku
        Buku buku = new Buku();
        buku.setJudul(request.getParameter("judul"));
        buku.setPenulis(request.getParameter("penulis"));
        buku.setPenerbit(request.getParameter("penerbit"));
        buku.setTahunTerbit(Integer.parseInt(request.getParameter("tahun")));
        buku.setJmlBuku(Integer.parseInt(request.getParameter("jumlah")));
        buku.setIdKategori(Integer.parseInt(request.getParameter("idKategori")));
        
        // 🌟 PERBAIKAN: Tangkap parameter form jsp dan masukkan ke dalam objek buku
        buku.setIsbn(request.getParameter("isbn"));
        buku.setAbstraksi(request.getParameter("abstraksi"));

        // Handle cover image upload
        Part coverPart = request.getPart("coverImage");
        if (coverPart != null && coverPart.getSize() > 0) {
            // Delete old cover if updating
            if ("update".equals(action) || (idStr != null && !idStr.isEmpty())) {
                int id = Integer.parseInt(idStr);
                Buku existing = dao.getBukuById(id);
                if (existing.getFotoBuku() != null && !existing.getFotoBuku().isEmpty()) {
                    String oldPath = getServletContext().getRealPath("/") + "uploads" + File.separator + "buku" + File.separator + existing.getFotoBuku();
                    File oldFile = new File(oldPath);
                    if (oldFile.exists()) oldFile.delete();
                }
            }
            String fileName = saveCoverImage(coverPart, request);
            if (fileName != null) {
                buku.setFotoBuku(fileName);
            } else {
                response.sendRedirect(request.getContextPath() + "/buku?status=fail");
                return;
            }
        } else if ("update".equals(action) || (idStr != null && !idStr.isEmpty())) {
            // Preserve existing cover on update if no new file uploaded
            int id = Integer.parseInt(idStr);
            Buku existing = dao.getBukuById(id);
            buku.setFotoBuku(existing.getFotoBuku());
        }

        try {
            if ("update".equals(action) || (idStr != null && !idStr.isEmpty())) {
                int id = Integer.parseInt(idStr);
                buku.setIdBuku(id);
                
                boolean updated = dao.update(buku);
                if (updated) {
                    response.sendRedirect(request.getContextPath() + "/buku?status=success");
                } else {
                    response.sendRedirect(request.getContextPath() + "/buku?status=fail");
                }
            } else {
                dao.insert(buku);
                response.sendRedirect(request.getContextPath() + "/buku?status=success");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/buku?status=fail");
        }
    }

    private String saveCoverImage(Part part, HttpServletRequest request) {
        try {
            String submittedFileName = part.getSubmittedFileName();
            if (submittedFileName == null || submittedFileName.isEmpty()) return null;

            String extension = "";
            int dotIndex = submittedFileName.lastIndexOf('.');
            if (dotIndex > 0) {
                extension = submittedFileName.substring(dotIndex).toLowerCase();
            }
            if (!extension.equals(".jpg") && !extension.equals(".jpeg") && !extension.equals(".png")) {
                return null;
            }

            String uploadPath = getServletContext().getRealPath("/") + "uploads" + File.separator + "buku";
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }

            String newFileName = "cover_" + UUID.randomUUID().toString() + extension;
            File newFile = new File(uploadPath + File.separator + newFileName);

            try (InputStream is = part.getInputStream();
                 FileOutputStream fos = new FileOutputStream(newFile)) {
                byte[] buffer = new byte[8192];
                int bytesRead;
                while ((bytesRead = is.read(buffer)) != -1) {
                    fos.write(buffer, 0, bytesRead);
                }
            }

            return newFileName;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
}