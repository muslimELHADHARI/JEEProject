package com.salle.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;
import java.util.Objects;

@Entity
@Table(name = "waiting_list")
public class WaitingList {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "salle_id", nullable = false)
    private Salle salle;

    @Column(name = "requested_date_debut", nullable = false)
    private LocalDateTime requestedDateDebut;

    @Column(name = "requested_date_fin", nullable = false)
    private LocalDateTime requestedDateFin;

    @Column(name = "request_time", nullable = false)
    private LocalDateTime requestTime;

    // Constructors
    public WaitingList() {
    }

    public WaitingList(User user, Salle salle, LocalDateTime requestedDateDebut, LocalDateTime requestedDateFin) {
        this.user = user;
        this.salle = salle;
        this.requestedDateDebut = requestedDateDebut;
        this.requestedDateFin = requestedDateFin;
        this.requestTime = LocalDateTime.now();
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

    public LocalDateTime getRequestedDateDebut() {
        return requestedDateDebut;
    }

    public void setRequestedDateDebut(LocalDateTime requestedDateDebut) {
        this.requestedDateDebut = requestedDateDebut;
    }

    public LocalDateTime getRequestedDateFin() {
        return requestedDateFin;
    }

    public void setRequestedDateFin(LocalDateTime requestedDateFin) {
        this.requestedDateFin = requestedDateFin;
    }

    public LocalDateTime getRequestTime() {
        return requestTime;
    }

    public void setRequestTime(LocalDateTime requestTime) {
        this.requestTime = requestTime;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        WaitingList that = (WaitingList) o;
        return Objects.equals(id, that.id);
    }

    @Override
    public int hashCode() {
        return Objects.hash(id);
    }

    @Override
    public String toString() {
        return "WaitingList{" +
               "id=" + id +
               ", user=" + (user != null ? user.getId() : "null") +
               ", salle=" + (salle != null ? salle.getId() : "null") +
               ", requestedDateDebut=" + requestedDateDebut +
               ", requestedDateFin=" + requestedDateFin +
               ", requestTime=" + requestTime +
               '}';
    }
}
