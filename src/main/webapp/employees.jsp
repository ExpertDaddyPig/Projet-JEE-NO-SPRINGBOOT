<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestion des Employés</title>
    <style>
        /* --- STYLE GLOBAL (COPIÉ DU DASHBOARD) --- */
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: #f5f5f5; }
        
        /* Navbar */
        .navbar { background-color: #333; color: white; padding: 15px 30px; display: flex; justify-content: space-between; align-items: center; }
        .navbar-brand { font-size: 24px; font-weight: bold; text-decoration: none; color: white; }
        .navbar-user { display: flex; align-items: center; gap: 20px; }
        .user-info { text-align: right; }
        .user-name { font-weight: 600; display: block;}
        .user-role { font-size: 12px; color: #aaa; }
        .btn-logout { padding: 8px 16px; background-color: #dc3545; color: white; border: none; border-radius: 5px; cursor: pointer; text-decoration: none; font-size: 14px; }

        .container { max-width: 1200px; margin: 30px auto; padding: 0 20px; }

        /* --- TABLEAU ET ACTIONS --- */
        .action-bar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }

        .page-title { font-size: 24px; color: #333; font-weight: 600; }

        .btn-add {
            background-color: #28a745;
            color: white;
            padding: 10px 20px;
            text-decoration: none;
            border-radius: 5px;
            font-weight: 600;
            border: none;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }
        .btn-add:hover { background-color: #218838; }

        .table-card {
            background: white;
            border-radius: 10px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            overflow: hidden; /* Pour les coins arrondis */
        }

        table { width: 100%; border-collapse: collapse; }
        
        th {
            background-color: #f8f9fa;
            color: #333;
            font-weight: 600;
            text-align: left;
            padding: 15px 20px;
            border-bottom: 2px solid #eee;
        }

        td {
            padding: 15px 20px;
            border-bottom: 1px solid #eee;
            color: #555;
            vertical-align: middle;
        }

        tr:last-child td { border-bottom: none; }
        tr:hover { background-color: #fdfdfd; }

        .actions-cell { text-align: right; white-space: nowrap; }

        .btn-icon {
            padding: 6px 10px;
            border-radius: 4px;
            color: white;
            text-decoration: none;
            font-size: 12px;
            margin-left: 5px;
            cursor: pointer;
            border: none;
        }
        .btn-edit { background-color: #ffc107; color: #333; }
        .btn-delete { background-color: #dc3545; }

        /* Status Badge */
        .status-badge {
            padding: 4px 8px;
            border-radius: 12px;
            font-size: 11px;
            font-weight: bold;
        }
        .status-active { background-color: #d4edda; color: #155724; }
        .status-inactive { background-color: #f8d7da; color: #721c24; }

        /* --- MODAL STYLES --- */
        .modal-overlay {
            position: fixed;
            top: 0; left: 0; width: 100%; height: 100%;
            background: rgba(0,0,0,0.5);
            display: none; /* Caché par défaut */
            justify-content: center;
            align-items: center;
            z-index: 1000;
            backdrop-filter: blur(3px);
        }

        .modal-content {
            background: white;
            padding: 30px;
            border-radius: 10px;
            width: 90%;
            max-width: 800px;
            max-height: 90vh;
            overflow-y: auto;
            box-shadow: 0 10px 25px rgba(0,0,0,0.2);
            position: relative;
            animation: slideDown 0.3s ease-out;
        }
        
        .modal-small { max-width: 400px; text-align: center; }

        @keyframes slideDown {
            from { transform: translateY(-20px); opacity: 0; }
            to { transform: translateY(0); opacity: 1; }
        }

        .modal-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; border-bottom: 1px solid #eee; padding-bottom: 15px; }
        .modal-title { font-size: 20px; font-weight: bold; color: #333; }
        .close-modal { background: none; border: none; font-size: 24px; color: #aaa; cursor: pointer; }
        .close-modal:hover { color: #333; }

        /* Form Styles repris de l'ajout */
        .form-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 15px; }
        .full-width { grid-column: span 2; }
        .form-group { margin-bottom: 10px; }
        .form-label { display: block; margin-bottom: 5px; font-weight: 600; font-size: 13px; color: #555; }
        .form-control { width: 100%; padding: 8px 12px; border: 1px solid #ddd; border-radius: 5px; }
        .form-control:focus { border-color: #007bff; outline: none; }
        
        .modal-footer { margin-top: 20px; display: flex; justify-content: flex-end; gap: 10px; padding-top: 15px; border-top: 1px solid #eee; }
    </style>
</head>
<body>

    <!-- Navbar (Identique) -->
    <nav class="navbar">
        <a href="${pageContext.request.contextPath}/" class="navbar-brand">RH System</a>
        <div class="navbar-user">
            <div class="user-info">
                <span class="user-name">${sessionScope.currentUser.first_name} ${sessionScope.currentUser.last_name}</span>
                <span class="user-role">${sessionScope.currentUser.role}</span>
            </div>
            <a href="${pageContext.request.contextPath}/logout" class="btn-logout">Déconnexion</a>
        </div>
    </nav>

    <div class="container">
        
        <!-- En-tête de la page -->
        <div class="action-bar">
            <h1 class="page-title">Liste des Employés</h1>
            <button onclick="openModal('add')" class="btn-add">
                <span>+</span> Nouvel Employé
            </button>
        </div>

        <!-- Messages de succès/erreur -->
        <c:if test="${param.success eq 'add'}">
            <div style="background: #d4edda; color: #155724; padding: 15px; margin-bottom: 20px; border-radius: 5px;">Employé ajouté avec succès.</div>
        </c:if>
        <c:if test="${param.success eq 'update'}">
            <div style="background: #cce5ff; color: #004085; padding: 15px; margin-bottom: 20px; border-radius: 5px;">Employé mis à jour avec succès.</div>
        </c:if>
        <c:if test="${param.success eq 'delete'}">
            <div style="background: #f8d7da; color: #721c24; padding: 15px; margin-bottom: 20px; border-radius: 5px;">Employé supprimé.</div>
        </c:if>

        <!-- Tableau des employés -->
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
                                    <c:if test="${d.id == u.departement_id}">${d.name}</c:if>
                                </c:forEach>
                            </td>
                            <td>${u.role}</td>
                            <td>
                                <span class="status-badge ${u.active ? 'status-active' : 'status-inactive'}">
                                    ${u.active ? 'Actif' : 'Inactif'}
                                </span>
                            </td>
                            <td class="actions-cell">
                                <button class="btn-icon btn-edit"
                                    onclick="openModal('edit', {
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
                                    })">
                                    ✎
                                </button>
                                <button class="btn-icon btn-delete" onclick="openDeleteModal('${u.id}')">
                                    🗑
                                </button>
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
                                <option value="${role}">${role}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="form-group full-width">
                        <label class="form-label">Département</label>
                        <select class="form-control" name="departement" id="departement" required>
                            <option value="-1">Choisir...</option>
                            <c:forEach var="dept" items="${departments}">
                                <option value="${dept.id}">${dept.name}</option>
                            </c:forEach>
                        </select>
                    </div>
                    
                    <!-- Projets (Multiple) -->
                    <div class="form-group full-width">
                        <label class="form-label">Projets</label>
                        <select class="form-control" name="projects" id="projects" multiple size="3">
                            <c:forEach var="proj" items="${projectList}">
                                <option value="${proj.id}">${proj.name}</option>
                            </c:forEach>
                        </select>
                        <small style="color: #999; font-size: 11px;">Ctrl+Click pour sélectionner plusieurs</small>
                    </div>

                    <!-- Connexion -->
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
                    <button type="button" class="btn-logout" style="background:#6c757d;" onclick="closeModal('employeeModal')">Annuler</button>
                    <button type="submit" class="btn-add" id="submitBtn">Enregistrer</button>
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
                <button type="button" class="btn-logout" style="background: #6c757d;" onclick="closeModal('deleteModal')">Annuler</button>
                <button type="submit" class="btn-logout">Confirmer suppression</button>
            </form>
        </div>
    </div>

    <script>
        // Fonction pour fermer une modale
        function closeModal(modalId) {
            document.getElementById(modalId).style.display = 'none';
        }

        // Fonction pour ouvrir la modale de suppression
        function openDeleteModal(id) {
            document.getElementById('deleteId').value = id;
            document.getElementById('deleteModal').style.display = 'flex';
        }

        // Fonction Principale : Ouvrir Modal Ajout ou Edit
        function openModal(mode, data = null) {
            const modal = document.getElementById('employeeModal');
            const form = document.getElementById('employeeForm');
            const title = document.getElementById('modalTitle');
            const submitBtn = document.getElementById('submitBtn');
            
            // Réinitialiser le formulaire
            form.reset();

            if (mode === 'add') {
                title.textContent = "Ajouter un nouvel employé";
                submitBtn.textContent = "Créer";
                // URL du servlet pour l'ajout
                form.action = "${pageContext.request.contextPath}/users/add";
                
                // Mot de passe requis
                document.getElementById('password').required = true;
                document.getElementById('confirmPassword').required = true;
                document.getElementById('pwdHelp').style.display = 'none';
                document.getElementById('userId').value = "";
                document.getElementById('active').checked = true; // Actif par défaut

            } else if (mode === 'edit') {
                title.textContent = "Modifier l'employé";
                submitBtn.textContent = "Mettre à jour";
                // URL du servlet pour l'édition
                form.action = "${pageContext.request.contextPath}/users/edit";
                
                // Remplir les champs avec les données JSON reçues
                document.getElementById('userId').value = data.id;
                document.getElementById('firstName').value = data.firstName;
                document.getElementById('lastName').value = data.lastName;
                document.getElementById('age').value = data.age;
                document.getElementById('gender').value = data.gender;
                document.getElementById('jobName').value = data.jobName;
                document.getElementById('email').value = data.email;
                document.getElementById('username').value = data.username;
                
                // Gestion des Selects simples
                document.getElementById('role').value = data.role;
                document.getElementById('departement').value = data.deptId;
                
                // Gestion de la checkbox
                document.getElementById('active').checked = data.active;

                // Gestion des Projets (Multi-Select)
                // data.projects est une string "P1, P2". On doit sélectionner les options correspondantes.
                const projectSelect = document.getElementById('projects');
                const userProjects = data.projects ? data.projects.split(',').map(s => s.trim()) : [];
                
                for (let i = 0; i < projectSelect.options.length; i++) {
                    if (userProjects.includes(projectSelect.options[i].value)) {
                        projectSelect.options[i].selected = true;
                    }
                }

                // Mot de passe optionnel en edit
                document.getElementById('password').required = false;
                document.getElementById('confirmPassword').required = false;
                document.getElementById('pwdHelp').style.display = 'block';
            }

            modal.style.display = 'flex';
        }

        // Fermer la modale si on clique en dehors du contenu
        window.onclick = function(event) {
            if (event.target.classList.contains('modal-overlay')) {
                event.target.style.display = 'none';
            }
        }
    </script>
</body>
</html>