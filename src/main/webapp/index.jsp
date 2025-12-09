<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    com.salle.model.User user = (com.salle.model.User) session.getAttribute("user");
    if (user != null) {
        response.sendRedirect(request.getContextPath() + "/dashboard");
        return;
    }
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestion et Réservation de Salles - Solution Professionnelle</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        // Configure Tailwind dark mode
        tailwind.config = {
            darkMode: 'class',
        }
    </script>
    <script>
        // Dark Mode Toggle Script
        (function() {
            // Check for saved theme preference or default to light mode
            const theme = localStorage.getItem('theme') || 'light';
            const html = document.documentElement;
            
            // Apply theme immediately to prevent flash
            if (theme === 'dark') {
                html.classList.add('dark');
            } else {
                html.classList.remove('dark');
            }
            
            // Function to toggle dark mode
            function toggleDarkMode() {
                const html = document.documentElement;
                const isDark = html.classList.contains('dark');
                
                if (isDark) {
                    html.classList.remove('dark');
                    localStorage.setItem('theme', 'light');
                } else {
                    html.classList.add('dark');
                    localStorage.setItem('theme', 'dark');
                }
            }
            
            // Add event listeners to all toggle buttons
            document.addEventListener('DOMContentLoaded', function() {
                const toggleButtons = document.querySelectorAll('#darkModeToggle');
                toggleButtons.forEach(button => {
                    button.addEventListener('click', toggleDarkMode);
                });
            });
        })();
    </script>
    <script src="https://unpkg.com/heroicons@2.0.18/24/outline/index.js" type="module"></script>
    <style>
        @keyframes fadeInUp {
            from { opacity: 0; transform: translateY(30px); }
            to { opacity: 1; transform: translateY(0); }
        }
        @keyframes fadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }
        .animate-fade-in-up {
            animation: fadeInUp 0.8s ease-out forwards;
        }
        .animate-fade-in {
            animation: fadeIn 1s ease-out forwards;
        }
    </style>
