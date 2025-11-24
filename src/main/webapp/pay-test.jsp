<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.main.model.Employe" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Test Payslips</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            padding: 20px;
            background: #f5f5f5;
        }
        .container {
            max-width: 800px;
            margin: 0 auto;
            background: white;
            padding: 20px;
            border-radius: 10px;
        }
        .success { color: green; }
        .error { color: red; }
    </style>
</head>
<body>
    <div class="container">
        <h1>📄 Test Page Payslips</h1>

        <%
            HttpSession sess = request.getSession(false);
            Employe currentUser = null;

            if (sess != null) {
                currentUser = (Employe) sess.getAttribute("currentUser");
            }

            if (currentUser == null) {
        %>
            <p class="error">✗ Aucun utilisateur connecté</p>
            <p><a href="<%= request.getContextPath() %>/login.jsp">Se connecter</a></p>
        <%
            } else {
        %>
            <p class="success">✓ Utilisateur connecté: <%= currentUser.getUsername() %></p>
            <p>Rank: <%= currentUser.getEmploye_rank() %></p>

            <h2>Navigation</h2>
            <ul>
                <li><a href="<%= request.getContextPath() %>/payslips">Via Servlet PayslipServlet</a></li>
                <li><a href="<%= request.getContextPath() %>/dashboard">Retour Dashboard</a></li>
            </ul>

            <h2>Info Debug</h2>
            <p>Context Path: <%= request.getContextPath() %></p>
            <p>Request URI: <%= request.getRequestURI() %></p>
        <%
            }
        %>
    </div>
</body>
</html>