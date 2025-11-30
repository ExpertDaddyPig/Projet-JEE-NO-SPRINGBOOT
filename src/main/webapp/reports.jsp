<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ page import="com.main.model.Employe" %>
            <%@ page import="java.util.Map" %>
                <% Employe currentUser=(Employe) session.getAttribute("currentUser"); if (currentUser==null) {
                    response.sendRedirect(request.getContextPath() + "/login.jsp" ); return; } %>
                    <!DOCTYPE html>
                    <html lang="fr">

                    <head>
                        <meta charset="UTF-8">
                        <meta name="viewport" content="width=device-width, initial-scale=1.0">
                        <title>Rapports et Statistiques</title>
                        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/styles.css">
                    </head>

                    <body>
                        <nav class="navbar">
                            <div class="navbar-brand">📈 Rapports & Statistiques</div>
                            <div class="navbar-links">
                                <a href="${pageContext.request.contextPath}/dashboard">Tableau de bord</a>
                                <a href="${pageContext.request.contextPath}/logout">Déconnexion</a>
                            </div>
                        </nav>

                        <div class="container">
                            <div class="page-header">
                                <h1>📊 Vue d'ensemble</h1>
                                <p style="color: #666; margin-top: 10px;">Statistiques et rapports de l'entreprise</p>
                            </div>

                            <div class="stats-grid">
                                <div class="stat-card">
                                    <div class="stat-icon">👥</div>
                                    <div class="stat-value">${stats.totalEmployees}</div>
                                    <div class="stat-label">Employés Total</div>
                                </div>
                                <div class="stat-card">
                                    <div class="stat-icon">✅</div>
                                    <div class="stat-value">${stats.activeEmployees}</div>
                                    <div class="stat-label">Employés Actifs</div>
                                </div>
                                <div class="stat-card">
                                    <div class="stat-icon">🏢</div>
                                    <div class="stat-value">${stats.totalDepartments}</div>
                                    <div class="stat-label">Départements</div>
                                </div>
                                <div class="stat-card">
                                    <div class="stat-icon">📊</div>
                                    <div class="stat-value">${stats.totalProjects}</div>
                                    <div class="stat-label">Projets Total</div>
                                </div>
                                <div class="stat-card">
                                    <div class="stat-icon">⏳</div>
                                    <div class="stat-value">${stats.activeProjects}</div>
                                    <div class="stat-label">Projets en Cours</div>
                                </div>
                                <div class="stat-card">
                                    <div class="stat-icon">✔️</div>
                                    <div class="stat-value">${stats.finishedProjects}</div>
                                    <div class="stat-label">Projets Terminés</div>
                                </div>
                            </div>

                            <c:if test="${stats.totalEmployees > 0}">
                                <div class="reports-section">
                                    <h2>👔 Répartition des Employés par Grade</h2>
                                    <div class="chart-container">
                                        <div class="bar-chart">
                                            <c:forEach var="entry" items="${stats.employeesByRank}">
                                                <div class="bar-item">
                                                    <div class="bar-label">${entry.key}</div>
                                                    <div class="bar-wrapper">
                                                        <div class="bar-fill"
                                                            style="width: ${entry.value * 100 / stats.totalEmployees}%">
                                                            ${entry.value}
                                                        </div>
                                                    </div>
                                                </div>
                                            </c:forEach>
                                        </div>
                                    </div>
                                </div>

                                <div class="reports-section">
                                    <h2>🏢 Employés par Département</h2>
                                    <div class="chart-container">
                                        <div class="bar-chart">
                                            <c:forEach var="entry" items="${stats.employeesByDepartment}">
                                                <div class="bar-item">
                                                    <div class="bar-label">${entry.key}</div>
                                                    <div class="bar-wrapper">
                                                        <div class="bar-fill"
                                                            style="width: ${entry.value * 100 / stats.totalEmployees}%">
                                                            ${entry.value}
                                                        </div>
                                                    </div>
                                                </div>
                                            </c:forEach>
                                        </div>
                                    </div>
                                </div>

                                <div class="reports-section">
                                    <h2>📊 Employés par Projet</h2>
                                    <div class="chart-container">
                                        <div class="bar-chart">
                                            <c:forEach var="entry" items="${stats.employeesByProject}">
                                                <div class="bar-item">
                                                    <div class="bar-label">${entry.key}</div>
                                                    <div class="bar-wrapper">
                                                        <div class="bar-fill"
                                                            style="width: ${entry.value * 100 / stats.totalEmployees}%">
                                                            ${entry.value}
                                                        </div>
                                                    </div>
                                                </div>
                                            </c:forEach>
                                        </div>
                                    </div>
                                </div>
                            </c:if>

                            <c:if test="${stats.totalEmployees == 0}">
                                <div class="reports-section">
                                    <p>Aucune donnée d'employé disponible pour générer les rapports graphiques.</p>
                                </div>
                            </c:if>
                        </div>
                    </body>

                    </html>