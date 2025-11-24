package com.main.filter;

import com.main.model.Employe;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.Arrays;
import java.util.List;

/**
 * Filtre pour vérifier l'authentification des utilisateurs
 */
@WebFilter("/*")
public class AuthenticationFilter implements Filter {

    // Pages accessibles sans authentification
    private static final List<String> PUBLIC_URLS = Arrays.asList(
            "/login",
            "/login.jsp",
            "/signin.jsp",
            "/index.jsp",
            "/test-simple.jsp",
            "/diagnostic",
            "/css/",
            "/js/",
            "/images/",
            "/error/"
    );

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        System.out.println("✓ AuthenticationFilter initialisé");
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

        System.out.println("🔍 AuthenticationFilter - Path: " + path);

        // Vérifier si l'URL est publique
        boolean isPublicResource = isPublicResource(path);

        // Vérifier si l'utilisateur est connecté
        Employe currentUser = null;
        if (session != null) {
            currentUser = (Employe) session.getAttribute("currentUser");
        }

        if (isPublicResource) {
            System.out.println("✓ Ressource publique autorisée: " + path);
            chain.doFilter(request, response);
        } else if (currentUser != null) {
            System.out.println("✓ Utilisateur connecté: " + currentUser.getUsername());
            chain.doFilter(request, response);
        } else {
            // Rediriger vers la page de connexion
            System.out.println("✗ Accès refusé - Redirection vers login: " + path);
            httpResponse.sendRedirect(contextPath + "/login.jsp");
        }
    }

    @Override
    public void destroy() {
        System.out.println("✗ AuthenticationFilter détruit");
    }

    /**
     * Vérifie si une ressource est accessible publiquement
     */
    private boolean isPublicResource(String path) {
        // Vérifier les ressources statiques
        if (path.startsWith("/css/") ||
                path.startsWith("/js/") ||
                path.startsWith("/images/") ||
                path.startsWith("/error/")) {
            return true;
        }

        // Vérifier les URLs publiques exactes
        for (String publicUrl : PUBLIC_URLS) {
            if (path.equals(publicUrl) || path.startsWith(publicUrl)) {
                return true;
            }
        }

        return false;
    }
}