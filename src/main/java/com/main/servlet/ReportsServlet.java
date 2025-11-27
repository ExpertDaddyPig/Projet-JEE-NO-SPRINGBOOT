package com.main.servlet;

import com.main.dao.RHDAO;
import com.main.model.Employe;
import com.main.model.Departement;
import com.main.model.Project;
import com.main.model.Role;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.*;
import java.util.stream.Collectors;

@WebServlet("/reports/*")
public class ReportsServlet extends HttpServlet {

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
            if (pathInfo == null || pathInfo.equals("/") || pathInfo.equals("/dashboard")) {
                showDashboard(request, response);
            } else if (pathInfo.equals("/departments")) {
                showDepartmentReport(request, response);
            } else if (pathInfo.equals("/projects")) {
                showProjectReport(request, response);
            } else if (pathInfo.equals("/employees")) {
                showEmployeeReport(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException("Erreur lors de la génération du rapport", e);
        }
    }

    private void showDashboard(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Récupérer toutes les données
        List<Employe> allEmployees = dao.getAllEmployees();
        List<Departement> allDepartments = dao.getAllDepartements();
        List<Project> allProjects = dao.getAllProjects();

        // Statistiques générales
        Map<String, Object> stats = new HashMap<>();
        stats.put("totalEmployees", allEmployees.size());
        stats.put("totalDepartments", allDepartments.size());
        stats.put("totalProjects", allProjects.size());

        // Employés actifs
        long activeEmployees = allEmployees.stream()
                .filter(e -> e.isActive())
                .count();
        stats.put("activeEmployees", activeEmployees);

        // Projets en cours
        long activeProjects = allProjects.stream()
                .filter(p -> "in process".equals(p.getProject_state()))
                .count();
        stats.put("activeProjects", activeProjects);

        // Projets terminés
        long finishedProjects = allProjects.stream()
                .filter(p -> "finished".equals(p.getProject_state()))
                .count();
        stats.put("finishedProjects", finishedProjects);

        Map<String, Long> employeesByRank = calculateEmployeesByRankFixed(allEmployees);

        stats.put("employeesByRank", employeesByRank);

        Map<String, Long> employeesByDept = calculateEmployeesByDepartmentFixed(allEmployees, allDepartments);
        stats.put("employeesByDepartment", employeesByDept);

        Map<String, Integer> employeesByProject = calculateEmployeesByProject(allProjects);
        stats.put("employeesByProject", employeesByProject);

        System.out.println(stats.get("employeesByRank"));

        request.setAttribute("stats", stats);
        request.setAttribute("allDepartments", allDepartments);
        request.setAttribute("allProjects", allProjects);
        request.getRequestDispatcher("/reports.jsp").forward(request, response);
    }

    private void showDepartmentReport(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Departement> departments = dao.getAllDepartements();
        List<Employe> allEmployees = dao.getAllEmployees();

        List<Map<String, Object>> departmentReports = new ArrayList<>();

        for (Departement dept : departments) {
            Map<String, Object> report = new HashMap<>();
            report.put("department", dept);

            List<Employe> deptEmployees = allEmployees.stream()
                    .filter(e -> e.getDepartement_id() != null && e.getDepartement_id().equals(dept.getId()))
                    .collect(Collectors.toList());

            report.put("employeeCount", deptEmployees.size());
            report.put("employees", deptEmployees);

            // Répartition par grade
            Map<Integer, Long> rankDistribution = deptEmployees.stream()
                    .collect(Collectors.groupingBy(Employe::getEmploye_rank, Collectors.counting()));
            report.put("rankDistribution", rankDistribution);

            departmentReports.add(report);
        }

        request.setAttribute("departmentReports", departmentReports);
        request.getRequestDispatcher("/WEB-INF/reports-departments.jsp").forward(request, response);
    }

