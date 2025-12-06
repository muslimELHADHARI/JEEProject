# Guide de Démarrage - Comment Exécuter le Projet

Ce guide vous explique comment exécuter l'application de gestion de salles.

## 📋 Prérequis

Vérifiez que vous avez installé :
- **Java 17 ou supérieur** : `java -version`
- **Maven 3.6+** : `mvn -version`

## 🚀 Méthode 1 : Avec Tomcat (Recommandé pour développement)

### Étape 1 : Télécharger et installer Tomcat 10+

```bash
# Télécharger Tomcat 10.1.x depuis https://tomcat.apache.org/download-10.cgi
# Extraire dans un répertoire (ex: /opt/tomcat ou ~/tomcat)
```

### Étape 2 : Compiler le projet

```bash
cd /home/enigma/Documents/GitHub/JEE
mvn clean package
```

### Étape 3 : Déployer sur Tomcat

```bash
# Copier le WAR dans le répertoire webapps de Tomcat
cp target/gestion-salles.war /chemin/vers/tomcat/webapps/

# OU créer un lien symbolique
ln -s /home/enigma/Documents/GitHub/JEE/target/gestion-salles.war /chemin/vers/tomcat/webapps/
```

### Étape 4 : Démarrer Tomcat

```bash
cd /chemin/vers/tomcat
./bin/startup.sh    # Linux/Mac
# OU
bin\startup.bat     # Windows
```

### Étape 5 : Accéder à l'application

Ouvrez votre navigateur :
- **Page d'accueil** : http://localhost:8080/gestion-salles/
- **Connexion** : http://localhost:8080/gestion-salles/login

**Compte administrateur par défaut :**
- Email : `admin@salle.com`
- Mot de passe : `admin123`

### Arrêter Tomcat

```bash
cd /chemin/vers/tomcat
./bin/shutdown.sh   # Linux/Mac
# OU
bin\shutdown.bat    # Windows
```

---

## 🚀 Méthode 2 : Avec Maven Jetty Plugin (Plus simple - RECOMMANDÉ)

Cette méthode utilise Jetty 11 qui supporte Jakarta EE nativement.

### Étape 1 : Compiler et démarrer

```bash
cd /home/enigma/Documents/GitHub/JEE
mvn clean package
mvn jetty:run
```

OU utilisez le script fourni :

```bash
./run.sh
```

### Étape 2 : Accéder à l'application

- **Page d'accueil** : http://localhost:8080/gestion-salles/

---

## 🚀 Méthode 3 : Avec GlassFish/Payara

### Étape 1 : Télécharger GlassFish ou Payara

- GlassFish : https://glassfish.org/download
- Payara : https://www.payara.fish/downloads

### Étape 2 : Compiler le projet

```bash
cd /home/enigma/Documents/GitHub/JEE
mvn clean package
```

### Étape 3 : Déployer via l'interface d'administration

1. Démarrer GlassFish/Payara
2. Accéder à http://localhost:4848 (interface d'administration)
3. Aller dans "Applications" > "Deploy"
4. Sélectionner `target/gestion-salles.war`
5. Cliquer sur "OK"

### Étape 4 : Accéder à l'application

- **Page d'accueil** : http://localhost:8080/gestion-salles/

---

## 🚀 Méthode 4 : Avec Jetty (Alternative légère)

### Étape 1 : Ajouter le plugin Jetty au pom.xml

Ajoutez dans la section `<plugins>` :

```xml
<plugin>
    <groupId>org.eclipse.jetty</groupId>
    <artifactId>jetty-maven-plugin</artifactId>
    <version>11.0.20</version>
</plugin>
```

### Étape 2 : Démarrer avec Jetty

```bash
mvn clean package jetty:run
```

---

## 🔧 Configuration Maven pour Jetty (Déjà configuré)

Le plugin Jetty est déjà configuré dans `pom.xml` pour supporter Jakarta EE :

```xml
<plugin>
    <groupId>org.eclipse.jetty</groupId>
    <artifactId>jetty-maven-plugin</artifactId>
    <version>11.0.20</version>
    <configuration>
        <httpConnector>
            <port>8080</port>
        </httpConnector>
        <webApp>
            <contextPath>/gestion-salles</contextPath>
        </webApp>
    </configuration>
</plugin>
```

