package com.main.model;

/**
 * Énumération des rôles utilisateurs dans le système
 */
public enum Role {
    ADMINISTRATEUR("Administrateur", 4, "Accès complet au système"),
    CHEF_DEPARTEMENT("Chef de département", 3, "Gestion d'un département"),
    CHEF_PROJET("Chef de projet", 2, "Gestion de projets"),
    EMPLOYE("Employé", 1, "Accès limité aux informations personnelles");

    private final String displayName;
    private final int level; // Niveau hiérarchique
    private final String description;


    Role(String displayName, int level, String description) {
        this.displayName = displayName;
        this.level = level;
        this.description = description;
    }

    public String getDisplayName() {
        return displayName;
    }

    public int getLevel() {
        return level;
    }

    public String getDescription() {
        return description;
    }

    /**
     * Vérifie si ce rôle a un niveau supérieur ou égal au rôle spécifié
     */
    public boolean hasLevelGreaterOrEqual(Role other) {
        return this.level >= other.level;
    }

    /**
     * Convertit une chaîne en Role
     */
    public static Role fromString(String roleStr) {
        if (roleStr == null)
            return null;

        for (Role r : Role.values()) {
            if (r.name().equalsIgnoreCase(roleStr) ||
                    r.displayName.equalsIgnoreCase(roleStr)) {
                return r;
            }
        }
        return null;
    }
}