</head>
<body class="min-h-screen bg-gradient-to-br from-slate-50 via-orange-50 to-slate-100 dark:from-gray-900 dark:via-gray-800 dark:to-gray-900 transition-colors duration-200">
    <!-- Header -->
    <header class="bg-white dark:bg-gray-800 shadow-sm border-b border-orange-100 dark:border-gray-700 transition-colors duration-200">
        <nav class="container mx-auto px-6 py-4">
            <div class="flex items-center justify-between">
                <div class="flex items-center space-x-3">
                    <div class="w-10 h-10 bg-gradient-to-br from-orange-500 to-orange-700 rounded-lg flex items-center justify-center shadow-md">
                        <svg class="w-6 h-6 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4"/>
                        </svg>
                    </div>
                    <span class="text-2xl font-bold text-gray-800 dark:text-white">Gestion Salles</span>
                </div>
                <div class="flex items-center space-x-4">
                    <button id="darkModeToggle" 
                            class="p-2 rounded-lg text-gray-700 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-700 transition-colors duration-200 mr-2"
                            aria-label="Toggle dark mode">
                        <svg id="sunIcon" class="w-5 h-5 hidden dark:block" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 3v1m0 16v1m9-9h-1M4 12H3m15.364 6.364l-.707-.707M6.343 6.343l-.707-.707m12.728 0l-.707.707M6.343 17.657l-.707.707M16 12a4 4 0 11-8 0 4 4 0 018 0z"/>
                        </svg>
                        <svg id="moonIcon" class="w-5 h-5 block dark:hidden" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M20.354 15.354A9 9 0 018.646 3.646 9.003 9.003 0 0012 21a9.003 9.003 0 008.354-5.646z"/>
                        </svg>
                    </button>
                    <a href="${pageContext.request.contextPath}/login#login-form" 
                       class="text-gray-700 dark:text-gray-300 hover:text-orange-600 dark:hover:text-orange-400 font-medium transition-colors duration-200">
                        Connexion
                    </a>
                    <a href="${pageContext.request.contextPath}/register#register-form" 
                       class="bg-orange-600 dark:bg-orange-700 text-white px-6 py-2 rounded-lg font-semibold hover:bg-orange-700 dark:hover:bg-orange-600 transition-colors duration-200 shadow-md">
                        Inscription
                    </a>
                </div>
            </div>
        </nav>
    </header>

    <!-- Hero Section -->
    <section class="container mx-auto px-6 py-20">
        <div class="max-w-4xl mx-auto text-center animate-fade-in-up">
            <h1 class="text-5xl md:text-6xl font-bold text-gray-900 dark:text-white mb-6 leading-tight">
                Gestion Professionnelle<br/>
                <span class="text-orange-600 dark:text-orange-400">de vos Espaces</span>
            </h1>
            <p class="text-xl text-gray-600 dark:text-gray-300 mb-12 max-w-2xl mx-auto leading-relaxed">
                Solution complète pour la gestion et la réservation de salles de réunion. 
                Optimisez l'utilisation de vos espaces avec notre plateforme intuitive.
            </p>
            <div class="flex flex-col sm:flex-row justify-center gap-4">
                <a href="${pageContext.request.contextPath}/login#login-form" 
                   class="bg-orange-600 text-white px-8 py-4 rounded-lg font-semibold text-lg hover:bg-orange-700 transition-all duration-200 shadow-lg hover:shadow-xl">
                    Commencer maintenant
                </a>
                <a href="${pageContext.request.contextPath}/register#register-form" 
                   class="bg-white text-orange-600 px-8 py-4 rounded-lg font-semibold text-lg border-2 border-orange-600 hover:bg-orange-50 transition-all duration-200 shadow-md">
                    Créer un compte
                </a>
            </div>
        </div>
    </section>

    <!-- Features Section -->
    <section class="bg-white dark:bg-gray-800 py-20 transition-colors duration-200">
        <div class="container mx-auto px-6">
            <div class="text-center mb-16">
                <h2 class="text-4xl font-bold text-gray-900 dark:text-white mb-4">Fonctionnalités Principales</h2>
                <p class="text-xl text-gray-600 dark:text-gray-300 max-w-2xl mx-auto">Tout ce dont vous avez besoin pour gérer efficacement vos salles</p>
            </div>
            
            <div class="grid grid-cols-1 md:grid-cols-3 gap-8 max-w-6xl mx-auto">
                <div class="bg-gradient-to-br from-orange-50 to-white p-8 rounded-xl border border-orange-100 hover:shadow-lg transition-shadow duration-300">
                    <div class="w-14 h-14 bg-orange-100 rounded-lg flex items-center justify-center mb-6">
                        <svg class="w-7 h-7 text-orange-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4"/>
                        </svg>
                    </div>
                    <h3 class="text-xl font-bold text-gray-900 dark:text-white mb-3">Gestion des Salles</h3>
                    <p class="text-gray-600 dark:text-gray-300 leading-relaxed">Créez et gérez vos espaces avec des informations détaillées : capacité, équipements, disponibilité.</p>
                </div>
                
                <div class="bg-gradient-to-br from-orange-50 to-white p-8 rounded-xl border border-orange-100 hover:shadow-lg transition-shadow duration-300">
                    <div class="w-14 h-14 bg-orange-100 rounded-lg flex items-center justify-center mb-6">
                        <svg class="w-7 h-7 text-orange-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"/>
                        </svg>
                    </div>
                    <h3 class="text-xl font-bold text-gray-900 dark:text-white mb-3">Réservation Intelligente</h3>
                    <p class="text-gray-600 dark:text-gray-300 leading-relaxed">Système automatique de détection des conflits pour éviter les chevauchements de réservations.</p>
                </div>
                
                <div class="bg-gradient-to-br from-orange-50 to-white p-8 rounded-xl border border-orange-100 hover:shadow-lg transition-shadow duration-300">
                    <div class="w-14 h-14 bg-orange-100 rounded-lg flex items-center justify-center mb-6">
                        <svg class="w-7 h-7 text-orange-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z"/>
                        </svg>
                    </div>
                    <h3 class="text-xl font-bold text-gray-900 dark:text-white mb-3">Sécurité Avancée</h3>
                    <p class="text-gray-600 dark:text-gray-300 leading-relaxed">Authentification sécurisée avec gestion des rôles et permissions pour protéger vos données.</p>
                </div>
            </div>
        </div>
    </section>

    <!-- Additional Features -->
    <section class="py-16 bg-gradient-to-br from-slate-50 to-orange-50 dark:from-gray-800 dark:to-gray-900 transition-colors duration-200">
        <div class="container mx-auto px-6">
            <div class="grid grid-cols-2 md:grid-cols-4 gap-8 max-w-5xl mx-auto">
                <div class="text-center">
                    <div class="w-12 h-12 bg-orange-100 rounded-lg flex items-center justify-center mx-auto mb-3">
                        <svg class="w-6 h-6 text-orange-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 10V3L4 14h7v7l9-11h-7z"/>
                        </svg>
                    </div>
                    <p class="text-gray-700 dark:text-gray-300 font-semibold">Performance</p>
                </div>
                <div class="text-center">
                    <div class="w-12 h-12 bg-orange-100 rounded-lg flex items-center justify-center mx-auto mb-3">
                        <svg class="w-6 h-6 text-orange-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9.663 17h4.673M12 3v1m6.364 1.636l-.707.707M21 12h-1M4 12H3m3.343-5.657l-.707-.707m2.828 9.9a5 5 0 117.072 0l-.548.547A3.374 3.374 0 0014 18.469V19a2 2 0 11-4 0v-.531c0-.895-.356-1.754-.988-2.386l-.548-.547z"/>
                        </svg>
                    </div>
                    <p class="text-gray-700 dark:text-gray-300 font-semibold">Innovation</p>
                </div>
                <div class="text-center">
                    <div class="w-12 h-12 bg-orange-100 rounded-lg flex items-center justify-center mx-auto mb-3">
                        <svg class="w-6 h-6 text-orange-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 18h.01M8 21h8a2 2 0 002-2V5a2 2 0 00-2-2H8a2 2 0 00-2 2v14a2 2 0 002 2z"/>
                        </svg>
                    </div>
                    <p class="text-gray-700 dark:text-gray-300 font-semibold">Mobile</p>
                </div>
                <div class="text-center">
                    <div class="w-12 h-12 bg-orange-100 rounded-lg flex items-center justify-center mx-auto mb-3">
                        <svg class="w-6 h-6 text-orange-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"/>
                        </svg>
                    </div>
                    <p class="text-gray-700 dark:text-gray-300 font-semibold">Fiabilité</p>
                </div>
            </div>
        </div>
    </section>

    <!-- Footer -->
    <footer class="bg-gray-900 dark:bg-gray-950 text-white py-12 transition-colors duration-200">
        <div class="container mx-auto px-6 text-center">
            <p class="text-gray-400">© 2024 Gestion et Réservation de Salles. Tous droits réservés.</p>
        </div>
    </footer>
    
</body>
</html>
