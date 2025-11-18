package com.main.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * Classe utilitaire pour la gestion de la connexion à la base de données
 */
public class DatabaseConnection {

    // ⚠️ IMPORTANT : Remplacez ces valeurs par vos paramètres MySQL réels
    private static final String URL = "jdbc:mysql://localhost:3306/gestion_rh?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true";
    private static final String USER = "root";
    private static final String PASSWORD = "";  // ← METTEZ VOTRE MOT DE PASSE MYSQL ICI (vide si pas de password)

    static {
        try {
            // Chargement du driver MySQL
            Class.forName("com.mysql.cj.jdbc.Driver");
            System.out.println("✓ Driver MySQL chargé avec succès");
        } catch (ClassNotFoundException e) {
            System.err.println("✗ Driver MySQL introuvable!");
            throw new RuntimeException("Driver MySQL introuvable", e);
        }
    }

    /**
     * Obtient une connexion à la base de données
     */
    public static Connection getConnection() throws SQLException {
        try {
            Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
            System.out.println("✓ Connexion à la base de données établie");
            return conn;
        } catch (SQLException e) {
            System.err.println("✗ Erreur de connexion à la base de données:");
            System.err.println("  URL: " + URL);
            System.err.println("  USER: " + USER);
            System.err.println("  Message: " + e.getMessage());
            throw e;
        }
    }

    /**
     * Ferme une connexion de manière sécurisée
     */
    public static void closeConnection(Connection conn) {
        if (conn != null) {
            try {
                conn.close();
                System.out.println("✓ Connexion fermée");
            } catch (SQLException e) {
                System.err.println("✗ Erreur lors de la fermeture de la connexion");
                e.printStackTrace();
            }
        }
    }

    /**
     * Test de la connexion - pour debug
     */
    public static void testConnection() {
        System.out.println("=== TEST DE CONNEXION ===");
        System.out.println("URL: " + URL);
        System.out.println("USER: " + USER);
        System.out.println("PASSWORD: " + (PASSWORD.isEmpty() ? "(vide)" : "(défini)"));

        try (Connection conn = getConnection()) {
            System.out.println("✓ Test de connexion réussi!");
            System.out.println("Database: " + conn.getCatalog());
        } catch (SQLException e) {
            System.err.println("✗ Test de connexion échoué!");
            e.printStackTrace();
        }
        System.out.println("========================");
    }
}