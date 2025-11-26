<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
            <%@ page import="com.main.model.Employe" %>
                <% // Récupérer l'utilisateur pour les vérifications Java Employe currentUser=(Employe)
                    session.getAttribute("currentUser"); if (currentUser==null) {
                    response.sendRedirect(request.getContextPath() + "/login.jsp" ); return; } %>
                    <!DOCTYPE html>
                    <html lang="fr">

                    <head>
                        <meta charset="UTF-8">
                        <meta name="viewport" content="width=device-width, initial-scale=1.0">
                        <title>Projets - Gestion RH</title>
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

                            .user-info {
                                text-align: right;
                            }

                            .user-name {
                                font-weight: 600;
                                display: block;
                            }

                            .user-role {
                                font-size: 12px;
                                color: #aaa;
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
                                flex-wrap: wrap;
                                gap: 15px;
                            }

                            .header-section h1 {
                                color: #333;
                                font-size: 28px;
                            }

                            .header-actions {
                                display: flex;
                                gap: 10px;
                                align-items: center;
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

                            .filter-section {
                                background: white;
                                padding: 20px;
                                border-radius: 10px;
                                box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
                                margin-bottom: 25px;
                            }

                            .filter-buttons {
                                display: flex;
                                gap: 10px;
                                flex-wrap: wrap;
                            }

                            .filter-btn {
                                padding: 8px 16px;
                                border: 2px solid #dee2e6;
                                background: white;
                                color: #333;
                                border-radius: 20px;
                                cursor: pointer;
                                font-weight: 500;
                                text-decoration: none;
                                transition: all 0.3s;
                            }

                            .filter-btn:hover,
                            .filter-btn.active {
                                background: #667eea;
                                color: white;
                                border-color: #667eea;
                            }

                            .projects-grid {
                                display: grid;
                                grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
                                gap: 25px;
                            }

                            .project-card {
                                background: white;
                                border-radius: 10px;
                                box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
                                transition: transform 0.3s, box-shadow 0.3s;
                                overflow: hidden;
                            }

                            .project-card:hover {
                                transform: translateY(-5px);
                                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
                            }

                            .project-header {
                                padding: 20px;
                                border-bottom: 1px solid #dee2e6;
                            }

                            .project-header h3 {
                                color: #333;
                                font-size: 20px;
                                margin-bottom: 10px;
                            }

                            .project-body {
                                padding: 20px;
                            }

                            .project-info {
                                margin-bottom: 15px;
                            }

                            .project-info label {
                                display: block;
                                color: #666;
                                font-size: 12px;
                                margin-bottom: 5px;
                                text-transform: uppercase;
                            }

                            .project-info value {
                                display: block;
                                color: #333;
                                font-size: 14px;
                                font-weight: 500;
                            }

                            .project-footer {
                                padding: 15px 20px;
                                background: #f8f9fa;
                                display: flex;
                                gap: 8px;
                                justify-content: space-between;
                            }

                            .badge {
                                display: inline-block;
                                padding: 6px 12px;
                                border-radius: 15px;
                                font-size: 12px;
                                font-weight: 600;
                            }

                            .badge-inprocess {
                                background-color: #cfe2ff;
                                color: #084298;
                            }

                            .badge-finished {
                                background-color: #d1e7dd;
                                color: #0f5132;
                            }

                            .badge-canceled {
                                background-color: #f8d7da;
                                color: #842029;
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
                                padding: 80px 20px;
                                background: white;
                                border-radius: 10px;
                                box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
                            }

                            .empty-state i {
                                font-size: 80px;
                                opacity: 0.3;
                                margin-bottom: 20px;
                                display: block;
                            }

                            .empty-state h3 {
                                color: #666;
                                margin-bottom: 10px;
                            }
                        </style>
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

                        <div class="container">
                            <div class="header-section">
                                <h1>📊 Gestion des Projets</h1>
                                <div class="header-actions">
                                    <% if (currentUser.getEmploye_rank()>= 2) { %>
                                        <a href="${pageContext.request.contextPath}/projects/create"
                                            class="btn btn-primary">
                                            + Créer un projet
                                        </a>
                                        <% } %>
                                </div>
                            </div>

                            <!-- Messages -->
                            <c:if test="${param.success == 'create'}">
                                <div class="alert alert-success">
                                    ✓ Projet créé avec succès.
                                </div>
                            </c:if>

                            <c:if test="${param.success == 'update'}">
                                <div class="alert alert-success">
                                    ✓ Projet mis à jour avec succès.
                                </div>
                            </c:if>

                            <c:if test="${param.success == 'delete'}">
                                <div class="alert alert-success">
                                    ✓ Projet supprimé avec succès.
                                </div>
                            </c:if>

                            <c:if test="${param.error == 'notfound'}">
                                <div class="alert alert-error">
                                    ✗ Projet introuvable.
                                </div>
                            </c:if>

                            <!-- Filtres -->
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

                            <!-- Grille de projets -->
                            <c:choose>
                                <c:when test="${empty projects}">
                                    <div class="empty-state">
                                        <i>📁</i>
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
                                                                <c:when
                                                                    test="${empty project.employees || project.employees == '0'}">
                                                                    Aucun employé assigné
                                                                </c:when>
                                                                <c:otherwise>
                                                                    ${fn:length(fn:split(project.employees, ','))}
                                                                    employé(s)
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </value>
                                                    </div>
                                                </div>

                                                <div class="project-footer">
                                                    <a href="${pageContext.request.contextPath}/projects/view?id=${project.id}"
                                                        class="btn btn-info"
                                                        style="padding: 6px 12px; font-size: 13px;">
                                                        👁️ Détails
                                                    </a>

                                                    <% if (currentUser.getEmploye_rank()>= 2) { %>
                                                        <a href="${pageContext.request.contextPath}/projects/edit?id=${project.id}"
                                                            class="btn btn-warning"
                                                            style="padding: 6px 12px; font-size: 13px;">
                                                            ✏️ Modifier
                                                        </a>

                                                        <form
                                                            action="${pageContext.request.contextPath}/projects/delete"
                                                            method="post" style="display: inline;"
                                                            onsubmit="return confirm('Voulez-vous vraiment supprimer ce projet ?');">
                                                            <input type="hidden" name="id" value="${project.id}">
                                                            <button type="submit" class="btn btn-danger"
                                                                style="padding: 6px 12px; font-size: 13px;">
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