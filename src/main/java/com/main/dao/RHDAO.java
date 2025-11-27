package com.main.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

import org.mindrot.jbcrypt.BCrypt;

import com.main.model.Departement;
import com.main.model.Employe;
import com.main.model.Payslip;
import com.main.model.Project;
import com.main.util.DatabaseConnection;

import jakarta.persistence.*;

public class RHDAO {

    private static final String URL = "jdbc:mysql://localhost:3306/RHDATABASE";
    private static final String UTILISATEUR = "root";
    private static final String MOT_DE_PASSE = "";
    private final EntityManagerFactory emf;

    public RHDAO() {
        this.emf = Persistence.createEntityManagerFactory("RHDATABASE");
    }

    // #region GET DATA
    // #region GET ALL DATA
    public List<Employe> getAllEmployees() {
        try (EntityManager em = emf.createEntityManager()) {
            @SuppressWarnings("unchecked")
            TypedQuery<Employe> query = (TypedQuery<Employe>) em.createNativeQuery("SELECT * FROM Employees", Employe.class);
            return query.getResultList();
        }
    }

    public List<Departement> getAllDepartements() {
        try (EntityManager em = emf.createEntityManager()) {
            @SuppressWarnings("unchecked")
            TypedQuery<Departement> query = (TypedQuery<Departement>) em.createNativeQuery("SELECT * FROM Departements", Departement.class);
            List<Departement> departements = query.getResultList();
            for (Departement departement: departements) {
                departement.setEmployeesCount();
            }
            return departements;
        }
    }

    public List<Project> getAllProjects() {
        try (EntityManager em = emf.createEntityManager()) {
            @SuppressWarnings("unchecked")
            TypedQuery<Project> query = (TypedQuery<Project>) em.createNativeQuery("SELECT * FROM Projects", Project.class);
            return query.getResultList();
        }
    }

    public List<Payslip> getAllPayslips() {
        try (EntityManager em = emf.createEntityManager()) {
            @SuppressWarnings("unchecked")
            TypedQuery<Payslip> query = (TypedQuery<Payslip>) em.createNativeQuery("SELECT * FROM Payslips", Payslip.class);
            return query.getResultList();
        }
    }
    // #endregion

    // #region GET DATA WHERE "query"
    public Employe getEmploye(String queryString) {
        try (EntityManager em = emf.createEntityManager()) {
            @SuppressWarnings("unchecked")
            TypedQuery<Employe> query = (TypedQuery<Employe>) em.createNativeQuery("SELECT * FROM Employees WHERE " + queryString, Employe.class);
            return query.getSingleResultOrNull();
        }
    }

    public Departement getDepartement(String queryString) {
        try (EntityManager em = emf.createEntityManager()) {
            @SuppressWarnings("unchecked")
            TypedQuery<Departement> query = (TypedQuery<Departement>) em.createNativeQuery("SELECT * FROM Departements WHERE " + queryString,
                    Departement.class);
            return query.getSingleResultOrNull();
        }
    }

    public Project getProject(String queryString) {
        try (EntityManager em = emf.createEntityManager()) {
            @SuppressWarnings("unchecked")
            TypedQuery<Project> query = (TypedQuery<Project>) em.createNativeQuery("SELECT * FROM Projects WHERE " + queryString, Project.class);
            return query.getSingleResultOrNull();
        }
    }

    public Payslip getPayslip(String queryString) {
        try (EntityManager em = emf.createEntityManager()) {
            @SuppressWarnings("unchecked")
            TypedQuery<Payslip> query = (TypedQuery<Payslip>) em.createNativeQuery("SELECT * FROM Payslips WHERE " + queryString, Payslip.class);
            return query.getSingleResultOrNull();
        }
    }
    // #endregion

    // #region GET ALL DATA WHERE "query"
    public List<Employe> getEmployees(String queryString) {
        try (EntityManager em = emf.createEntityManager()) {
            @SuppressWarnings("unchecked")
            TypedQuery<Employe> query = (TypedQuery<Employe>) em.createNativeQuery("SELECT * FROM Employees WHERE " + queryString, Employe.class);
            return query.getResultList();
        }
    }

