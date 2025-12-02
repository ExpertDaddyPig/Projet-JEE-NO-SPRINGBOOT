<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.main.model.Employe" %>
<%
    Employe currentUser = (Employe) session.getAttribute("currentUser");
    if (currentUser == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="fr">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Fiches de Paie - Gestion RH</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/styles.css">
</head>

<body>
    <nav class="navbar">
        <div class="navbar-brand">Gestion RH - Fiches de Paie</div>
        <div class="navbar-links">
            <a href="${pageContext.request.contextPath}/dashboard">Tableau de bord</a>
            <div class="user-info">
                <span class="user-name">${sessionScope.currentUser.username}</span>
                <span class="user-role">${sessionScope.currentUser.role.displayName}</span>
            </div>
            <a href="${pageContext.request.contextPath}/logout" class="btn-logout">Déconnexion</a>
        </div>
    </nav>

    <div class="container container-wide">
        <div class="header-section">
            <h1>📄 Gestion des Fiches de Paie</h1>
            <% if (currentUser.getEmploye_rank() >= 3) { %>
                <a href="${pageContext.request.contextPath}/payslips/create" class="btn btn-primary">
                    + Créer une fiche de paie
                </a>
            <% } %>
        </div>

        <c:if test="${param.success == 'create'}">
            <div class="alert alert-success">✓ Fiche de paie créée avec succès.</div>
        </c:if>

        <c:if test="${param.success == 'delete'}">
            <div class="alert alert-success">✓ Fiche de paie supprimée avec succès.</div>
        </c:if>

        <c:if test="${param.error == 'notfound'}">
            <div class="alert alert-error">✗ Fiche de paie introuvable.</div>
        </c:if>

        <div class="search-section">
            <h3 style="margin-bottom: 15px;">🔍 Rechercher</h3>
            <form action="${pageContext.request.contextPath}/payslips/search" method="get" class="search-form" style="display: flex; gap: 15px; align-items: end;">
                <div class="form-group" style="flex: 1;">
                    <label>Employé (ID)</label>
                    <input type="number" name="employe_id" class="form-control" value="${searchEmployeId}" placeholder="ID de l'employé">
                </div>
                <div class="form-group" style="flex: 1;">
                    <label>Mois</label>
                    <select name="month" class="form-control">
                        <option value="">Tous les mois</option>
                        <option value="1" ${searchMonth=='1' ? 'selected' : ''}>Janvier</option>
                        <option value="2" ${searchMonth=='2' ? 'selected' : ''}>Février</option>
                        <option value="3" ${searchMonth=='3' ? 'selected' : ''}>Mars</option>
                        <option value="4" ${searchMonth=='4' ? 'selected' : ''}>Avril</option>
                        <option value="5" ${searchMonth=='5' ? 'selected' : ''}>Mai</option>
                        <option value="6" ${searchMonth=='6' ? 'selected' : ''}>Juin</option>
                        <option value="7" ${searchMonth=='7' ? 'selected' : ''}>Juillet</option>
                        <option value="8" ${searchMonth=='8' ? 'selected' : ''}>Août</option>
                        <option value="9" ${searchMonth=='9' ? 'selected' : ''}>Septembre</option>
                        <option value="10" ${searchMonth=='10' ? 'selected' : ''}>Octobre</option>
                        <option value="11" ${searchMonth=='11' ? 'selected' : ''}>Novembre</option>
                        <option value="12" ${searchMonth=='12' ? 'selected' : ''}>Décembre</option>
                    </select>
                </div>
                <button type="submit" class="btn btn-primary">Rechercher</button>
            </form>
        </div>

        <div class="table-section">
            <c:choose>
                <c:when test="${empty payslips}">
                    <div class="empty-state">
                        <i>🔭</i>
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
                                        <a href="${pageContext.request.contextPath}/payslips/employee?id=${payslip.employe_id}">
                                            #${payslip.employe_id}
                                        </a>
                                    </td>
                                    <td>
                                        <span class="badge badge-month">Mois ${payslip.month}</span>
                                    </td>
                                    <td>${payslip.salary} €</td>
                                    <td style="color: #28a745;">+${payslip.primes} €</td>
                                    <td style="color: #dc3545;">-${payslip.deductions} €</td>
                                    <td class="net-salary">
                                        ${payslip.salary + payslip.primes - payslip.deductions} €
                                    </td>
                                    <td>
                                        <div class="actions" style="display: flex; gap: 8px;">
                                            <a href="${pageContext.request.contextPath}/payslips/view?id=${payslip.id}"
                                                class="btn btn-info btn-icon">👁️ Voir</a>
                                            <a href="${pageContext.request.contextPath}/payslips/print?id=${payslip.id}"
                                                class="btn btn-warning btn-icon" target="_blank">🖨️ Imprimer</a>
                                            <% if (currentUser.getEmploye_rank() >= 3) { %>
                                                <form action="${pageContext.request.contextPath}/payslips/delete"
                                                    method="post" style="display: inline;"
                                                    onsubmit="return confirm('Voulez-vous vraiment supprimer cette fiche de paie ?');">
                                                    <input type="hidden" name="id" value="${payslip.id}">
                                                    <button type="submit" class="btn btn-danger btn-icon">
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