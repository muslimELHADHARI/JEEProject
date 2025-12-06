package com.salle.dao;

import com.salle.model.Salle;
import com.salle.util.JPAUtil;
import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;
import java.util.List;
import java.util.Optional;

public class SalleDAO {
    
    public List<Salle> findAll() {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            TypedQuery<Salle> query = em.createNamedQuery("Salle.findAll", Salle.class);
            return query.getResultList();
        } finally {
            em.close();
        }
    }
    
    public Optional<Salle> findById(Long id) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            Salle salle = em.find(Salle.class, id);
            return Optional.ofNullable(salle);
        } finally {
            em.close();
        }
    }
    
    public Optional<Salle> findByNom(String nom) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            TypedQuery<Salle> query = em.createNamedQuery("Salle.findByNom", Salle.class);
            query.setParameter("nom", nom);
            List<Salle> results = query.getResultList();
            return results.isEmpty() ? Optional.empty() : Optional.of(results.get(0));
        } finally {
            em.close();
        }
    }
    
    public List<Salle> findByCapacite(Integer capacite) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            TypedQuery<Salle> query = em.createNamedQuery("Salle.findByCapacite", Salle.class);
            query.setParameter("capacite", capacite);
            return query.getResultList();
        } finally {
            em.close();
        }
    }
    
    public Salle save(Salle salle) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            if (salle.getId() == null) {
                em.persist(salle);
            } else {
                salle = em.merge(salle);
            }
            em.getTransaction().commit();
            return salle;
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw e;
        } finally {
            em.close();
        }
    }
    
    public void delete(Long id) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            Salle salle = em.find(Salle.class, id);
            if (salle != null) {
                em.remove(salle);
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
}

