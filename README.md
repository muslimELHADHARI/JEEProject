# Application Web de Gestion et Réservation de Salles

Application web Jakarta EE pour la gestion et la réservation de salles avec prévention des chevauchements de réservations.

## 🌶️ Caractéristiques

- **Gestion des salles** : CRUD complet pour les salles avec description, capacité et équipements
- **Réservation de salles** : Système de réservation avec détection automatique des chevauchements
- **Authentification** : Système de connexion/inscription avec hachage de mots de passe (BCrypt)
- **Autorisation** : Gestion des rôles (USER/ADMIN) avec contrôle d'accès
- **Interface moderne** : Design inspiré de la culture harissa tunisienne avec Tailwind CSS et animations créatives
- **Validation** : Validation des dates, prévention des réservations passées, contrôle des chevauchements

## 🛠️ Technologies

- **Java 17+**
- **Jakarta EE** (Servlet, JSP, JPA)
- **Hibernate** (JPA Provider)
- **H2 Database** (Base de données en mémoire)
- **Tailwind CSS** (Framework CSS)
- **BCrypt** (Hachage de mots de passe)
- **Maven** (Gestion des dépendances)

## 📋 Prérequis

- JDK 17 ou supérieur
- Maven 3.6+
- Serveur Jakarta EE compatible (Tomcat 10+, GlassFish, Payara)

## 🚀 Installation et Démarrage

### 1. Cloner le projet

```bash
cd /home/enigma/Documents/GitHub/JEE
```

### 2. Compiler le projet

```bash
mvn clean compile
```

### 3. Créer le package WAR

```bash
mvn clean package
```

Le fichier WAR sera généré dans `target/gestion-salles.war`

### 4. Déployer sur le serveur

#### Avec Tomcat :
1. Copier `target/gestion-salles.war` dans le répertoire `webapps` de Tomcat
2. Démarrer Tomcat
3. Accéder à `http://localhost:8080/gestion-salles`

#### Avec GlassFish/Payara :
1. Utiliser l'interface d'administration ou la ligne de commande
2. Déployer le fichier WAR
3. Accéder à l'URL fournie

### 5. Accès à l'application

- **Page d'accueil** : `http://localhost:8080/gestion-salles/`
- **Connexion** : `http://localhost:8080/gestion-salles/login`
- **Inscription** : `http://localhost:8080/gestion-salles/register`

## 📁 Structure du Projet

```
JEE/
├── src/
│   ├── main/
│   │   ├── java/
│   │   │   └── com/salle/
│   │   │       ├── controller/     # Servlets (contrôleurs)
│   │   │       ├── dao/            # Couche d'accès aux données
│   │   │       ├── exception/      # Exceptions personnalisées
│   │   │       ├── filter/         # Filtres (authentification, encodage)
│   │   │       ├── model/          # Entités JPA
│   │   │       ├── service/        # Couche métier
│   │   │       └── util/           # Utilitaires (JPAUtil)
│   │   ├── resources/
│   │   │   └── META-INF/
│   │   │       └── persistence.xml # Configuration JPA
│   │   └── webapp/
│   │       ├── WEB-INF/
│   │       │   ├── views/          # Vues JSP
│   │       │   └── web.xml         # Configuration web
│   │       └── index.jsp           # Page d'accueil
│   └── test/                        # Tests (à implémenter)
└── pom.xml                          # Configuration Maven
```

## 🎨 Fonctionnalités

### Utilisateur Standard (USER)

- S'inscrire et se connecter
- Voir la liste des salles disponibles
- Créer des réservations
- Modifier ses propres réservations (futures uniquement)
- Annuler ses propres réservations (futures uniquement)
- Voir ses réservations

### Administrateur (ADMIN)

- Toutes les fonctionnalités utilisateur
- Gérer les salles (CRUD)
- Voir toutes les réservations
- Gérer les utilisateurs
- Supprimer des réservations

## 🔒 Sécurité

- Mots de passe hachés avec BCrypt
- Filtre d'authentification pour protéger les pages
- Contrôle d'accès basé sur les rôles
- Validation des entrées utilisateur
- Protection CSRF (à implémenter si nécessaire)

## 🗄️ Base de Données

Le schéma de base de données est généré automatiquement par JPA/Hibernate au démarrage de l'application.

### Entités

- **User** : Utilisateurs avec rôles
- **Salle** : Salles de réunion
- **Reservation** : Réservations avec dates et statut

### Configuration

La base de données H2 est configurée en mémoire dans `persistence.xml`. Pour utiliser une base de données persistante (MySQL, PostgreSQL, etc.), modifiez la configuration dans `src/main/resources/META-INF/persistence.xml`.

## 🧪 Tests

Les tests peuvent être ajoutés dans le répertoire `src/test/java`. La structure de base est prête pour :
- Tests unitaires des services
- Tests d'intégration des DAO
- Tests des contrôleurs

## 🎨 Thème et Design

L'application utilise un thème inspiré de la culture harissa tunisienne :
- Palette de couleurs orange (orange-500 à orange-900)
- Animations créatives (fadeIn, slideIn, pulse-orange)
- Design moderne et responsive avec Tailwind CSS
- Icônes emoji pour une interface conviviale

## 📝 Notes

- La base de données H2 est stockée dans le fichier `./data/gestion_salles.mv.db` : les données sont persistantes
- Le schéma est mis à jour automatiquement (mode `update`) - les données existantes sont préservées
- Pour la production, configurez une base de données persistante (MySQL, PostgreSQL, etc.)
- Les mots de passe sont hachés avec BCrypt (coût: 10)
- Accès à la console H2 : `jdbc:h2:file:./data/gestion_salles` (User: sa, Password: vide)

## 🐛 Dépannage

### Erreur de compilation
- Vérifiez que JDK 17+ est installé : `java -version`
- Vérifiez Maven : `mvn -version`

### Erreur de déploiement
- Vérifiez que le serveur Jakarta EE est compatible
- Vérifiez les logs du serveur

### Problème de base de données
- Vérifiez la configuration dans `persistence.xml`
- Vérifiez que H2 est dans les dépendances Maven

## 📄 Licence

Ce projet est un projet éducatif pour l'apprentissage de Jakarta EE.

## 👤 Auteur

Développé dans le cadre d'un projet Jakarta EE avec architecture MVC complète.

