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

                .navbar-user {
                    display: flex;
                    align-items: center;
                    gap: 20px;
                }

                .user-info {
                    text-align: right;
                }

                .user-name {
                    font-weight: 600;
                }

                .user-role {
                    font-size: 12px;
                    color: #aaa;
                }

                .btn-logout {
                    padding: 8px 16px;
                    background-color: #dc3545;
                    color: white;
                    border: none;
                    border-radius: 5px;
                    cursor: pointer;
                    text-decoration: none;
                }

                .container {
                    max-width: 1200px;
                    margin: 30px auto;
                    padding: 0 20px;
                }

                .welcome-section {
                    background: white;
                    padding: 30px;
                    border-radius: 10px;
                    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
                    margin-bottom: 30px;
                }

                .welcome-section h1 {
                    color: #333;
                    margin-bottom: 10px;
                }

                .welcome-section p {
                    color: #666;
                }

                .menu-grid {
                    display: grid;
                    grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
                    gap: 20px;
                    margin-top: 30px;
                }

                .menu-card {
                    background: white;
                    padding: 30px;
                    border-radius: 10px;
                    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
                    text-align: center;
                    transition: transform 0.3s;
                    cursor: pointer;
                    text-decoration: none;
                    color: inherit;
                }

                .menu-card:hover {
                    transform: translateY(-5px);
                    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
                }

                .menu-icon {
                    font-size: 48px;
                    margin-bottom: 15px;
                }

                .menu-title {
                    font-size: 20px;
                    font-weight: 600;
                    color: #333;
                    margin-bottom: 10px;
                }

                .menu-description {
                    font-size: 14px;
                    color: #666;
                }

                .role-badge {
                    display: inline-block;
                    padding: 5px 12px;
                    border-radius: 20px;
                    font-size: 12px;
                    font-weight: 600;
                    margin-top: 10px;
                }

                .role-admin {
                    background-color: #dc3545;
                    color: white;
                }

                .role-chef-dept {
                    background-color: #007bff;
                    color: white;
                }

                .role-chef-proj {
                    background-color: #28a745;
                    color: white;
                }

                .role-employe {
                    background-color: #6c757d;
                    color: white;
                }
            </style>
        </head>

        <body>
            <nav class="navbar">
                <div class="navbar-brand">Gestion RH</div>
                <div class="navbar-user">
                    <div class="user-info">
                        <!-- Utilisation de sessionScope pour être explicite -->
                        <div class="user-name">${sessionScope.currentUser.username}</div>
                        <div class="user-role">${sessionScope.currentUser.role.displayName}</div>
                    </div>
                    <a href="${pageContext.request.contextPath}/logout" class="btn-logout">Déconnexion</a>
                </div>
            </nav>

            <div class="container">
                <div class="welcome-section">
                    <h1>Bienvenue, ${sessionScope.currentUser.username} !</h1>
                    <p>Vous êtes connecté en tant que <strong>${sessionScope.currentUser.role.displayName}</strong></p>
                    <span class="role-badge
                <c:choose>
                    <c:when test=" ${sessionScope.currentUser.role=='ADMINISTRATEUR' }">role-admin</c:when>
                        <c:when test="${sessionScope.currentUser.role == 'CHEF_DEPARTEMENT'}">role-chef-dept</c:when>
                        <c:when test="${sessionScope.currentUser.role == 'CHEF_PROJET'}">role-chef-proj</c:when>
                        <c:otherwise>role-employe</c:otherwise>
                        </c:choose>
                        ">${sessionScope.currentUser.role.displayName}
                    </span>
                </div>

                <div class="menu-grid">
                    <!-- Menu accessible à tous -->
                    <a href="${pageContext.request.contextPath}/profile.jsp" class="menu-card">
                        <div class="menu-icon">👤</div>
                        <div class="menu-title">Mon Profil</div>
                        <div class="menu-description">Consulter et modifier vos informations</div>
                    </a>

                    <!-- Menu pour Admin et Chefs de département -->
                    <c:if
                        test="${sessionScope.currentUser.role == 'ADMINISTRATEUR' || sessionScope.currentUser.role == 'CHEF_DEPARTEMENT'}">
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

                    <!-- Menu pour Admin, Chefs de département et Chefs de projet -->
                    <c:if
                        test="${sessionScope.currentUser.role == 'ADMINISTRATEUR' || sessionScope.currentUser.role == 'CHEF_DEPARTEMENT' || sessionScope.currentUser.role == 'CHEF_PROJET'}">
                        <a href="${pageContext.request.contextPath}/projects" class="menu-card">
                            <div class="menu-icon">📊</div>
                            <div class="menu-title">Projets</div>
                            <div class="menu-description">Gérer les projets de l'entreprise</div>
                        </a>
                    </c:if>

                    <!-- Menu fiches de paie -->
                    <a href="${pageContext.request.contextPath}/payslips" class="menu-card">
                        <div class="menu-icon">💰</div>
                        <div class="menu-title">Fiches de Paie</div>
                        <div class="menu-description">
                            <c:choose>
                                <c:when
                                    test="${sessionScope.currentUser.role == 'ADMINISTRATEUR' || sessionScope.currentUser.role == 'CHEF_DEPARTEMENT'}">
                                    Gérer toutes les fiches de paie
                                </c:when>
                                <c:otherwise>
                                    Consulter vos fiches de paie
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </a>

                    <!-- Menu uniquement pour Administrateur -->
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