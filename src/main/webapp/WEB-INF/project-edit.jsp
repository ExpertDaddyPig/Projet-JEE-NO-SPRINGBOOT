<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="fr">

        <head>
            <meta charset="UTF-8">
            <title>Modifier le projet - ${project.project_name}</title>
            <style>
                * {
                    margin: 0;
                    padding: 0;
                    box-sizing: border-box;
                }

                body {
                    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                    background-color: #f5f5f5;
                    padding: 20px;
                }

                .container {
                    max-width: 800px;
                    margin: 0 auto;
                }

                .back-link {
                    display: inline-block;
                    color: #667eea;
                    text-decoration: none;
                    margin-bottom: 20px;
                    font-weight: 600;
                }

                .back-link:hover {
                    text-decoration: underline;
                }

                .form-section {
                    background: white;
                    padding: 30px;
                    border-radius: 10px;
                    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
                }

                .form-header {
                    margin-bottom: 25px;
                    border-bottom: 2px solid #dee2e6;
                    padding-bottom: 15px;
                }

                .form-header h1 {
                    color: #333;
                    font-size: 28px;
                }

                .form-group {
                    margin-bottom: 20px;
                }

                .form-label {
                    display: block;
                    margin-bottom: 8px;
                    color: #666;
                    font-weight: 600;
                }

                .form-control {
                    width: 100%;
                    padding: 12px;
                    border: 1px solid #ddd;
                    border-radius: 6px;
                    font-size: 16px;
                    font-family: inherit;
                    transition: border-color 0.2s;
                }

                .form-control:focus {
                    border-color: #667eea;
                    outline: none;
                    box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
                }

                .form-actions {
                    display: flex;
                    gap: 15px;
                    margin-top: 30px;
                    padding-top: 20px;
                    border-top: 1px solid #eee;
                }

                .btn {
                    padding: 12px 24px;
                    border: none;
                    border-radius: 6px;
                    cursor: pointer;
                    font-weight: 600;
                    font-size: 16px;
                    text-decoration: none;
                    text-align: center;
                    transition: opacity 0.2s, transform 0.1s;
                }

                .btn:hover {
                    opacity: 0.9;
                    transform: translateY(-1px);
                }

                .btn-primary {
                    background: #667eea;
                    color: white;
                    flex: 2;
                }

                .btn-secondary {
                    background: #e2e6ea;
                    color: #333;
                    flex: 1;
                }
            </style>
        </head>

        <body>

            <div class="container">
                <!-- Link back to the details page of the specific project -->
                <a href="${pageContext.request.contextPath}/projects/view?id=${project.id}" class="back-link">
                    ← Retour aux détails
                </a>

                <div class="form-section">
                    <div class="form-header">
                        <h1>✏️ Modifier le projet</h1>
                    </div>

                    <!-- Form submits to the update controller -->
                    <form action="${pageContext.request.contextPath}/projects/edit" method="post">

                        <!-- Hidden ID to identify which project to update -->
                        <input type="hidden" name="id" value="${project.id}">

                        <!-- Project Name Field -->
                        <div class="form-group">
                            <label for="project_name" class="form-label">Nom du Projet</label>
                            <input type="text" id="project_name" name="project_name" class="form-control"
                                value="${project.project_name}" required placeholder="Entrez le nom du projet">
                        </div>

                        <!-- Project State Field -->
                        <div class="form-group">
                            <label for="project_state" class="form-label">État du Projet</label>
                            <select id="project_state" name="project_state" class="form-control">
                                <option value="in process" ${project.project_state=='in process' ? 'selected' : '' }>
                                    ⏳ En cours
                                </option>
                                <option value="finished" ${project.project_state=='finished' ? 'selected' : '' }>
                                    ✅ Terminé
                                </option>
                                <option value="canceled" ${project.project_state=='canceled' ? 'selected' : '' }>
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