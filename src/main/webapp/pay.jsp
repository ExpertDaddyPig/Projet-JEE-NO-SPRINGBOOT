<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ page import="com.main.model.Employe" %>
            <% // Récupérer l'utilisateur pour les vérifications Java Employe currentUser=(Employe)
                session.getAttribute("currentUser"); if (currentUser==null) {
                response.sendRedirect(request.getContextPath() + "/login.jsp" ); return; } %>
                <!DOCTYPE html>
                <html lang="fr">

                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>Fiches de Paie - Gestion RH</title>
                    <style>
                        * {
                            margin: 0;
                            padding: 0;
                            box-sizing: border-box;
                        }

                        body {
                            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                            background-color: #f5f5f5;
                        }

                        .navbar {
                            background-color: #333;
                            color: white;
                            padding: 15px 30px;
                            display: flex;
                            justify-content: space-between;
                            align-items: center;
                        }

                        .navbar-brand {
                            font-size: 24px;
                            font-weight: bold;
                        }

                        .navbar-links a {
                            color: white;
                            text-decoration: none;
                            margin-left: 20px;
                            padding: 8px 15px;
                            border-radius: 5px;
                            transition: background 0.3s;
                        }

                        .navbar-links a:hover {
                            background-color: #555;
                        }

                        .container {
                            max-width: 1400px;
                            margin: 30px auto;
                            padding: 0 20px;
                        }

                        .header-section {
                            background: white;
                            padding: 25px;
                            border-radius: 10px;
                            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
                            margin-bottom: 25px;
                            display: flex;
                            justify-content: space-between;
                            align-items: center;
                        }

                        .header-section h1 {
                            color: #333;
                            font-size: 28px;
                        }

                        .btn {
                            padding: 10px 20px;
                            border: none;
                            border-radius: 5px;
                            cursor: pointer;
                            text-decoration: none;
                            font-weight: 600;
                            transition: all 0.3s;
                            display: inline-block;
                        }

                        .btn-primary {
                            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                            color: white;
                        }

                        .btn-primary:hover {
                            transform: translateY(-2px);
                            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
                        }

                        .btn-success {
                            background-color: #28a745;
                            color: white;
                        }

                        .btn-danger {
                            background-color: #dc3545;
                            color: white;
                        }

                        .btn-info {
                            background-color: #17a2b8;
                            color: white;
                        }

                        .btn-warning {
                            background-color: #ffc107;
                            color: #333;
                        }

                        .search-section {
                            background: white;
                            padding: 20px;
                            border-radius: 10px;
                            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
                            margin-bottom: 25px;
                        }

                        .search-form {
                            display: flex;
                            gap: 15px;
                            align-items: end;
                        }

                        .form-group {
                            flex: 1;
                        }

                        .form-group label {
                            display: block;
                            margin-bottom: 5px;
                            color: #333;
                            font-weight: 500;
                        }

                        .form-group input,
                        .form-group select {
                            width: 100%;
                            padding: 10px;
                            border: 1px solid #ddd;
                            border-radius: 5px;
                        }

                        .table-section {
                            background: white;
                            padding: 25px;
                            border-radius: 10px;
                            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
                        }

                        table {
                            width: 100%;
                            border-collapse: collapse;
                        }

                        table th {
                            background-color: #f8f9fa;
                            padding: 12px;
                            text-align: left;
                            font-weight: 600;
                            color: #333;
                            border-bottom: 2px solid #dee2e6;
                        }

                        table td {
                            padding: 12px;
                            border-bottom: 1px solid #dee2e6;
                        }

                        table tr:hover {
                            background-color: #f8f9fa;
                        }

                        .net-salary {
                            font-weight: bold;
                            color: #28a745;
                            font-size: 16px;
                        }

                        .actions {
                            display: flex;
                            gap: 8px;
                        }

                        .alert {
                            padding: 15px;
                            border-radius: 5px;
                            margin-bottom: 20px;
                        }

                        .alert-success {
                            background-color: #d4edda;
                            color: #155724;
                            border: 1px solid #c3e6cb;
                        }

                        .alert-error {
                            background-color: #f8d7da;
                            color: #721c24;
                            border: 1px solid #f5c6cb;
                        }

                        .empty-state {
                            text-align: center;
                            padding: 60px 20px;
                            color: #666;
                        }

                        .empty-state i {
                            font-size: 64px;
                            margin-bottom: 20px;
                            opacity: 0.3;
                        }

                        .badge {
                            display: inline-block;
                            padding: 4px 8px;
                            border-radius: 12px;
                            font-size: 12px;
                            font-weight: 600;
                        }

                        .badge-month {
                            background-color: #e7f3ff;
                            color: #0066cc;
                        }
                    </style>
                </head>

                <body>
                    <nav class="navbar">
                        <div class="navbar-brand">Gestion RH - Fiches de Paie</div>
                        <div class="navbar-links">
                        <a href="${pageContext.request.contextPath}/dashboard">Tableau de bord</a>
                        <a href="${pageContext.request.contextPath}/users">Employés</a>
                        <a href="${pageContext.request.contextPath}/projects">Projets</a>
                        <div class="user-info">
                            <span class="user-name">${sessionScope.currentUser.username}</span>
                            <span class="user-role">${sessionScope.currentUser.role.displayName}</span>
                        </div>
                        <a href="${pageContext.request.contextPath}/logout" class="btn-logout">Déconnexion</a>
                    </div>
                    </nav>

                    <div class="container">
                        <div class="header-section">
                            <h1>📄 Gestion des Fiches de Paie</h1>
                            <% if (currentUser.getEmploye_rank()>= 3) { %>
                                <a href="${pageContext.request.contextPath}/payslips/create" class="btn btn-primary">
                                    + Créer une fiche de paie
                                </a>
                                <% } %>
                        </div>

                        <!-- Messages -->
                        <c:if test="${param.success == 'create'}">
                            <div class="alert alert-success">
                                ✓ Fiche de paie créée avec succès.
                            </div>
                        </c:if>

                        <c:if test="${param.success == 'delete'}">
                            <div class="alert alert-success">
                                ✓ Fiche de paie supprimée avec succès.
                            </div>
                        </c:if>

                        <c:if test="${param.error == 'notfound'}">
                            <div class="alert alert-error">
                                ✗ Fiche de paie introuvable.
                            </div>
                        </c:if>

                        <!-- Recherche -->
                        <div class="search-section">
                            <h3 style="margin-bottom: 15px;">🔍 Rechercher</h3>
                            <form action="${pageContext.request.contextPath}/payslips/search" method="get"
                                class="search-form">
                                <div class="form-group">
                                    <label>Employé (ID)</label>
                                    <input type="number" name="employe_id" value="${searchEmployeId}"
                                        placeholder="ID de l'employé">
                                </div>
                                <div class="form-group">
                                    <label>Mois</label>
                                    <select name="month">
                                        <option value="">Tous les mois</option>
                                        <option value="1" ${searchMonth=='1' ? 'selected' : '' }>Janvier</option>
                                        <option value="2" ${searchMonth=='2' ? 'selected' : '' }>Février</option>
                                        <option value="3" ${searchMonth=='3' ? 'selected' : '' }>Mars</option>
                                        <option value="4" ${searchMonth=='4' ? 'selected' : '' }>Avril</option>
                                        <option value="5" ${searchMonth=='5' ? 'selected' : '' }>Mai</option>
                                        <option value="6" ${searchMonth=='6' ? 'selected' : '' }>Juin</option>
                                        <option value="7" ${searchMonth=='7' ? 'selected' : '' }>Juillet</option>
                                        <option value="8" ${searchMonth=='8' ? 'selected' : '' }>Août</option>
                                        <option value="9" ${searchMonth=='9' ? 'selected' : '' }>Septembre</option>
                                        <option value="10" ${searchMonth=='10' ? 'selected' : '' }>Octobre</option>
                                        <option value="11" ${searchMonth=='11' ? 'selected' : '' }>Novembre</option>
                                        <option value="12" ${searchMonth=='12' ? 'selected' : '' }>Décembre</option>
                                    </select>
                                </div>
                                <button type="submit" class="btn btn-primary">Rechercher</button>
                            </form>
                        </div>

                        <!-- Tableau -->
                        <div class="table-section">
                            <c:choose>
                                <c:when test="${empty payslips}">
                                    <div class="empty-state">
                                        <i>📭</i>
                                        <h3>Aucune fiche de paie</h3>
                                        <p>Aucune fiche de paie n'a été trouvée.</p>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <table>
                                        <thead>
                                            <tr>
                                                <th>ID</th>
                                                <th>Employé (ID)</th>
                                                <th>Mois</th>
                                                <th>Salaire de base</th>
                                                <th>Primes</th>
                                                <th>Déductions</th>
                                                <th>Net à payer</th>
                                                <th>Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="payslip" items="${payslips}">
                                                <tr>
                                                    <td>${payslip.id}</td>
                                                    <td>
                                                        <a
                                                            href="${pageContext.request.contextPath}/payslips/employee?id=${payslip.employe_id}">
                                                            #${payslip.employe_id}
                                                        </a>
                                                    </td>
                                                    <td>
                                                        <span class="badge badge-month">
                                                            Mois ${payslip.month}
                                                        </span>
                                                    </td>
                                                    <td>${payslip.salary} €</td>
                                                    <td style="color: #28a745;">+${payslip.primes} €</td>
                                                    <td style="color: #dc3545;">-${payslip.deductions} €</td>
                                                    <td class="net-salary">
                                                        ${payslip.salary + payslip.primes - payslip.deductions} €
                                                    </td>
                                                    <td>
                                                        <div class="actions">
                                                            <a href="${pageContext.request.contextPath}/payslips/view?id=${payslip.id}"
                                                                class="btn btn-info"
                                                                style="padding: 6px 12px; font-size: 14px;">
                                                                👁️ Voir
                                                            </a>
                                                            <a href="${pageContext.request.contextPath}/payslips/print?id=${payslip.id}"
                                                                class="btn btn-warning"
                                                                style="padding: 6px 12px; font-size: 14px;"
                                                                target="_blank">
                                                                🖨️ Imprimer
                                                            </a>
                                                            <% if (currentUser.getEmploye_rank()>= 3) { %>
                                                                <form
                                                                    action="${pageContext.request.contextPath}/payslips/delete"
                                                                    method="post" style="display: inline;"
                                                                    onsubmit="return confirm('Voulez-vous vraiment supprimer cette fiche de paie ?');">
                                                                    <input type="hidden" name="id"
                                                                        value="${payslip.id}">
                                                                    <button type="submit" class="btn btn-danger"
                                                                        style="padding: 6px 12px; font-size: 14px;">
                                                                        🗑️ Supprimer
                                                                    </button>
                                                                </form>
                                                                <% } %>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </body>

                </html>