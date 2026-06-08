package filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;

import java.io.IOException;

@WebFilter("/*")
public class AuthFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {}

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        HttpSession session = req.getSession(false);

        String path = req.getRequestURI().substring(req.getContextPath().length());

        // Allow static assets, login, and register
        if (path.startsWith("/css/") || path.startsWith("/js/") || path.startsWith("/images/") ||
            path.equals("/login") || path.equals("/login.jsp") || 
            path.equals("/register") || path.equals("/register.jsp") ||
            path.equals("/") || path.equals("/index.jsp")) {
            chain.doFilter(request, response);
            return;
        }

        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null) {
            // Redirect to login if not authenticated
            res.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        // Check page authorization
        if (path.startsWith("/admin/") || path.equals("/buku") || path.equals("/kategori") || path.equals("/user")) {
            if (!"admin".equalsIgnoreCase(user.getLevel())) {
                res.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied: Admin role required.");
                return;
            }
        }

        if (path.startsWith("/anggota/") || path.equals("/favorit") || path.equals("/ulasan")) {
            if (!"anggota".equalsIgnoreCase(user.getLevel())) {
                // Admin trying to view member page -> redirect to dashboard
                res.sendRedirect(req.getContextPath() + "/dashboard");
                return;
            }
        }

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {}
}
