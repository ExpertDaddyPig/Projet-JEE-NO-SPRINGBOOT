<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Création de Compte - Gestion RH</title>
    <style>
        /* CSS is copied exactly from login.jsp to maintain consistent styling */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }

        /* Increased max-height for registration form to accommodate more fields */
        .login-container {
            background: white;
            padding: 40px;
            border-radius: 10px;
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.2);
            width: 100%;
            max-width: 450px; /* Slightly wider container for more fields */
        }

        .login-header {
            text-align: center;
            margin-bottom: 30px;
        }

        .login-header h1 {
            color: #333;
            font-size: 28px;
            margin-bottom: 10px;
        }

        .login-header p {
            color: #666;
            font-size: 14px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            margin-bottom: 5px;
            color: #333;
            font-weight: 500;
        }

        .form-group input[type="text"],
        .form-group input[type="password"],
        .form-group input[type="email"],
        .form-group input[type="number"],
        .form-group select { /* Added select for styling */
            width: 100%;
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 14px;
            transition: border-color 0.3s;
        }

        .form-group input:focus,
        .form-group select:focus {
            outline: none;
            border-color: #667eea;
        }
        
        /* Flex container for side-by-side fields (First Name/Last Name) */
        .form-row {
            display: flex;
            gap: 20px;
        }
        
        .form-row > .form-group {
            flex: 1;
        }

        .btn-register {
            width: 100%;
            padding: 12px;
            background: linear-gradient(135deg, #764ba2 0%, #667eea 100%); /* Color gradient swapped slightly */
            color: white;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: transform 0.2s;
        }

        .btn-register:hover {
            transform: translateY(-2px);
        }

        .alert {
            padding: 12px;
            border-radius: 5px;
            margin-bottom: 20px;
            font-size: 14px;
        }

        .alert-error {
            background-color: #fee;
            color: #c33;
            border: 1px solid #fcc;
        }

        .alert-success {
            background-color: #efe;
            color: #3c3;
            border: 1px solid #cfc;
        }

        .login-footer {
            text-align: center;
            margin-top: 20px;
            font-size: 12px;
            color: #999;
        }
        
        .link-login {
            display: block;
            text-align: center;
            margin-top: 15px;
            font-size: 14px;
            color: #667eea;
            text-decoration: none;
        }

        .link-login:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <div class="login-container">
        <div class="login-header">
            <h1>Créer un Compte Employé</h1>
            <p>Renseignez vos informations pour vous inscrire</p>
        </div>

        <%-- Display any error or success messages from the controller --%>
        <c:if test="${not empty errorMessage}">
            <div class="alert alert-error">
                ${errorMessage}
            </div>
        </c:if>

        <c:if test="${not empty successMessage}">
            <div class="alert alert-success">
                ${successMessage}
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/createAccount" method="post">
            
            <div class="form-row">
                <div class="form-group">
                    <label for="firstName">Prénom</label>
                    <input type="text"
                           id="firstName"
                           name="firstName"
                           value="${employee.firstName}"
                           required
                           placeholder="Entrez votre prénom">
                </div>

                <div class="form-group">
                    <label for="lastName">Nom</label>
                    <input type="text"
                           id="lastName"
                           name="lastName"
                           value="${employee.lastName}"
                           required
                           placeholder="Entrez votre nom">
                </div>
            </div>

            <div class="form-group">
                <label for="email">Adresse Email</label>
                <input type="email"
                       id="email"
                       name="email"
                       value="${employee.email}"
                       required
                       placeholder="exemple@entreprise.com">
            </div>
            
            <div class="form-row">
                <div class="form-group">
                    <label for="departmentId">ID Département</label>
                    <%-- Note: In a real app, this should be a dynamic list of departments --%>
                    <select id="departmentId" name="departement_id" required>
                        <option value="">Sélectionnez un département</option>
                        <option value="1" <c:if test="${employee.departementId == 1}">selected</c:if>>Ressources Humaines</option>
                        <option value="2" <c:if test="${employee.departementId == 2}">selected</c:if>>Développement</option>
                        <option value="3" <c:if test="${employee.departementId == 3}">selected</c:if>>Marketing</option>
                        <option value="4" <c:if test="${employee.departementId == 4}">selected</c:if>>Comptabilité</option>
                    </select>
                </div>
                
                <div class="form-group">
                    <label for="employeRank">Rang (1-5)</label>
                    <select id="employeRank" name="employe_rank" required>
                        <option value="">Sélectionnez un rang</option>
                        <option value="1" <c:if test="${employee.employeRank == 1}">selected</c:if>>1 (Junior)</option>
                        <option value="2" <c:if test="${employee.employeRank == 2}">selected</c:if>>2</option>
                        <option value="3" <c:if test="${employee.employeRank == 3}">selected</c:if>>3</option>
                        <option value="4" <c:if test="${employee.employeRank == 4}">selected</c:if>>4</option>
                        <option value="5" <c:if test="${employee.employeRank == 5}">selected</c:if>>5 (Senior/Manager)</option>
                    </select>
                </div>
            </div>

            <div class="form-group">
                <label for="username">Nom d'utilisateur</label>
                <input type="text"
                       id="username"
                       name="username"
                       value="${employee.username}"
                       required
                       placeholder="Créez votre nom d'utilisateur">
            </div>

            <div class="form-group">
                <label for="password">Mot de passe</label>
                <input type="password"
                       id="password"
                       name="password"
                       required
                       placeholder="Créez votre mot de passe">
            </div>

            <div class="form-group">
                <label for="confirmPassword">Confirmer Mot de passe</label>
                <input type="password"
                       id="confirmPassword"
                       name="confirmPassword"
                       required
                       placeholder="Confirmez votre mot de passe">
            </div>
            
            <%-- Added a hidden field for registration number, often auto-assigned or system-generated --%>
            <input type="hidden" name="registration_number" value="TEMP_${System.currentTimeMillis()}">

            <button type="submit" class="btn-register">Créer mon Compte</button>
        </form>

        <a href="${pageContext.request.contextPath}/login" class="link-login">
            Vous avez déjà un compte? Se connecter
        </a>

        <div class="login-footer">
            &copy; 2025 Système de Gestion RH. Tous droits réservés.
        </div>
    </div>
</body>
</html>