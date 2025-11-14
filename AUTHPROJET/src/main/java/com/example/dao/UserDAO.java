package com.example.dao;

import com.example.model.Role;
import com.example.model.User;
import com.example.util.DatabaseConnection;
import org.mindrot.jbcrypt.BCrypt;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO pour la gestion des utilisateurs
 */
public class UserDAO {

    /**
     * Crée un nouvel utilisateur avec mot de passe hashé
     */
    public boolean createUser(User user) throws SQLException {
        String sql = "INSERT INTO users (username, password, email, role, employee_id, active, created_at) " +
                "VALUES (?, ?, ?, ?, ?, ?, NOW())";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setString(1, user.getUsername());
            stmt.setString(2, hashPassword(user.getPassword()));
            stmt.setString(3, user.getEmail());
            stmt.setString(4, user.getRole().name());

            if (user.getEmployeeId() != null) {
                stmt.setLong(5, user.getEmployeeId());
            } else {
                stmt.setNull(5, Types.BIGINT);
            }

            stmt.setBoolean(6, user.isActive());

            int affectedRows = stmt.executeUpdate();

            if (affectedRows > 0) {
                try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        user.setId(generatedKeys.getLong(1));
                    }
                }
                return true;
            }
            return false;
        }
    }

    /**
     * Authentifie un utilisateur
     */
    public User authenticate(String username, String password) throws SQLException {
        String sql = "SELECT * FROM users WHERE username = ? AND active = true";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, username);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                String hashedPassword = rs.getString("password");

                // Vérification du mot de passe
                if (BCrypt.checkpw(password, hashedPassword)) {
                    User user = extractUserFromResultSet(rs);
                    updateLastLogin(user.getId());
                    return user;
                }
            }
        }
        return null;
    }

    /**
     * Récupère un utilisateur par son ID
     */
    public User getUserById(Long id) throws SQLException {
        String sql = "SELECT * FROM users WHERE id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setLong(1, id);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return extractUserFromResultSet(rs);
            }
        }
        return null;
    }

    /**
     * Récupère un utilisateur par son nom d'utilisateur
     */
    public User getUserByUsername(String username) throws SQLException {
        String sql = "SELECT * FROM users WHERE username = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, username);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return extractUserFromResultSet(rs);
            }
        }
        return null;
    }

    /**
     * Récupère tous les utilisateurs
     */
    public List<User> getAllUsers() throws SQLException {
        List<User> users = new ArrayList<>();
        String sql = "SELECT * FROM users ORDER BY username";

        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                users.add(extractUserFromResultSet(rs));
            }
        }
        return users;
    }

    /**
     * Récupère les utilisateurs par rôle
     */
    public List<User> getUsersByRole(Role role) throws SQLException {
        List<User> users = new ArrayList<>();
        String sql = "SELECT * FROM users WHERE role = ? ORDER BY username";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, role.name());
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                users.add(extractUserFromResultSet(rs));
            }
        }
        return users;
    }

    /**
     * Met à jour un utilisateur
     */
    public boolean updateUser(User user) throws SQLException {
        String sql = "UPDATE users SET username = ?, email = ?, role = ?, " +
                "employee_id = ?, active = ? WHERE id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, user.getUsername());
            stmt.setString(2, user.getEmail());
            stmt.setString(3, user.getRole().name());

            if (user.getEmployeeId() != null) {
                stmt.setLong(4, user.getEmployeeId());
            } else {
                stmt.setNull(4, Types.BIGINT);
            }

            stmt.setBoolean(5, user.isActive());
            stmt.setLong(6, user.getId());

            return stmt.executeUpdate() > 0;
        }
    }

    /**
     * Change le mot de passe d'un utilisateur
     */
    public boolean changePassword(Long userId, String newPassword) throws SQLException {
        String sql = "UPDATE users SET password = ? WHERE id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, hashPassword(newPassword));
            stmt.setLong(2, userId);

            return stmt.executeUpdate() > 0;
        }
    }

    /**
     * Supprime un utilisateur
     */
    public boolean deleteUser(Long id) throws SQLException {
        String sql = "DELETE FROM users WHERE id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setLong(1, id);
            return stmt.executeUpdate() > 0;
        }
    }

    /**
     * Vérifie si un nom d'utilisateur existe déjà
     */
    public boolean usernameExists(String username) throws SQLException {
        String sql = "SELECT COUNT(*) FROM users WHERE username = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, username);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        }
        return false;
    }

    /**
     * Met à jour la date de dernière connexion
     */
    private void updateLastLogin(Long userId) throws SQLException {
        String sql = "UPDATE users SET last_login = NOW() WHERE id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setLong(1, userId);
            stmt.executeUpdate();
        }
    }

    /**
     * Hash un mot de passe avec BCrypt
     */
    private String hashPassword(String plainPassword) {
        return BCrypt.hashpw(plainPassword, BCrypt.gensalt(12));
    }

    /**
     * Extrait un objet User depuis un ResultSet
     */
    private User extractUserFromResultSet(ResultSet rs) throws SQLException {
        User user = new User();
        user.setId(rs.getLong("id"));
        user.setUsername(rs.getString("username"));
        user.setPassword(rs.getString("password"));
        user.setEmail(rs.getString("email"));
        user.setRole(Role.valueOf(rs.getString("role")));

        Long empId = rs.getLong("employee_id");
        if (!rs.wasNull()) {
            user.setEmployeeId(empId);
        }

        user.setActive(rs.getBoolean("active"));
        user.setCreatedAt(rs.getTimestamp("created_at"));

        Timestamp lastLogin = rs.getTimestamp("last_login");
        if (lastLogin != null) {
            user.setLastLogin(lastLogin);
        }

        return user;
    }
}