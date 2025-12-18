package com.salle.service;

import com.salle.dao.ReservationDAO;
import com.salle.dao.SalleDAO;
import com.salle.dao.UserDAO;
import com.salle.dao.WaitingListDAO;
import com.salle.exception.OverlapException;
import com.salle.model.Reservation;
import com.salle.model.Salle;
import com.salle.model.User;
import com.salle.model.WaitingList;
import com.salle.service.NotificationService; // Import NotificationService

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

public class WaitingListService {

    private final WaitingListDAO waitingListDAO;
    private final ReservationDAO reservationDAO;
    private final UserDAO userDAO;
    private final SalleDAO salleDAO;
    private final NotificationService notificationService; // Add NotificationService

    public WaitingListService() {
        this.waitingListDAO = new WaitingListDAO();
        this.reservationDAO = new ReservationDAO();
        this.userDAO = new UserDAO();
        this.salleDAO = new SalleDAO();
        this.notificationService = new NotificationService(); // Initialize NotificationService
    }

    public void addEntryToWaitingList(Long userId, Long salleId, LocalDateTime dateDebut, LocalDateTime dateFin)
            throws OverlapException {
        User user = userDAO.findById(userId).orElseThrow(() -> new IllegalArgumentException("User not found"));
        Salle salle = salleDAO.findById(salleId).orElseThrow(() -> new IllegalArgumentException("Salle not found"));

        // Check if the user already has a reservation for this time
        if (reservationDAO.getReservationsByUserAndPeriod(userId, dateDebut, dateFin).stream()
                .anyMatch(r -> r.getSalle().getId().equals(salleId))) {
            throw new OverlapException("Vous avez déjà une réservation pour cette salle et cette période.");
        }

        // Check if the user is already on the waiting list for this specific slot
        if (waitingListDAO.getWaitingListForUser(userId).stream()
                .anyMatch(wl -> wl.getSalle().getId().equals(salleId) &&
                        wl.getRequestedDateDebut().equals(dateDebut) &&
                        wl.getRequestedDateFin().equals(dateFin))) {
            throw new OverlapException("Vous êtes déjà sur la liste d'attente pour cette salle et cette période.");
        }

        WaitingList entry = new WaitingList(user, salle, dateDebut, dateFin);
        waitingListDAO.addEntry(entry);
        System.out.println("User " + user.getEmail() + " added to waiting list for salle " + salle.getNom() + " from "
                + dateDebut + " to " + dateFin);

        // Create notification for the user who joined the waiting list
        notificationService.createNotification(userId,
                "Vous avez été ajouté à la liste d'attente pour la salle " + salle.getNom() + ".",
                "WAITING_LIST_JOINED",
                entry.getId());
    }

    public void removeEntryFromWaitingList(Long entryId) {
        waitingListDAO.removeEntry(entryId);
    }

    public Optional<WaitingList> getNextWaitingEntry(Long salleId, LocalDateTime dateDebut, LocalDateTime dateFin) {
        return waitingListDAO.getNextWaitingEntryForSalle(salleId, dateDebut, dateFin);
    }

    public List<WaitingList> getWaitingListForUser(Long userId) {
        return waitingListDAO.getWaitingListForUser(userId);
    }

    public List<WaitingList> getAllWaitingListEntries() {
        return waitingListDAO.getAllWaitingListEntries();
    }

    public boolean assignNextWaitingUser(Long salleId, LocalDateTime dateDebut, LocalDateTime dateFin) {
        System.out.println("DEBUG: assignNextWaitingUser called for salleId=" + salleId + " (trigger event: cancelled "
                + dateDebut + " to " + dateFin + ")");

        // Get ALL waiting list entries for this salle (FIFO)
        List<WaitingList> allEntries = waitingListDAO.getAllWaitingListEntriesForSalle(salleId);
        System.out.println("DEBUG: Found " + allEntries.size() + " total waiting list entries for salle " + salleId);

        for (WaitingList entry : allEntries) {
            System.out.println("DEBUG: Checking entry " + entry.getId() + " for user " + entry.getUser().getEmail() +
                    " (" + entry.getRequestedDateDebut() + " to " + entry.getRequestedDateFin() + ")");

            // Check if the room is FREE for this specific request
            // logical check: findOverlapping(salleId, entryStar, entryEnd, excludeId=null)
            List<Reservation> overlapping = reservationDAO.findOverlapping(
                    salleId,
                    entry.getRequestedDateDebut(),
                    entry.getRequestedDateFin(),
                    null);

            if (overlapping.isEmpty()) {
                System.out.println("DEBUG: Room is FREE for entry " + entry.getId() + "! Promoting user.");
                try {
                    // Create reservation
                    Reservation newReservation = new Reservation(
                            entry.getUser(),
                            entry.getSalle(),
                            entry.getRequestedDateDebut(),
                            entry.getRequestedDateFin(),
                            "Attribution automatique de la liste d'attente");
                    newReservation.setStatut(Reservation.StatutReservation.CONFIRMEE);
                    reservationDAO.save(newReservation);

                    // Remove from waiting list
                    removeEntryFromWaitingList(entry.getId());
                    System.out.println("DEBUG: Promoted user " + entry.getUser().getEmail() + ". WL entry removed.");

                    // Notify user
                    notificationService.createNotification(entry.getUser().getId(),
                            "La salle " + entry.getSalle().getNom()
                                    + " est maintenant disponible et vous a été attribuée.",
                            "SALLE_AUTO_ASSIGNED",
                            newReservation.getId());
                    return true; // Stop after one successful assignment
                } catch (Exception e) {
                    System.err.println("Failed to promote waiting list entry " + entry.getId() + ": " + e.getMessage());
                    e.printStackTrace();
                    // Continue to next entry if this one fails
                }
            } else {
                System.out.println("DEBUG: Room is BUSY for entry " + entry.getId() + ". Overlapping count: "
                        + overlapping.size());
            }
        }

        System.out.println("DEBUG: No waiting list entries could be promoted.");
        return false;
    }

    public boolean isUserOnWaitingList(Long userId, Long salleId, LocalDateTime dateDebut, LocalDateTime dateFin) {
        return waitingListDAO.getWaitingListEntriesBySalleAndTime(salleId, dateDebut, dateFin).stream()
                .anyMatch(wl -> wl.getUser().getId().equals(userId));
    }
}
