package controller;

import dao.UserDAO;
import model.User;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/user")
public class UserServlet extends HttpServlet {

    private UserDAO dao = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("delete".equals(action)) {
            try {
                int id = Integer.parseInt(request.getParameter("id"));
                boolean success = dao.delete(id); // Asumsi method delete Anda mengembalikan nilai boolean
                
                if (success) {
                    response.sendRedirect(request.getContextPath() + "/user?status=deleted");
                } else {
                    response.sendRedirect(request.getContextPath() + "/user?status=fail");
                }
            } catch (Exception e) {
                e.printStackTrace();
                // Antisipasi error Foreign Key Constraint jika user masih meminjam buku
                response.sendRedirect(request.getContextPath() + "/user?status=fail");
            }
        } else if ("edit".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            User editUser = dao.getUserById(id);
            List<User> daftarUser = dao.getAllUser();

            request.setAttribute("editUser", editUser);
            request.setAttribute("daftarUser", daftarUser);

            request.getRequestDispatcher("/admin/user.jsp").forward(request, response);
        } else {
            List<User> daftarUser = dao.getAllUser();
            request.setAttribute("daftarUser", daftarUser);
            request.getRequestDispatcher("/admin/user.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        String idStr = request.getParameter("idUser");

        User user = new User();
        user.setUsername(request.getParameter("username"));
        user.setPassword(request.getParameter("password"));
        user.setEmail(request.getParameter("email"));
        user.setNamaLengkap(request.getParameter("namaLengkap"));
        user.setAlamat(request.getParameter("alamat"));
        user.setLevel(request.getParameter("level"));

        boolean isSuccess = false;

        try {
            if ("update".equals(action) || (idStr != null && !idStr.isEmpty())) {
                int id = Integer.parseInt(idStr);
                user.setIdUser(id);
                isSuccess = dao.update(user); // Asumsi method update Anda mengembalikan boolean
            } else {
                isSuccess = dao.insert(user); // Asumsi method insert Anda mengembalikan boolean
            }

            if (isSuccess) {
                response.sendRedirect(request.getContextPath() + "/user?status=success");
            } else {
                response.sendRedirect(request.getContextPath() + "/user?status=fail");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/user?status=fail");
        }
    }
}