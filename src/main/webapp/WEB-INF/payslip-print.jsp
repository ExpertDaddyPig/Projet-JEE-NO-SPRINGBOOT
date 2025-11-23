<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Fiche de Paie - ${employee.first_name} ${employee.last_name}</title>
    <style>
        @media print {
            .no-print {
                display: none !important;
            }
            body {
                margin: 0;
            }
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: Arial, sans-serif;
            padding: 20px;
            background: #f5f5f5;
        }

        .payslip-container {
            max-width: 800px;
            margin: 0 auto;
            background: white;
            padding: 40px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }

        .header {
            text-align: center;
            padding-bottom: 20px;
            border-bottom: 3px solid #333;
            margin-bottom: 30px;
        }

        .header h1 {
            font-size: 28px;
            color: #333;
            margin-bottom: 10px;
        }

        .header .company-info {
            color: #666;
            font-size: 14px;
        }

        .info-section {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 30px;
            margin-bottom: 30px;
        }

        .info-box {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 5px;
        }

        .info-box h3 {
            font-size: 16px;
            color: #333;
            margin-bottom: 15px;
            border-bottom: 2px solid #dee2e6;
            padding-bottom: 10px;
        }

        .info-line {
            display: flex;
            justify-content: space-between;
            padding: 8px 0;
            font-size: 14px;
        }

        .info-line .label {
            color: #666;
        }

        .info-line .value {
            font-weight: 600;
            color: #333;
        }

        .calculation-table {
            width: 100%;
            border-collapse: collapse;
            margin: 30px 0;
        }

        .calculation-table th {
            background: #333;
            color: white;
            padding: 12px;
            text-align: left;
            font-weight: 600;
        }

        .calculation-table td {
            padding: 12px;
            border-bottom: 1px solid #dee2e6;
        }

        .calculation-table tr:last-child td {
            border-bottom: none;
        }

        .total-row {
            background: #f8f9fa;
            font-weight: bold;
            font-size: 18px;
        }

        .total-row td:last-child {
            color: #28a745;
        }

        .footer {
            margin-top: 50px;
            padding-top: 20px;
            border-top: 1px solid #dee2e6;
            text-align: center;
            color: #666;
            font-size: 12px;
        }

        .print-button {
            position: fixed;
            top: 20px;
            right: 20px;
            padding: 12px 24px;
            background: #667eea;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-weight: 600;
            box-shadow: 0 2px 8px rgba(0,0,0,0.2);
        }

        .print-button:hover {
            background: #5568d3;
        }

        .month-names {
            display: none;
        }
    </style>
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