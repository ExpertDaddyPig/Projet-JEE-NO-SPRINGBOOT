package com.main.model;

import java.text.*;
import java.time.LocalDate;
import java.util.*;

import jakarta.persistence.*;

@Entity
@Table(name = "employees")
public class Employe {

    private String candidateChars = "1234567890";

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private int id;

    @Column(name = "first_name", length = 50, nullable = false)
    private String first_name;

    @Column(name = "last_name", length = 50, nullable = false)
    private String last_name;

    @Column(name = "gender", length = 50, nullable = false)
    private String gender;

    @Column(name = "registration_number", length = 10, nullable = false)
    private String registration_number;

    @Column(name = "departement_id", nullable = true)
    private int departement_id;

    @Column(name = "projects", length = 200, nullable = true)
    private String projects;

    @Column(name = "job_name", length = 100, nullable = true)
    private String job_name;

    @Column(name = "employe_rank", nullable = false)
    private int employe_rank;

    @Column(name = "age", nullable = false)
    private int age;

    @Column(name = "username", length = 50, nullable = false)
    private String username;

    @Column(name = "password_hash", length = 255, nullable = false)
    private String password_hash;

    @Column(name = "email", length = 50, nullable = false)
    private String email;

    @Column(name = "active", nullable = false)
    private boolean active;

    @Column(name = "createdAt")
    private LocalDate createdAt;

    @Column(name = "lastLogin")
    private LocalDate lastLogin;

    private Role role;

    public Employe() {
    }

    // Creation of one employe with no additionnal information
    public Employe(String first_name, String last_name, String gender, int employe_rank, int age) {
        this.first_name = first_name;
        this.last_name = last_name;
        this.gender = gender;
        this.age = age;
        this.employe_rank = employe_rank;
        this.registration_number = generateRegistrationNumber();
    }

    public Employe(String first_name, String last_name, String gender, String job_name, int departement_id,
            int employe_rank, int age) {
        this(first_name, last_name, gender, employe_rank, age);
        this.job_name = job_name;
        this.departement_id = departement_id;
    }

    public Employe(String first_name, String last_name, String gender, String job_name, int projects_id[],
            int departement_id, int employe_rank, int age) {
        this(first_name, last_name, gender, employe_rank, age);
        this.job_name = job_name;
        this.departement_id = departement_id;
        this.employe_rank = employe_rank;
        StringBuilder projectsIdStrings = new StringBuilder();
        for (int project_id : projects_id) {
            projectsIdStrings.append(project_id);
            projectsIdStrings.append("|");
        }
        this.projects = projectsIdStrings.toString();
    }

    private String generateRegistrationNumber() {
        StringBuilder generated = new StringBuilder();
        Random random = new Random();
        for (int i = 0; i < 10; i++) {
            generated.append(candidateChars.charAt(random.nextInt(candidateChars.length())));
        }
        return generated.toString();
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword_hash() {
        return password_hash;
    }

    public void setPassword_hash(String password) {
        this.password_hash = password;
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

    public int getEmployeeId() {
        return id;
    }

    public void setEmployeeId(int id) {
        this.id = id;
    }

    public boolean isActive() {
        return active;
    }

    public void setActive(boolean active) {
        this.active = active;
    }

    public LocalDate getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDate createdAt) {
        this.createdAt = createdAt;
    }

    public LocalDate getLastLogin() {
        return lastLogin;
    }

    public void setLastLogin(LocalDate lastLogin) {
        this.lastLogin = lastLogin;
    }

    public boolean hasRole(Role requiredRole) {
        return this.role != null && this.role.equals(requiredRole);
    }

    public boolean hasAnyRole(Role... roles) {
        if (this.role == null)
            return false;
        for (Role r : roles) {
            if (this.role.equals(r))
                return true;
        }
        return false;
    }

    public String getProjects() {
        return projects;
    }

    public void setProjects(Project[] projects) {
        StringBuilder projectList = new StringBuilder();
        for (Project project : projects) {
            projectList.append(project.getId() + ',');
        }
    }

    @Override
    public String toString() {
        return "Employe{" +
                "id=" + id +
                ", username='" + username + '\'' +
                ", email='" + email + '\'' +
                ", role=" + role +
                ", active=" + active +
                ", active=" + active +
                ", active=" + active +
                ", active=" + active +
                ", active=" + active +
                ", active=" + active +
                ", active=" + active +
                ", active=" + active +
                ", active=" + active +
                ", active=" + active +
                ", active=" + active +
                '}';
    }

}