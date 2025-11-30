<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="fr">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestion des Employés</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/styles.css">
    <style>
        /* Styles spécifiques à cette page uniquement */
        .search-form {
            display: flex;
            align-items: center;
            background: white;
            padding: 5px;
            border-radius: 5px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
            border: 1px solid #eee;
        }

        .search-input {
            border: none;
            padding: 8px 12px;
            font-size: 14px;
            outline: none;
            width: 300px;
            color: #555;
        }

        .search-btn {
            background-color: #6c757d;
            color: white;
            border: none;
            padding: 8px 12px;
            border-radius: 4px;
            cursor: pointer;
            transition: background 0.2s;
        }

        .search-btn:hover {
            background-color: #5a6268;
        }

        .reset-link {
            color: #dc3545;
            text-decoration: none;
            margin-left: 10px;
            margin-right: 5px;
            font-weight: bold;
            font-size: 18px;
            display: flex;
            align-items: center;
        }
    </style>
</head>

        <body>

            <nav class="navbar">
                <div class="navbar-brand">Gestion RH - Employés</div>
                <div class="navbar-links">
                    <a href="${pageContext.request.contextPath}/dashboard">Tableau de bord</a>
                    <a href="${pageContext.request.contextPath}/projects">Projets</a>
                    <a href="${pageContext.request.contextPath}/payslips">Fiches de Paie</a>
                    <div class="user-info">
                        <span class="user-name">${sessionScope.currentUser.username}</span>
                        <span class="user-role">${sessionScope.currentUser.role.displayName}</span>
                    </div>
                    <a href="${pageContext.request.contextPath}/logout" class="btn-logout">Déconnexion</a>
                </div>
            </nav>

    <div class="container">
        <div class="action-bar">
            <h1 class="page-title">Liste des Employés</h1>

            <form action="${pageContext.request.contextPath}/users" method="get" class="search-form">
                <input type="text" name="search" class="search-input"
                    placeholder="Rechercher (Nom, Matricule, Département...)" value="${param.search}">
                <button type="submit" class="search-btn">🔍</button>
                <c:if test="${not empty param.search}">
                    <a href="${pageContext.request.contextPath}/users" class="reset-link" title="Effacer la recherche">×</a>
                </c:if>
            </form>

            <c:if test="${sessionScope.currentUser.role=='ADMINISTRATEUR' }">
                <button onclick="openModal('add')" class="btn btn-add">
                    <span>+</span> Nouvel Employé
                </button>
            </c:if>
        </div>

        <c:if test="${param.success eq 'add'}">
            <div class="alert alert-success">Employé ajouté avec succès.</div>
        </c:if>
        <c:if test="${param.success eq 'update'}">
            <div class="alert alert-info">Employé mis à jour avec succès.</div>
        </c:if>
        <c:if test="${param.success eq 'delete'}">
            <div class="alert alert-error">Employé supprimé.</div>
        </c:if>

        <div class="table-card">
            <table>
                <thead>
                    <tr>
                        <th>Employé</th>
                        <th>Poste</th>
                        <th>Département</th>
                        <th>Rôle</th>
                        <th>Statut</th>
                        <th style="text-align: right;">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="u" items="${users}">
                        <tr>
                            <td>
                                <strong>${u.first_name} ${u.last_name}</strong><br>
                                <small style="color: #888;">${u.email}</small>
                            </td>
                            <td>${u.job_name}</td>
                            <td>
                                <c:forEach var="d" items="${departments}">
                                    <c:if test="${d.id == u.departement_id}">${d.departement_name}</c:if>
                                </c:forEach>
                            </td>
                            <td>${u.role.displayName}</td>
                            <td>
                                <span class="status-badge ${u.active ? 'status-active' : 'status-inactive'}">
                                    ${u.active ? 'Actif' : 'Inactif'}
                                </span>
                            </td>
                            <td class="actions-cell">
                                <button class="btn-icon btn-edit" onclick="openModal('edit', {
                                    id: '${u.id}',
                                    firstName: '${u.first_name}',
                                    lastName: '${u.last_name}',
                                    age: '${u.age}',
                                    gender: '${u.gender}',
                                    role: '${u.role}',
                                    jobName: '${u.job_name}',
                                    deptId: '${u.departement_id}',
                                    email: '${u.email}',
                                    username: '${u.username}',
                                    active: '${u.active}',
                                    projects: '${u.projects}'
                                })">✎</button>
                                <button class="btn-icon btn-delete" onclick="openDeleteModal('${u.id}')">🗑</button>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>

    <div id="employeeModal" class="modal-overlay">
        <div class="modal-content">
            <div class="modal-header">
                <h3 class="modal-title" id="modalTitle">Ajouter un employé</h3>
                <button type="button" class="close-modal" onclick="closeModal('employeeModal')">&times;</button>
            </div>
            <form id="employeeForm" method="post">
                <input type="hidden" id="userId" name="id">

                <div class="form-grid">
                    <div class="form-group">
                        <label class="form-label">Prénom</label>
                        <input type="text" class="form-control" name="firstName" id="firstName" required>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Nom</label>
                        <input type="text" class="form-control" name="lastName" id="lastName" required>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Age</label>
                        <input type="number" class="form-control" name="age" id="age" min="18" required>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Genre</label>
                        <select class="form-control" name="gender" id="gender">
                            <option value="M">Homme</option>
                            <option value="F">Femme</option>
                            <option value="X">Autre</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Intitulé du poste</label>
                        <input type="text" class="form-control" name="jobName" id="jobName">
                    </div>
                    <div class="form-group">
                        <label class="form-label">Rôle</label>
                        <select class="form-control" name="role" id="role" required>
                            <c:forEach var="role" items="${roles}">
                                <c:if test="${role != 'ADMINISTRATEUR' || sessionScope.currentUser.role == 'ADMINISTRATEUR'}">
                                    <option value="${role}">${role.displayName}</option>
                                </c:if>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="form-group full-width">
                        <label class="form-label">Département</label>
                        <select class="form-control" name="departement" id="departement" required>
                            <option value="-1">Choisir...</option>
                            <c:forEach var="dept" items="${departments}">
                                <option value="${dept.id}">${dept.departement_name}</option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="form-group full-width">
                        <label class="form-label">Projets</label>
                        <select class="form-control" name="projects" id="projects" multiple size="3">
                            <c:forEach var="proj" items="${projectList}">
                                <option value="${proj.id}">${proj.project_name}</option>
                            </c:forEach>
                        </select>
                        <small style="color: #999; font-size: 11px;">Ctrl+Click pour sélectionner plusieurs</small>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Email</label>
                        <input type="email" class="form-control" name="email" id="email" required>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Username</label>
                        <input type="text" class="form-control" name="username" id="username" required>
                    </div>

                    <div class="form-group">
                        <label class="form-label" id="pwdLabel">Mot de passe</label>
                        <input type="password" class="form-control" name="password" id="password">
                        <small id="pwdHelp" style="display:none; color: #666;">Laisser vide pour ne pas changer</small>
                    </div>
                    <div class="form-group">
                        <label class="form-label" id="confirmPwdLabel">Confirmation</label>
                        <input type="password" class="form-control" name="confirmPassword" id="confirmPassword">
                    </div>

                    <div class="form-group full-width" style="margin-top: 10px;">
                        <input type="checkbox" name="active" id="active">
                        <label for="active" style="font-weight: 600; margin-left: 5px;">Compte Actif</label>
                    </div>
                </div>

                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" onclick="closeModal('employeeModal')">Annuler</button>
                    <button type="submit" class="btn btn-add" id="submitBtn">Enregistrer</button>
                </div>
            </form>
        </div>
    </div>

    <div id="deleteModal" class="modal-overlay">
        <div class="modal-content modal-small">
            <div class="modal-header" style="justify-content: center; border:none;">
                <div style="font-size: 40px; margin-bottom: 10px;">⚠️</div>
            </div>
            <h3 style="margin-bottom: 15px; color: #333;">Confirmer la suppression</h3>
            <p style="color: #666; margin-bottom: 25px;">Êtes-vous sûr de vouloir supprimer cet employé ? Cette action est irréversible.</p>

            <form action="${pageContext.request.contextPath}/users/delete" method="post" style="display: flex; justify-content: center; gap: 15px;">
                <input type="hidden" name="id" id="deleteId">
                <button type="button" class="btn btn-secondary" onclick="closeModal('deleteModal')">Annuler</button>
                <button type="submit" class="btn btn-logout">Confirmer suppression</button>
            </form>
        </div>
    </div>

    <script>
        function closeModal(modalId) {
            document.getElementById(modalId).style.display = 'none';
        }

        function openDeleteModal(id) {
            document.getElementById('deleteId').value = id;
            document.getElementById('deleteModal').style.display = 'flex';
        }

        function openModal(mode, data = null) {
            const modal = document.getElementById('employeeModal');
            const form = document.getElementById('employeeForm');
            const title = document.getElementById('modalTitle');
            const submitBtn = document.getElementById('submitBtn');

            form.reset();

            if (mode === 'add') {
                title.textContent = "Ajouter un nouvel employé";
                submitBtn.textContent = "Créer";
                form.action = "${pageContext.request.contextPath}/users/add";

                document.getElementById('password').required = true;
                document.getElementById('confirmPassword').required = true;
                document.getElementById('pwdHelp').style.display = 'none';
                document.getElementById('userId').value = "";
                document.getElementById('active').checked = true;

            } else if (mode === 'edit') {
                title.textContent = "Modifier l'employé";
                submitBtn.textContent = "Mettre à jour";
                form.action = "${pageContext.request.contextPath}/users/edit";

                document.getElementById('userId').value = data.id;
                document.getElementById('firstName').value = data.firstName;
                document.getElementById('lastName').value = data.lastName;
                document.getElementById('age').value = data.age;
                document.getElementById('gender').value = data.gender;
                document.getElementById('jobName').value = data.jobName;
                document.getElementById('email').value = data.email;
                document.getElementById('username').value = data.username;

                document.getElementById('role').value = data.role;
                document.getElementById('departement').value = data.deptId;

                document.getElementById('active').checked = data.active === 'true';

                const projectSelect = document.getElementById('projects');
                const userProjects = data.projects ? data.projects.split(',').map(s => s.trim()) : [];

                for (let i = 0; i < projectSelect.options.length; i++) {
                    if (userProjects.includes(projectSelect.options[i].value)) {
                        projectSelect.options[i].selected = true;
                    }
                }

                document.getElementById('password').required = false;
                document.getElementById('confirmPassword').required = false;
                document.getElementById('pwdHelp').style.display = 'block';
            }

            modal.style.display = 'flex';
        }

        window.onclick = function (event) {
            if (event.target.classList.contains('modal-overlay')) {
                event.target.style.display = 'none';
            }
        }
    </script>
</body>

</html>