<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

            <!DOCTYPE html>
            <html lang="fr">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Profil de
                    <c:out value="${sessionScope.currentUser.first_name}" />
                    <c:out value="${sessionScope.currentUser.last_name}" />
                </title>
                <link rel="stylesheet" href="${pageContext.request.contextPath}/css/styles.css">
                <link rel="stylesheet"
                    href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
            </head>

            <body>

                <nav class="navbar no-print">
                    <div class="navbar-brand">Gestion RH - Profil</div>
                    <div class="navbar-user">
                        <div class="navbar-links">
                            <a href="${pageContext.request.contextPath}/dashboard">Tableau de Bord</a>
                            <a href="${pageContext.request.contextPath}/logout" class="btn-logout">Déconnexion</a>
                        </div>
                        <div class="user-info">
                            <span class="user-name">
                                <c:out value="${sessionScope.currentUser.username}" />
                            </span>
                            <span class="user-role">
                                <c:out value="${sessionScope.currentUser.role}" />
                            </span>
                        </div>
                        <a href="${pageContext.request.contextPath}/logout" class="btn btn-logout">Déconnexion</a>
                    </div>
                </nav>

                <div class="container">

                    <div class="action-bar">
                        <h1 class="page-title">Mon Profil</h1>
                    </div>

                    <div class="info-section">
                        <h2>Informations Personnelles</h2>
                        <div class="info-grid">
                            <span class="info-label">Nom complet</span>
                            <span class="info-value">
                                <c:out
                                    value="${sessionScope.currentUser.first_name} ${sessionScope.currentUser.last_name}" />
                            </span>

                            <span class="info-label">Adresse e-mail</span>
                            <span class="info-value">
                                <c:out value="${sessionScope.currentUser.email}" />
                            </span>

                            <span class="info-label">Âge</span>
                            <span class="info-value">
                                <c:out value="${sessionScope.currentUser.age}" /> ans
                            </span>

                            <span class="info-label">Genre</span>
                            <span class="info-value">
                                <c:out value="${sessionScope.currentUser.gender}" />
                            </span>
                        </div>
                    </div>

                    <div class="info-section">
                        <h2>Informations Professionnelles</h2>
                        <div class="info-grid">
                            <span class="info-label">Matricule</span>
                            <span class="info-value">
                                <c:out value="${sessionScope.currentUser.registration_number}" />
                            </span>

                            <span class="info-label">Poste</span>
                            <span class="info-value">
                                <c:choose>
                                    <c:when test="${not empty sessionScope.currentUser.job_name}">
                                        <c:out value="${sessionScope.currentUser.job_name}" />
                                    </c:when>
                                    <c:otherwise>Non spécifié</c:otherwise>
                                </c:choose>
                            </span>

                            <span class="info-label">Département ID</span>
                            <span class="info-value">
                                <c:choose>
                                    <c:when test="${not empty sessionScope.currentUser.departement_id}">
                                        <c:out value="${sessionScope.currentUser.departement_id}" />
                                    </c:when>
                                    <c:otherwise>Non assigné</c:otherwise>
                                </c:choose>
                            </span>

                            <span class="info-label">Rôle</span>
                            <span class="info-value">
                                <c:set var="roleClass" value="role-employe" />
                                <c:if test="${sessionScope.currentUser.role == 'ADMINISTRATEUR'}">
                                    <c:set var="roleClass" value="role-admin" />
                                </c:if>
                                <c:if test="${sessionScope.currentUser.role == 'CHEF_DEPARTEMENT'}">
                                    <c:set var="roleClass" value="role-chef-dept" />
                                </c:if>
                                <c:if test="${sessionScope.currentUser.role == 'CHEF_PROJET'}">
                                    <c:set var="roleClass" value="role-chef-proj" />
                                </c:if>
                                <span class="role-badge ${roleClass}">
                                    <c:out value="${sessionScope.currentUser.role}" />
                                </span>
                            </span>
                        </div>
                    </div>

                    <div class="info-section">
                        <h2>Gestion du Compte</h2>
                        <div class="info-grid">
                            <span class="info-label">Nom d'utilisateur</span>
                            <span class="info-value">
                                <c:out value="${sessionScope.currentUser.username}" />
                            </span>

                            <span class="info-label">Statut du compte</span>
                            <span class="info-value">
                                <c:choose>
                                    <c:when test="${sessionScope.currentUser.active}">
                                        <span class="status-badge status-active">Actif</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="status-badge status-inactive">Inactif</span>
                                    </c:otherwise>
                                </c:choose>
                            </span>

                            <span class="info-label">Membre depuis</span>
                            <span class="info-value">
                                <c:out value="${employe.createdAt}" />
                            </span>

                            <span class="info-label">Dernière connexion</span>
                            <span class="info-value">
                                <c:choose>
                                    <c:when test="${not empty employe.lastLogin}">
                                        <c:out value="${employe.lastLogin}" />
                                    </c:when>
                                    <c:otherwise>Jamais connecté</c:otherwise>
                                </c:choose>
                            </span>
                        </div>
                    </div>
                </div>

            </body>

            </html>