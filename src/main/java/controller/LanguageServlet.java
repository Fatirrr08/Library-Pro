package controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;

@WebServlet("/language")
public class LanguageServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String lang = request.getParameter("lang");
        if (lang != null && (lang.equalsIgnoreCase("id") || lang.equalsIgnoreCase("en"))) {
            HttpSession session = request.getSession(true);
            session.setAttribute("lang", lang.toLowerCase());
        }
        
        // Redirect back to the previous page using the Referer header
        String referer = request.getHeader("Referer");
        if (referer == null || referer.isEmpty()) {
            referer = request.getContextPath() + "/dashboard";
        }
        response.sendRedirect(referer);
    }
}
