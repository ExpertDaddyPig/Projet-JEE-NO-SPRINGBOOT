<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="fr">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Modifier le projet - ${project.project_name}</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/styles.css">
</head>

<body>
    <div class="container" style="max-width: 800px;">
        <a href="${pageContext.request.contextPath}/projects/view?id=${project.id}" class="back-link">
            ← Retour aux détails
        </a>

        <div class="form-section">
            <div class="form-header">
                <h1>✏️ Modifier le projet</h1>
            </div>

            <form action="${pageContext.request.contextPath}/projects/edit" method="post">
                <input type="hidden" name="id" value="${project.id}">

                <div class="form-group">
                    <label for="project_name" class="form-label">Nom du Projet</label>
                    <input type="text" id="project_name" name="project_name" class="form-control"
                        value="${project.project_name}" required placeholder="Entrez le nom du projet">
                </div>

                <div class="form-group">
                    <label for="project_state" class="form-label">État du Projet</label>
                    <select id="project_state" name="project_state" class="form-control">
                        <option value="in process" ${project.project_state=='in process' ? 'selected' : ''}>
                            ⏳ En cours
                        </option>
                        <option value="finished" ${project.project_state=='finished' ? 'selected' : ''}>
                            ✅ Terminé
                        </option>
                        <option value="canceled" ${project.project_state=='canceled' ? 'selected' : ''}>
                            ❌ Annulé
                        </option>
                    </select>
                </div>

                <div class="form-actions">
                    <a href="${pageContext.request.contextPath}/projects/view?id=${project.id}"
                        class="btn btn-secondary">
                        Annuler
                    </a>
                    <button type="submit" class="btn btn-primary">
                        💾 Enregistrer les modifications
                    </button>
                </div>
            </form>
        </div>
    </div>
</body>

</html>