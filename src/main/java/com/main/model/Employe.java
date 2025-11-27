package com.main.model;

import java.time.LocalDate;
import java.util.*;

import jakarta.persistence.*;

@Entity
@Table(name = "employees")
public class Employe {

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
    private Integer departement_id;

    @Column(name = "projects", length = 200, nullable = true)
    private String projects;

    @Column(name = "job_name", length = 100, nullable = true)
    private String job_name;

    @Column(name = "employe_rank", nullable = false)
    private Integer employe_rank;

    @Column(name = "age", nullable = false)
    private int age;

    @Column(name = "username", length = 50, nullable = false)
    private String username;

    @Column(name = "password_hash", length = 255, nullable = false)
    private String password_hash;

    @Column(name = "email", length = 50, nullable = false)
    private String email;

    @Column(name = "isActive", nullable = false)
    private boolean isActive;

    @Column(name = "createdAt")
    private LocalDate createdAt;

    @Column(name = "lastLogin")
    private LocalDate lastLogin;

    private Role role;

    public Employe() {
        this.isActive = true;
        this.createdAt = LocalDate.now();
    }

    public Employe(String first_name, String last_name, String email, String gender, int employe_rank, int age) {
        this.first_name = first_name;
        this.last_name = last_name;
        this.email = email;
        this.gender = gender;
        this.age = age;
        this.employe_rank = employe_rank;
        this.registration_number = generateRegistrationNumber();
    }

    public Employe(String first_name, String last_name, String email, String gender, String job_name, int departement_id,
                   int employe_rank, int age) {
        this(first_name, last_name, email, gender, employe_rank, age);
        this.job_name = job_name;
        this.departement_id = departement_id;
    }

    public Employe(String first_name, String last_name, String email, String gender, String job_name, int projects_id[],
                   int departement_id, int employe_rank, int age) {
        this(first_name, last_name, email, gender, employe_rank, age);
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
        String candidateChars = "1234567890";
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

    public String getFirst_name() {
        return first_name;
    }

    public void setFirst_name(String first_name) {
        this.first_name = first_name;
    }

    public String getLast_name() {
        return last_name;
    }

    public void setLast_name(String last_name) {
        this.last_name = last_name;
    }

    public int getAge() {
        return age;
    }

    public void setAge(int age) {
        this.age = age;
    }

    public Integer getEmploye_rank() {
        return employe_rank;
    }

    public void setEmploye_rank(Integer employe_rank) {
        this.employe_rank = employe_rank;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public String getJob_name() {
        return job_name;
    }

    public void setJob_name(String job_name) {
        this.job_name = job_name;
    }

    public String getRegistration_number() {
        return registration_number;
    }

    public void setRegistration_number(String registration_number) {
        this.registration_number = registration_number;
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
        if (role == null) {
            switch (employe_rank) {
                case 2:
                    setRole(Role.CHEF_PROJET);
                    break;
                case 3:
                    setRole(Role.CHEF_DEPARTEMENT);
                    break;
                case 4:
                    setRole(Role.ADMINISTRATEUR);
                    break;
                default:
                    setRole(Role.EMPLOYE);
                    break;
            }
        }
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
        return isActive;
    }

    public void setActive(boolean active) {
        this.isActive = active;
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

    public void setDepartement_id(int departement_id) {
        this.departement_id = departement_id;
    }

    public Integer getDepartement_id() {
        return departement_id;
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
                ", registration_number='" + registration_number + '\'' +
                ", first_name='" + first_name + '\'' +
                ", last_name='" + last_name + '\'' +
                ", email='" + email + '\'' +
                ", username='" + username + '\'' +
                ", job_name='" + job_name + '\'' +
                ", departement_id=" + departement_id +
                ", gender='" + gender + '\'' +
                ", age=" + age +
                ", employe_rank=" + employe_rank +
                ", role=" + getRole() +
                ", active=" + isActive +
                ", createdAt=" + createdAt +
                ", lastLogin=" + lastLogin +
                ", projects='" + projects + '\'' +
                '}';
    }

}