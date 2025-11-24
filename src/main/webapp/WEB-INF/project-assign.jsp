<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Assigner des Employés - ${project.project_name}</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 40px 20px;
        }

        .form-container {
            max-width: 800px;
            margin: 0 auto;
            background: white;
            padding: 40px;
            border-radius: 10px;
            box-shadow: 0 10px 25px rgba(0,0,0,0.2);
        }

        .form-header {
            margin-bottom: 30px;
        }

        .form-header h1 {
            color: #333;
            font-size: 28px;
            margin-bottom: 10px;
        }

        .form-header p {
            color: #666;
        }

        .project-info {
            background: #e7f3ff;
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 25px;
            border-left: 4px solid #0066cc;
        }

        .project-info h3 {
            color: #004085;
            margin-bottom: 8px;
        }

        .employees-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
            gap: 15px;
            margin-bottom: 30px;
        }

        .employee-checkbox {
            background: #f8f9fa;
            padding: 15px;
            border-radius: 8px;
            border: 2px solid #dee2e6;
            cursor: pointer;
            transition: all 0.3s;
        }

        .employee-checkbox:hover {
            border-color: #667eea;
            background: #f0f4ff;
        }

        .employee-checkbox input[type="checkbox"] {
            display: none;
        }

        .employee-checkbox input[type="checkbox"]:checked + label {
            border-color: #667eea;
        }

        .employee-checkbox.selected {
            border-color: #667eea;
            background: #e7f3ff;
        }

        .employee-label {
            cursor: pointer;
            display: block;
        }

        .employee-label h4 {
            color: #333;
            margin-bottom: 8px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .employee-label p {
            color: #666;
            font-size: 13px;
            margin: 4px 0;
        }

        .checkbox-icon {
            width: 20px;
            height: 20px;
            border: 2px solid #dee2e6;
            border-radius: 4px;
            display: inline-block;
            position: relative;
            transition: all 0.3s;
        }

        .employee-checkbox.selected .checkbox-icon {
            background: #667eea;
            border-color: #667eea;
        }

        .employee-checkbox.selected .checkbox-icon::after {
            content: '✓';
            color: white;
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            font-weight: bold;
        }

        .btn {
            padding: 12px 24px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-weight: 600;
            font-size: 16px;
            transition: all 0.3s;
        }

        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            width: 100%;
        }

        .btn-primary:hover {
            transform: translateY(-2px);
        }

        .btn-secondary {
            background: #6c757d;
            color: white;
            text-decoration: none;
            display: inline-block;
            text-align: center;
        }

        .form-actions {
            display: flex;
            gap: 15px;
            margin-top: 30px;
        }

        .form-actions > * {
            flex: 1;
        }

        .selection-summary {
            background: #fff3cd;
            border: 1px solid #ffc107;
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 20px;
            text-align: center;
        }

        .selection-summary strong {
            color: #856404;
            font-size: 18px;
        }

        .select-all-btn {
            background: #17a2b8;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            margin-bottom: 20px;
            font-weight: 600;
        }

        .select-all-btn:hover {
            background: #138496;
        }
    </style>
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
            // Initialiser les cases déjà cochées
            document.querySelectorAll('input[name="employee_ids"]:checked').forEach(cb => {
                cb.closest('.employee-checkbox').classList.add('selected');
            });
            updateSummary();
        };
    </script>
</head>
<body>
    <div class="form-container">
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