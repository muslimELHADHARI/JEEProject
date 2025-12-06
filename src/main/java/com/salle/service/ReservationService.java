package com.salle.service;

import com.salle.dao.ReservationDAO;
import com.salle.dao.SalleDAO;
import com.salle.dao.UserDAO;
import com.salle.exception.InvalidDateException;
import com.salle.exception.OverlapException;
import com.salle.exception.UnauthorizedActionException;
import com.salle.model.Reservation;
import com.salle.model.Salle;
import com.salle.model.User;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

public class ReservationService {
    
    private final ReservationDAO reservationDAO;
    private final UserDAO userDAO;
    private final SalleDAO salleDAO;
    
    public ReservationService() {
        this.reservationDAO = new ReservationDAO();
        this.userDAO = new UserDAO();
        this.salleDAO = new SalleDAO();
    }
    
    public List<Reservation> getAllReservations() {
        return reservationDAO.findAll();
    }
    
    public List<Reservation> getFutureReservations() {
        return reservationDAO.findFuture();
    }
    
    public List<Reservation> getReservationsByUser(Long userId) {
        return reservationDAO.findByUser(userId);
    }
    
    public List<Reservation> getReservationsBySalle(Long salleId) {
        return reservationDAO.findBySalle(salleId);
    }
    
    public Optional<Reservation> getReservationById(Long id) {
        return reservationDAO.findById(id);
    }
    
    public Reservation createReservation(Long userId, Long salleId, LocalDateTime dateDebut, 
                                        LocalDateTime dateFin, String motif) 
            throws OverlapException, InvalidDateException {
        
        // Validate dates
        if (dateDebut.isBefore(LocalDateTime.now())) {
            throw new InvalidDateException("La date de début doit être dans le futur");
        }
        
        if (dateFin.isBefore(dateDebut) || dateFin.isEqual(dateDebut)) {
            throw new InvalidDateException("La date de fin doit être après la date de début");
        }
        
        // Get user and salle
        Optional<User> userOpt = userDAO.findById(userId);
        if (userOpt.isEmpty()) {
            throw new IllegalArgumentException("Utilisateur non trouvé");
        }
        
        Optional<Salle> salleOpt = salleDAO.findById(salleId);
        if (salleOpt.isEmpty()) {
            throw new IllegalArgumentException("Salle non trouvée");
        }
        
        User user = userOpt.get();
        Salle salle = salleOpt.get();
        
        // Check for overlapping reservations
        List<Reservation> overlapping = reservationDAO.findOverlapping(salleId, dateDebut, dateFin, null);
        if (!overlapping.isEmpty()) {
            throw new OverlapException("Cette salle est déjà réservée pour cette période");
        }
        
        // Create reservation
        Reservation reservation = new Reservation(user, salle, dateDebut, dateFin, motif);
        return reservationDAO.save(reservation);
    }
    
    public Reservation updateReservation(Long reservationId, Long userId, Long salleId, 
                                        LocalDateTime dateDebut, LocalDateTime dateFin, String motif) 
            throws OverlapException, InvalidDateException, UnauthorizedActionException {
        
        Optional<Reservation> reservationOpt = reservationDAO.findById(reservationId);
        if (reservationOpt.isEmpty()) {
            throw new IllegalArgumentException("Réservation non trouvée");
        }
        
        Reservation reservation = reservationOpt.get();
        
        // Check if user is authorized (owner or admin)
        if (!reservation.getUser().getId().equals(userId)) {
            Optional<User> userOpt = userDAO.findById(userId);
            if (userOpt.isEmpty() || userOpt.get().getRole() != User.Role.ADMIN) {
                throw new UnauthorizedActionException("Vous n'êtes pas autorisé à modifier cette réservation");
            }
        }
        
        // Prevent modification of past reservations
        if (reservation.isPast()) {
            throw new UnauthorizedActionException("Impossible de modifier une réservation passée");
        }
        
        // Validate dates
        if (dateDebut.isBefore(LocalDateTime.now())) {
            throw new InvalidDateException("La date de début doit être dans le futur");
        }
        
        if (dateFin.isBefore(dateDebut) || dateFin.isEqual(dateDebut)) {
            throw new InvalidDateException("La date de fin doit être après la date de début");
        }
        
        // Get salle
        Optional<Salle> salleOpt = salleDAO.findById(salleId);
        if (salleOpt.isEmpty()) {
            throw new IllegalArgumentException("Salle non trouvée");
        }
        
        Salle salle = salleOpt.get();
        
        // Check for overlapping reservations (excluding current reservation)
        List<Reservation> overlapping = reservationDAO.findOverlapping(salleId, dateDebut, dateFin, reservationId);
        if (!overlapping.isEmpty()) {
            throw new OverlapException("Cette salle est déjà réservée pour cette période");
        }
        
        // Update reservation
        reservation.setSalle(salle);
        reservation.setDateDebut(dateDebut);
        reservation.setDateFin(dateFin);
        reservation.setMotif(motif);
        
        return reservationDAO.save(reservation);
    }
    
    public void cancelReservation(Long reservationId, Long userId) 
            throws UnauthorizedActionException {
        
        Optional<Reservation> reservationOpt = reservationDAO.findById(reservationId);
        if (reservationOpt.isEmpty()) {
            throw new IllegalArgumentException("Réservation non trouvée");
        }
        
        Reservation reservation = reservationOpt.get();
        
        // Check if user is authorized (owner or admin)
        if (!reservation.getUser().getId().equals(userId)) {
            Optional<User> userOpt = userDAO.findById(userId);
            if (userOpt.isEmpty() || userOpt.get().getRole() != User.Role.ADMIN) {
                throw new UnauthorizedActionException("Vous n'êtes pas autorisé à annuler cette réservation");
            }
        }
        
        // Prevent cancellation of past reservations
        if (reservation.isPast()) {
            throw new UnauthorizedActionException("Impossible d'annuler une réservation passée");
        }
        
        reservation.setStatut(Reservation.StatutReservation.ANNULEE);
        reservationDAO.save(reservation);
    }
    
    public void deleteReservation(Long reservationId, Long userId) 
            throws UnauthorizedActionException {
        
        // Check if reservation exists
        if (reservationDAO.findById(reservationId).isEmpty()) {
            throw new IllegalArgumentException("Réservation non trouvée");
        }
        
        // Only admin can delete
        Optional<User> userOpt = userDAO.findById(userId);
        if (userOpt.isEmpty() || userOpt.get().getRole() != User.Role.ADMIN) {
            throw new UnauthorizedActionException("Seuls les administrateurs peuvent supprimer des réservations");
        }
        
        reservationDAO.delete(reservationId);
    }
}

