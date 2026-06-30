package controller;

import dao.UserDAO;
import model.User;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;

@WebServlet("/forgot-password")
public class ForgotPasswordServlet extends HttpServlet {

    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        }
        request.getRequestDispatcher("/forgot-password.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String step = request.getParameter("step");

        if ("1".equals(step)) {
            String username = request.getParameter("username");
            if (username == null || username.trim().isEmpty()) {
                request.setAttribute("error", "Masukkan username terlebih dahulu.");
                request.getRequestDispatcher("/forgot-password.jsp").forward(request, response);
                return;
            }

            User user = userDAO.findByUsername(username.trim());
            if (user == null) {
                request.setAttribute("error", "Username tidak ditemukan.");
                request.setAttribute("step", "1");
                request.getRequestDispatcher("/forgot-password.jsp").forward(request, response);
                return;
            }

            if (user.getSecurityQuestion() == null || user.getSecurityQuestion().isEmpty()) {
                request.setAttribute("error", "Akun ini belum memiliki pertanyaan keamanan. Hubungi admin.");
                request.setAttribute("step", "1");
                request.getRequestDispatcher("/forgot-password.jsp").forward(request, response);
                return;
            }

            HttpSession session = request.getSession();
            session.setAttribute("resetUserId", user.getIdUser());
            session.setAttribute("resetUsername", user.getUsername());
            session.setAttribute("resetQuestion", user.getSecurityQuestion());

            request.setAttribute("step", "2");
            request.setAttribute("securityQuestion", user.getSecurityQuestion());
            request.setAttribute("resetUsername", user.getUsername());
            request.getRequestDispatcher("/forgot-password.jsp").forward(request, response);

        } else if ("2".equals(step)) {
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("resetUserId") == null) {
                response.sendRedirect(request.getContextPath() + "/forgot-password");
                return;
            }

            String answer = request.getParameter("answer");
            if (answer == null || answer.trim().isEmpty()) {
                request.setAttribute("error", "Jawab pertanyaan keamanan terlebih dahulu.");
                request.setAttribute("step", "2");
                request.setAttribute("securityQuestion", session.getAttribute("resetQuestion"));
                request.setAttribute("resetUsername", session.getAttribute("resetUsername"));
                request.getRequestDispatcher("/forgot-password.jsp").forward(request, response);
                return;
            }

            User user = userDAO.findByUsername((String) session.getAttribute("resetUsername"));
            if (user == null || !answer.trim().equalsIgnoreCase(user.getSecurityAnswer())) {
                request.setAttribute("error", "Jawaban keamanan salah. Silakan coba lagi.");
                request.setAttribute("step", "2");
                request.setAttribute("securityQuestion", session.getAttribute("resetQuestion"));
                request.setAttribute("resetUsername", session.getAttribute("resetUsername"));
                request.getRequestDispatcher("/forgot-password.jsp").forward(request, response);
                return;
            }

            request.setAttribute("step", "3");
            request.setAttribute("resetUsername", session.getAttribute("resetUsername"));
            request.getRequestDispatcher("/forgot-password.jsp").forward(request, response);

        } else if ("3".equals(step)) {
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("resetUserId") == null) {
                response.sendRedirect(request.getContextPath() + "/forgot-password");
                return;
            }

            String newPassword = request.getParameter("newPassword");
            String confirmPassword = request.getParameter("confirmPassword");

            if (newPassword == null || newPassword.trim().isEmpty()) {
                request.setAttribute("error", "Password baru tidak boleh kosong.");
                request.setAttribute("step", "3");
                request.setAttribute("resetUsername", session.getAttribute("resetUsername"));
                request.getRequestDispatcher("/forgot-password.jsp").forward(request, response);
                return;
            }

            if (newPassword.length() < 3) {
                request.setAttribute("error", "Password minimal 3 karakter.");
                request.setAttribute("step", "3");
                request.setAttribute("resetUsername", session.getAttribute("resetUsername"));
                request.getRequestDispatcher("/forgot-password.jsp").forward(request, response);
                return;
            }

            if (!newPassword.equals(confirmPassword)) {
                request.setAttribute("error", "Konfirmasi password tidak cocok.");
                request.setAttribute("step", "3");
                request.setAttribute("resetUsername", session.getAttribute("resetUsername"));
                request.getRequestDispatcher("/forgot-password.jsp").forward(request, response);
                return;
            }

            int userId = (int) session.getAttribute("resetUserId");
            boolean updated = userDAO.updatePassword(userId, newPassword);

            session.removeAttribute("resetUserId");
            session.removeAttribute("resetUsername");
            session.removeAttribute("resetQuestion");

            if (updated) {
                response.sendRedirect(request.getContextPath() + "/login.jsp?resetSuccess=true");
            } else {
                request.setAttribute("error", "Gagal mereset password. Silakan coba lagi.");
                request.setAttribute("step", "3");
                request.setAttribute("resetUsername", session.getAttribute("resetUsername"));
                request.getRequestDispatcher("/forgot-password.jsp").forward(request, response);
            }

        } else {
            response.sendRedirect(request.getContextPath() + "/forgot-password");
        }
    }
}
