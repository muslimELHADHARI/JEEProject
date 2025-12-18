package com.salle.model;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "salles")
@NamedQueries({
        @NamedQuery(name = "Salle.findAll", query = "SELECT s FROM Salle s ORDER BY s.nom"),
        @NamedQuery(name = "Salle.findByNom", query = "SELECT s FROM Salle s WHERE s.nom = :nom"),
        @NamedQuery(name = "Salle.findByCapacite", query = "SELECT s FROM Salle s WHERE s.capacite >= :capacite ORDER BY s.capacite")
})
public class Salle {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @NotBlank
    @Column(nullable = false, unique = true, length = 100)
    private String nom;

    @NotBlank
    @Column(nullable = false, length = 500)
    private String description;

    @NotNull
    @Positive
    @Column(nullable = false)
    private Integer capacite;

    @Column(length = 200)
    private String equipements;

    @OneToMany(mappedBy = "salle", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<Reservation> reservations = new ArrayList<>();

    public Salle() {
    }

    @Column(name = "image_path")
    private String imagePath;

    @Column(name = "video_path")
    private String videoPath;

    @Column(name = "location")
    private String location;

    public Salle(String nom, String description, Integer capacite, String equipements, String imagePath,
            String videoPath, String location) {
        this.nom = nom;
        this.description = description;
        this.capacite = capacite;
        this.equipements = equipements;
        this.imagePath = imagePath;
        this.videoPath = videoPath;
        this.location = location;
    }

    // Getters and Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getNom() {
        return nom;
    }

    public void setNom(String nom) {
        this.nom = nom;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Integer getCapacite() {
        return capacite;
    }

    public void setCapacite(Integer capacite) {
        this.capacite = capacite;
    }

    public String getEquipements() {
        return equipements;
    }

    public void setEquipements(String equipements) {
        this.equipements = equipements;
    }

    public List<Reservation> getReservations() {
        return reservations;
    }

    public void setReservations(List<Reservation> reservations) {
        this.reservations = reservations;
    }

    public String getImagePath() {
        return imagePath;
    }

    public void setImagePath(String imagePath) {
        this.imagePath = imagePath;
    }

    public String getVideoPath() {
        return videoPath;
    }

    public void setVideoPath(String videoPath) {
        this.videoPath = videoPath;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }
}
