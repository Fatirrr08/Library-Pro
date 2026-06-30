package controller;

import dao.UserDAO;
import model.User;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        }
        request.getRequestDispatcher("/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String nama = request.getParameter("nama");
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String alamat = request.getParameter("alamat");

        UserDAO dao = new UserDAO();

        if (dao.checkUsernameExists(username)) {
            request.setAttribute("error", "Username sudah terdaftar! Pilih username lain.");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        User user = new User();
        user.setNamaLengkap(nama);
        user.setUsername(username);
        user.setEmail(email);
        user.setPassword(password);
        user.setAlamat(alamat);
        user.setLevel("anggota");
        user.setSecurityQuestion(request.getParameter("securityQuestion"));
        user.setSecurityAnswer(request.getParameter("securityAnswer"));

        boolean success = dao.register(user);

        if (success) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?registerSuccess=true");
        } else {
            request.setAttribute("error", "Gagal melakukan registrasi. Silakan coba lagi.");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
        }
    }
}
