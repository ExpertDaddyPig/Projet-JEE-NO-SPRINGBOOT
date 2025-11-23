<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Créer un Projet</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 40px 20px;
        }

        .form-container {
            max-width: 600px;
            margin: 0 auto;
            background: white;
            padding: 40px;
            border-radius: 10px;
            box-shadow: 0 10px 25px rgba(0,0,0,0.2);
        }

        .form-header {
            margin-bottom: 30px;
        }

        .form-header h1 {
            color: #333;
            font-size: 28px;
            margin-bottom: 10px;
        }

        .form-header p {
            color: #666;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            color: #333;
            font-weight: 600;
        }

        .form-group input,
        .form-group select {
            width: 100%;
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 14px;
            transition: border-color 0.3s;
        }

        .form-group input:focus,
        .form-group select:focus {
            outline: none;
            border-color: #667eea;
        }

        .btn {
            padding: 12px 24px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-weight: 600;
            font-size: 16px;
            transition: all 0.3s;
        }

        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            width: 100%;
        }

        .btn-primary:hover {
            transform: translateY(-2px);
        }

        .btn-secondary {
            background: #6c757d;
            color: white;
            text-decoration: none;
            display: inline-block;
            text-align: center;
        }

        .alert {
            padding: 12px;
            border-radius: 5px;
            margin-bottom: 20px;
        }

        .alert-error {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }

        .form-actions {
            display: flex;
            gap: 15px;
            margin-top: 30px;
        }

        .form-actions > * {
            flex: 1;
        }

        .info-box {
            background: #e7f3ff;
            border-left: 4px solid #0066cc;
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 20px;
        }

        .info-box p {
            margin: 0;
            color: #004085;
            font-size: 14px;
        }
    </style>
</head>
<body>
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