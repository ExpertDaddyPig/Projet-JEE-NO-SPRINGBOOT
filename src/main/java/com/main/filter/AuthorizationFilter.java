package com.main.filter;

import com.main.model.Employe;
import com.main.model.Role;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import java.util.Set;
import java.util.HashSet;

/**
 * Filtre pour vérifier les autorisations basées sur les rôles
 */
@WebFilter("/*")
public class AuthorizationFilter implements Filter {

    // Mapping des URLs vers les rôles requis
    private Map<String, Set<Role>> urlRoleMapping;

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        initializeUrlRoleMapping();
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
        Employe currentEmploye = null;
        if (session != null) {
            currentEmploye = (Employe) session.getAttribute("currentEmploye");
        }

        // Si l'utilisateur n'est pas connecté, laisser AuthenticationFilter gérer
        if (currentEmploye == null) {
            chain.doFilter(request, response);
            return;
        }

        // Vérifier les autorisations
        if (isAuthorized(path, currentEmploye.getRole())) {
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
     * Initialise le mapping entre URLs et rôles
     */
    private void initializeUrlRoleMapping() {
        urlRoleMapping = new HashMap<>();

        // Pages accessibles uniquement par l'administrateur
        Set<Role> adminOnly = new HashSet<>();
        adminOnly.add(Role.ADMINISTRATEUR);
        urlRoleMapping.put("/admin/", adminOnly);
        urlRoleMapping.put("/users/", adminOnly);

        // Pages accessibles par admin et chefs de département
        Set<Role> adminAndDeptHead = new HashSet<>();
        adminAndDeptHead.add(Role.ADMINISTRATEUR);
        adminAndDeptHead.add(Role.CHEF_DEPARTEMENT);
        urlRoleMapping.put("/departments/", adminAndDeptHead);
        urlRoleMapping.put("/employees/", adminAndDeptHead);

        // Pages accessibles par admin, chefs de département et chefs de projet
        Set<Role> adminDeptAndProject = new HashSet<>();
        adminDeptAndProject.add(Role.ADMINISTRATEUR);
        adminDeptAndProject.add(Role.CHEF_DEPARTEMENT);
        adminDeptAndProject.add(Role.CHEF_PROJET);
        urlRoleMapping.put("/projects/", adminDeptAndProject);

        // Pages fiches de paie : tous sauf employés basiques (sauf leur propre fiche)
        Set<Role> payslipManagers = new HashSet<>();
        payslipManagers.add(Role.ADMINISTRATEUR);
        payslipManagers.add(Role.CHEF_DEPARTEMENT);
        urlRoleMapping.put("/payslips/manage", payslipManagers);
    }

    /**
     * Vérifie si un rôle est autorisé pour un chemin donné
     */
    private boolean isAuthorized(String path, Role userRole) {
        // Pages publiques ou non protégées
        if (path.startsWith("/login") ||
                path.startsWith("/logout") ||
                path.startsWith("/dashboard") ||
                path.startsWith("/profile") ||
                path.startsWith("/css/") ||
                path.startsWith("/js/") ||
                path.startsWith("/images/")) {
            return true;
        }

        // Vérifier le mapping des rôles
        for (Map.Entry<String, Set<Role>> entry : urlRoleMapping.entrySet()) {
            if (path.startsWith(entry.getKey())) {
                return entry.getValue().contains(userRole);
            }
        }

        // Par défaut, autoriser si aucune restriction spécifique
        return true;
    }
}