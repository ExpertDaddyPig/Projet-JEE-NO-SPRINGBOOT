package com.main.servlet;

import com.main.model.Employe;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

/**
 * Servlet pour afficher le tableau de bord
 */
@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Récupérer l'utilisateur connecté depuis la session
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("currentUser") == null) {
            // Pas de session ou utilisateur non connecté
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        Employe currentEmploye = (Employe) session.getAttribute("currentUser");

        // Logger l'accès
        System.out.println("Dashboard accessed by: " + currentEmploye.getUsername() + " (" + currentEmploye.getRole() + ")");

        // L'utilisateur est déjà dans la session, pas besoin de le remettre
        // Il sera accessible via ${currentEmploye} dans la JSP

        // Forward vers la page JSP du dashboard
        request.getRequestDispatcher("/dashboard.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Rediriger POST vers GET
        doGet(request, response);
    }
}