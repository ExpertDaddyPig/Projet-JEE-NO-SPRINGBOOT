package com.main.servlet;

import com.main.model.Employe;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

/**
 * Servlet pour gérer la déconnexion des utilisateurs
 */
@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processLogout(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processLogout(request, response);
    }

    private void processLogout(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        HttpSession session = request.getSession(false);

        if (session != null) {
            // Récupérer l'utilisateur pour le log
            Employe user = (Employe) session.getAttribute("currentUser");
            if (user != null) {
                System.out.println("Déconnexion de : " + user.getUsername());
            }

            // Invalider la session
            session.invalidate();
        }

        // Supprimer les cookies "Se souvenir de moi"
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if ("username".equals(cookie.getName())) {
                    cookie.setMaxAge(0);
                    cookie.setPath(request.getContextPath());
                    response.addCookie(cookie);
                }
            }
        }

        // Rediriger vers la page de connexion
        response.sendRedirect(request.getContextPath() + "/login.jsp?logout=success");
    }
}