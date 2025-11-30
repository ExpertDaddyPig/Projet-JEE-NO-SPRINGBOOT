<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Voir Fiche de Paie</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/styles.css">
</head>
<body class="form-page">
    <div class="form-container">
        <div class="form-header">
            <h1>📄 Détails de la Fiche de Paie</h1>
            <p>Informations de la fiche #${payslip.id}</p>
        </div>

        <c:if test="${not empty errorMessage}">
            <div class="alert alert-error">
                ${errorMessage}
            </div>
        </c:if>

        <div class="form-group">
            <label>Employé</label>
            <input type="text" class="form-control" value="${employee.first_name} ${employee.last_name} (ID: ${employee.id})" disabled>
        </div>

        <div class="form-group">
            <label>Mois</label>
            <input type="text" class="form-control" value="Mois ${payslip.month}" disabled>
        </div>

        <div class="form-group">
            <label>Salaire de base (€)</label>
            <input type="text" class="form-control" value="${payslip.salary}" disabled>
        </div>

        <div class="form-row">
            <div class="form-group">
                <label>Primes (€)</label>
                <input type="text" class="form-control" value="${payslip.primes}" disabled>
            </div>

            <div class="form-group">
                <label>Déductions (€)</label>
                <input type="text" class="form-control" value="${payslip.deductions}" disabled>
            </div>
        </div>

        <div class="calculation-preview">
            <h3 style="margin-bottom: 15px; color: #333;">💰 Calcul du net à payer</h3>
            <div class="calculation-line">
                <span>Salaire de base:</span>
                <span>${payslip.salary}.00 €</span>
            </div>
            <div class="calculation-line">
                <span>+ Primes:</span>
                <span style="color: #28a745;">${payslip.primes}.00 €</span>
            </div>
            <div class="calculation-line">
                <span>- Déductions:</span>
                <span style="color: #dc3545;">${payslip.deductions}.00 €</span>
            </div>
            <div class="calculation-line">
                <span>= Net à payer:</span>
                <span>${payslip.salary + payslip.primes - payslip.deductions}.00 €</span>
            </div>
        </div>

        <div class="form-actions">
            <a href="${pageContext.request.contextPath}/payslips/print?id=${payslip.id}"
               class="btn btn-warning" target="_blank">🖨️ Imprimer</a>
            <a href="${pageContext.request.contextPath}/payslips" class="btn btn-secondary">← Retour</a>
        </div>
    </div>
</body>
</html>