package com.main.filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.Arrays;
import java.util.List;

import com.main.model.Employe;

/**
 * Filtre pour vérifier l'authentification des utilisateurs
 */
@WebFilter("/*")
public class AuthenticationFilter implements Filter {

    // Pages accessibles sans authentification
    private static final List<String> PUBLIC_URLS = Arrays.asList(
            "/login",
            "/login.jsp",
            "/test-connection",
            "/css/",
            "/js/",
            "/images/",
            "/error/"
    );

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Initialisation si nécessaire
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);

        String requestURI = httpRequest.getRequestURI();
        String contextPath = httpRequest.getContextPath();
        String path = requestURI.substring(contextPath.length());

        // Vérifier si l'URL est publique
        boolean isPublicResource = isPublicResource(path);

        // Vérifier si l'utilisateur est connecté
        Employe currentEmploye = null;
        if (session != null) {
            currentEmploye = (Employe) session.getAttribute("currentUser");
        }

        if (isPublicResource || currentEmploye != null) {
            // Autoriser l'accès
            chain.doFilter(request, response);
        } else {
            // Rediriger vers la page de connexion
            httpResponse.sendRedirect(contextPath + "/login.jsp");
        }
    }

    @Override
    public void destroy() {
        // Nettoyage si nécessaire
    }

    /**
     * Vérifie si une ressource est accessible publiquement
     */
    private boolean isPublicResource(String path) {
        for (String publicUrl : PUBLIC_URLS) {
            if (path.startsWith(publicUrl)) {
                return true;
            }
        }
        return false;
    }
}