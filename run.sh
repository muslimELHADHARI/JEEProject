#!/bin/bash

# Script de démarrage rapide pour l'application Gestion de Salles

echo "🌶️  Démarrage de l'application Gestion de Salles..."
echo ""

# Vérifier Java
if ! command -v java &> /dev/null; then
    echo "❌ Java n'est pas installé. Veuillez installer JDK 17+"
    exit 1
fi

# Vérifier Maven
if ! command -v mvn &> /dev/null; then
    echo "❌ Maven n'est pas installé. Veuillez installer Maven 3.6+"
    exit 1
fi

# Vérifier la version Java
JAVA_VERSION=$(java -version 2>&1 | awk -F '"' '/version/ {print $2}' | cut -d'.' -f1)
if [ "$JAVA_VERSION" -lt 17 ]; then
    echo "❌ Java 17+ est requis. Version actuelle: $JAVA_VERSION"
    exit 1
fi

echo "✅ Java et Maven détectés"
echo ""

# Compiler le projet
echo "📦 Compilation du projet..."
mvn clean package -DskipTests

if [ $? -ne 0 ]; then
    echo "❌ Erreur lors de la compilation"
    exit 1
fi

echo ""
echo "✅ Compilation réussie!"
echo ""
echo "🚀 Démarrage du serveur Jetty..."
echo ""
echo "📝 L'application sera accessible à: http://localhost:8080/gestion-salles/"
echo "📝 Compte admin: admin@salle.com / admin123"
echo ""
echo "Appuyez sur Ctrl+C pour arrêter le serveur"
echo ""

# Démarrer Jetty (supporte Jakarta EE)
mvn jetty:run

