<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
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
    <title>Projets - Gestion RH</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/styles.css">
</head>

<body>
    <nav class="navbar">
        <div class="navbar-brand">Gestion RH - Projets</div>
        <div class="navbar-links">
            <a href="${pageContext.request.contextPath}/dashboard">Tableau de bord</a>
            <a href="${pageContext.request.contextPath}/users">Employés</a>
            <a href="${pageContext.request.contextPath}/payslips">Fiches de Paie</a>
            <div class="user-info">
                <span class="user-name">${sessionScope.currentUser.username}</span>
                <span class="user-role">${sessionScope.currentUser.role.displayName}</span>
            </div>
            <a href="${pageContext.request.contextPath}/logout" class="btn-logout">Déconnexion</a>
        </div>
    </nav>

    <div class="container container-wide">
        <div class="header-section">
            <h1>📊 Gestion des Projets</h1>
            <div class="header-actions">
                <% if (currentUser.getEmploye_rank() >= 2) { %>
                    <a href="${pageContext.request.contextPath}/projects/create" class="btn btn-primary">
                        + Créer un projet
                    </a>
                <% } %>
            </div>
        </div>

        <c:if test="${param.success == 'create'}">
            <div class="alert alert-success">✓ Projet créé avec succès.</div>
        </c:if>

        <c:if test="${param.success == 'update'}">
            <div class="alert alert-success">✓ Projet mis à jour avec succès.</div>
        </c:if>

        <c:if test="${param.success == 'delete'}">
            <div class="alert alert-success">✓ Projet supprimé avec succès.</div>
        </c:if>

        <c:if test="${param.error == 'notfound'}">
            <div class="alert alert-error">✗ Projet introuvable.</div>
        </c:if>

        <div class="filter-section">
            <h3 style="margin-bottom: 15px;">🔍 Filtrer par état</h3>
            <div class="filter-buttons">
                <a href="${pageContext.request.contextPath}/projects"
                    class="filter-btn ${empty stateFilter ? 'active' : ''}">
                    📋 Tous les projets
                </a>
                <a href="${pageContext.request.contextPath}/projects?state=in%20process"
                    class="filter-btn ${stateFilter == 'in process' ? 'active' : ''}">
                    ⏳ En cours
                </a>
                <a href="${pageContext.request.contextPath}/projects?state=finished"
                    class="filter-btn ${stateFilter == 'finished' ? 'active' : ''}">
                    ✅ Terminés
                </a>
                <a href="${pageContext.request.contextPath}/projects?state=canceled"
                    class="filter-btn ${stateFilter == 'canceled' ? 'active' : ''}">
                    ❌ Annulés
                </a>
            </div>
        </div>

        <c:choose>
            <c:when test="${empty projects}">
                <div class="empty-state">
                    <i>🔍</i>
                    <h3>Aucun projet</h3>
                    <p>Aucun projet n'a été trouvé avec ces critères.</p>
                </div>
            </c:when>
            <c:otherwise>
                <div class="projects-grid">
                    <c:forEach var="project" items="${projects}">
                        <div class="project-card">
                            <div class="project-header">
                                <h3>${project.project_name}</h3>
                                <c:choose>
                                    <c:when test="${project.project_state == 'in process'}">
                                        <span class="badge badge-inprocess">⏳ En cours</span>
                                    </c:when>
                                    <c:when test="${project.project_state == 'finished'}">
                                        <span class="badge badge-finished">✅ Terminé</span>
                                    </c:when>
                                    <c:when test="${project.project_state == 'canceled'}">
                                        <span class="badge badge-canceled">❌ Annulé</span>
                                    </c:when>
                                </c:choose>
                            </div>

                            <div class="project-body">
                                <div class="project-info">
                                    <label>ID du Projet</label>
                                    <value>#${project.id}</value>
                                </div>
                                <div class="project-info">
                                    <label>Employés Assignés</label>
                                    <value>
                                        <c:choose>
                                            <c:when test="${empty project.employees || project.employees == '0'}">
                                                Aucun employé assigné
                                            </c:when>
                                            <c:otherwise>
                                                ${fn:length(fn:split(project.employees, ','))} employé(s)
                                            </c:otherwise>
                                        </c:choose>
                                    </value>
                                </div>
                            </div>

                            <div class="project-footer">
                                <a href="${pageContext.request.contextPath}/projects/view?id=${project.id}"
                                    class="btn btn-info btn-icon">👁️ Détails</a>

                                <% if (currentUser.getEmploye_rank() >= 2) { %>
                                    <a href="${pageContext.request.contextPath}/projects/edit?id=${project.id}"
                                        class="btn btn-warning btn-icon">✏️ Modifier</a>

                                    <form action="${pageContext.request.contextPath}/projects/delete"
                                        method="post" style="display: inline;"
                                        onsubmit="return confirm('Voulez-vous vraiment supprimer ce projet ?');">
                                        <input type="hidden" name="id" value="${project.id}">
                                        <button type="submit" class="btn btn-danger btn-icon">
                                            🗑️ Supprimer
                                        </button>
                                    </form>
                                <% } %>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</body>

</html>