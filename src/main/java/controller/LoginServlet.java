package controller;

import dao.UserDAO;
import model.User;
import model.Admin;
import model.Anggota;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        }
        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        UserDAO dao = new UserDAO();
        User user = dao.login(username, password);

        if (user != null) {
            HttpSession session = request.getSession(true);
            session.setAttribute("user", user);
            session.setAttribute("level", user.getLevel()); // pertahankan yang sudah ada

            // [OOP: Polymorphism] Cek tipe runtime untuk routing yang tepat
            if (user instanceof Admin) {
                Admin admin = (Admin) user; // [OOP: Downcasting]
                session.setAttribute("canManageBooks", admin.canManageBooks());
                response.sendRedirect(request.getContextPath() + admin.getDashboardPath());
            } else if (user instanceof Anggota) {
                Anggota anggota = (Anggota) user; // [OOP: Downcasting]
                session.setAttribute("maxBorrow", anggota.getMaxBorrowLimit());
                response.sendRedirect(request.getContextPath() + anggota.getDashboardPath());
            }
        } else {
            request.setAttribute("error", "Username atau password salah!");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }
}