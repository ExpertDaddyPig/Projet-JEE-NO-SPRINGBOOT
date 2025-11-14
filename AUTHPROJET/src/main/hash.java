package com.example.util;

import org.mindrot.jbcrypt.BCrypt;
import java.util.Scanner;

/**
 * Utilitaire pour générer des hash BCrypt
 * Exécutez cette classe pour générer des hash de mots de passe
 */
public class HashGenerator {

    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);

        System.out.println("=".repeat(80));
        System.out.println("GÉNÉRATEUR DE HASH BCRYPT");
        System.out.println("=".repeat(80));
        System.out.println();

        while (true) {
            System.out.print("Entrez un mot de passe (ou 'quit' pour quitter): ");
            String password = scanner.nextLine();

            if (password.equalsIgnoreCase("quit")) {
                break;
            }

            if (password.isEmpty()) {
                continue;
            }

            String hash = BCrypt.hashpw(password, BCrypt.gensalt(12));

            System.out.println();
            System.out.println("Mot de passe: " + password);
            System.out.println("Hash BCrypt:  " + hash);
            System.out.println("Longueur:     " + hash.length() + " caractères");

            // Vérification immédiate
            boolean matches = BCrypt.checkpw(password, hash);
            System.out.println("Vérification: " + (matches ? "✓ OK" : "✗ ERREUR"));

            // Générer la requête SQL
            System.out.println();
            System.out.println("Requête SQL pour mettre à jour:");
            System.out.println("UPDATE users SET password = '" + hash + "' WHERE username = 'admin';");
            System.out.println("-".repeat(80));
            System.out.println();
        }

        // Générer tous les hash par défaut
        System.out.println("\n" + "=".repeat(80));
        System.out.println("HASH PAR DÉFAUT POUR LE PROJET");
        System.out.println("=".repeat(80));
        System.out.println();

        String[][] defaultPasswords = {
                {"admin", "admin123"},
                {"chef_dept", "dept123"},
                {"chef_proj", "proj123"},
                {"employe1", "emp123"}
        };

        for (String[] user : defaultPasswords) {
            String username = user[0];
            String pwd = user[1];
            String hash = BCrypt.hashpw(pwd, BCrypt.gensalt(12));

            System.out.println("-- " + username + " (password: " + pwd + ")");
            System.out.println("UPDATE users SET password = '" + hash + "' WHERE username = '" + username + "';");
            System.out.println();
        }

        scanner.close();
    }
}