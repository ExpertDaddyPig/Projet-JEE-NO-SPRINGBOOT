<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Fiche de Paie - ${employee.first_name} ${employee.last_name}</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/styles.css">
    <script>
        const monthNames = [
            '', 'Janvier', 'Février', 'Mars', 'Avril', 'Mai', 'Juin',
            'Juillet', 'Août', 'Septembre', 'Octobre', 'Novembre', 'Décembre'
        ];

        function printPayslip() {
            window.print();
        }
    </script>
</head>
<body>
    <button class="print-button no-print" onclick="printPayslip()">🖨️ Imprimer</button>

    <div class="payslip-container">
        <div class="header">
            <h1>FICHE DE PAIE</h1>
            <div class="company-info">
                <p><strong>Votre Entreprise</strong></p>
                <p>Adresse de l'entreprise</p>
                <p>Code Postal, Ville</p>
            </div>
        </div>

        <div class="info-section">
            <div class="info-box">
                <h3>👤 Informations Employé</h3>
                <div class="info-line">
                    <span class="label">Nom complet:</span>
                    <span class="value">${employee.first_name} ${employee.last_name}</span>
                </div>
                <div class="info-line">
                    <span class="label">Matricule:</span>
                    <span class="value">${employee.registration_number}</span>
                </div>
                <div class="info-line">
                    <span class="label">Poste:</span>
                    <span class="value">${employee.job_name}</span>
                </div>
                <div class="info-line">
                    <span class="label">Email:</span>
                    <span class="value">${employee.email}</span>
                </div>
            </div>

            <div class="info-box">
                <h3>📅 Période</h3>
                <div class="info-line">
                    <span class="label">Mois:</span>
                    <span class="value">
                        <script>
                            document.write(monthNames[${payslip.month}] || 'Mois ${payslip.month}');
                        </script>
                        <noscript>Mois ${payslip.month}</noscript>
                    </span>
                </div>
                <div class="info-line">
                    <span class="label">ID Fiche:</span>
                    <span class="value">#${payslip.id}</span>
                </div>
                <div class="info-line">
                    <span class="label">Date d'émission:</span>
                    <span class="value">
                        <script>
                            document.write(new Date().toLocaleDateString('fr-FR'));
                        </script>
                    </span>
                </div>
            </div>
        </div>

        <table class="calculation-table">
            <thead>
                <tr>
                    <th>Description</th>
                    <th style="text-align: right;">Montant (€)</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td>Salaire de base</td>
                    <td style="text-align: right;">${payslip.salary}.00 €</td>
                </tr>
                <tr>
                    <td>Primes et bonus</td>
                    <td style="text-align: right; color: #28a745;">+ ${payslip.primes}.00 €</td>
                </tr>
                <tr>
                    <td>Déductions et retenues</td>
                    <td style="text-align: right; color: #dc3545;">- ${payslip.deductions}.00 €</td>
                </tr>
                <tr class="total-row">
                    <td><strong>NET À PAYER</strong></td>
                    <td style="text-align: right;">
                        <strong>${payslip.salary + payslip.primes - payslip.deductions}.00 €</strong>
                    </td>
                </tr>
            </tbody>
        </table>

        <div style="background: #fff3cd; padding: 15px; border-radius: 5px; border-left: 4px solid #ffc107; margin-top: 30px;">
            <p style="margin: 0; color: #856404; font-size: 14px;">
                <strong>Note:</strong> Ce document est un bulletin de paie officiel.
                Conservez-le précieusement pour vos archives personnelles.
            </p>
        </div>

        <div class="footer">
            <p>Document généré le <script>document.write(new Date().toLocaleDateString('fr-FR'));</script></p>
            <p>© 2025 - Système de Gestion RH</p>
        </div>
    </div>
</body>
</html>