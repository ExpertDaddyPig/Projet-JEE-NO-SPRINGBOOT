<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Assigner des Employés - ${project.project_name}</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/styles.css">
    <script>
        function toggleEmployee(checkbox) {
            const card = checkbox.closest('.employee-checkbox');
            if (checkbox.checked) {
                card.classList.add('selected');
            } else {
                card.classList.remove('selected');
            }
            updateSummary();
        }

        function updateSummary() {
            const checked = document.querySelectorAll('input[name="employee_ids"]:checked').length;
            document.getElementById('selection-count').textContent = checked;
        }

        function selectAll() {
            const checkboxes = document.querySelectorAll('input[name="employee_ids"]');
            const allChecked = Array.from(checkboxes).every(cb => cb.checked);

            checkboxes.forEach(cb => {
                cb.checked = !allChecked;
                toggleEmployee(cb);
            });
        }

        window.onload = function() {
            document.querySelectorAll('input[name="employee_ids"]:checked').forEach(cb => {
                cb.closest('.employee-checkbox').classList.add('selected');
            });
            updateSummary();
        };
    </script>
</head>
<body class="form-page">
    <div class="form-container" style="max-width: 800px;">
        <div class="form-header">
            <h1>👥 Assigner des Employés</h1>
            <p>Sélectionnez les employés à assigner au projet</p>
        </div>

        <div class="project-info">
            <h3>📊 Projet: ${project.project_name}</h3>
            <p>ID: #${project.id}</p>
        </div>

        <div class="selection-summary">
            <strong><span id="selection-count">0</span></strong> employé(s) sélectionné(s)
        </div>

        <button type="button" class="select-all-btn" onclick="selectAll()">
            ☑️ Tout sélectionner / Tout désélectionner
        </button>

        <form action="${pageContext.request.contextPath}/projects/assign" method="post">
            <input type="hidden" name="id" value="${project.id}">

            <div class="employees-grid">
                <c:forEach var="emp" items="${allEmployees}">
                    <div class="employee-checkbox">
                        <input type="checkbox"
                               id="emp_${emp.id}"
                               name="employee_ids"
                               value="${emp.id}"
                               onchange="toggleEmployee(this)"
                               <c:if test="${not empty currentEmployees && fn:contains(currentEmployees, emp.id)}">
                                   checked
                               </c:if>>
                        <label for="emp_${emp.id}" class="employee-label">
                            <h4>
                                <span class="checkbox-icon"></span>
                                ${emp.first_name} ${emp.last_name}
                            </h4>
                            <p>💼 ${emp.job_name}</p>
                            <p>📧 ${emp.email}</p>
                            <p>🔢 ${emp.registration_number}</p>
                        </label>
                    </div>
                </c:forEach>
            </div>

            <div class="form-actions">
                <button type="submit" class="btn btn-primary">✓ Enregistrer les assignations</button>
                <a href="${pageContext.request.contextPath}/projects/view?id=${project.id}" class="btn btn-secondary">✗ Annuler</a>
            </div>
        </form>
    </div>
</body>
</html>