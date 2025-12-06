package com.salle.util;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;

public class JPAUtil {
    
    private static final String PERSISTENCE_UNIT_NAME = "gestion-salles-pu";
    private static EntityManagerFactory emf;
    
    static {
        try {
            emf = Persistence.createEntityManagerFactory(PERSISTENCE_UNIT_NAME);
        } catch (Exception e) {
            throw new RuntimeException("Erreur lors de l'initialisation de l'EntityManagerFactory", e);
        }
    }
    
    public static EntityManager getEntityManager() {
        return emf.createEntityManager();
    }
    
    public static void closeEntityManagerFactory() {
        if (emf != null && emf.isOpen()) {
            emf.close();
        }
    }
}

