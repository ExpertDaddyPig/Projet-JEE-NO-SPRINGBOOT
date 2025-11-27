package com.main.servlet;

import com.main.dao.RHDAO;
import com.main.model.Departement;
import com.main.model.Employe;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

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
        List<Employe> allEmployees = rhdao.getAllEmployees();
        List<Departement> departements = rhdao.getAllDepartements();

        for (Departement departement : departements) {
            for (Employe employe : allEmployees) {
                String newList;
                if (departement.getEmployees() == "") newList = "" + employe.getId();
                else newList = departement.getEmployees() + "," + employe.getId();
                if (departement.getId() == employe.getDepartement_id() && !departement.getEmployees().contains("" + employe.getId())) rhdao.updateDepartementById(employe.getDepartement_id(),
                        " employees = \"" + newList + "\"");
            }
        }

        request.setAttribute("departments", departements);
        request.setAttribute("allEmployees", allEmployees);

        request.getRequestDispatcher("departments.jsp").forward(request, response);
    }

    private void addDepartment(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {

        String name = request.getParameter("name");
        String[] employeeIds = request.getParameterValues("employeeIds");

        String employeesString = "";
        if (employeeIds != null && employeeIds.length > 0) {
            employeesString = String.join(",", employeeIds);
        }

        Departement dept = new Departement();
        dept.setDepartement_name(name);
        dept.setEmployees(employeesString);

        rhdao.save(dept);

        response.sendRedirect(request.getContextPath() + "/departments?success=add");
    }

    private void updateDepartment(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {

        String idParam = request.getParameter("id");
        String[] employeeIds = request.getParameterValues("employeeIds");

        if (idParam != null) {
            int id = Integer.parseInt(idParam);

            String employeesString = "";
            if (employeeIds != null && employeeIds.length > 0) {
                employeesString = String.join(",", employeeIds);
            }

            rhdao.updateDepartementById(id, " employees = " + employeesString);

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