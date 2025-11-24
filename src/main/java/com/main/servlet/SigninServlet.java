package com.main.servlet;

import com.main.dao.RHDAO;
import com.main.model.Employe;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

/**
 * Servlet pour gérer l'authentification des utilisateurs
 */
@WebServlet("/signin")
public class SigninServlet extends HttpServlet {

    private RHDAO RHDAO;

    @Override
    public void init() throws ServletException {
        RHDAO = new RHDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Si l'utilisateur est déjà connecté, rediriger vers le dashboard
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("currentUser") != null) {
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        }

        // Sinon, afficher la page de connexion
        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Récupérer les paramètres du formulaire
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String rememberMe = request.getParameter("rememberMe");

        // Validation des données
        if (username == null || username.trim().isEmpty() ||
                password == null || password.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Nom d'utilisateur et mot de passe requis.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        try {
            // Authentifier l'utilisateur
            Employe user = RHDAO.authenticate(username.trim(), password);

            if (user != null) {
                // Authentification réussie
                HttpSession session = request.getSession(true);
                session.setAttribute("currentUser", user);
                session.setMaxInactiveInterval(30 * 60); // 30 minutes

                // Si "Se souvenir de moi" est coché
                if ("on".equals(rememberMe)) {
                    Cookie userCookie = new Cookie("username", username);
                    userCookie.setMaxAge(7 * 24 * 60 * 60); // 7 jours
                    userCookie.setHttpOnly(true);
                    userCookie.setPath(request.getContextPath());
                    response.addCookie(userCookie);
                }

                // Logger l'événement
                System.out.println("Connexion réussie : " + username + " (" + user.getRole() + ")");

                // Rediriger vers le dashboard
                response.sendRedirect(request.getContextPath() + "/dashboard");

            } else {
                // Authentification échouée
                request.setAttribute("errorMessage",
                        "Nom d'utilisateur ou mot de passe incorrect.");
                request.setAttribute("username", username);
                request.getRequestDispatcher("/login.jsp").forward(request, response);
            }

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage",
                    "Erreur lors de l'authentification. Veuillez réessayer.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }
}