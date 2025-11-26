<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Connexion - Gestion RH</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/styles.css">
</head>
<body class="login-page">
    <div class="login-container">
        <div class="login-header">
            <h1>Gestion RH</h1>
            <p>Connectez-vous à votre compte</p>
        </div>

        <c:if test="${not empty errorMessage}">
            <div class="alert alert-error">
                ${errorMessage}
            </div>
        </c:if>

        <c:if test="${param.logout == 'success'}">
            <div class="alert alert-success">
                Vous avez été déconnecté avec succès.
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/login" method="post">
            <div class="form-group">
                <label for="username">Nom d'utilisateur</label>
                <input type="text"
                       id="username"
                       name="username"
                       value="${username}"
                       required
                       autofocus
                       placeholder="Entrez votre nom d'utilisateur">
            </div>

            <div class="form-group">
                <label for="password">Mot de passe</label>
                <input type="password"
                       id="password"
                       name="password"
                       required
                       placeholder="Entrez votre mot de passe">
            </div>

            <div class="remember-me">
                <input type="checkbox" id="rememberMe" name="rememberMe">
                <label for="rememberMe">Se souvenir de moi</label>
            </div>

            <button type="submit" class="btn btn-primary" style="width: 100%;">Se connecter</button>
        </form>

        <div class="login-footer">
            &copy; 2025 Système de Gestion RH. Tous droits réservés.
        </div>
    </div>
</body>
</html>