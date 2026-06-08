package controller;

import dao.UserDAO;
import model.User;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.Base64;
import java.util.UUID;

@WebServlet("/profile")
public class ProfileServlet extends HttpServlet {

    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        request.getRequestDispatcher("/profile.jsp").forward(request, response);
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
        String action = request.getParameter("action");

        if ("delete_photo".equals(action)) {
            // Delete current profile picture and reset to default
            String oldPhoto = user.getFotoProfil();
            if (oldPhoto != null && !oldPhoto.isEmpty()) {
                String uploadPath = getServletContext().getRealPath("/") + "uploads" + File.separator + "profile";
                File file = new File(uploadPath + File.separator + oldPhoto);
                if (file.exists()) {
                    file.delete();
                }
            }
            user.setFotoProfil(null);
            userDAO.updateProfile(user);
            session.setAttribute("user", user);
            response.sendRedirect(request.getContextPath() + "/profile?status=photo_deleted");
            return;
        }

        // Standard profile update
        String namaLengkap = request.getParameter("namaLengkap");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String croppedImage = request.getParameter("croppedImage");

        if (namaLengkap == null || namaLengkap.trim().isEmpty() || email == null || email.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/profile?status=invalid_input");
            return;
        }

        user.setNamaLengkap(namaLengkap);
        user.setEmail(email);
        if (password != null && !password.trim().isEmpty()) {
            user.setPassword(password);
        }

        if (croppedImage != null && !croppedImage.trim().isEmpty()) {
            // Process the Base64 cropped image
            try {
                // Example: data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAA...
                String[] parts = croppedImage.split(",");
                if (parts.length == 2) {
                    String header = parts[0];
                    String base64Data = parts[1];

                    // Validate image type
                    String extension = "png";
                    if (header.contains("image/jpeg") || header.contains("image/jpg")) {
                        extension = "jpg";
                    } else if (header.contains("image/png")) {
                        extension = "png";
                    } else {
                        response.sendRedirect(request.getContextPath() + "/profile?status=invalid_type");
                        return;
                    }

                    byte[] imageBytes = Base64.getDecoder().decode(base64Data);

                    // Validate size (max 2MB = 2 * 1024 * 1024 bytes)
                    if (imageBytes.length > 2 * 1024 * 1024) {
                        response.sendRedirect(request.getContextPath() + "/profile?status=file_too_large");
                        return;
                    }

                    // Ensure target directory exists
                    String uploadPath = getServletContext().getRealPath("/") + "uploads" + File.separator + "profile";
                    File uploadDir = new File(uploadPath);
                    if (!uploadDir.exists()) {
                        uploadDir.mkdirs();
                    }

                    // Delete old photo if it exists
                    String oldPhoto = user.getFotoProfil();
                    if (oldPhoto != null && !oldPhoto.isEmpty()) {
                        File file = new File(uploadPath + File.separator + oldPhoto);
                        if (file.exists()) {
                            file.delete();
                        }
                    }

                    // Generate a unique file name
                    String newFileName = user.getUsername() + "_" + UUID.randomUUID().toString() + "." + extension;
                    File newFile = new File(uploadPath + File.separator + newFileName);

                    try (FileOutputStream fos = new FileOutputStream(newFile)) {
                        fos.write(imageBytes);
                    }

                    user.setFotoProfil(newFileName);
                }
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect(request.getContextPath() + "/profile?status=error");
                return;
            }
        }

        boolean success = userDAO.updateProfile(user);
        if (success) {
            // Sync with session
            session.setAttribute("user", user);
            response.sendRedirect(request.getContextPath() + "/profile?status=success");
        } else {
            response.sendRedirect(request.getContextPath() + "/profile?status=error");
        }
    }
}
