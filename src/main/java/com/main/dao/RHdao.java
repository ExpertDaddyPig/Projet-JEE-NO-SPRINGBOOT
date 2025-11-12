package com.main.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.List;

import com.main.model.Departement;
import com.main.model.Employe;
import com.main.model.Payslip;
import com.main.model.Project;

import jakarta.persistence.*;

public class RHdao {

    private static final String URL = "jdbc:mysql://localhost:3306/RHDATABASE";
    private static final String UTILISATEUR = "root";
    private static final String MOT_DE_PASSE = "";
    private final EntityManagerFactory emf;

    public RHdao() {
        this.emf = Persistence.createEntityManagerFactory("RHDATABASE");
    }

    //#region GET DATA
    //#region GET ALL DATA
    public List<Employe> getAllEmployees() {
        EntityManager em = emf.createEntityManager();
        try {
            TypedQuery<Employe> query = em.createQuery("SELECT * FROM Employees", Employe.class);
            return query.getResultList();
        } finally {
            em.close();
        }
    }
    public List<Departement> getAllDepartements() {
        EntityManager em = emf.createEntityManager();
        try {
            TypedQuery<Departement> query = em.createQuery("SELECT * FROM Departements", Departement.class);
            return query.getResultList();
        } finally {
            em.close();
        }
    }
    public List<Project> getAllProjects() {
        EntityManager em = emf.createEntityManager();
        try {
            TypedQuery<Project> query = em.createQuery("SELECT * FROM Projects", Project.class);
            return query.getResultList();
        } finally {
            em.close();
        }
    }
    public List<Payslip> getAllPayslips() {
        EntityManager em = emf.createEntityManager();
        try {
            TypedQuery<Payslip> query = em.createQuery("SELECT * FROM Payslips", Payslip.class);
            return query.getResultList();
        } finally {
            em.close();
        }
    }
    //#endregion

    //#region GET DATA WHERE "query"
    public Employe getEmploye(String queryString) {
        EntityManager em = emf.createEntityManager();
        try {
            TypedQuery<Employe> query = em.createQuery("SELECT * FROM Employees WHERE " + queryString, Employe.class);
            return query.getSingleResultOrNull();
        } finally {
            em.close();
        }
    }
    public Departement getDepartement(String queryString) {
        EntityManager em = emf.createEntityManager();
        try {
            TypedQuery<Departement> query = em.createQuery("SELECT * FROM Departements WHERE " + queryString, Departement.class);
            return query.getSingleResultOrNull();
        } finally {
            em.close();
        }
    }
    public Project getProject(String queryString) {
        EntityManager em = emf.createEntityManager();
        try {
            TypedQuery<Project> query = em.createQuery("SELECT * FROM Projects WHERE " + queryString, Project.class);
            return query.getSingleResultOrNull();
        } finally {
            em.close();
        }
    }
    public Payslip getPayslip(String queryString) {
        EntityManager em = emf.createEntityManager();
        try {
            TypedQuery<Payslip> query = em.createQuery("SELECT * FROM Payslips WHERE " + queryString, Payslip.class);
            return query.getSingleResultOrNull();
        } finally {
            em.close();
        }
    }
    //#endregion

    //#region GET ALL DATA WHERE "query"
    public List<Employe> getEmployees(String queryString) {
        EntityManager em = emf.createEntityManager();
        try {
            TypedQuery<Employe> query = em.createQuery("SELECT * FROM Employees WHERE " + queryString, Employe.class);
            return query.getResultList();
        } finally {
            em.close();
        }
    }
    public List<Departement> getDepartements(String queryString) {
        EntityManager em = emf.createEntityManager();
        try {
            TypedQuery<Departement> query = em.createQuery("SELECT * FROM Departements WHERE " + queryString, Departement.class);
            return query.getResultList();
        } finally {
            em.close();
        }
    }
    public List<Project> getProjects(String queryString) {
        EntityManager em = emf.createEntityManager();
        try {
            TypedQuery<Project> query = em.createQuery("SELECT * FROM Projects WHERE " + queryString, Project.class);
            return query.getResultList();
        } finally {
            em.close();
        }
    }
    public List<Payslip> getPayslips(String queryString) {
        EntityManager em = emf.createEntityManager();
        try {
            TypedQuery<Payslip> query = em.createQuery("SELECT * FROM Payslips WHERE " + queryString, Payslip.class);
            return query.getResultList();
        } finally {
            em.close();
        }
    }
    //#endregion
    //#endregion

    //#region UPDATE DATA
    //#region UPDATE ALL DATA WHERE "query"
    public void updateAllEmployees(String query, String changes) {
        try {
            Connection con = DriverManager.getConnection(URL, UTILISATEUR, MOT_DE_PASSE);
            PreparedStatement preparedStatement = con.prepareStatement("UPDATE Employees WHERE " + query + " SET " + changes);
            preparedStatement.executeQuery();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    public void updateAllDepartements(String query, String changes) {
        try {
            Connection con = DriverManager.getConnection(URL, UTILISATEUR, MOT_DE_PASSE);
            PreparedStatement preparedStatement = con.prepareStatement("UPDATE Departements WHERE " + query + " SET " + changes);
            preparedStatement.executeQuery();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    public void updateAllProjects(String query, String changes) {
        try {
            Connection con = DriverManager.getConnection(URL, UTILISATEUR, MOT_DE_PASSE);
            PreparedStatement preparedStatement = con.prepareStatement("UPDATE Projects WHERE " + query + " SET " + changes);
            preparedStatement.executeQuery();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    public void updateAllPayslips(String query, String changes) {
        try {
            Connection con = DriverManager.getConnection(URL, UTILISATEUR, MOT_DE_PASSE);
            PreparedStatement preparedStatement = con.prepareStatement("UPDATE Payslips WHERE " + query + " SET " + changes);
            preparedStatement.executeQuery();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    //#endregion
    
    //#region UPDATE DATA WHERE "query"
    public void updateEmploye(int id, String query, String changes) {
        try {
            Connection con = DriverManager.getConnection(URL, UTILISATEUR, MOT_DE_PASSE);
            PreparedStatement preparedStatement = con.prepareStatement("UPDATE Employees WHERE id = " + id + " AND " + query + " SET " + changes);
            preparedStatement.executeQuery();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    public void updateDepartement(int id, String query, String changes) {
        try {
            Connection con = DriverManager.getConnection(URL, UTILISATEUR, MOT_DE_PASSE);
            PreparedStatement preparedStatement = con.prepareStatement("UPDATE Departements WHERE id = " + id + " AND " + query + " SET " + changes);
            preparedStatement.executeQuery();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    public void updateProject(int id, String query, String changes) {
        try {
            Connection con = DriverManager.getConnection(URL, UTILISATEUR, MOT_DE_PASSE);
            PreparedStatement preparedStatement = con.prepareStatement("UPDATE Projects WHERE id = " + id + " AND " + query + " SET " + changes);
            preparedStatement.executeQuery();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    public void updatePayslip(int id, String query, String changes) {
        try {
            Connection con = DriverManager.getConnection(URL, UTILISATEUR, MOT_DE_PASSE);
            PreparedStatement preparedStatement = con.prepareStatement("UPDATE Payslips WHERE id = " + id + " AND " + query + " SET " + changes);
            preparedStatement.executeQuery();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    //#endregion
    //#endregion

    //#region CREATE DATA
    public void save(Object data) {
        EntityManager em = emf.createEntityManager();
        em.getTransaction().begin();
        try {
            em.persist(data);
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
    //#endregion

    //#region DELETE DATA
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
    //#endregion
}
