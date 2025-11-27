<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Créer une Fiche de Paie</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/styles.css">
    <style>
        /* Styles spécifiques pour le calcul en temps réel */
        .calculation-preview {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 5px;
            margin: 20px 0;
        }

        .calculation-line {
            display: flex;
            justify-content: space-between;
            padding: 8px 0;
            border-bottom: 1px solid #dee2e6;
        }

        .calculation-line:last-child {
            border-bottom: none;
            font-weight: bold;
            font-size: 18px;
            color: #28a745;
            padding-top: 15px;
        }
    </style>
    <script>
        function calculateNet() {
            const salary = parseFloat(document.getElementById('salary').value) || 0;
            const primes = parseFloat(document.getElementById('primes').value) || 0;
            const deductions = parseFloat(document.getElementById('deductions').value) || 0;

            const net = salary + primes - deductions;

            document.getElementById('preview-salary').textContent = salary.toFixed(2) + ' €';
            document.getElementById('preview-primes').textContent = primes.toFixed(2) + ' €';
            document.getElementById('preview-deductions').textContent = deductions.toFixed(2) + ' €';
            document.getElementById('preview-net').textContent = net.toFixed(2) + ' €';
        }

        window.onload = function() {
            document.getElementById('salary').addEventListener('input', calculateNet);
            document.getElementById('primes').addEventListener('input', calculateNet);
            document.getElementById('deductions').addEventListener('input', calculateNet);
            calculateNet();
        };
    </script>
</head>
<body class="form-page">
    <div class="form-container">
        <div class="form-header">
            <h1>📄 Créer une Fiche de Paie</h1>
            <p>Remplissez les informations ci-dessous</p>
        </div>

        <c:if test="${not empty errorMessage}">
            <div class="alert alert-error">
                ${errorMessage}
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/payslips/create" method="post">
            <div class="form-group">
                <label for="employe_id">Employé *</label>
                <select id="employe_id" name="employe_id" required>
                    <option value="">-- Sélectionnez un employé --</option>
                    <c:forEach var="emp" items="${employees}">
                        <option value="${emp.id}">
                            ${emp.first_name} ${emp.last_name} (ID: ${emp.id})
                        </option>
                    </c:forEach>
                </select>
            </div>

            <div class="form-group">
                <label for="month">Mois *</label>
                <select id="month" name="month" required>
                    <option value="">-- Sélectionnez un mois --</option>
                    <option value="1">Janvier</option>
                    <option value="2">Février</option>
                    <option value="3">Mars</option>
                    <option value="4">Avril</option>
                    <option value="5">Mai</option>
                    <option value="6">Juin</option>
                    <option value="7">Juillet</option>
                    <option value="8">Août</option>
                    <option value="9">Septembre</option>
                    <option value="10">Octobre</option>
                    <option value="11">Novembre</option>
                    <option value="12">Décembre</option>
                </select>
            </div>

            <div class="form-group">
                <label for="salary">Salaire de base (€) *</label>
                <input type="number" id="salary" name="salary" min="0" step="0.01" required value="0">
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label for="primes">Primes (€)</label>
                    <input type="number" id="primes" name="primes" min="0" step="0.01" value="0">
                </div>

                <div class="form-group">
                    <label for="deductions">Déductions (€)</label>
                    <input type="number" id="deductions" name="deductions" min="0" step="0.01" value="0">
                </div>
            </div>

            <div class="calculation-preview">
                <h3 style="margin-bottom: 15px; color: #333;">💰 Calcul du net à payer</h3>
                <div class="calculation-line">
                    <span>Salaire de base:</span>
                    <span id="preview-salary">0.00 €</span>
                </div>
                <div class="calculation-line">
                    <span>+ Primes:</span>
                    <span id="preview-primes" style="color: #28a745;">0.00 €</span>
                </div>
                <div class="calculation-line">
                    <span>- Déductions:</span>
                    <span id="preview-deductions" style="color: #dc3545;">0.00 €</span>
                </div>
                <div class="calculation-line">
                    <span>= Net à payer:</span>
                    <span id="preview-net">0.00 €</span>
                </div>
            </div>

            <div class="form-actions">
                <button type="submit" class="btn btn-primary">✓ Créer la fiche de paie</button>
                <a href="${pageContext.request.contextPath}/payslips" class="btn btn-secondary">✗ Annuler</a>
            </div>
        </form>
    </div>
</body>
</html>