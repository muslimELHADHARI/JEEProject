package com.salle.util;

import com.salle.exception.InvalidDateException;
import com.salle.exception.OverlapException;
import com.salle.model.User;
import com.salle.service.ReservationService;
import com.salle.service.SalleService;
import com.salle.service.UserService;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;
import java.time.LocalDateTime;
import java.util.List;

/**
 * Initialise les données de base au démarrage de l'application.
 * Peuple la base de données avec des utilisateurs, salles et réservations de test.
 */
@WebListener
public class DataInitializer implements ServletContextListener {
    
    @Override
    public void contextInitialized(ServletContextEvent sce) {
        System.out.println("🌶️  Initialisation de la base de données...");
        
        UserService userService = new UserService();
        SalleService salleService = new SalleService();
        ReservationService reservationService = new ReservationService();
        
        try {
            // 1. Créer les utilisateurs
            createUsers(userService);
            
            // 2. Créer les salles
            createSalles(salleService);
            
            // 3. Créer des réservations
            createReservations(userService, salleService, reservationService);
            
            System.out.println("Base de données initialisée avec succès!");
        } catch (Exception e) {
            System.err.println(" Erreur lors de l'initialisation: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    private void createUsers(UserService userService) {
        System.out.println(" Création des utilisateurs...");
        
        // Admin
        if (userService.getUserByEmail("admin@salle.com").isEmpty()) {
            userService.createUser("Admin", "Système", "admin@salle.com", "admin123", User.Role.ADMIN);
            System.out.println("  ✓ Admin créé: admin@salle.com / admin123");
        }
        
        // Utilisateurs normaux
        if (userService.getUserByEmail("ahmed.benali@salle.com").isEmpty()) {
            userService.createUser("Benali", "Ahmed", "ahmed.benali@salle.com", "password123", User.Role.USER);
            System.out.println("  ✓ Utilisateur créé: ahmed.benali@salle.com / password123");
        }
        
        if (userService.getUserByEmail("fatima.trabelsi@salle.com").isEmpty()) {
            userService.createUser("Trabelsi", "Fatima", "fatima.trabelsi@salle.com", "password123", User.Role.USER);
            System.out.println("  ✓ Utilisateur créé: fatima.trabelsi@salle.com / password123");
        }
        
        if (userService.getUserByEmail("mohamed.chaabane@salle.com").isEmpty()) {
            userService.createUser("Chaabane", "Mohamed", "mohamed.chaabane@salle.com", "password123", User.Role.USER);
            System.out.println("  ✓ Utilisateur créé: mohamed.chaabane@salle.com / password123");
        }
        
        if (userService.getUserByEmail("sarra.mezghani@salle.com").isEmpty()) {
            userService.createUser("Mezghani", "Sarra", "sarra.mezghani@salle.com", "password123", User.Role.USER);
            System.out.println("  ✓ Utilisateur créé: sarra.mezghani@salle.com / password123");
        }
    }
    
    private void createSalles(SalleService salleService) {
        System.out.println("🏢 Création des salles...");
        
        if (salleService.getAllSalles().isEmpty()) {
            salleService.createSalle(
                "Salle de Conférence A",
                "Grande salle de conférence équipée pour les réunions importantes et les présentations",
                50,
                "Projecteur HD, Tableau blanc interactif, Système audio, Wi-Fi haut débit, Climatisation"
            );
            System.out.println("  ✓ Salle de Conférence A créée (50 places)");
            
            salleService.createSalle(
                "Salle de Réunion B",
                "Salle de réunion moyenne idéale pour les équipes",
                20,
                "Écran plat, Tableau blanc, Wi-Fi, Climatisation"
            );
            System.out.println("  ✓ Salle de Réunion B créée (20 places)");
            
            salleService.createSalle(
                "Salle de Formation C",
                "Salle spacieuse dédiée aux formations et ateliers",
                30,
                "Projecteur, Tableaux blancs multiples, Wi-Fi, Climatisation, Tables modulaires"
            );
            System.out.println("  ✓ Salle de Formation C créée (30 places)");
            
            salleService.createSalle(
                "Salle Exécutive",
                "Salle élégante pour les réunions de direction et les entretiens importants",
                10,
                "Écran 4K, Tableau blanc, Wi-Fi, Climatisation, Service café"
            );
            System.out.println("  ✓ Salle Exécutive créée (10 places)");
            
            salleService.createSalle(
                "Espace Collaboratif",
                "Espace ouvert et flexible pour le travail collaboratif",
                15,
                "Écrans partagés, Wi-Fi, Mobilier modulaire, Climatisation"
            );
            System.out.println("  ✓ Espace Collaboratif créé (15 places)");
            
            salleService.createSalle(
                "Amphithéâtre",
                "Grand amphithéâtre pour les conférences et présentations publiques",
                100,
                "Projecteur professionnel, Système audio avancé, Microphones, Wi-Fi, Climatisation"
            );
            System.out.println("  ✓ Amphithéâtre créé (100 places)");
        } else {
            System.out.println("  ℹ Des salles existent déjà, création ignorée");
        }
    }
    
    private void createReservations(UserService userService, SalleService salleService, 
                                   ReservationService reservationService) {
        System.out.println("📅 Création des réservations...");
        
        List<User> users = userService.getAllUsers();
        List<com.salle.model.Salle> salles = salleService.getAllSalles();
        
        if (users.isEmpty() || salles.isEmpty()) {
            System.out.println("  ⚠ Impossible de créer des réservations: utilisateurs ou salles manquants");
            return;
        }
        
        User admin = users.stream()
            .filter(u -> u.getRole() == User.Role.ADMIN)
            .findFirst()
            .orElse(users.get(0));
        
        User user1 = users.stream()
            .filter(u -> u.getRole() == User.Role.USER)
            .findFirst()
            .orElse(admin);
        
        if (salles.size() < 2) {
            System.out.println("  ⚠ Pas assez de salles pour créer des réservations");
            return;
        }
        
        LocalDateTime now = LocalDateTime.now();
        
        try {
            // Réservation aujourd'hui dans 2 heures (2h de durée)
            if (salles.size() > 0) {
                LocalDateTime debut1 = now.plusHours(2);
                LocalDateTime fin1 = debut1.plusHours(2);
                reservationService.createReservation(
                    user1.getId(),
                    salles.get(0).getId(),
                    debut1,
                    fin1,
                    "Réunion d'équipe - Revue de projet"
                );
                System.out.println("  ✓ Réservation créée: " + salles.get(0).getNom() + " - " + debut1.toLocalDate());
            }
            
            // Réservation demain matin
            if (salles.size() > 1) {
                LocalDateTime debut2 = now.plusDays(1).withHour(9).withMinute(0);
                LocalDateTime fin2 = debut2.plusHours(1).plusMinutes(30);
                reservationService.createReservation(
                    admin.getId(),
                    salles.get(1).getId(),
                    debut2,
                    fin2,
                    "Présentation client - Nouveau produit"
                );
                System.out.println("  ✓ Réservation créée: " + salles.get(1).getNom() + " - " + debut2.toLocalDate());
            }
            
            // Réservation après-demain après-midi
            if (salles.size() > 2) {
                LocalDateTime debut3 = now.plusDays(2).withHour(14).withMinute(0);
                LocalDateTime fin3 = debut3.plusHours(3);
                reservationService.createReservation(
                    user1.getId(),
                    salles.get(2).getId(),
                    debut3,
                    fin3,
                    "Formation interne - Nouvelles procédures"
                );
                System.out.println("  ✓ Réservation créée: " + salles.get(2).getNom() + " - " + debut3.toLocalDate());
            }
            
            // Réservation dans 3 jours
            if (salles.size() > 0) {
                LocalDateTime debut4 = now.plusDays(3).withHour(10).withMinute(0);
                LocalDateTime fin4 = debut4.plusHours(2);
                reservationService.createReservation(
                    admin.getId(),
                    salles.get(0).getId(),
                    debut4,
                    fin4,
                    "Réunion stratégique - Planification trimestrielle"
                );
                System.out.println("  ✓ Réservation créée: " + salles.get(0).getNom() + " - " + debut4.toLocalDate());
            }
            
        } catch (OverlapException | InvalidDateException e) {
            System.out.println("  ⚠ Erreur lors de la création d'une réservation: " + e.getMessage());
        }
    }
    
    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        // Nettoyage si nécessaire
        JPAUtil.closeEntityManagerFactory();
    }
}

