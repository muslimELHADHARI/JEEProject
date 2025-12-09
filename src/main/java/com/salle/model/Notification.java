package com.salle.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.Date;
import java.util.Objects;

@Entity
@Table(name = "notifications")
public class Notification {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @Column(nullable = false)
    private String message;

    @Column(nullable = false)
    private LocalDateTime timestamp;

    @Column(nullable = false)
    private boolean isRead;

    @Column(name = "notification_type")
    private String type; // e.g., "reservation_canceled", "salle_assigned"

    @Column(name = "target_entity_id")
    private Long targetEntityId; // e.g., ID of the reservation or waiting list entry

    // Constructors
    public Notification() {
    }

    public Notification(User user, String message, String type, Long targetEntityId) {
        this.user = user;
        this.message = message;
        this.timestamp = LocalDateTime.now();
        this.isRead = false;
        this.type = type;
        this.targetEntityId = targetEntityId;
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

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public LocalDateTime getTimestamp() {
        return timestamp;
    }

    public void setTimestamp(LocalDateTime timestamp) {
        this.timestamp = timestamp;
    }

    public java.util.Date getLegacyTimestamp() {
        return Date.from(timestamp.atZone(ZoneId.systemDefault()).toInstant());
    }

    public boolean isRead() {
        return isRead;
    }

    public void setRead(boolean read) {
        isRead = read;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public Long getTargetEntityId() {
        return targetEntityId;
    }

    public void setTargetEntityId(Long targetEntityId) {
        this.targetEntityId = targetEntityId;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Notification that = (Notification) o;
        return Objects.equals(id, that.id);
    }

    @Override
    public int hashCode() {
        return Objects.hash(id);
    }

    @Override
    public String toString() {
        return "Notification{" +
               "id=" + id +
               ", user=" + (user != null ? user.getId() : "null") +
               ", message='" + message + '\'' +
               ", timestamp=" + timestamp +
               ", isRead=" + isRead +
               ", type='" + type + '\'' +
               ", targetEntityId=" + targetEntityId +
               '}';
    }
}
