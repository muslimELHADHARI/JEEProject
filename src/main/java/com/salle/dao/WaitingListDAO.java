package com.salle.dao;

import com.salle.model.WaitingList;
import com.salle.util.JPAUtil;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import jakarta.persistence.NoResultException;
import jakarta.persistence.TypedQuery;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

public class WaitingListDAO {

    public void addEntry(WaitingList waitingList) {
        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            em.persist(waitingList);
            tx.commit();
            System.out.println("DEBUG: Persisted WaitingList entry " + waitingList.getId() + " for user "
                    + waitingList.getUser().getEmail());
        } catch (Exception e) {
            if (tx.isActive()) {
                tx.rollback();
            }
            throw e;
        } finally {
            em.close();
        }
    }

    public void removeEntry(Long id) {
        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            WaitingList waitingList = em.find(WaitingList.class, id);
            if (waitingList != null) {
                em.remove(waitingList);
            }
            tx.commit();
        } catch (Exception e) {
            if (tx.isActive()) {
                tx.rollback();
            }
            throw e;
        } finally {
            em.close();
        }
    }

    public List<WaitingList> getAllWaitingListEntriesForSalle(Long salleId) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            TypedQuery<WaitingList> query = em.createQuery(
                    "SELECT wl FROM WaitingList wl JOIN FETCH wl.user JOIN FETCH wl.salle WHERE wl.salle.id = :salleId ORDER BY wl.requestTime ASC",
                    WaitingList.class);
            query.setParameter("salleId", salleId);
            return query.getResultList();
        } finally {
            em.close();
        }
    }

    public Optional<WaitingList> getNextWaitingEntryForSalle(Long salleId, LocalDateTime dateDebut,
            LocalDateTime dateFin) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            TypedQuery<WaitingList> query = em.createQuery(
                    "SELECT wl FROM WaitingList wl JOIN FETCH wl.user JOIN FETCH wl.salle WHERE wl.salle.id = :salleId "
                            +
                            "AND wl.requestedDateDebut >= :dateDebut AND wl.requestedDateFin <= :dateFin " +
                            "ORDER BY wl.requestTime ASC",
                    WaitingList.class);
            query.setParameter("salleId", salleId);
            query.setParameter("dateDebut", dateDebut);
            query.setParameter("dateFin", dateFin);
            query.setMaxResults(1);
            return Optional.ofNullable(query.getSingleResult());
        } catch (NoResultException e) {
            return Optional.empty();
        } finally {
            em.close();
        }
    }

    public List<WaitingList> getWaitingListForUser(Long userId) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            TypedQuery<WaitingList> query = em.createQuery(
                    "SELECT wl FROM WaitingList wl JOIN FETCH wl.user JOIN FETCH wl.salle WHERE wl.user.id = :userId ORDER BY wl.requestTime ASC",
                    WaitingList.class);
            query.setParameter("userId", userId);
            return query.getResultList();
        } finally {
            em.close();
        }
    }

    public List<WaitingList> getAllWaitingListEntries() {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            TypedQuery<WaitingList> query = em.createQuery(
                    "SELECT wl FROM WaitingList wl JOIN FETCH wl.user JOIN FETCH wl.salle ORDER BY wl.requestTime ASC",
                    WaitingList.class);
            return query.getResultList();
        } finally {
            em.close();
        }
    }

    public Optional<WaitingList> getWaitingEntryById(Long id) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            // Changed from em.find to TypedQuery to allow for JOIN FETCH
            TypedQuery<WaitingList> query = em.createQuery(
                    "SELECT wl FROM WaitingList wl JOIN FETCH wl.user JOIN FETCH wl.salle WHERE wl.id = :id",
                    WaitingList.class);
            query.setParameter("id", id);
            return Optional.ofNullable(query.getSingleResult());
        } catch (NoResultException e) {
            return Optional.empty();
        } finally {
            em.close();
        }
    }

    public List<WaitingList> getWaitingListEntriesBySalleAndTime(Long salleId, LocalDateTime dateDebut,
            LocalDateTime dateFin) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            TypedQuery<WaitingList> query = em.createQuery(
                    "SELECT wl FROM WaitingList wl JOIN FETCH wl.user JOIN FETCH wl.salle WHERE wl.salle.id = :salleId "
                            +
                            "AND wl.requestedDateDebut >= :dateDebut AND wl.requestedDateFin <= :dateFin " +
                            "ORDER BY wl.requestTime ASC",
                    WaitingList.class);
            query.setParameter("salleId", salleId);
            query.setParameter("dateDebut", dateDebut);
            query.setParameter("dateFin", dateFin);
            return query.getResultList();
        } finally {
            em.close();
        }
    }
}
