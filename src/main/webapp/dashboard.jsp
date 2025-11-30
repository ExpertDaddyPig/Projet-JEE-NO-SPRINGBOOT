<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:if test="${empty sessionScope.currentUser}">
    <c:redirect url="login.jsp" />
</c:if>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tableau de bord - Gestion RH</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/styles.css">
</head>
<body>
    <nav class="navbar">
        <div class="navbar-brand">Gestion RH</div>
        <div class="navbar-user">
            <div class="user-info">
                <div class="user-name">${sessionScope.currentUser.username}</div>
                <div class="user-role">${sessionScope.currentUser.role.displayName}</div>
            </div>
            <a href="${pageContext.request.contextPath}/logout" class="btn btn-logout">Déconnexion</a>
        </div>
    </nav>

    <div class="container">
        <div class="welcome-section">
            <h1>Bienvenue, ${sessionScope.currentUser.username} !</h1>
            <p>Vous êtes connecté en tant que <strong>${sessionScope.currentUser.role.displayName}</strong></p>
            <span class="role-badge
                <c:choose>
                    <c:when test="${sessionScope.currentUser.role=='ADMINISTRATEUR'}">role-admin</c:when>
                    <c:when test="${sessionScope.currentUser.role == 'CHEF_DEPARTEMENT'}">role-chef-dept</c:when>
                    <c:when test="${sessionScope.currentUser.role == 'CHEF_PROJET'}">role-chef-proj</c:when>
                    <c:otherwise>role-employe</c:otherwise>
                </c:choose>
            ">${sessionScope.currentUser.role.displayName}</span>
        </div>

        <div class="menu-grid">
            <a href="${pageContext.request.contextPath}/profile" class="menu-card">
                <div class="menu-icon">👤</div>
                <div class="menu-title">Mon Profil</div>
                <div class="menu-description">Consulter et modifier vos informations</div>
            </a>

            <c:if test="${sessionScope.currentUser.role == 'ADMINISTRATEUR' || sessionScope.currentUser.role == 'CHEF_DEPARTEMENT'}">
                <a href="${pageContext.request.contextPath}/users" class="menu-card">
                    <div class="menu-icon">👥</div>
                    <div class="menu-title">Employés</div>
                    <div class="menu-description">Gérer les employés de l'entreprise</div>
                </a>

                <a href="${pageContext.request.contextPath}/departments" class="menu-card">
                    <div class="menu-icon">🏢</div>
                    <div class="menu-title">Départements</div>
                    <div class="menu-description">Gérer les départements</div>
                </a>
            </c:if>

            <c:if test="${sessionScope.currentUser.role == 'ADMINISTRATEUR' || sessionScope.currentUser.role == 'CHEF_DEPARTEMENT' || sessionScope.currentUser.role == 'CHEF_PROJET'}">
                <a href="${pageContext.request.contextPath}/projects" class="menu-card">
                    <div class="menu-icon">📊</div>
                    <div class="menu-title">Projets</div>
                    <div class="menu-description">Gérer les projets de l'entreprise</div>
                </a>
            </c:if>

            <a href="${pageContext.request.contextPath}/payslips" class="menu-card">
                <div class="menu-icon">💰</div>
                <div class="menu-title">Fiches de Paie</div>
                <div class="menu-description">
                    <c:choose>
                        <c:when test="${sessionScope.currentUser.role == 'ADMINISTRATEUR' || sessionScope.currentUser.role == 'CHEF_DEPARTEMENT'}">
                            Gérer toutes les fiches de paie
                        </c:when>
                        <c:otherwise>
                            Consulter vos fiches de paie
                        </c:otherwise>
                    </c:choose>
                </div>
            </a>

            <c:if test="${sessionScope.currentUser.role == 'ADMINISTRATEUR'}">
                <a href="${pageContext.request.contextPath}/reports" class="menu-card">
                    <div class="menu-icon">📈</div>
                    <div class="menu-title">Rapports</div>
                    <div class="menu-description">Statistiques et rapports</div>
                </a>
            </c:if>
        </div>
    </div>
</body>
</html>