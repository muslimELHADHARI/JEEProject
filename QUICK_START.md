# 🚀 Démarrage Rapide

## Problème résolu : Compatibilité Jakarta EE

Le projet utilise **Jakarta EE** (pas Java EE), donc il nécessite un serveur compatible :
- ✅ **Jetty 11+** (recommandé - déjà configuré)
- ✅ **Tomcat 10+** (manuel)
- ✅ **GlassFish/Payara**

## ⚡ Méthode la plus simple (30 secondes)

```bash
cd /home/enigma/Documents/GitHub/JEE
./run.sh
```

OU manuellement :

```bash
mvn clean package jetty:run
```

Puis ouvrez : **http://localhost:8080/gestion-salles/**

## 🔑 Compte admin par défaut

- **Email** : `admin@salle.com`
- **Mot de passe** : `admin123`

## ❌ Si vous voyez des erreurs

### Erreur : "jakarta.servlet.Filter not found"
➡️ Vous utilisez un serveur trop ancien. Utilisez Jetty 11+ ou Tomcat 10+.

### Erreur : "Port 8080 already in use"
```bash
# Trouver et tuer le processus
lsof -i :8080
kill -9 <PID>
```

### Erreur : "Java version"
➡️ Vérifiez que vous avez Java 17+ :
```bash
java -version
```

## 📖 Documentation complète

Voir `RUN.md` pour toutes les méthodes de déploiement.

