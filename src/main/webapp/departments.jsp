<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:if test="${empty sessionScope.currentUser}">
    <c:redirect url="login.jsp" />
</c:if>

<!DOCTYPE html>
<html lang="fr">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestion Départements</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/styles.css">
</head>

<body>
    <nav class="navbar">
        <div class="navbar-brand">Gestion RH - Départements</div>
        <div class="navbar-links">
            <a href="${pageContext.request.contextPath}/dashboard">Tableau de bord</a>
            <a href="${pageContext.request.contextPath}/users">Employés</a>
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
            <h1 class="page-title">Liste des Départements</h1>
            <button onclick="openModal('add')" class="btn btn-add">+ Nouveau Département</button>
        </div>

        <c:if test="${param.success eq 'add'}">
            <div class="alert alert-success">Ajouté avec succès.</div>
        </c:if>
        <c:if test="${param.success eq 'update'}">
            <div class="alert alert-info">Mis à jour avec succès.</div>
        </c:if>
        <c:if test="${param.success eq 'delete'}">
            <div class="alert alert-error">Supprimé avec succès.</div>
        </c:if>

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
                                            <c:if test="${not empty dept.employees}">
                                                <c:set var="count" value="0" />
                                                <c:set var="ids" value="${fn:split(dept.employees, ',')}" />

                                                <div style="font-size: 13px; color: #555;">
                                                    <c:forEach var="id" items="${ids}" varStatus="status">
                                                        <c:forEach var="emp" items="${allEmployees}">
                                                            <c:if test="${String.valueOf(emp.id) == id}">
                                                                ${emp.first_name} ${emp.last_name}
                                                                <c:if test="${!status.last}">, </c:if>
                                                                <c:set var="count" value="${count + 1}" />
                                                            </c:if>
                                                        </c:forEach>
                                                    </c:forEach>
                                                </div>
                                                <span class="badge-count">${dept.employeesCount} membre(s)</span>
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

    <div id="deptModal" class="modal-overlay">
        <div class="modal-content">
            <div class="modal-header">
                <h3 class="modal-title" id="modalTitle">Département</h3>
                <button type="button" class="close-modal" onclick="document.getElementById('deptModal').style.display='none'">&times;</button>
            </div>
            <form id="deptForm" method="post">
                <input type="hidden" id="deptId" name="id">

                <div class="form-group">
                    <label class="form-label">Nom du Département</label>
                    <input type="text" class="form-control" name="name" id="deptName" required>
                </div>

                <div class="form-group">
                    <label class="form-label">Sélectionner les employés</label>
                    <select class="form-control" name="employeeIds" id="deptEmployees" multiple size="6" style="height: auto;">
                        <c:forEach var="emp" items="${allEmployees}">
                            <option value="${emp.id}">${emp.first_name} ${emp.last_name} (${emp.job_name})</option>
                        </c:forEach>
                    </select>
                    <small style="color: #888; font-size: 12px;">Maintenir Ctrl (Windows) ou Cmd (Mac) pour sélectionner plusieurs.</small>
                </div>

                <div class="modal-footer">
                    <button type="button" class="btn-secondary" onclick="document.getElementById('deptModal').style.display='none'">Annuler</button>
                    <button type="submit" class="btn-add" id="submitBtn">Enregistrer</button>
                </div>
            </form>
        </div>
    </div>

    <div id="deleteModal" class="modal-overlay">
        <div class="modal-content modal-small">
            <h3 style="margin-bottom: 15px;">Confirmer la suppression ?</h3>
            <form action="${pageContext.request.contextPath}/departments/delete" method="post" style="display: flex; justify-content: center; gap: 15px;">
                <input type="hidden" name="id" id="deleteId">
                <button type="button" class="btn-secondary" onclick="document.getElementById('deleteModal').style.display='none'">Annuler</button>
                <button type="submit" class="btn-delete">Supprimer</button>
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

            form.reset();

            if (mode === 'add') {
                title.textContent = "Nouveau Département";
                form.action = "${pageContext.request.contextPath}/departments/add";
                document.getElementById('deptId').value = "";
                Array.from(select.options).forEach(opt => opt.selected = false);
            } else if (mode === 'edit') {
                title.textContent = "Modifier le Département";
                form.action = "${pageContext.request.contextPath}/departments/edit";
                document.getElementById('deptId').value = data.id;
                document.getElementById('deptName').value = data.name;

                if (data.employees) {
                    const ids = data.employees.split(',');
                    Array.from(select.options).forEach(option => {
                        option.selected = ids.includes(option.value);
                    });
                }
            }
            modal.style.display = 'flex';
        }

        window.onclick = function (e) {
            if (e.target.classList.contains('modal-overlay')) e.target.style.display = 'none';
        }
    </script>
</body>

</html>