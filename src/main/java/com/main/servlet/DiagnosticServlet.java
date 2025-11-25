package com.main.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;

/**
 * Servlet de diagnostic pour tester le déploiement
 */
@WebServlet("/diagnostic")
public class DiagnosticServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();

        out.println("<!DOCTYPE html>");
        out.println("<html><head><title>Diagnostic</title>");
        out.println("<style>");
        out.println("body { font-family: monospace; padding: 20px; background: #f5f5f5; }");
        out.println(".ok { color: green; font-weight: bold; }");
        out.println(".error { color: red; font-weight: bold; }");
        out.println("table { background: white; border-collapse: collapse; width: 100%; }");
        out.println("th, td { border: 1px solid #ddd; padding: 10px; text-align: left; }");
        out.println("th { background: #333; color: white; }");
        out.println("</style></head><body>");

        out.println("<h1>🔧 Diagnostic du Système</h1>");

        // Test de la session
        out.println("<h2>1. Test de Session</h2>");
        HttpSession session = request.getSession(false);
        if (session != null) {
            Object currentUser = session.getAttribute("currentUser");
            if (currentUser != null) {
                out.println("<p class='ok'>✓ Session active</p>");
                out.println("<p>Utilisateur: " + currentUser.toString() + "</p>");
            } else {
                out.println("<p class='error'>✗ Pas d'utilisateur connecté</p>");
            }
        } else {
            out.println("<p class='error'>✗ Pas de session</p>");
        }

        // Test du contexte
        out.println("<h2>2. Informations Contexte</h2>");
        out.println("<p>Context Path: " + request.getContextPath() + "</p>");
        out.println("<p>Server Info: " + getServletContext().getServerInfo() + "</p>");

        // URLs à tester
        out.println("<h2>3. URLs des Servlets</h2>");
        out.println("<table>");
        out.println("<tr><th>Servlet</th><th>URL</th><th>Test</th></tr>");

        String[][] servlets = {
                {"PayslipServlet", "/payslips"},
                {"ProjectServlet", "/projects"},
                {"DashboardServlet", "/dashboard"},
                {"LoginServlet", "/login"}
        };

        String contextPath = request.getContextPath();
        for (String[] servlet : servlets) {
            out.println("<tr>");
            out.println("<td>" + servlet[0] + "</td>");
            out.println("<td>" + contextPath + servlet[1] + "</td>");
            out.println("<td><a href='" + contextPath + servlet[1] + "' target='_blank'>Tester →</a></td>");
            out.println("</tr>");
        }

        out.println("</table>");

        // Vérifier les JSP
        out.println("<h2>4. JSP Disponibles</h2>");
        out.println("<table>");
        out.println("<tr><th>JSP</th><th>Emplacement</th><th>URL</th></tr>");

        String[][] jsps = {
                {"pay.jsp", "webapp/", "/pay.jsp"},
                {"projects.jsp", "webapp/", "/projects.jsp"},
                {"dashboard.jsp", "webapp/", "/dashboard.jsp"},
                {"login.jsp", "webapp/", "/login.jsp"}
        };

        for (String[] jsp : jsps) {
            out.println("<tr>");
            out.println("<td>" + jsp[0] + "</td>");
            out.println("<td>" + jsp[1] + "</td>");
            out.println("<td><a href='" + contextPath + jsp[2] + "' target='_blank'>" + contextPath + jsp[2] + "</a></td>");
            out.println("</tr>");
        }

        out.println("</table>");

        // Instructions
        out.println("<h2>5. Instructions de Dépannage</h2>");
        out.println("<ul>");
        out.println("<li>Si les servlets retournent 404: Vérifiez que les classes sont bien compilées dans target/classes/</li>");
        out.println("<li>Si les JSP retournent 404: Vérifiez qu'elles sont dans webapp/</li>");
        out.println("<li>Essayez de faire Build → Rebuild Project dans IntelliJ</li>");
        out.println("<li>Redémarrez Tomcat complètement</li>");
        out.println("</ul>");

        out.println("<hr>");
        out.println("<p><a href='" + contextPath + "/dashboard'>← Retour au dashboard</a></p>");

        out.println("</body></html>");
    }
}