package com.main.servlet;

import com.main.dao.RHDAO;
import com.main.model.Role;
import com.main.model.Employe;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

/**
 * Servlet pour gérer les opérations CRUD sur les utilisateurs
 * Accessible uniquement aux administrateurs
 */
@WebServlet("/employees/*")
public class UserManagementServlet extends HttpServlet {

    private RHDAO rhdao;

    @Override
    public void init() throws ServletException {
        rhdao = new RHDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String pathInfo = request.getPathInfo();

        try {
            if (pathInfo == null || pathInfo.equals("/")) {
                listUsers(request, response);
            } else if (pathInfo.equals("/add")) {
                showAddForm(request, response);
            } else if (pathInfo.equals("/edit")) {
                showEditForm(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (SQLException e) {
            throw new ServletException("Erreur base de données", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String pathInfo = request.getPathInfo();

        try {
            if (pathInfo == null || pathInfo.equals("/")) {
                response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
            } else if (pathInfo.equals("/add")) {
                addUser(request, response);
            } else if (pathInfo.equals("/edit")) {
                updateUser(request, response);
            } else if (pathInfo.equals("/delete")) {
                deleteUser(request, response);
            } else if (pathInfo.equals("/changePassword")) {
                changePassword(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (SQLException e) {
            throw new ServletException("Erreur base de données", e);
        }
    }

    private void listUsers(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {

        List<Employe> employees = rhdao.getAllEmployees();
        request.setAttribute("employees", employees);
        request.getRequestDispatcher("/employe.jsp").forward(request, response);
    }

    private void showAddForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setAttribute("roles", Role.values());
        request.getRequestDispatcher("/WEB-INF/employee-add.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {

        String idParam = request.getParameter("id");
        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/employees");
            return;
        }

        int userId = Integer.parseInt(idParam);
        Employe user = rhdao.getEmploye("id = " + userId);

        if (user != null) {
            request.setAttribute("user", user);
            request.setAttribute("roles", Role.values());
            request.getRequestDispatcher("/WEB-INF/employee-edit.jsp").forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/employees");
        }
    }

    private void addUser(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {

        // Récupération des paramètres
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String email = request.getParameter("email");
        String roleStr = request.getParameter("role");
        String firstName = request.getParameter("first_name");
        String lastName = request.getParameter("last_name");
        String activeStr = request.getParameter("active");

        // Validation
        StringBuilder errors = new StringBuilder();

        if (username == null || username.trim().isEmpty()) {
            errors.append("Le nom d'utilisateur est requis. ");
        } else if (rhdao.usernameExists(username.trim())) {
            errors.append("Ce nom d'utilisateur existe déjà. ");
        }

        if (password == null || password.length() < 6) {
            errors.append("Le mot de passe doit contenir au moins 6 caractères. ");
        }

        if (!password.equals(confirmPassword)) {
            errors.append("Les mots de passe ne correspondent pas. ");
        }

        if (email == null || !email.matches("^[A-Za-z0-9+_.-]+@(.+)$")) {
            errors.append("Email invalide. ");
        }

        Role role = Role.fromString(roleStr);
        if (roleStr == null || role == null) {
            errors.append("Rôle invalide. ");
        }

        if (errors.length() > 0) {
            request.setAttribute("errorMessage", errors.toString());
            request.setAttribute("username", username);
            request.setAttribute("email", email);
            request.setAttribute("roles", Role.values());
            showAddForm(request, response);
            return;
        }

        // Création de l'utilisateur
        Employe newUser = new Employe();
        newUser.setUsername(username.trim());
        newUser.setPassword_hash(rhdao.hashPassword(password));
        newUser.setEmail(email.trim());
        newUser.setFirst_name(firstName != null ? firstName.trim() : "");
        newUser.setLast_name(lastName != null ? lastName.trim() : "");
        newUser.setRole(role); // Ceci met automatiquement employe_rank
        newUser.setActive(activeStr != null && activeStr.equals("on"));

        boolean success = rhdao.save(newUser);

        if (success) {
            response.sendRedirect(request.getContextPath() + "/employees?success=add");
        } else {
            request.setAttribute("errorMessage", "Erreur lors de la création de l'utilisateur.");
            showAddForm(request, response);
        }
    }

    private void updateUser(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {

        String idParam = request.getParameter("id");
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String roleStr = request.getParameter("role");
        String activeStr = request.getParameter("active");

        // Validation
        if (idParam == null || username == null || email == null || roleStr == null) {
            response.sendRedirect(request.getContextPath() + "/employees");
            return;
        }

        int userId = Integer.parseInt(idParam);
        Employe user = rhdao.getEmploye("id = " + userId);

        if (user != null) {
            user.setUsername(username.trim());
            user.setEmail(email.trim());

            Role role = Role.fromString(roleStr);
            if (role != null) {
                user.setRole(role); // Ceci met à jour employe_rank automatiquement
            }

            user.setActive(activeStr != null && activeStr.equals("on"));

            // Mise à jour dans la base
            boolean success = rhdao.updateEmployeById(userId,
                    "username = '" + username.trim() + "', " +
                            "email = '" + email.trim() + "', " +
                            "employe_rank = " + user.getEmploye_rank() + ", " +
                            "isActive = " + (user.isActive() ? 1 : 0)
            );

            if (success) {
                response.sendRedirect(request.getContextPath() + "/employees?success=update");
            } else {
                request.setAttribute("errorMessage", "Erreur lors de la mise à jour.");
                showEditForm(request, response);
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/employees");
        }
    }

    private void deleteUser(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {

        String idParam = request.getParameter("id");
        if (idParam != null) {
            int userId = Integer.parseInt(idParam);

            // Empêcher la suppression de son propre compte
            HttpSession session = request.getSession();
            Employe currentUser = (Employe) session.getAttribute("currentUser");

            if (currentUser.getId() == userId) {
                response.sendRedirect(request.getContextPath() +
                        "/employees?error=cannotDeleteSelf");
                return;
            }

            rhdao.deleteEmploye(userId);
        }

        response.sendRedirect(request.getContextPath() + "/employees?success=delete");
    }

    private void changePassword(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {

        String idParam = request.getParameter("id");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        if (idParam != null && newPassword != null &&
                newPassword.equals(confirmPassword) && newPassword.length() >= 6) {

            int userId = Integer.parseInt(idParam);
            String hashedPassword = rhdao.hashPassword(newPassword);
            rhdao.updateEmployeById(userId, "password_hash = '" + hashedPassword + "'");
            response.sendRedirect(request.getContextPath() + "/employees?success=passwordChanged");
        } else {
            response.sendRedirect(request.getContextPath() +
                    "/employees/edit?id=" + idParam + "&error=passwordInvalid");
        }
    }
}