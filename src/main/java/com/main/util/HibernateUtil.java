package com.main.util;

import org.hibernate.SessionFactory;

import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;

public class HibernateUtil {
    
    private static final String BDD_UNIT_NAME = "RHDATABASE"; 

    private static final SessionFactory sessionFactory = buildSessionFactory(BDD_UNIT_NAME);
    
    private static SessionFactory buildSessionFactory(String unitName) {
        try {
            EntityManagerFactory emf = Persistence.createEntityManagerFactory(unitName);
            
            return emf.unwrap(SessionFactory.class);

        } catch (Throwable ex) {
            System.err.println("La création de la SessionFactory pour '" + unitName + "' a échoué.");
            ex.printStackTrace(); 
            throw new ExceptionInInitializerError(ex); 
        }
    }

    public static SessionFactory getSessionFactory() {
        return sessionFactory;
    }
    
}
