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
import com.salle.service.NotificationService; // Import NotificationService
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

public class ReservationService {
    
    private final ReservationDAO reservationDAO;
    private final UserDAO userDAO;
    private final SalleDAO salleDAO;
    private final WaitingListService waitingListService; // Add WaitingListService
    private final NotificationService notificationService; // Add NotificationService
    
    public ReservationService() {
        this.reservationDAO = new ReservationDAO();
        this.userDAO = new UserDAO();
        this.salleDAO = new SalleDAO();
        this.waitingListService = new WaitingListService(); // Initialize WaitingListService
        this.notificationService = new NotificationService(); // Initialize NotificationService
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
            // If overlapping, add to waiting list instead of throwing an exception
            waitingListService.addEntryToWaitingList(userId, salleId, dateDebut, dateFin);
            // Optionally, return a specific reservation status or throw a custom exception for waiting list
            // For now, we'll just return null or a placeholder reservation indicating waiting list entry
            // This part might need refinement based on how the UI should react
            System.out.println("Salle " + salle.getNom() + " is full. User " + user.getEmail() + " added to waiting list.");
            throw new OverlapException("Cette salle est déjà réservée pour cette période. Vous avez été ajouté à la liste d'attente.");
        }
        
        // Create reservation
        Reservation reservation = new Reservation(user, salle, dateDebut, dateFin, motif);
        Reservation savedReservation = reservationDAO.save(reservation);
        
        // Create notification for the user who made the reservation
        notificationService.createNotification(userId, 
                                               "Votre réservation pour la salle " + salle.getNom() + " a été créée avec succès.", 
                                               "RESERVATION_CREATED", 
                                               savedReservation.getId());
        
        return savedReservation;
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
        
        Reservation updatedReservation = reservationDAO.save(reservation);

        // Create notification for the user whose reservation was updated
        notificationService.createNotification(userId, 
                                               "Votre réservation pour la salle " + salle.getNom() + " a été modifiée.", 
                                               "RESERVATION_UPDATED", 
                                               updatedReservation.getId());

        return updatedReservation;
    }
    
    public String cancelReservation(Long reservationId, Long userId) 
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

        // After a reservation is cancelled, check the waiting list for auto-assignment
        boolean autoAssigned = waitingListService.assignNextWaitingUser(reservation.getSalle().getId(), 
                                                                         reservation.getDateDebut(), 
                                                                         reservation.getDateFin());
        
        String message = "Réservation annulée avec succès.";
        
        if (autoAssigned) {
            System.out.println("Reservation cancelled and a waiting list user was auto-assigned.");

            // Create notification for the user whose reservation was cancelled
            notificationService.createNotification(userId, 
                                                   "Votre réservation pour la salle " + reservation.getSalle().getNom() + " a été annulée. Une salle a été attribuée à un utilisateur en attente.", 
                                                   "RESERVATION_CANCELLED_AUTO_ASSIGNED", 
                                                   reservation.getId());
            message = "Réservation annulée avec succès. Une salle a été automatiquement attribuée à un utilisateur en attente.";
        } else {
            notificationService.createNotification(userId, 
                                                   "Votre réservation pour la salle " + reservation.getSalle().getNom() + " a été annulée.", 
                                                   "RESERVATION_CANCELLED", 
                                                   reservation.getId());
        }
        return message;
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
        // Create notification for admin who deleted the reservation
        notificationService.createNotification(userId, 
                                               "Une réservation (ID: " + reservationId + ") a été supprimée par un administrateur.", 
                                               "RESERVATION_DELETED", 
                                               reservationId);
    }
}

