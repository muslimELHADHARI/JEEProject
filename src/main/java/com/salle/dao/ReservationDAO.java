package com.salle.dao;

import com.salle.model.Reservation;
import com.salle.util.JPAUtil;
import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

public class ReservationDAO {
    
    public List<Reservation> findAll() {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            TypedQuery<Reservation> query = em.createNamedQuery("Reservation.findAll", Reservation.class);
            return query.getResultList();
        } finally {
            em.close();
        }
    }
    
    public Optional<Reservation> findById(Long id) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            Reservation reservation = em.find(Reservation.class, id);
            return Optional.ofNullable(reservation);
        } finally {
            em.close();
        }
    }
    
    public List<Reservation> findByUser(Long userId) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            TypedQuery<Reservation> query = em.createNamedQuery("Reservation.findByUser", Reservation.class);
            query.setParameter("userId", userId);
            return query.getResultList();
        } finally {
            em.close();
        }
    }
    
    public List<Reservation> findBySalle(Long salleId) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            TypedQuery<Reservation> query = em.createNamedQuery("Reservation.findBySalle", Reservation.class);
            query.setParameter("salleId", salleId);
            return query.getResultList();
        } finally {
            em.close();
        }
    }
    
    public List<Reservation> findFuture() {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            TypedQuery<Reservation> query = em.createNamedQuery("Reservation.findFuture", Reservation.class);
            query.setParameter("now", LocalDateTime.now());
            return query.getResultList();
        } finally {
            em.close();
        }
    }
    
    public List<Reservation> findOverlapping(Long salleId, LocalDateTime dateDebut, LocalDateTime dateFin, Long excludeId) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            TypedQuery<Reservation> query = em.createNamedQuery("Reservation.findOverlapping", Reservation.class);
            query.setParameter("salleId", salleId);
            query.setParameter("dateDebut", dateDebut);
            query.setParameter("dateFin", dateFin);
            query.setParameter("excludeId", excludeId != null ? excludeId : -1L);
            return query.getResultList();
        } finally {
            em.close();
        }
    }
    
    public Reservation save(Reservation reservation) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            if (reservation.getId() == null) {
                em.persist(reservation);
            } else {
                reservation = em.merge(reservation);
            }
            em.getTransaction().commit();
            return reservation;
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
            Reservation reservation = em.find(Reservation.class, id);
            if (reservation != null) {
                em.remove(reservation);
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

