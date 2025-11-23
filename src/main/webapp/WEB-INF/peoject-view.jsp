<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>${project.project_name} - Détails</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f5f5f5;
            padding: 20px;
        }

        .container {
            max-width: 1000px;
            margin: 0 auto;
        }

        .back-link {
            display: inline-block;
            color: #667eea;
            text-decoration: none;
            margin-bottom: 20px;
            font-weight: 600;
        }

        .back-link:hover {
            text-decoration: underline;
        }

        .project-header {
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            margin-bottom: 25px;
        }

        .project-header h1 {
            color: #333;
            font-size: 32px;
            margin-bottom: 15px;
        }

        .badge {
            display: inline-block;
            padding: 8px 16px;
            border-radius: 20px;
            font-size: 14px;
            font-weight: 600;
            margin-right: 10px;
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

        .info-section {
            background: white;
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            margin-bottom: 25px;
        }

        .info-section h2 {
            color: #333;
            font-size: 20px;
            margin-bottom: 20px;
            border-bottom: 2px solid #dee2e6;
            padding-bottom: 10px;
        }

        .info-grid {
            display: grid;
            grid-template-columns: 200px 1fr;
            gap: 15px;
            margin-bottom: 20px;
        }

        .info-label {
            color: #666;
            font-weight: 600;
        }

        .info-value {
            color: #333;
        }

        .employees-list {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
            gap: 15px;
        }

        .employee-card {
            background: #f8f9fa;
            padding: 15px;
            border-radius: 8px;
            border-left: 4px solid #667eea;
        }

        .employee-card h4 {
            color: #333;
            margin-bottom: 8px;
        }

        .employee-card p {
            color: #666;
            font-size: 14px;
            margin: 4px 0;
        }

        .actions-section {
            background: white;
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }

        .actions-section h2 {
            color: #333;
            font-size: 20px;
            margin-bottom: 20px;
        }

        .actions-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
        }

        .btn {
            padding: 12px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            text-decoration: none;
            font-weight: 600;
            text-align: center;
            display: inline-block;
            transition: all 0.3s;
        }

        .btn-primary {
            background: #667eea;
            color: white;
        }

        .btn-success {
            background: #28a745;
            color: white;
        }

        .btn-danger {
            background: #dc3545;
            color: white;
        }

        .btn-warning {
            background: #ffc107;
            color: #333;
        }

        .btn:hover {
            opacity: 0.9;
            transform: translateY(-2px);
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

        .empty-state {
            text-align: center;
            padding: 40px;
            color: #999;
        }
    </style>
</head>
<body>
    <div class="container">
        <a href="${pageContext.request.contextPath}/projects" class="back-link">
            ← Retour aux projets
        </a>

        <c:if test="${param.success == 'assign'}">
            <div class="alert alert-success">
                ✓ Employés assignés avec succès.
            </div>
        </c:if>

        <c:if test="${param.success == 'stateChanged'}">
            <div class="alert alert-success">
                ✓ État du projet mis à jour avec succès.
            </div>
        </c:if>

        <div class="project-header">
            <h1>📊 ${project.project_name}</h1>
            <div>
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
        </div>

        <div class="info-section">
            <h2>📋 Informations du Projet</h2>
            <div class="info-grid">
                <div class="info-label">ID du Projet:</div>
                <div class="info-value">#${project.id}</div>

                <div class="info-label">Nom du Projet:</div>
                <div class="info-value">${project.project_name}</div>

                <div class="info-label">État Actuel:</div>
                <div class="info-value">
                    <c:choose>
                        <c:when test="${project.project_state == 'in process'}">En cours</c:when>
                        <c:when test="${project.project_state == 'finished'}">Terminé</c:when>
                        <c:when test="${project.project_state == 'canceled'}">Annulé</c:when>
                    </c:choose>
                </div>

                <div class="info-label">Nombre d'Employés:</div>
                <div class="info-value">
                    <c:choose>
                        <c:when test="${empty assignedEmployees}">
                            0 employé
                        </c:when>
                        <c:otherwise>
                            ${assignedEmployees.size()} employé(s)
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>

        <div class="info-section">
            <h2>👥 Employés Assignés</h2>
            <c:choose>
                <c:when test="${empty assignedEmployees}">
                    <div class="empty-state">
                        <p>Aucun employé n'est assigné à ce projet.</p>
                        <p style="margin-top: 10px;">
                            <a href="${pageContext.request.contextPath}/projects/assign?id=${project.id}" class="btn btn-primary">
                                Assigner des employés
                            </a>
                        </p>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="employees-list">
                        <c:forEach var="emp" items="${assignedEmployees}">
                            <div class="employee-card">
                                <h4>${emp.first_name} ${emp.last_name}</h4>
                                <p>📧 ${emp.email}</p>
                                <p>💼 ${emp.job_name}</p>
                                <p>🔢 Matricule: ${emp.registration_number}</p>
                            </div>
                        </c:forEach>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <c:if test="${currentUser.employe_rank >= 2}">
            <div class="actions-section">
                <h2>⚙️ Actions</h2>
                <div class="actions-grid">
                    <a href="${pageContext.request.contextPath}/projects/assign?id=${project.id}"
                       class="btn btn-primary">
                        👥 Assigner des employés
                    </a>

                    <a href="${pageContext.request.contextPath}/projects/edit?id=${project.id}"
                       class="btn btn-warning">
                        ✏️ Modifier le projet
                    </a>

                    <c:if test="${project.project_state == 'in process'}">
                        <form action="${pageContext.request.contextPath}/projects/changeState"
                              method="post"
                              style="display: inline;">
                            <input type="hidden" name="id" value="${project.id}">
                            <input type="hidden" name="state" value="finished">
                            <button type="submit" class="btn btn-success" style="width: 100%;">
                                ✅ Marquer comme terminé
                            </button>
                        </form>

                        <form action="${pageContext.request.contextPath}/projects/changeState"
                              method="post"
                              style="display: inline;">
                            <input type="hidden" name="id" value="${project.id}">
                            <input type="hidden" name="state" value="canceled">
                            <button type="submit" class="btn btn-danger" style="width: 100%;">
                                ❌ Annuler le projet
                            </button>
                        </form>
                    </c:if>

                    <form action="${pageContext.request.contextPath}/projects/delete"
                          method="post"
                          style="display: inline;"
                          onsubmit="return confirm('Voulez-vous vraiment supprimer ce projet ?');">
                        <input type="hidden" name="id" value="${project.id}">
                        <button type="submit" class="btn btn-danger" style="width: 100%;">
                            🗑️ Supprimer le projet
                        </button>
                    </form>
                </div>
            </div>
        </c:if>
    </div>
</body>
</html>