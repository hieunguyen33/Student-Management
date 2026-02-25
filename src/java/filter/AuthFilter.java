package filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.*;
import java.io.IOException;

/**
 * AuthFilter – redirects unauthenticated users to the login page.
 * Applied to every URL pattern except /login and static resources.
 */
@WebFilter(filterName = "AuthFilter", urlPatterns = {"/*"})
public class AuthFilter implements Filter {

    // Pages that do NOT require authentication
    private static final String[] PUBLIC_PATHS = {
        "/login",
        "/login.jsp",
        "/index.jsp"
    };

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // nothing to initialise
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response,
                         FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest  req  = (HttpServletRequest)  request;
        HttpServletResponse resp = (HttpServletResponse) response;

        String path = req.getServletPath();

        // Allow public paths through unconditionally
        if (isPublicPath(path)) {
            chain.doFilter(request, response);
            return;
        }

        // Check session
        HttpSession session  = req.getSession(false);
        boolean     loggedIn = (session != null) && (session.getAttribute("loggedInUser") != null);

        if (loggedIn) {
            chain.doFilter(request, response);
        } else {
            resp.sendRedirect(req.getContextPath() + "/login");
        }
    }

    @Override
    public void destroy() {
        // nothing to clean up
    }

    private boolean isPublicPath(String path) {
        for (String pub : PUBLIC_PATHS) {
            if (path.equalsIgnoreCase(pub)) return true;
        }
        return false;
    }
}