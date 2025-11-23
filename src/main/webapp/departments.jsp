<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!-- SÉCURITÉ -->
<c:if test="${empty sessionScope.currentUser}">
    <c:redirect url="login.jsp" />
</c:if>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Gestion Départements</title>
    <!-- Mêmes styles que précédemment -->
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Segoe UI', sans-serif; background-color: #f5f5f5; }
        .navbar { background-color: #333; color: white; padding: 15px 30px; display: flex; justify-content: space-between; align-items: center; }
        .navbar-brand { font-size: 24px; font-weight: bold; color: white; text-decoration: none; }
        .navbar-user { display: flex; gap: 20px; align-items: center; }
        .user-info { text-align: right; }
        .user-name { font-weight: 600; display: block; }
        .user-role { font-size: 12px; color: #aaa; }
        .btn-logout { padding: 8px 16px; background-color: #dc3545; color: white; border: none; border-radius: 5px; text-decoration: none; }
        
        .container { max-width: 1200px; margin: 30px auto; padding: 0 20px; }
        .action-bar { display: flex; justify-content: space-between; margin-bottom: 20px; }
        .btn-add { background-color: #28a745; color: white; padding: 10px 20px; border-radius: 5px; text-decoration: none; border: none; cursor: pointer; }
        
        .table-card { background: white; border-radius: 10px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); overflow: hidden; }
        table { width: 100%; border-collapse: collapse; }
        th, td { padding: 15px 20px; text-align: left; border-bottom: 1px solid #eee; }
        th { background-color: #f8f9fa; font-weight: 600; }
        
        .btn-icon { padding: 6px 10px; border-radius: 4px; color: white; border: none; cursor: pointer; margin-left: 5px; }
        .btn-edit { background-color: #ffc107; color: #333; }
        .btn-delete { background-color: #dc3545; }

        /* Modals */
        .modal-overlay { position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.5); display: none; justify-content: center; align-items: center; z-index: 1000; }
        .modal-content { background: white; padding: 30px; border-radius: 10px; width: 90%; max-width: 600px; }
        .form-group { margin-bottom: 15px; }
        .form-label { display: block; margin-bottom: 5px; font-weight: 600; }
        .form-control { width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 5px; }
        .modal-footer { margin-top: 20px; display: flex; justify-content: flex-end; gap: 10px; }
        
        .badge-count { background: #007bff; color: white; padding: 2px 8px; border-radius: 10px; font-size: 12px; }
    </style>
</head>
<body>

<nav class="navbar">
    <a href="${pageContext.request.contextPath}/dashboard" class="navbar-brand">Gestion RH</a>
    <div class="navbar-user">
        <div class="user-info">
            <span class="user-name">${sessionScope.currentUser.username}</span>
            <span class="user-role">${sessionScope.currentUser.role.displayName}</span>
        </div>
        <a href="${pageContext.request.contextPath}/logout" class="btn-logout">Déconnexion</a>
    </div>
</nav>

<div class="container">
    <div class="action-bar">
        <h1>Liste des Départements</h1>
        <button onclick="openModal('add')" class="btn-add">+ Nouveau Département</button>
    </div>

    <c:if test="${param.success eq 'add'}"><div style="color:green; margin-bottom:10px;">Ajouté avec succès.</div></c:if>
    <c:if test="${param.success eq 'update'}"><div style="color:blue; margin-bottom:10px;">Mis à jour avec succès.</div></c:if>
    <c:if test="${param.success eq 'delete'}"><div style="color:red; margin-bottom:10px;">Supprimé avec succès.</div></c:if>

    <div class="table-card">
        <table>
            <thead>
            <tr>
                <th>Nom</th>
                <th>Membres assignés</th>
                <th style="text-align: right;">Actions</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="dept" items="${departments}">
                <tr>
                    <td><strong>${dept.departement_name}</strong></td>
                    <td>
                        <!-- Logique pour afficher les noms à partir des IDs stockés en String -->
                        <c:if test="${not empty dept.employees}">
                            <c:set var="count" value="0" />
                            <c:set var="ids" value="${fn:split(dept.employees, ',')}" />
                            
                            <div style="font-size: 13px; color: #555;">
                                <c:forEach var="id" items="${ids}" varStatus="status">
                                    <!-- On cherche l'employé correspondant dans la liste complète -->
                                    <c:forEach var="emp" items="${allEmployees}">
                                        <!-- Attention : comparaison String vs Int ou String vs String -->
                                        <c:if test="${String.valueOf(emp.id) == id}">
                                            ${emp.first_name} ${emp.last_name}
                                            <c:if test="${!status.last}">, </c:if>
                                            <c:set var="count" value="${count + 1}" />
                                        </c:if>
                                    </c:forEach>
                                </c:forEach>
                            </div>
                            <span class="badge-count">${count} membre(s)</span>
                        </c:if>
                        <c:if test="${empty dept.employees}">
                            <span style="color:#999; font-style:italic;">Aucun membre</span>
                        </c:if>
                    </td>
                    <td style="text-align: right;">
                        <button class="btn-icon btn-edit" onclick="openModal('edit', {
                                id: '${dept.id}',
                                name: '${dept.departement_name}',
                                employees: '${dept.employees}' 
                                })">✎</button>
                        <button class="btn-icon btn-delete" onclick="openDeleteModal('${dept.id}')">🗑</button>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>
</div>

<!-- MODAL ADD/EDIT -->
<div id="deptModal" class="modal-overlay">
    <div class="modal-content">
        <h3 id="modalTitle" style="margin-bottom: 20px;">Département</h3>
        <form id="deptForm" method="post">
            <input type="hidden" id="deptId" name="id">
            
            <div class="form-group">
                <label class="form-label">Nom du Département</label>
                <input type="text" class="form-control" name="name" id="deptName" required>
            </div>

            <div class="form-group">
                <label class="form-label">Sélectionner les employés</label>
                <!-- SELECT MULTIPLE -->
                <select class="form-control" name="employeeIds" id="deptEmployees" multiple size="6" style="height: auto;">
                    <c:forEach var="emp" items="${allEmployees}">
                        <option value="${emp.id}">${emp.first_name} ${emp.last_name} (${emp.job_name})</option>
                    </c:forEach>
                </select>
                <small style="color: #888; font-size: 12px;">Maintenir Ctrl (Windows) ou Cmd (Mac) pour sélectionner plusieurs.</small>
            </div>

            <div class="modal-footer">
                <button type="button" class="btn-logout" style="background:#6c757d;" onclick="document.getElementById('deptModal').style.display='none'">Annuler</button>
                <button type="submit" class="btn-add" id="submitBtn">Enregistrer</button>
            </div>
        </form>
    </div>
</div>

<!-- MODAL DELETE -->
<div id="deleteModal" class="modal-overlay">
    <div class="modal-content" style="max-width: 400px; text-align: center;">
        <h3 style="margin-bottom: 15px;">Confirmer la suppression ?</h3>
        <form action="${pageContext.request.contextPath}/departments/delete" method="post" style="display: flex; justify-content: center; gap: 15px;">
            <input type="hidden" name="id" id="deleteId">
            <button type="button" class="btn-logout" style="background: #6c757d;" onclick="document.getElementById('deleteModal').style.display='none'">Annuler</button>
            <button type="submit" class="btn-delete" style="padding: 8px 16px; border-radius: 5px;">Supprimer</button>
        </form>
    </div>
</div>

<script>
    function openDeleteModal(id) {
        document.getElementById('deleteId').value = id;
        document.getElementById('deleteModal').style.display = 'flex';
    }

    function openModal(mode, data = null) {
        const modal = document.getElementById('deptModal');
        const form = document.getElementById('deptForm');
        const title = document.getElementById('modalTitle');
        const select = document.getElementById('deptEmployees');

        form.reset(); // Reset inputs

        if (mode === 'add') {
            title.textContent = "Nouveau Département";
            form.action = "${pageContext.request.contextPath}/departments/add";
            document.getElementById('deptId').value = "";
            
            // Désélectionner tout
            Array.from(select.options).forEach(opt => opt.selected = false);

        } else if (mode === 'edit') {
            title.textContent = "Modifier le Département";
            form.action = "${pageContext.request.contextPath}/departments/edit";
            document.getElementById('deptId').value = data.id;
            document.getElementById('deptName').value = data.name;

            // Gestion de la présélection dans le multiselect
            // data.employees est une string "1,5,9"
            if (data.employees) {
                const ids = data.employees.split(','); // Tableau ["1", "5", "9"]
                Array.from(select.options).forEach(option => {
                    // Si la valeur de l'option est dans le tableau ids, on sélectionne
                    if (ids.includes(option.value)) {
                        option.selected = true;
                    } else {
                        option.selected = false;
                    }
                });
            }
        }
        modal.style.display = 'flex';
    }

    // Fermeture au clic dehors
    window.onclick = function(e) {
        if (e.target.classList.contains('modal-overlay')) e.target.style.display = 'none';
    }
</script>
</body>
</html>