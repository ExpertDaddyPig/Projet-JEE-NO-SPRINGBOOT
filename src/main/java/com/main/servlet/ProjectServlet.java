package com.main.servlet;

import com.main.dao.RHDAO;
import com.main.model.Employe;
import com.main.model.Project;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

/**
 * Servlet pour gérer les projets
 */
@WebServlet("/projects/*")
public class ProjectServlet extends HttpServlet {

    private RHDAO dao;

    @Override
    public void init() throws ServletException {
        dao = new RHDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String pathInfo = request.getPathInfo();

        try {
            if (pathInfo == null || pathInfo.equals("/")) {
                listProjects(request, response);
            } else if (pathInfo.equals("/create")) {
                showCreateForm(request, response);
            } else if (pathInfo.equals("/edit")) {
                showEditForm(request, response);
            } else if (pathInfo.equals("/view")) {
                viewProject(request, response);
            } else if (pathInfo.equals("/assign")) {
                showAssignForm(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException("Erreur lors du traitement de la requête", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String pathInfo = request.getPathInfo();

        try {
            if (pathInfo == null || pathInfo.equals("/")) {
                response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
            } else if (pathInfo.equals("/create")) {
                createProject(request, response);
            } else if (pathInfo.equals("/edit")) {
                updateProject(request, response);
            } else if (pathInfo.equals("/delete")) {
                deleteProject(request, response);
            } else if (pathInfo.equals("/assign")) {
                assignEmployees(request, response);
            } else if (pathInfo.equals("/changeState")) {
                changeProjectState(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException("Erreur lors du traitement de la requête", e);
        }
    }

    /**
     * Liste tous les projets
     */
    private void listProjects(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String stateFilter = request.getParameter("state");

        List<Project> projects;

        if (stateFilter != null && !stateFilter.isEmpty()) {
            projects = dao.getProjects("project_state = '" + stateFilter + "'");
        } else {
            projects = dao.getAllProjects();
        }

        request.setAttribute("projects", projects);
        request.setAttribute("stateFilter", stateFilter);
        request.getRequestDispatcher("/projects.jsp").forward(request, response);
    }

    /**
     * Affiche le formulaire de création
     */
    private void showCreateForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.getRequestDispatcher("/WEB-INF/project-create.jsp").forward(request, response);
    }

    /**
     * Crée un nouveau projet
     */
    private void createProject(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String projectName = request.getParameter("project_name");
        String projectState = request.getParameter("project_state");

        // Validation
        if (projectName == null || projectName.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Le nom du projet est requis.");
            showCreateForm(request, response);
            return;
        }

        // Créer le projet
        Project project = new Project(projectName.trim());

        // Si un état est spécifié
        if (projectState != null && !projectState.isEmpty()) {
            if (isValidState(projectState)) {
                project.setProject_state(projectState);
            }
        }

        boolean success = dao.save(project);

        if (success) {
            System.out.println("✓ Projet créé: " + projectName);
            response.sendRedirect(request.getContextPath() + "/projects?success=create");
        } else {
            request.setAttribute("errorMessage", "Erreur lors de la création du projet.");
            showCreateForm(request, response);
        }
    }

    /**
     * Affiche le formulaire de modification
     */
    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idStr = request.getParameter("id");

        if (idStr == null || idStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/projects");
            return;
        }

        int id = Integer.parseInt(idStr);
        Project project = dao.getProject("id = " + id);

        if (project != null) {
            request.setAttribute("project", project);
            request.getRequestDispatcher("/WEB-INF/project-edit.jsp").forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/projects?error=notfound");
        }
    }

    /**
     * Met à jour un projet
     */
    private void updateProject(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {

        String idStr = request.getParameter("id");
        String projectName = request.getParameter("project_name");
        String projectState = request.getParameter("project_state");

        if (idStr == null || projectName == null || projectName.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/projects?error=invalid");
            return;
        }

        int id = Integer.parseInt(idStr);

        StringBuilder changes = new StringBuilder();
        changes.append("project_name = '").append(projectName.trim()).append("'");

        if (projectState != null && isValidState(projectState)) {
            changes.append(", project_state = '").append(projectState).append("'");
        }

        boolean success = dao.updateProjectById(id, changes.toString());

        if (success) {
            System.out.println("✓ Projet mis à jour: ID " + id);
            response.sendRedirect(request.getContextPath() + "/projects?success=update");
        } else {
            request.setAttribute("errorMessage", "Erreur lors de la mise à jour.");
            showEditForm(request, response);
        }
    }

    /**
     * Affiche les détails d'un projet
     */
    private void viewProject(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idStr = request.getParameter("id");

        if (idStr == null || idStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/projects");
            return;
        }

        int id = Integer.parseInt(idStr);
        Project project = dao.getProject("id = " + id);

        if (project != null) {
            // Récupérer les employés assignés
            List<Employe> assignedEmployees = null;
            if (project.getEmployees() != null && !project.getEmployees().isEmpty()) {
                String employeeIds = project.getEmployees();
                if (!employeeIds.equals("0")) {
                    assignedEmployees = dao.getEmployees("id IN (" + employeeIds + ")");
                }
            }

            request.setAttribute("project", project);
            request.setAttribute("assignedEmployees", assignedEmployees);
            request.getRequestDispatcher("/WEB-INF/project-view.jsp").forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/projects?error=notfound");
        }
    }

    /**
     * Affiche le formulaire d'assignation d'employés
     */
    private void showAssignForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idStr = request.getParameter("id");

        if (idStr == null || idStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/projects");
            return;
        }

        int id = Integer.parseInt(idStr);
        Project project = dao.getProject("id = " + id);

        if (project != null) {
            List<Employe> allEmployees = dao.getAllEmployees();

            // Récupérer les IDs des employés déjà assignés
            String currentEmployees = project.getEmployees();

            request.setAttribute("project", project);
            request.setAttribute("allEmployees", allEmployees);
            request.setAttribute("currentEmployees", currentEmployees);
            request.getRequestDispatcher("/WEB-INF/project-assign.jsp").forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/projects?error=notfound");
        }
    }

    /**
     * Assigne des employés à un projet
     */
    private void assignEmployees(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        String idStr = request.getParameter("id");
        String[] employeeIds = request.getParameterValues("employee_ids");

        if (idStr == null || idStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/projects");
            return;
        }

        int id = Integer.parseInt(idStr);

        // Construire la liste d'IDs
        String employeeList = "0";
        if (employeeIds != null && employeeIds.length > 0) {
            employeeList = String.join(",", employeeIds);
        }

        String changes = "employees = '" + employeeList + "'";
        boolean success = dao.updateProjectById(id, changes);

        if (success) {
            System.out.println("✓ Employés assignés au projet ID " + id);

            // Mettre à jour aussi les employés avec ce projet
            if (employeeIds != null) {
                for (String empId : employeeIds) {
                    Employe emp = dao.getEmploye("id = " + empId);
                    if (emp != null) {
                        String currentProjects = emp.getProjects();
                        if (currentProjects == null || currentProjects.isEmpty() || currentProjects.equals("0")) {
                            dao.updateEmployeById(Integer.parseInt(empId), "projects = '" + id + "'");
                        } else if (!currentProjects.contains(String.valueOf(id))) {
                            String newProjects = currentProjects + "," + id;
                            dao.updateEmployeById(Integer.parseInt(empId), "projects = '" + newProjects + "'");
                        }
                    }
                }
            }

            response.sendRedirect(request.getContextPath() + "/projects/view?id=" + id + "&success=assign");
        } else {
            response.sendRedirect(request.getContextPath() + "/projects/assign?id=" + id + "&error=assign");
        }
    }

    /**
     * Change l'état d'un projet
     */
    private void changeProjectState(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        String idStr = request.getParameter("id");
        String newState = request.getParameter("state");

        if (idStr == null || newState == null || !isValidState(newState)) {
            response.sendRedirect(request.getContextPath() + "/projects");
            return;
        }

        int id = Integer.parseInt(idStr);
        String changes = "project_state = '" + newState + "'";

        boolean success = dao.updateProjectById(id, changes);

        if (success) {
            System.out.println("✓ État du projet changé: ID " + id + " -> " + newState);
            response.sendRedirect(request.getContextPath() + "/projects/view?id=" + id + "&success=stateChanged");
        } else {
            response.sendRedirect(request.getContextPath() + "/projects/view?id=" + id + "&error=stateChange");
        }
    }

    /**
     * Supprime un projet
     */
    private void deleteProject(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        String idStr = request.getParameter("id");

        if (idStr != null && !idStr.trim().isEmpty()) {
            int id = Integer.parseInt(idStr);
            dao.deleteProject(id);
            System.out.println("✓ Projet supprimé: ID " + id);
        }

        response.sendRedirect(request.getContextPath() + "/projects?success=delete");
    }

    /**
     * Vérifie si un état est valide
     */
    private boolean isValidState(String state) {
        return state.equals("in process") || state.equals("finished") || state.equals("canceled");
    }
}