    private void showProjectReport(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Project> projects = dao.getAllProjects();
        List<Employe> allEmployees = dao.getAllEmployees();

        List<Map<String, Object>> projectReports = new ArrayList<>();

        for (Project project : projects) {
            Map<String, Object> report = new HashMap<>();
            report.put("project", project);

            // Employés assignés
            List<Employe> assignedEmployees = new ArrayList<>();
            if (project.getEmployees() != null && !project.getEmployees().isEmpty()
                    && !project.getEmployees().equals("0")) {

                String[] employeeIds = project.getEmployees().split(",");
                for (String idStr : employeeIds) {
                    try {
                        int empId = Integer.parseInt(idStr.trim());
                        Employe emp = allEmployees.stream()
                                .filter(e -> e.getId() == empId)
                                .findFirst()
                                .orElse(null);
                        if (emp != null) {
                            assignedEmployees.add(emp);
                        }
                    } catch (NumberFormatException e) {
                        // Ignorer les IDs invalides
                    }
                }
            }

            report.put("employeeCount", assignedEmployees.size());
            report.put("employees", assignedEmployees);

            // Répartition par grade
            Map<Integer, Long> rankDistribution = assignedEmployees.stream()
                    .collect(Collectors.groupingBy(Employe::getEmploye_rank, Collectors.counting()));
            report.put("rankDistribution", rankDistribution);

            projectReports.add(report);
        }

        request.setAttribute("projectReports", projectReports);
        request.getRequestDispatcher("/WEB-INF/reports-projects.jsp").forward(request, response);
    }

    private void showEmployeeReport(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Employe> employees = dao.getAllEmployees();

        Map<String, Object> report = new HashMap<>();

        // Total et actifs
        report.put("totalEmployees", employees.size());
        report.put("activeEmployees", employees.stream().filter(Employe::isActive).count());
        report.put("inactiveEmployees", employees.stream().filter(e -> !e.isActive()).count());

        // Par grade
        Map<String, Long> byRank = new LinkedHashMap<>();
        byRank.put("Administrateurs", employees.stream().filter(e -> e.getEmploye_rank() == 4).count());
        byRank.put("Chefs de Département", employees.stream().filter(e -> e.getEmploye_rank() == 3).count());
        byRank.put("Chefs de Projet", employees.stream().filter(e -> e.getEmploye_rank() == 2).count());
        byRank.put("Employés", employees.stream().filter(e -> e.getEmploye_rank() == 1).count());
        report.put("byRank", byRank);

        // Par département
        Map<Integer, Long> byDept = employees.stream()
                .filter(e -> e.getDepartement_id() != null)
                .collect(Collectors.groupingBy(Employe::getDepartement_id, Collectors.counting()));
        report.put("byDepartment", byDept);

        request.setAttribute("report", report);
        request.setAttribute("employees", employees);
        request.getRequestDispatcher("/WEB-INF/reports-employees.jsp").forward(request, response);
    }

    /**
     * Calcule le nombre d'employés par grade
     */
    private Map<String, Long> calculateEmployeesByRankFixed(List<Employe> employees) {
        Map<String, Long> result = new LinkedHashMap<>();

        for (Role role : Role.values()) {
            long count = employees.stream()
                    .filter(e -> e.getEmploye_rank() == role.getLevel())
                    .count();

            result.put(role.getDisplayName(), count);
        }

        return result;
    }

    /**
     * Calcule le nombre d'employés par département en utilisant departement_id
     */
    private Map<String, Long> calculateEmployeesByDepartmentFixed(List<Employe> employees,
            List<Departement> departments) {
        Map<String, Long> result = new LinkedHashMap<>();

        for (Departement dept : departments) {
            // Compter les employés qui ont ce departement_id
            long count = employees.stream()
                    .filter(e -> e.getDepartement_id() != null && e.getDepartement_id().equals(dept.getId()))
                    .count();

            // N'ajouter que si count > 0 pour éviter d'afficher les départements vides
            if (count > 0) {
                result.put(dept.getDepartement_name(), count);
            }
        }

        return result;
    }

    /**
     * Calcule le nombre d'employés par projet
     */
    private Map<String, Integer> calculateEmployeesByProject(List<Project> projects) {
        Map<String, Integer> result = new LinkedHashMap<>();

        for (Project project : projects) {
            int count = 0;
            if (project.getEmployees() != null && !project.getEmployees().isEmpty()
                    && !project.getEmployees().equals("0")) {
                count = project.getEmployees().split(",").length;
            }

            // N'ajouter que si count > 0
            if (count > 0) {
                result.put(project.getProject_name(), count);
            }
        }

        return result;
    }
}