    public List<Departement> getDepartements(String queryString) {
        try (EntityManager em = emf.createEntityManager()) {
            @SuppressWarnings("unchecked")
            TypedQuery<Departement> query = (TypedQuery<Departement>) em.createNativeQuery("SELECT * FROM Departements WHERE " + queryString,
                    Departement.class);
            return query.getResultList();
        }
    }

    public List<Project> getProjects(String queryString) {
        try (EntityManager em = emf.createEntityManager()) {
            @SuppressWarnings("unchecked")
            TypedQuery<Project> query = (TypedQuery<Project>) em.createNativeQuery("SELECT * FROM Projects WHERE " + queryString, Project.class);
            return query.getResultList();
        }
    }

    public List<Payslip> getPayslips(String queryString) {
        try (EntityManager em = emf.createEntityManager()) {
            @SuppressWarnings("unchecked")
            TypedQuery<Payslip> query = (TypedQuery<Payslip>) em.createNativeQuery("SELECT * FROM Payslips WHERE " + queryString, Payslip.class);
            return query.getResultList();
        }
    }
    // #endregion
    // #endregion

    // #region UPDATE DATA
    // #region UPDATE ALL DATA WHERE "query"
    public void updateAllEmployees(String query, String changes) {
        try {
            Connection con = DriverManager.getConnection(URL, UTILISATEUR, MOT_DE_PASSE);
            PreparedStatement preparedStatement = con
                    .prepareStatement("UPDATE Employees WHERE " + query + " SET " + changes);
            preparedStatement.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void updateAllDepartements(String query, String changes) {
        try {
            Connection con = DriverManager.getConnection(URL, UTILISATEUR, MOT_DE_PASSE);
            PreparedStatement preparedStatement = con
                    .prepareStatement("UPDATE Departements WHERE " + query + " SET " + changes);
            preparedStatement.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void updateAllProjects(String query, String changes) {
        try {
            Connection con = DriverManager.getConnection(URL, UTILISATEUR, MOT_DE_PASSE);
            PreparedStatement preparedStatement = con
                    .prepareStatement("UPDATE Projects WHERE " + query + " SET " + changes);
            preparedStatement.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void updateAllPayslips(String query, String changes) {
        try {
            Connection con = DriverManager.getConnection(URL, UTILISATEUR, MOT_DE_PASSE);
            PreparedStatement preparedStatement = con
                    .prepareStatement("UPDATE Payslips WHERE " + query + " SET " + changes);
            preparedStatement.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    // #endregion

    // #region UPDATE DATA WHERE "query"
    public void updateEmploye(int id, String query, String changes) {
        try {
            Connection con = DriverManager.getConnection(URL, UTILISATEUR, MOT_DE_PASSE);
            PreparedStatement preparedStatement = con
                    .prepareStatement("UPDATE Employees SET " + changes + " WHERE id = " + id + " AND " + query);
            preparedStatement.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void updateDepartement(int id, String query, String changes) {
        try {
            Connection con = DriverManager.getConnection(URL, UTILISATEUR, MOT_DE_PASSE);
            PreparedStatement preparedStatement = con
                    .prepareStatement("UPDATE Departements SET " + changes + " WHERE id = " + id + " AND " + query);
            preparedStatement.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void updateProject(int id, String query, String changes) {
        try {
            Connection con = DriverManager.getConnection(URL, UTILISATEUR, MOT_DE_PASSE);
            PreparedStatement preparedStatement = con
                    .prepareStatement("UPDATE Projects SET " + changes + " WHERE id = " + id + " AND " + query);
            preparedStatement.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void updatePayslip(int id, String query, String changes) {
        try {
            Connection con = DriverManager.getConnection(URL, UTILISATEUR, MOT_DE_PASSE);
            PreparedStatement preparedStatement = con
                    .prepareStatement("UPDATE Payslips SET " + changes + " WHERE id = " + id + " AND " + query);
            preparedStatement.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    // #endregion

    // #region UPDATE BY ID DATA WHERE "query"
    public boolean updateEmployeById(int id, String changes) {
        try {
            Connection con = DriverManager.getConnection(URL, UTILISATEUR, MOT_DE_PASSE);
            PreparedStatement preparedStatement = con
                    .prepareStatement("UPDATE Employees SET " + changes + " WHERE id = " + id);
            preparedStatement.executeUpdate();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateDepartementById(int id, String changes) {
        try {
            Connection con = DriverManager.getConnection(URL, UTILISATEUR, MOT_DE_PASSE);
            PreparedStatement preparedStatement = con
                    .prepareStatement("UPDATE Departements SET " + changes + " WHERE id = " + id);
            preparedStatement.executeUpdate();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateProjectById(int id, String changes) {
        try {
            Connection con = DriverManager.getConnection(URL, UTILISATEUR, MOT_DE_PASSE);
            PreparedStatement preparedStatement = con
                    .prepareStatement("UPDATE Projects SET " + changes + " WHERE id = " + id);
            preparedStatement.executeUpdate();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updatePayslipById(int id, String changes) {
        try {
            Connection con = DriverManager.getConnection(URL, UTILISATEUR, MOT_DE_PASSE);
            PreparedStatement preparedStatement = con
                    .prepareStatement("UPDATE Payslips SET " + changes + " WHERE id = " + id);
            preparedStatement.executeUpdate();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    // #endregion

    // #endregion

    // #region CREATE DATA
    public boolean save(Object data) {
        Boolean result;
        EntityManager em = emf.createEntityManager();
        em.getTransaction().begin();
        try {
            em.persist(data);
            em.getTransaction().commit();
            result = true;
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            result = false;
            throw e;
        } finally {
            em.close();
        }
        return result;
    }
    // #endregion

    // #region DELETE DATA
    public void deleteEmploye(int id) {
        EntityManager em = emf.createEntityManager();
        em.getTransaction().begin();
        try {
            Employe employe = em.find(Employe.class, id);
            if (employe != null) {
                em.remove(employe);
            }
            em.getTransaction().commit();
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw e;
        } finally {
            em.close();
        }
    }

    public void deleteDepartement(int id) {
        EntityManager em = emf.createEntityManager();
        em.getTransaction().begin();
        try {
            Departement departement = em.find(Departement.class, id);
            if (departement != null) {
                em.remove(departement);
            }
            em.getTransaction().commit();
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw e;
        } finally {
            em.close();
        }
    }

    public void deleteProject(int id) {
        EntityManager em = emf.createEntityManager();
        em.getTransaction().begin();
        try {
            Project project = em.find(Project.class, id);
            if (project != null) {
                em.remove(project);
            }
            em.getTransaction().commit();
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw e;
        } finally {
            em.close();
        }
    }

    public void deletePayslip(int id) {
        EntityManager em = emf.createEntityManager();
        em.getTransaction().begin();
        try {
            Payslip payslip = em.find(Payslip.class, id);
            if (payslip != null) {
                em.remove(payslip);
            }
            em.getTransaction().commit();
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw e;
        } finally {
            em.close();
        }
    }
    // #endregion

    // #region AUTH
    public String hashPassword(String plainPassword) {
        return BCrypt.hashpw(plainPassword, BCrypt.gensalt(12));
    }

    public Employe authenticate(String username, String password) throws SQLException {
        Employe user = getEmploye("username = \"" + username + "\"");
        if (user == null) return null;
        String hashedPassword = user.getPassword_hash();

        // Vérification du mot de passe
        if (BCrypt.checkpw(password, hashedPassword)) {
            updateEmployeById(user.getId(), "lastLogin = CURRENT_TIMESTAMP()");
            return user;
        }
        return null;
    }
    // #endregion

    // #region OTHER
    public boolean usernameExists(String username) throws SQLException {
        String sql = "SELECT COUNT(*) FROM Employees WHERE username = ?";

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

    // #endregion
}
