package com.example.servlet;

import com.example.dao.UserDAO;
import com.example.model.Role;
import com.example.model.User;
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
@WebServlet("/users/*")
public class UserManagementServlet extends HttpServlet {

    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
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

        List<User> users = userDAO.getAllUsers();
        request.setAttribute("users", users);
        request.getRequestDispatcher("/WEB-INF/views/users/list.jsp").forward(request, response);
    }

    private void showAddForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setAttribute("roles", Role.values());
        request.getRequestDispatcher("/WEB-INF/views/users/add.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {

        String idParam = request.getParameter("id");
        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/users");
            return;
        }

        Long userId = Long.parseLong(idParam);
        User user = userDAO.getUserById(userId);

        if (user != null) {
            request.setAttribute("user", user);
            request.setAttribute("roles", Role.values());
            request.getRequestDispatcher("/WEB-INF/views/users/edit.jsp").forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/users");
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
        String employeeIdStr = request.getParameter("employeeId");
        String activeStr = request.getParameter("active");

        // Validation
        StringBuilder errors = new StringBuilder();

        if (username == null || username.trim().isEmpty()) {
            errors.append("Le nom d'utilisateur est requis. ");
        } else if (userDAO.usernameExists(username.trim())) {
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

        if (roleStr == null || Role.fromString(roleStr) == null) {
            errors.append("Rôle invalide. ");
        }

        if (errors.length() > 0) {
            request.setAttribute("errorMessage", errors.toString());
            request.setAttribute("username", username);
            request.setAttribute("email", email);
            request.setAttribute("roles", Role.values());
            request.getRequestDispatcher("/WEB-INF/views/users/add.jsp").forward(request, response);
            return;
        }

        // Création de l'utilisateur
        User newUser = new User();
        newUser.setUsername(username.trim());
        newUser.setPassword(password);
        newUser.setEmail(email.trim());
        newUser.setRole(Role.fromString(roleStr));

        if (employeeIdStr != null && !employeeIdStr.trim().isEmpty()) {
            newUser.setEmployeeId(Long.parseLong(employeeIdStr));
        }

        newUser.setActive(activeStr != null && activeStr.equals("on"));

        boolean success = userDAO.createUser(newUser);

        if (success) {
            response.sendRedirect(request.getContextPath() + "/users?success=add");
        } else {
            request.setAttribute("errorMessage", "Erreur lors de la création de l'utilisateur.");
            request.getRequestDispatcher("/WEB-INF/views/users/add.jsp").forward(request, response);
        }
    }

    private void updateUser(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {

        String idParam = request.getParameter("id");
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String roleStr = request.getParameter("role");
        String employeeIdStr = request.getParameter("employeeId");
        String activeStr = request.getParameter("active");

        // Validation
        if (idParam == null || username == null || email == null || roleStr == null) {
            response.sendRedirect(request.getContextPath() + "/users");
            return;
        }

        Long userId = Long.parseLong(idParam);
        User user = userDAO.getUserById(userId);

        if (user != null) {
            user.setUsername(username.trim());
            user.setEmail(email.trim());
            user.setRole(Role.fromString(roleStr));

            if (employeeIdStr != null && !employeeIdStr.trim().isEmpty()) {
                user.setEmployeeId(Long.parseLong(employeeIdStr));
            } else {
                user.setEmployeeId(null);
            }

            user.setActive(activeStr != null && activeStr.equals("on"));

            boolean success = userDAO.updateUser(user);

            if (success) {
                response.sendRedirect(request.getContextPath() + "/users?success=update");
            } else {
                request.setAttribute("errorMessage", "Erreur lors de la mise à jour.");
                showEditForm(request, response);
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/users");
        }
    }

    private void deleteUser(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {

        String idParam = request.getParameter("id");
        if (idParam != null) {
            Long userId = Long.parseLong(idParam);

            // Empêcher la suppression de son propre compte
            HttpSession session = request.getSession();
            User currentUser = (User) session.getAttribute("currentUser");

            if (currentUser.getId().equals(userId)) {
                response.sendRedirect(request.getContextPath() +
                        "/users?error=cannotDeleteSelf");
                return;
            }

            userDAO.deleteUser(userId);
        }

        response.sendRedirect(request.getContextPath() + "/users?success=delete");
    }

    private void changePassword(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {

        String idParam = request.getParameter("id");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        if (idParam != null && newPassword != null &&
                newPassword.equals(confirmPassword) && newPassword.length() >= 6) {

            Long userId = Long.parseLong(idParam);
            userDAO.changePassword(userId, newPassword);
            response.sendRedirect(request.getContextPath() + "/users?success=passwordChanged");
        } else {
            response.sendRedirect(request.getContextPath() +
                    "/users/edit?id=" + idParam + "&error=passwordInvalid");
        }
    }
}