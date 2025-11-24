package com.example.model;

import java.io.Serializable;
import java.util.Date;

/**
 * Entité représentant un utilisateur du système
 */
public class User implements Serializable {
    private static final long serialVersionUID = 1L;

    private Long id;
    private String username;
    private String password; // Stocké en hash BCrypt
    private String email;
    private Role role;
    private Long employeeId; // Lien avec l'employé si applicable
    private boolean active;
    private Date createdAt;
    private Date lastLogin;

    // Constructeurs
    public User() {
        this.active = true;
        this.createdAt = new Date();
    }

    public User(String username, String password, String email, Role role) {
        this();
        this.username = username;
        this.password = password;
        this.email = email;
        this.role = role;
    }

    // Getters et Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public Role getRole() {
        return role;
    }

    public void setRole(Role role) {
        this.role = role;
    }

    public Long getEmployeeId() {
        return employeeId;
    }

    public void setEmployeeId(Long employeeId) {
        this.employeeId = employeeId;
    }

    public boolean isActive() {
        return active;
    }

    public void setActive(boolean active) {
        this.active = active;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    public Date getLastLogin() {
        return lastLogin;
    }

    public void setLastLogin(Date lastLogin) {
        this.lastLogin = lastLogin;
    }

    // Méthodes utilitaires
    public boolean hasRole(Role requiredRole) {
        return this.role != null && this.role.equals(requiredRole);
    }

    public boolean hasAnyRole(Role... roles) {
        if (this.role == null) return false;
        for (Role r : roles) {
            if (this.role.equals(r)) return true;
        }
        return false;
    }

    @Override
    public String toString() {
        return "User{" +
                "id=" + id +
                ", username='" + username + '\'' +
                ", email='" + email + '\'' +
                ", role=" + role +
                ", active=" + active +
                '}';
    }
}