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
            int id = Integer.parseInt(request.getParameter("id"));
            dao.delete(id);
            response.sendRedirect(request.getContextPath() + "/user");
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

        if ("update".equals(action) || (idStr != null && !idStr.isEmpty())) {
            int id = Integer.parseInt(idStr);
            user.setIdUser(id);
            dao.update(user);
        } else {
            dao.insert(user);
        }

        response.sendRedirect(request.getContextPath() + "/user");
    }
}
