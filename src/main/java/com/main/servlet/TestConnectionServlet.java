package com.main.servlet;

import com.main.dao.RHDAO;
import com.main.model.Employe;
import com.main.util.DatabaseConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import org.mindrot.jbcrypt.BCrypt;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;

/**
 * Servlet de test pour diagnostiquer les problèmes de connexion
 * ATTENTION : À SUPPRIMER EN PRODUCTION
 */
@WebServlet("/test-connection")
public class TestConnectionServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();

        out.println("<!DOCTYPE html>");
        out.println("<html><head><title>Test de Connexion</title>");
        out.println("<style>");
        out.println("body { font-family: monospace; padding: 20px; background: #f5f5f5; }");
        out.println(".success { color: green; font-weight: bold; }");
        out.println(".error { color: red; font-weight: bold; }");
        out.println(".info { color: blue; }");
        out.println("pre { background: white; padding: 10px; border: 1px solid #ddd; }");
        out.println("</style></head><body>");
        out.println("<h1>Test de Connexion - Diagnostic</h1>");

        // Test 1: Connexion à la base de données
        out.println("<h2>1. Test de connexion à la base de données</h2>");
        try (Connection conn = DatabaseConnection.getConnection()) {
            out.println("<p class='success'>✓ Connexion à la base de données réussie!</p>");
            out.println("<p class='info'>Database: " + conn.getCatalog() + "</p>");
        } catch (Exception e) {
            out.println("<p class='error'>✗ Erreur de connexion à la base de données</p>");
            out.println("<pre>" + e.getMessage() + "</pre>");
            out.println("</body></html>");
            return;
        }

        // Test 2: Vérifier que la table users existe
        out.println("<h2>2. Vérification de la table 'users'</h2>");
        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement()) {

            ResultSet rs = stmt.executeQuery("SHOW TABLES LIKE 'users'");
            if (rs.next()) {
                out.println("<p class='success'>✓ Table 'users' trouvée</p>");
            } else {
                out.println("<p class='error'>✗ Table 'users' n'existe pas!</p>");
                out.println("<p>Exécutez le script SQL create_users_table.sql</p>");
                out.println("</body></html>");
                return;
            }
        } catch (Exception e) {
            out.println("<p class='error'>✗ Erreur lors de la vérification de la table</p>");
            out.println("<pre>" + e.getMessage() + "</pre>");
        }

        // Test 3: Compter les utilisateurs
        out.println("<h2>3. Nombre d'utilisateurs dans la base</h2>");
        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement()) {

            ResultSet rs = stmt.executeQuery("SELECT COUNT(*) as total FROM users");
            if (rs.next()) {
                int total = rs.getInt("total");
                out.println("<p class='info'>Nombre d'utilisateurs: " + total + "</p>");
                if (total == 0) {
                    out.println("<p class='error'>✗ Aucun utilisateur trouvé! Insérez les utilisateurs par défaut.</p>");
                }
            }
        } catch (Exception e) {
            out.println("<p class='error'>✗ Erreur lors du comptage</p>");
            out.println("<pre>" + e.getMessage() + "</pre>");
        }

        // Test 4: Lister tous les utilisateurs
        out.println("<h2>4. Liste des utilisateurs</h2>");
        out.println("<table border='1' cellpadding='5' style='background: white;'>");
        out.println("<tr><th>ID</th><th>Username</th><th>Email</th><th>Role</th><th>Active</th><th>Password (hash)</th></tr>");

        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement()) {

            ResultSet rs = stmt.executeQuery("SELECT id, username, email, role, active, password FROM users");
            while (rs.next()) {
                out.println("<tr>");
                out.println("<td>" + rs.getLong("id") + "</td>");
                out.println("<td>" + rs.getString("username") + "</td>");
                out.println("<td>" + rs.getString("email") + "</td>");
                out.println("<td>" + rs.getString("role") + "</td>");
                out.println("<td>" + (rs.getBoolean("active") ? "✓" : "✗") + "</td>");
                out.println("<td style='font-size: 10px;'>" + rs.getString("password").substring(0, 20) + "...</td>");
                out.println("</tr>");
            }
        } catch (Exception e) {
            out.println("</table>");
            out.println("<p class='error'>✗ Erreur lors de la lecture des utilisateurs</p>");
            out.println("<pre>" + e.getMessage() + "</pre>");
        }
        out.println("</table>");

        // Test 5: Test du hash BCrypt
        out.println("<h2>5. Test du hash BCrypt</h2>");
        String testPassword = "admin123";
        String expectedHash = "$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5GyYVRlJzZXaC";

        try {
            boolean matches = BCrypt.checkpw(testPassword, expectedHash);
            out.println("<p class='info'>Test: '" + testPassword + "' contre le hash par défaut</p>");
            out.println("<p class='" + (matches ? "success'>✓" : "error'>✗") + " Résultat: " + matches + "</p>");

            // Générer un nouveau hash pour comparaison
            String newHash = BCrypt.hashpw(testPassword, BCrypt.gensalt(12));
            out.println("<p class='info'>Nouveau hash généré pour 'admin123':</p>");
            out.println("<pre>" + newHash + "</pre>");

        } catch (Exception e) {
            out.println("<p class='error'>✗ Erreur BCrypt</p>");
            out.println("<pre>" + e.getMessage() + "</pre>");
        }

        // Test 6: Test d'authentification avec UserDAO
        out.println("<h2>6. Test d'authentification UserDAO</h2>");
        try {
            RHDAO RHDAO = new RHDAO();
            Employe employe = RHDAO.authenticate("admin", "admin123");

            if (employe != null) {
                out.println("<p class='success'>✓ Authentification réussie!</p>");
                out.println("<p class='info'>Utilisateur: " + employe.getUsername() + "</p>");
                out.println("<p class='info'>Rôle: " + employe.getRole() + "</p>");
            } else {
                out.println("<p class='error'>✗ Authentification échouée</p>");
                out.println("<p>Le mot de passe ne correspond pas ou l'utilisateur est inactif</p>");
            }
        } catch (Exception e) {
            out.println("<p class='error'>✗ Erreur lors de l'authentification</p>");
            out.println("<pre>" + e.getMessage() + "</pre>");
            e.printStackTrace();
        }

        // Test 7: Vérifier les filtres
        out.println("<h2>7. Configuration des filtres</h2>");
        out.println("<p class='info'>Si vous voyez cette page, les filtres ne bloquent pas /test-connection</p>");
        out.println("<p>Ajoutez /test-connection aux URLs publiques dans AuthenticationFilter si nécessaire</p>");

        out.println("<hr>");
        out.println("<h2>Actions recommandées</h2>");
        out.println("<ul>");
        out.println("<li>Si tous les tests passent mais la connexion échoue, vérifiez les logs Tomcat</li>");
        out.println("<li>Vérifiez que login.jsp est accessible sans authentification</li>");
        out.println("<li>Testez la connexion depuis: <a href='" + request.getContextPath() + "/login'>Page de connexion</a></li>");
        out.println("<li><strong>SUPPRIMEZ CE SERVLET EN PRODUCTION!</strong></li>");
        out.println("</ul>");

        out.println("</body></html>");
    }
}