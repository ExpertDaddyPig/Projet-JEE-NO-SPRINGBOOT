<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Créer un Projet</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/styles.css">
</head>
<body class="form-page">
    <div class="form-container">
        <div class="form-header">
            <h1>📊 Créer un Nouveau Projet</h1>
            <p>Remplissez les informations du projet</p>
        </div>

        <c:if test="${not empty errorMessage}">
            <div class="alert alert-error">
                ${errorMessage}
            </div>
        </c:if>

        <div class="info-box">
            <p>💡 <strong>Astuce:</strong> Après la création, vous pourrez assigner des employés au projet.</p>
        </div>

        <form action="${pageContext.request.contextPath}/projects/create" method="post">
            <div class="form-group">
                <label for="project_name">Nom du Projet *</label>
                <input type="text"
                       id="project_name"
                       name="project_name"
                       required
                       placeholder="Ex: Refonte du site web"
                       maxlength="50">
            </div>

            <div class="form-group">
                <label for="project_state">État Initial</label>
                <select id="project_state" name="project_state">
                    <option value="in process" selected>⏳ En cours</option>
                    <option value="finished">✅ Terminé</option>
                    <option value="canceled">❌ Annulé</option>
                </select>
            </div>

            <div class="form-actions">
                <button type="submit" class="btn btn-primary">✓ Créer le projet</button>
                <a href="${pageContext.request.contextPath}/projects" class="btn btn-secondary">✗ Annuler</a>
            </div>
        </form>
    </div>
</body>
</html>