Ensuite, vous pouvez simplement exécuter :
```bash
mvn jetty:run
```

---

## 🗄️ Base de Données

### H2 Database - Stockage sur disque

L'application utilise H2 avec stockage sur fichier. La base de données est sauvegardée dans :
- **Fichier** : `./data/gestion_salles.mv.db` (créé automatiquement)
- **Emplacement** : Répertoire `data/` à la racine du projet

### H2 Console (Pour visualiser la base de données)

Pour accéder à la console H2 :

1. Ajoutez cette dépendance dans `pom.xml` (déjà présente)
2. Accédez à : http://localhost:8080/gestion-salles/h2-console
   - JDBC URL : `jdbc:h2:file:./data/gestion_salles`
   - User : `sa`
   - Password : (vide)

**Note** : 
- Les données sont persistantes entre les redémarrages
- Le schéma est mis à jour automatiquement (mode `update`)
- Pour réinitialiser, supprimez le dossier `data/`

---

## ✅ Vérification du Démarrage

### 1. Vérifier que le serveur démarre

Regardez les logs du serveur. Vous devriez voir :
```
INFO: Starting Servlet engine
INFO: Hibernate: create table users ...
INFO: Utilisateur administrateur créé: admin@salle.com / admin123
```

### 2. Tester l'application

1. Ouvrez http://localhost:8080/gestion-salles/
2. Cliquez sur "Créer un compte" ou "Se connecter"
3. Connectez-vous avec `admin@salle.com` / `admin123`

### 3. Créer une salle (Admin)

1. Connectez-vous en tant qu'admin
2. Allez dans "Salles" > "Ajouter une salle"
3. Remplissez le formulaire

### 4. Créer une réservation

1. Allez dans "Réservations" > "Nouvelle réservation"
2. Sélectionnez une salle et des dates
3. Créez la réservation

---

## 🐛 Dépannage

### Erreur : "Port 8080 already in use"

```bash
# Trouver le processus qui utilise le port
lsof -i :8080    # Linux/Mac
netstat -ano | findstr :8080    # Windows

# Tuer le processus ou changer le port dans la configuration
```

### Erreur : "ClassNotFoundException"

Vérifiez que toutes les dépendances sont téléchargées :
```bash
mvn clean install
```

### Erreur : "JPA/Hibernate not working"

- Vérifiez que H2 est dans les dépendances
- Vérifiez `persistence.xml`
- Regardez les logs du serveur pour les erreurs Hibernate

### Erreur : "404 Not Found"

- Vérifiez que le WAR est bien déployé
- Vérifiez l'URL (doit inclure `/gestion-salles`)
- Vérifiez les logs du serveur

### Erreur : "Cannot connect to database"

- H2 est en mémoire, donc pas de connexion externe nécessaire
- Vérifiez les logs pour les erreurs de connexion

---

## 📝 Commandes Utiles

```bash
# Compiler le projet
mvn clean compile

# Créer le package WAR
mvn clean package

# Nettoyer et reconstruire
mvn clean install

# Voir les dépendances
mvn dependency:tree

# Exécuter les tests (quand ajoutés)
mvn test
```

---

## 🎯 Prochaines Étapes

1. **Créer un compte utilisateur** : http://localhost:8080/gestion-salles/register
2. **Se connecter** : http://localhost:8080/gestion-salles/login
3. **Explorer le dashboard** : http://localhost:8080/gestion-salles/dashboard
4. **Gérer les salles** (admin) : http://localhost:8080/gestion-salles/salles
5. **Créer des réservations** : http://localhost:8080/gestion-salles/reservations

---

## 💡 Astuces

- **Hot reload** : Certains serveurs supportent le rechargement automatique
- **Logs** : Consultez toujours les logs du serveur en cas d'erreur
- **Base de données** : Les données sont perdues au redémarrage (H2 en mémoire)
- **Production** : Configurez une base de données persistante (MySQL, PostgreSQL)

---

Bon développement ! 🌶️

