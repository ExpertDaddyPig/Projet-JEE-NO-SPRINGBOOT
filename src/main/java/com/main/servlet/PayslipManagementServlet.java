package com.main.servlet;

import com.main.dao.RHDAO;
import com.main.model.Employe;
import com.main.model.Payslip;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

/**
 * Servlet pour gérer les fiches de paie
 */
@WebServlet("/payslips/*")
public class PayslipManagementServlet extends HttpServlet {

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
                listPayslips(request, response);
            } else if (pathInfo.equals("/create")) {
                showCreateForm(request, response);
            } else if (pathInfo.equals("/view")) {
                viewPayslip(request, response);
            } else if (pathInfo.equals("/employee")) {
                viewEmployeePayslips(request, response);
            } else if (pathInfo.equals("/search")) {
                searchPayslips(request, response);
            } else if (pathInfo.equals("/print")) {
                printPayslip(request, response);
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
                createPayslip(request, response);
            } else if (pathInfo.equals("/delete")) {
                deletePayslip(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException("Erreur lors du traitement de la requête", e);
        }
    }

    /**
     * Liste toutes les fiches de paie
     */
    private void listPayslips(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Vérifier les permissions (Admin ou Chef département)
        HttpSession session = request.getSession();
        Employe currentUser = (Employe) session.getAttribute("currentUser");

        List<Payslip> payslips;

        if (currentUser.getEmploye_rank() == 4 || currentUser.getEmploye_rank() == 3) {
            // Admin ou Chef département : voir toutes les fiches
            payslips = dao.getAllPayslips();
        } else {
            // Employé ou Chef projet : voir seulement ses fiches
            payslips = dao.getPayslips("employe_id = " + currentUser.getId());
        }

        request.setAttribute("payslips", payslips);
        request.getRequestDispatcher("/payslips.jsp").forward(request, response);
    }

    /**
     * Affiche le formulaire de création
     */
    private void showCreateForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Récupérer la liste des employés pour le formulaire
        List<Employe> employees = dao.getAllEmployees();
        request.setAttribute("employees", employees);

        request.getRequestDispatcher("/WEB-INF/payslip-create.jsp").forward(request, response);
    }

    /**
     * Crée une nouvelle fiche de paie
     */
    private void createPayslip(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Récupération des paramètres
        String employeIdStr = request.getParameter("employe_id");
        String monthStr = request.getParameter("month");
        String salaryStr = request.getParameter("salary");
        String primesStr = request.getParameter("primes");
        String deductionsStr = request.getParameter("deductions");

        // Validation
        StringBuilder errors = new StringBuilder();

        if (employeIdStr == null || employeIdStr.trim().isEmpty()) {
            errors.append("L'employé est requis. ");
        }

        if (monthStr == null || monthStr.trim().isEmpty()) {
            errors.append("Le mois est requis. ");
        }

        if (salaryStr == null || salaryStr.trim().isEmpty()) {
            errors.append("Le salaire est requis. ");
        }

        if (errors.length() > 0) {
            request.setAttribute("errorMessage", errors.toString());
            showCreateForm(request, response);
            return;
        }

        try {
            int employeId = Integer.parseInt(employeIdStr);
            int month = Integer.parseInt(monthStr);
            int salary = Integer.parseInt(salaryStr);
            int primes = primesStr != null && !primesStr.isEmpty() ? Integer.parseInt(primesStr) : 0;
            int deductions = deductionsStr != null && !deductionsStr.isEmpty() ? Integer.parseInt(deductionsStr) : 0;

            // Validation du mois (1-12)
            if (month < 1 || month > 12) {
                request.setAttribute("errorMessage", "Le mois doit être entre 1 et 12.");
                showCreateForm(request, response);
                return;
            }

            // Créer la fiche de paie
            Payslip payslip = new Payslip(employeId, month, salary, primes, deductions);

            boolean success = dao.save(payslip);

            if (success) {
                System.out.println("✓ Fiche de paie créée: Employé " + employeId + ", Mois " + month);
                response.sendRedirect(request.getContextPath() + "/payslips?success=create");
            } else {
                request.setAttribute("errorMessage", "Erreur lors de la création de la fiche de paie.");
                showCreateForm(request, response);
            }

        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Valeurs numériques invalides.");
            showCreateForm(request, response);
        }
    }

    /**
     * Affiche une fiche de paie spécifique
     */
    private void viewPayslip(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idStr = request.getParameter("id");

        if (idStr == null || idStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/payslips");
            return;
        }

        int id = Integer.parseInt(idStr);
        Payslip payslip = dao.getPayslip("id = " + id);

        if (payslip != null) {
            // Récupérer les infos de l'employé
            Employe employee = dao.getEmploye("id = " + payslip.getEmploye_id());

            request.setAttribute("payslip", payslip);
            request.setAttribute("employee", employee);
            request.getRequestDispatcher("/WEB-INF/payslip-view.jsp").forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/payslips?error=notfound");
        }
    }

    /**
     * Affiche les fiches de paie d'un employé
     */
    private void viewEmployeePayslips(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String employeIdStr = request.getParameter("id");

        if (employeIdStr == null || employeIdStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/payslips");
            return;
        }

        int employeId = Integer.parseInt(employeIdStr);
        Employe employee = dao.getEmploye("id = " + employeId);
        List<Payslip> payslips = dao.getPayslips("employe_id = " + employeId);

        request.setAttribute("employee", employee);
        request.setAttribute("payslips", payslips);
        request.getRequestDispatcher("/WEB-INF/payslip-employee.jsp").forward(request, response);
    }

    /**
     * Recherche des fiches de paie
     */
    private void searchPayslips(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String employeIdStr = request.getParameter("employe_id");
        String monthStr = request.getParameter("month");

        StringBuilder query = new StringBuilder();

        if (employeIdStr != null && !employeIdStr.trim().isEmpty()) {
            query.append("employe_id = ").append(employeIdStr);
        }

        if (monthStr != null && !monthStr.trim().isEmpty()) {
            if (query.length() > 0) query.append(" AND ");
            query.append("month = ").append(monthStr);
        }

        List<Payslip> payslips;
        if (query.length() > 0) {
            payslips = dao.getPayslips(query.toString());
        } else {
            payslips = dao.getAllPayslips();
        }

        request.setAttribute("payslips", payslips);
        request.setAttribute("searchEmployeId", employeIdStr);
        request.setAttribute("searchMonth", monthStr);
        request.getRequestDispatcher("/payslips.jsp").forward(request, response);
    }

    /**
     * Génère une fiche de paie imprimable
     */
    private void printPayslip(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idStr = request.getParameter("id");

        if (idStr == null || idStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/payslips");
            return;
        }

        int id = Integer.parseInt(idStr);
        Payslip payslip = dao.getPayslip("id = " + id);

        if (payslip != null) {
            Employe employee = dao.getEmploye("id = " + payslip.getEmploye_id());

            request.setAttribute("payslip", payslip);
            request.setAttribute("employee", employee);
            request.getRequestDispatcher("/WEB-INF/payslip-print.jsp").forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/payslips?error=notfound");
        }
    }

    /**
     * Supprime une fiche de paie
     */
    private void deletePayslip(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        String idStr = request.getParameter("id");

        if (idStr != null && !idStr.trim().isEmpty()) {
            int id = Integer.parseInt(idStr);
            dao.deletePayslip(id);
            System.out.println("✓ Fiche de paie supprimée: ID " + id);
        }

        response.sendRedirect(request.getContextPath() + "/payslips?success=delete");
    }
}