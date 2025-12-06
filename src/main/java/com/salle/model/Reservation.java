package com.salle.model;

import jakarta.persistence.*;
import jakarta.validation.constraints.Future;
import jakarta.validation.constraints.NotNull;
import java.time.LocalDateTime;

@Entity
@Table(name = "reservations")
@NamedQueries({
    @NamedQuery(name = "Reservation.findAll", query = "SELECT r FROM Reservation r ORDER BY r.dateDebut"),
    @NamedQuery(name = "Reservation.findByUser", query = "SELECT r FROM Reservation r WHERE r.user.id = :userId ORDER BY r.dateDebut"),
    @NamedQuery(name = "Reservation.findBySalle", query = "SELECT r FROM Reservation r WHERE r.salle.id = :salleId ORDER BY r.dateDebut"),
    @NamedQuery(name = "Reservation.findFuture", query = "SELECT r FROM Reservation r WHERE r.dateDebut >= :now ORDER BY r.dateDebut"),
    @NamedQuery(name = "Reservation.findOverlapping", 
                query = "SELECT r FROM Reservation r WHERE r.salle.id = :salleId " +
                        "AND r.id != :excludeId " +
                        "AND ((r.dateDebut < :dateFin AND r.dateFin > :dateDebut))")
})
public class Reservation {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @NotNull
    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;
    
    @NotNull
    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "salle_id", nullable = false)
    private Salle salle;
    
    @NotNull
    @Future
    @Column(nullable = false)
    private LocalDateTime dateDebut;
    
    @NotNull
    @Column(nullable = false)
    private LocalDateTime dateFin;
    
    @Column(length = 500)
    private String motif;
    
    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    private StatutReservation statut;
    
    public Reservation() {
        this.statut = StatutReservation.CONFIRMEE;
    }
    
    public Reservation(User user, Salle salle, LocalDateTime dateDebut, LocalDateTime dateFin, String motif) {
        this.user = user;
        this.salle = salle;
        this.dateDebut = dateDebut;
        this.dateFin = dateFin;
        this.motif = motif;
        this.statut = StatutReservation.CONFIRMEE;
    }
    
    // Getters and Setters
    public Long getId() {
        return id;
    }
    
    public void setId(Long id) {
        this.id = id;
    }
    
    public User getUser() {
        return user;
    }
    
    public void setUser(User user) {
        this.user = user;
    }
    
    public Salle getSalle() {
        return salle;
    }
    
    public void setSalle(Salle salle) {
        this.salle = salle;
    }
    
    public LocalDateTime getDateDebut() {
        return dateDebut;
    }
    
    public void setDateDebut(LocalDateTime dateDebut) {
        this.dateDebut = dateDebut;
    }
    
    public LocalDateTime getDateFin() {
        return dateFin;
    }
    
    public void setDateFin(LocalDateTime dateFin) {
        this.dateFin = dateFin;
    }
    
    public String getMotif() {
        return motif;
    }
    
    public void setMotif(String motif) {
        this.motif = motif;
    }
    
    public StatutReservation getStatut() {
        return statut;
    }
    
    public void setStatut(StatutReservation statut) {
        this.statut = statut;
    }
    
    public boolean isPast() {
        return dateDebut.isBefore(LocalDateTime.now());
    }
    
    public enum StatutReservation {
        CONFIRMEE, ANNULEE
    }
}

