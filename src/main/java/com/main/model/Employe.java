package com.main.model;

import jakarta.persistence.*;
import java.util.Date;

@Entity
@Table(name = "Employees")
public class Employe {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private int id;

    @Column(name = "departement_id")
    private Integer departement_id;

    @Column(name = "first_name", length = 50)
    private String first_name;

    @Column(name = "last_name", length = 50)
    private String last_name;

    @Column(name = "gender", length = 50)
    private String gender;

    @Column(name = "registration_number", length = 10)
    private String registration_number;

    @Column(name = "projects", length = 1000)
    private String projects;

    @Column(name = "job_name", length = 100)
    private String job_name;

    @Column(name = "employe_rank")
    private int employe_rank; // 1=Employé, 2=Chef projet, 3=Chef département, 4=Admin

    // Pas besoin de @Transient Role role ici, on le calcule dynamiquement

    @Column(name = "age")
    private Integer age;

    @Column(name = "email", length = 100, nullable = false, unique = true)
    private String email;

    @Column(name = "username", length = 50, nullable = false, unique = true)
    private String username;

    @Column(name = "password_hash", length = 255, nullable = false)
    private String password_hash;

    @Column(name = "createdAt")
    @Temporal(TemporalType.DATE)
    private Date createdAt;

    @Column(name = "lastLogin")
    @Temporal(TemporalType.DATE)
    private Date lastLogin;

    @Column(name = "isActive")
    private Boolean isActive;

    // Constructeurs
    public Employe() {
        this.isActive = true;
        this.createdAt = new Date();
    }

    public Employe(String first_name, String last_name, String email, String username, String password_hash, int employe_rank) {
        this();
        this.first_name = first_name;
        this.last_name = last_name;
        this.email = email;
        this.username = username;
        this.password_hash = password_hash;
        this.employe_rank = employe_rank;
    }

    // Getters et Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public Integer getDepartement_id() {
        return departement_id;
    }

    public void setDepartement_id(Integer departement_id) {
        this.departement_id = departement_id;
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

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public String getRegistration_number() {
        return registration_number;
    }

    public void setRegistration_number(String registration_number) {
        this.registration_number = registration_number;
    }

    public String getProjects() {
        return projects;
    }

    public void setProjects(String projects) {
        this.projects = projects;
    }

    public String getJob_name() {
        return job_name;
    }

    public void setJob_name(String job_name) {
        this.job_name = job_name;
    }

    public int getEmploye_rank() {
        return employe_rank;
    }

    public void setEmploye_rank(int employe_rank) {
        this.employe_rank = employe_rank;
    }

    public Integer getAge() {
        return age;
    }

    public void setAge(Integer age) {
        this.age = age;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
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

    public void setPassword_hash(String password_hash) {
        this.password_hash = password_hash;
    }

    // Alias pour compatibilité avec UserManagementServlet
    public String getPassword() {
        return this.password_hash;
    }

    public void setPassword(String password) {
        this.password_hash = password;
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

    public Boolean getIsActive() {
        return isActive;
    }

    public void setIsActive(Boolean isActive) {
        this.isActive = isActive;
    }

    // Alias pour compatibilité
    public Boolean isActive() {
        return this.isActive != null ? this.isActive : false;
    }

    public void setActive(Boolean active) {
        this.isActive = active;
    }

    // Méthodes pour la gestion des rôles (compatibilité avec Role enum)
    public Role getRole() {
        // Convertit employe_rank en Role enum
        return Role.fromLevel(this.employe_rank);
    }

    public void setRole(Role role) {
        if (role != null) {
            this.employe_rank = role.getLevel();
        }
    }

    // Méthodes utilitaires
    public boolean isAdmin() {
        return this.employe_rank == 4;
    }

    public boolean isChefDepartement() {
        return this.employe_rank == 3;
    }

    public boolean isChefProjet() {
        return this.employe_rank == 2;
    }

    public String getRoleName() {
        return getRole().getDisplayName();
    }

    public String getRoleCode() {
        return getRole().name();
    }

    /**
     * Vérifie si l'utilisateur a un niveau de rôle supérieur ou égal
     */
    public boolean hasRankGreaterOrEqual(int rank) {
        return this.employe_rank >= rank;
    }

    /**
     * Vérifie si l'utilisateur a les permissions pour gérer un autre utilisateur
     */
    public boolean canManage(Employe other) {
        return this.getRole().hasLevelGreaterOrEqual(other.getRole());
    }

    /**
     * Retourne le nom complet de l'employé
     */
    public String getFullName() {
        return this.first_name + " " + this.last_name;
    }

    /**
     * Vérifie si l'employé est assigné à un projet spécifique
     */
    public boolean isAssignedToProject(int projectId) {
        if (this.projects == null || this.projects.isEmpty() || this.projects.equals("0")) {
            return false;
        }
        String[] projectIds = this.projects.split(",");
        for (String id : projectIds) {
            if (id.trim().equals(String.valueOf(projectId))) {
                return true;
            }
        }
        return false;
    }

    /**
     * Ajoute un projet à la liste des projets de l'employé
     */
    public void addProject(int projectId) {
        if (this.projects == null || this.projects.isEmpty() || this.projects.equals("0")) {
            this.projects = String.valueOf(projectId);
        } else if (!isAssignedToProject(projectId)) {
            this.projects += "," + projectId;
        }
    }

    /**
     * Retire un projet de la liste des projets de l'employé
     */
    public void removeProject(int projectId) {
        if (this.projects == null || this.projects.isEmpty()) {
            return;
        }
        String[] projectIds = this.projects.split(",");
        StringBuilder newProjects = new StringBuilder();
        for (String id : projectIds) {
            if (!id.trim().equals(String.valueOf(projectId))) {
                if (newProjects.length() > 0) {
                    newProjects.append(",");
                }
                newProjects.append(id.trim());
            }
        }
        this.projects = newProjects.length() > 0 ? newProjects.toString() : "0";
    }

    /**
     * Retourne le nombre de projets assignés
     */
    public int getProjectCount() {
        if (this.projects == null || this.projects.isEmpty() || this.projects.equals("0")) {
            return 0;
        }
        return this.projects.split(",").length;
    }

    @Override
    public String toString() {
        return "Employe{" +
                "id=" + id +
                ", first_name='" + first_name + '\'' +
                ", last_name='" + last_name + '\'' +
                ", email='" + email + '\'' +
                ", username='" + username + '\'' +
                ", employe_rank=" + employe_rank +
                ", isActive=" + isActive +
                '}';
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Employe employe = (Employe) o;
        return id == employe.id;
    }

    @Override
    public int hashCode() {
        return Integer.hashCode(id);
    }
}