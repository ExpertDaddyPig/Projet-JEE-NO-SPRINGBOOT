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
                        <style>
                            /* ... (votre CSS reste inchangé) ... */
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

                            .navbar-links a {
                                color: white;
                                text-decoration: none;
                                margin-left: 20px;
                                padding: 8px 15px;
                                border-radius: 5px;
                                transition: background 0.3s;
                            }

                            .navbar-links a:hover {
                                background-color: #555;
                            }

                            .container {
                                max-width: 1400px;
                                margin: 30px auto;
                                padding: 0 20px;
                            }

                            .page-header {
                                background: white;
                                padding: 30px;
                                border-radius: 10px;
                                box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
                                margin-bottom: 30px;
                            }

                            .page-header h1 {
                                color: #333;
                                font-size: 32px;
                                margin-bottom: 10px;
                            }

                            .stats-grid {
                                display: grid;
                                grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
                                gap: 20px;
                                margin-bottom: 30px;
                            }

                            .stat-card {
                                background: white;
                                padding: 25px;
                                border-radius: 10px;
                                box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
                                text-align: center;
                                transition: transform 0.3s;
                            }

                            .stat-card:hover {
                                transform: translateY(-5px);
                                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
                            }

                            .stat-icon {
                                font-size: 48px;
                                margin-bottom: 15px;
                            }

                            .stat-value {
                                font-size: 36px;
                                font-weight: bold;
                                color: #667eea;
                                margin-bottom: 10px;
                            }

                            .stat-label {
                                font-size: 14px;
                                color: #666;
                                text-transform: uppercase;
                                letter-spacing: 1px;
                            }

                            .reports-section {
                                background: white;
                                padding: 30px;
                                border-radius: 10px;
                                box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
                                margin-bottom: 30px;
                            }

                            .reports-section h2 {
                                color: #333;
                                margin-bottom: 20px;
                                border-bottom: 2px solid #667eea;
                                padding-bottom: 10px;
                            }

                            .chart-container {
                                margin: 20px 0;
                            }

                            .bar-chart {
                                display: flex;
                                flex-direction: column;
                                gap: 15px;
                            }

                            .bar-item {
                                display: flex;
                                align-items: center;
                                gap: 15px;
                            }

                            .bar-label {
                                width: 200px;
                                font-weight: 600;
                                color: #333;
                            }

                            .bar-wrapper {
                                flex: 1;
                                background: #f0f0f0;
                                border-radius: 5px;
                                height: 30px;
                                position: relative;
                                overflow: hidden;
                            }

                            .bar-fill {
                                height: 100%;
                                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                                border-radius: 5px;
                                display: flex;
                                align-items: center;
                                justify-content: flex-end;
                                padding-right: 10px;
                                color: white;
                                font-weight: bold;
                                transition: width 0.5s ease;
                            }

                            .quick-actions {
                                display: grid;
                                grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
                                gap: 20px;
                            }

                            .action-card {
                                background: white;
                                padding: 20px;
                                border-radius: 10px;
                                box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
                                text-decoration: none;
                                color: inherit;
                                transition: all 0.3s;
                                border-left: 4px solid #667eea;
                            }

                            .action-card:hover {
                                transform: translateX(5px);
                                box-shadow: 0 4px 8px rgba(0, 0, 0, 0.15);
                            }

                            .action-card h3 {
                                color: #333;
                                margin-bottom: 10px;
                                font-size: 18px;
                            }

                            .action-card p {
                                color: #666;
                                font-size: 14px;
                            }
                        </style>
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

                            <!-- Statistiques globales -->
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

                            <!-- Section de condition pour les graphiques -->
                            <c:if test="${stats.totalEmployees > 0}">
                                <!-- Employés par grade -->
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

                                <!-- Employés par département -->
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

                                <!-- Employés par projet -->
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

                            <!-- Message si aucune donnée n'est disponible -->
                            <c:if test="${stats.totalEmployees == 0}">
                                <div class="reports-section">
                                    <p>Aucune donnée d'employé disponible pour générer les rapports graphiques.</p>
                                </div>
                            </c:if>

                            <!-- Actions rapides -->
                            <div class="reports-section">
                                <h2>🔗 Rapports Détaillés</h2>
                                <div class="quick-actions">
                                    <a href="${pageContext.request.contextPath}/reports/departments"
                                        class="action-card">
                                        <h3>🏢 Rapport par Département</h3>
                                        <p>Analyse détaillée de chaque département avec répartition des employés</p>
                                    </a>
                                    <a href="${pageContext.request.contextPath}/reports/projects" class="action-card">
                                        <h3>📊 Rapport par Projet</h3>
                                        <p>Statistiques complètes sur les projets et leurs équipes</p>
                                    </a>
                                    <a href="${pageContext.request.contextPath}/reports/employees" class="action-card">
                                        <h3>👥 Rapport Employés</h3>
                                        <p>Vue d'ensemble de tous les employés avec leurs grades</p>
                                    </a>
                                </div>
                            </div>
                        </div>
                    </body>

                    </html>