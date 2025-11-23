package com.main.servlet;

import com.main.dao.RHDAO;
import com.main.model.Departement;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/departments/*")
public class DepartmentManagementServlet extends HttpServlet {

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
                listDepartments(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (SQLException e) {
            throw new ServletException("Erreur SQL", e);
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
                addDepartment(request, response);
            } else if (pathInfo.equals("/edit")) {
                updateDepartment(request, response);
            } else if (pathInfo.equals("/delete")) {
                deleteDepartment(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (SQLException e) {
            throw new ServletException("Erreur SQL", e);
        }
    }

    private void listDepartments(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        // On a besoin des départements ET de tous les employés pour afficher les noms
        request.setAttribute("departments", rhdao.getAllDepartements());
        request.setAttribute("allEmployees", rhdao.getAllEmployees());

        request.getRequestDispatcher("departments.jsp").forward(request, response);
    }

    private void addDepartment(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {

        String name = request.getParameter("name");
        // Récupère les IDs sélectionnés (tableau de strings)
        String[] employeeIds = request.getParameterValues("employeeIds");

        // Transformation du tableau ["1", "5"] en String "1,5"
        String employeesString = "";
        if (employeeIds != null && employeeIds.length > 0) {
            employeesString = String.join(",", employeeIds);
        }

        Departement dept = new Departement();
        dept.setDepartement_name(name);
        dept.setEmployees(employeesString);

        // Appel DAO (assurez-vous d'avoir une méthode insertDepartment(Departement d))
        rhdao.save(dept);

        response.sendRedirect(request.getContextPath() + "/departments?success=add");
    }

    private void updateDepartment(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {

        String idParam = request.getParameter("id");
        String name = request.getParameter("name");
        String[] employeeIds = request.getParameterValues("employeeIds");

        if (idParam != null) {
            int id = Integer.parseInt(idParam);

            String employeesString = "";
            if (employeeIds != null && employeeIds.length > 0) {
                employeesString = String.join(",", employeeIds);
            }

            rhdao.updateDepartementById(id, "name = " + name + ", employees = " + employeesString);

            response.sendRedirect(request.getContextPath() + "/departments?success=update");
        } else {
            response.sendRedirect(request.getContextPath() + "/departments");
        }
    }

    private void deleteDepartment(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        String idParam = request.getParameter("id");
        if (idParam != null) {
            rhdao.deleteDepartement(Integer.parseInt(idParam));
        }
        response.sendRedirect(request.getContextPath() + "/departments?success=delete");
    }
}