package com.salle.service;

import com.salle.dao.SalleDAO;
import com.salle.model.Salle;
import java.util.List;
import java.util.Optional;

public class SalleService {

    private final SalleDAO salleDAO;

    public SalleService() {
        this.salleDAO = new SalleDAO();
    }

    public List<Salle> getAllSalles() {
        return salleDAO.findAll();
    }

    public Optional<Salle> getSalleById(Long id) {
        return salleDAO.findById(id);
    }

    public Salle createSalle(String nom, String description, Integer capacite, String equipements, String imagePath,
            String videoPath, String location) {
        // Check if nom already exists
        if (salleDAO.findByNom(nom).isPresent()) {
            throw new IllegalArgumentException("Une salle avec ce nom existe déjà");
        }

        Salle salle = new Salle(nom, description, capacite, equipements, imagePath, videoPath, location);
        return salleDAO.save(salle);
    }

    public Salle updateSalle(Long id, String nom, String description, Integer capacite, String equipements,
            String imagePath, String videoPath, String location) {
        Optional<Salle> salleOpt = salleDAO.findById(id);
        if (salleOpt.isEmpty()) {
            throw new IllegalArgumentException("Salle non trouvée");
        }

        Salle salle = salleOpt.get();

        // Check if nom is being changed and if new nom already exists
        if (!salle.getNom().equals(nom)) {
            if (salleDAO.findByNom(nom).isPresent()) {
                throw new IllegalArgumentException("Une salle avec ce nom existe déjà");
            }
        }

        salle.setNom(nom);
        salle.setDescription(description);
        salle.setCapacite(capacite);
        salle.setEquipements(equipements);
        salle.setImagePath(imagePath);
        salle.setVideoPath(videoPath);
        salle.setLocation(location);

        return salleDAO.save(salle);
    }

    public void deleteSalle(Long id) {
        salleDAO.delete(id);
    }

    public List<Salle> findSallesByCapacite(Integer capacite) {
        return salleDAO.findByCapacite(capacite);
    }
}
