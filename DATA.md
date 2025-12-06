# 📊 Données de Test - Base de Données

Ce document liste toutes les données de test créées automatiquement au démarrage de l'application.

## 👥 Utilisateurs

### Administrateur
- **Email** : `admin@salle.com`
- **Mot de passe** : `admin123`
- **Rôle** : ADMIN
- **Nom** : Admin Système

### Utilisateurs Standards
Tous les utilisateurs standards ont le mot de passe : `password123`

1. **Ahmed Benali**
   - Email : `ahmed.benali@salle.com`
   - Mot de passe : `password123`

2. **Fatima Trabelsi**
   - Email : `fatima.trabelsi@salle.com`
   - Mot de passe : `password123`

3. **Mohamed Chaabane**
   - Email : `mohamed.chaabane@salle.com`
   - Mot de passe : `password123`

4. **Sarra Mezghani**
   - Email : `sarra.mezghani@salle.com`
   - Mot de passe : `password123`

## 🏢 Salles

1. **Salle de Conférence A**
   - Capacité : 50 places
   - Équipements : Projecteur HD, Tableau blanc interactif, Système audio, Wi-Fi haut débit, Climatisation
   - Description : Grande salle de conférence équipée pour les réunions importantes et les présentations

2. **Salle de Réunion B**
   - Capacité : 20 places
   - Équipements : Écran plat, Tableau blanc, Wi-Fi, Climatisation
   - Description : Salle de réunion moyenne idéale pour les équipes

3. **Salle de Formation C**
   - Capacité : 30 places
   - Équipements : Projecteur, Tableaux blancs multiples, Wi-Fi, Climatisation, Tables modulaires
   - Description : Salle spacieuse dédiée aux formations et ateliers

4. **Salle Exécutive**
   - Capacité : 10 places
   - Équipements : Écran 4K, Tableau blanc, Wi-Fi, Climatisation, Service café
   - Description : Salle élégante pour les réunions de direction et les entretiens importants

5. **Espace Collaboratif**
   - Capacité : 15 places
   - Équipements : Écrans partagés, Wi-Fi, Mobilier modulaire, Climatisation
   - Description : Espace ouvert et flexible pour le travail collaboratif

6. **Amphithéâtre**
   - Capacité : 100 places
   - Équipements : Projecteur professionnel, Système audio avancé, Microphones, Wi-Fi, Climatisation
   - Description : Grand amphithéâtre pour les conférences et présentations publiques

## 📅 Réservations de Test

Des réservations sont créées automatiquement pour tester le système :

- **Réservation 1** : Aujourd'hui + 2h (durée 2h) - Réunion d'équipe
- **Réservation 2** : Demain 9h00 (durée 1h30) - Présentation client
- **Réservation 3** : Après-demain 14h00 (durée 3h) - Formation interne
- **Réservation 4** : Dans 3 jours 10h00 (durée 2h) - Réunion stratégique

## 🔄 Réinitialisation

Pour réinitialiser la base de données :

1. **Avec H2 en mémoire** : Redémarrez simplement l'application
2. **Avec base de données persistante** : Supprimez les tables ou utilisez `hibernate.hbm2ddl.auto=create` dans `persistence.xml`

## 📝 Notes

- Les données sont créées uniquement si elles n'existent pas déjà
- Les réservations sont créées avec des dates futures
- Tous les mots de passe sont en clair dans ce document (à changer en production)
- Les réservations de test peuvent échouer si des réservations existent déjà aux mêmes dates

## 🧪 Tests Recommandés

1. **Connexion** : Testez avec différents comptes utilisateurs
2. **Création de réservation** : Créez une nouvelle réservation
3. **Détection de chevauchement** : Essayez de réserver une salle déjà réservée
4. **Gestion des salles** (Admin) : Créez, modifiez, supprimez des salles
5. **Annulation** : Annulez une réservation existante

---

**Note** : Ces données sont uniquement pour le développement et les tests. En production, changez tous les mots de passe et ne créez pas de données de test automatiquement.

