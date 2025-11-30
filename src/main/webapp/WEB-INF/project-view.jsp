<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="fr">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${project.project_name} - Détails</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/styles.css">
</head>

<body>
    <div class="container" style="max-width: 1000px;">
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
                            <a href="${pageContext.request.contextPath}/projects/assign?id=${project.id}"
                                class="btn btn-primary" style="width: auto; padding: 10px 20px;">
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
                    <form action="${pageContext.request.contextPath}/projects/assign" method="get">
                        <input type="hidden" name="id" value="${project.id}">
                        <button type="submit" class="btn btn-primary">
                            👥 Assigner des employés
                        </button>
                    </form>

                    <form action="${pageContext.request.contextPath}/projects/edit" method="get">
                        <input type="hidden" name="id" value="${project.id}">
                        <button type="submit" class="btn btn-warning">
                            ✏️ Modifier le projet
                        </button>
                    </form>

                    <c:if test="${project.project_state == 'in process'}">
                        <form action="${pageContext.request.contextPath}/projects/changeState" method="post">
                            <input type="hidden" name="id" value="${project.id}">
                            <input type="hidden" name="state" value="finished">
                            <button type="submit" class="btn btn-success">
                                ✅ Marquer comme terminé
                            </button>
                        </form>

                        <form action="${pageContext.request.contextPath}/projects/changeState" method="post">
                            <input type="hidden" name="id" value="${project.id}">
                            <input type="hidden" name="state" value="canceled">
                            <button type="submit" class="btn btn-danger">
                                ❌ Annuler le projet
                            </button>
                        </form>
                    </c:if>

                    <form action="${pageContext.request.contextPath}/projects/delete" method="post"
                        onsubmit="return confirm('Voulez-vous vraiment supprimer ce projet ?');">
                        <input type="hidden" name="id" value="${project.id}">
                        <button type="submit" class="btn btn-danger">
                            🗑️ Supprimer le projet
                        </button>
                    </form>
                </div>
            </div>
        </c:if>
    </div>
</body>

</html>