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
@WebServlet("/users/*")
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

        List<Employe> users = rhdao.getAllEmployees();

        request.setAttribute("users", users);
        request.setAttribute("departments", rhdao.getAllDepartements());
        request.setAttribute("projectList", rhdao.getAllProjects());
        request.setAttribute("roles", Role.values());
        request.getRequestDispatcher("/employees.jsp").forward(request, response);
    }

    private void showAddForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setAttribute("users", rhdao.getAllEmployees());
        request.setAttribute("departments", rhdao.getAllDepartements());
        request.setAttribute("projectList", rhdao.getAllProjects());
        request.setAttribute("roles", Role.values());
        request.getRequestDispatcher("/employees.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {

        String idParam = request.getParameter("id");
        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/users");
            return;
        }

        int userId = Integer.parseInt(idParam);
        Employe user = rhdao.getEmploye("id = " + userId);

        if (user != null) {
            request.setAttribute("user", user);
            request.setAttribute("roles", Role.values());
            request.getRequestDispatcher("/users/edit").forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/users");
        }
    }

    private void addUser(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {

        // Récupération des paramètres
        String first_name = request.getParameter("firstName");
        String last_name = request.getParameter("lastName");
        int age = Integer.parseInt(request.getParameter("age"));
        String gender = request.getParameter("gender");
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String email = request.getParameter("email");
        String roleStr = request.getParameter("role");
        String activeStr = request.getParameter("active");
        int departementId = Integer.parseInt(request.getParameter("departement"));
        String jobName = request.getParameter("jobName");
        String[] projectArray = request.getParameterValues("projects");
        String projects = "";
        if (projectArray != null && projectArray.length > 0) {
            projects = String.join(", ", projectArray); // Crée une string "Proj1, Proj2"
        }
        Role role = Role.fromString(roleStr);
        Employe currentUser = (Employe) request.getSession().getAttribute("currentUser");


        
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
        
        if (roleStr == null || Role.fromString(roleStr) == null) {
            errors.append("Rôle invalide. ");
        }

        if (role == Role.ADMINISTRATEUR && currentUser.getRole() != Role.ADMINISTRATEUR) {
            errors.append("Seuls les administrateurs peuvent ajouter des administrateurs. ");
        }

        if (errors.length() > 0) {
            request.setAttribute("errorMessage", errors.toString());
            request.setAttribute("firstName", first_name);
            request.setAttribute("lastName", last_name);
            request.setAttribute("gender", gender);
            request.setAttribute("age", age);
            request.setAttribute("username", username);
            request.setAttribute("email", email);
            request.setAttribute("roles", Role.values());
            request.getRequestDispatcher("/employees.jsp").forward(request, response);
            return;
        }

        // Création de l'utilisateur
        Employe newUser = new Employe(first_name, last_name, email, gender, jobName, departementId,
                Role.fromString(roleStr).getLevel(), age);

        if (projects != null) {
            System.out.println(projects);
        }

        newUser.setActive(activeStr != null && activeStr.equals("on"));
        newUser.setUsername(username);
        newUser.setPassword_hash(rhdao.hashPassword(password));

        boolean success = rhdao.save(newUser);

        if (success) {
            System.out.println("SUCCESS");
            response.sendRedirect(request.getContextPath() + "/users?success=add");
        } else {
            request.setAttribute("errorMessage", "Erreur lors de la création de l'utilisateur.");
            request.getRequestDispatcher("/employees.jsp").forward(request, response);
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
            response.sendRedirect(request.getContextPath() + "/users");
            return;
        }

        int userId = Integer.parseInt(idParam);
        Employe user = rhdao.getEmploye("id = " + userId);

        if (user != null) {
            user.setUsername(username.trim());
            user.setEmail(email.trim());
            user.setRole(Role.fromString(roleStr));

            user.setActive(activeStr != null && activeStr.equals("on"));

            boolean success = rhdao.updateEmployeById(userId,
                    "username = " + username + ", email = " + email + ", employee_rank = " + user.getRole().getLevel());

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
            int userId = Integer.parseInt(idParam);

            // Empêcher la suppression de son propre compte
            HttpSession session = request.getSession();
            Employe currentUser = (Employe) session.getAttribute("currentUser");

            if (currentUser.getId() == userId) {
                response.sendRedirect(request.getContextPath() +
                        "/users?error=cannotDeleteSelf");
                return;
            }

            rhdao.deleteEmploye(userId);
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

            int userId = Integer.parseInt(idParam);
            rhdao.updateEmployeById(userId, "password_hash = " + rhdao.hashPassword(confirmPassword));
            response.sendRedirect(request.getContextPath() + "/users?success=passwordChanged");
        } else {
            response.sendRedirect(request.getContextPath() +
                    "/users/edit?id=" + idParam + "&error=passwordInvalid");
        }
    }
}