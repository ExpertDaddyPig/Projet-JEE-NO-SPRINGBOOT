package com.main.filter;

import com.main.model.Employe;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.*;
import java.io.IOException;

/**
 * Filtre pour vérifier les autorisations basées sur les rôles
 */
@WebFilter("/*")
public class AuthorizationFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Initialisation
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

        // Récupérer l'utilisateur courant
        Employe currentUser = null;
        if (session != null) {
            currentUser = (Employe) session.getAttribute("currentUser");
        }

        // Si l'utilisateur n'est pas connecté, laisser AuthenticationFilter gérer
        if (currentUser == null) {
            chain.doFilter(request, response);
            return;
        }

        // Vérifier les autorisations basées sur employe_rank
        if (isAuthorized(path, currentUser)) {
            chain.doFilter(request, response);
        } else {
            // Accès refusé
            httpRequest.setAttribute("errorMessage",
                    "Vous n'avez pas les autorisations nécessaires pour accéder à cette page.");
            httpRequest.getRequestDispatcher("/error/403.jsp").forward(httpRequest, httpResponse);
        }
    }

    @Override
    public void destroy() {
        // Nettoyage si nécessaire
    }

    /**
     * Vérifie si un utilisateur est autorisé pour un chemin donné
     */
    private boolean isAuthorized(String path, Employe user) {
        int rank = user.getEmploye_rank();

        // Pages publiques (accessibles à tous les connectés)
        if (path.startsWith("/login") ||
                path.startsWith("/logout") ||
                path.startsWith("/dashboard") ||
                path.startsWith("/profile") ||
                path.startsWith("/diagnostic") ||
                path.startsWith("/css/") ||
                path.startsWith("/js/") ||
                path.startsWith("/images/") ||
                path.endsWith(".jsp") && !path.startsWith("/WEB-INF/")) {
            return true;
        }

        // /admin - Administrateur uniquement (rank 4)
        if (path.startsWith("/admin")) {
            return rank == 4;
        }

        // /employees - Administrateur et Chef département (rank >= 3)
        if (path.startsWith("/employees")) {
            return rank >= 3;
        }

        // /departments - Administrateur et Chef département (rank >= 3)
        if (path.startsWith("/departments") || path.startsWith("/department")) {
            return rank >= 3;
        }

        // /projects - Administrateur, Chef département, Chef projet (rank >= 2)
        if (path.startsWith("/projects")) {
            return rank >= 2;
        }

        // /payslips - Tous peuvent voir leurs fiches
        // Les créations/suppressions sont gérées dans le servlet
        if (path.startsWith("/payslips") || path.startsWith("/pay")) {
            return true; // Autoriser l'accès, le servlet gérera les permissions
        }

        // Par défaut, autoriser (principe du moindre privilège inversé pour éviter de bloquer)
        return true;
    }
}