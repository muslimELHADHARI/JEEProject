<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Connexion - Gestion de Salles</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = { darkMode: 'class' }
    </script>
    <style>
        @keyframes slideInRight {
            from { opacity: 0; transform: translateX(30px); }
            to { opacity: 1; transform: translateX(0); }
        }
        @keyframes slideInLeft {
            from { opacity: 0; transform: translateX(-30px); }
            to { opacity: 1; transform: translateX(0); }
        }
        @keyframes fadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }
        .animate-slide-in-right {
            animation: slideInRight 0.6s ease-out forwards;
        }
        .animate-slide-in-left {
            animation: slideInLeft 0.6s ease-out forwards;
        }
        .animate-fade-in {
            animation: fadeIn 0.8s ease-out forwards;
        }
        html {
            scroll-behavior: smooth;
        }
    </style>
</head>
<body class="min-h-screen bg-gray-50 dark:bg-gray-900 transition-colors duration-200">
    <div class="flex min-h-screen">
        <!-- Left Side - Content -->
        <div class="hidden lg:flex lg:w-1/2 bg-gradient-to-br from-orange-500 to-orange-700 dark:from-orange-600 dark:to-orange-800 p-12 flex-col justify-center animate-slide-in-left transition-colors duration-200">
            <div class="max-w-md">
                <div class="mb-8">
                    <div class="w-16 h-16 bg-white/20 backdrop-blur-sm rounded-xl flex items-center justify-center mb-6">
                        <svg class="w-8 h-8 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4"/>
                        </svg>
                    </div>
                    <h1 class="text-4xl font-bold text-white mb-4">Bienvenue</h1>
                    <p class="text-xl text-orange-100 leading-relaxed mb-6">
                        Connectez-vous à votre espace de gestion de salles et gérez vos réservations en toute simplicité.
                    </p>
                </div>
                
                <div class="space-y-4">
                    <div class="flex items-start space-x-3">
                        <svg class="w-6 h-6 text-white flex-shrink-0 mt-0.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"/>
                        </svg>
                        <div>
                            <h3 class="text-white font-semibold mb-1">Gestion simplifiée</h3>
                            <p class="text-orange-100 text-sm">Accédez rapidement à toutes vos salles et réservations</p>
                        </div>
                    </div>
                    <div class="flex items-start space-x-3">
                        <svg class="w-6 h-6 text-white flex-shrink-0 mt-0.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z"/>
                        </svg>
                        <div>
                            <h3 class="text-white font-semibold mb-1">Sécurité garantie</h3>
                            <p class="text-orange-100 text-sm">Vos données sont protégées avec une authentification sécurisée</p>
                        </div>
                    </div>
                    <div class="flex items-start space-x-3">
                        <svg class="w-6 h-6 text-white flex-shrink-0 mt-0.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 10V3L4 14h7v7l9-11h-7z"/>
                        </svg>
                        <div>
                            <h3 class="text-white font-semibold mb-1">Interface rapide</h3>
                            <p class="text-orange-100 text-sm">Navigation fluide et intuitive pour une expérience optimale</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Right Side - Login Form -->
        <div id="login-form" class="w-full lg:w-1/2 flex items-center justify-center p-8 animate-slide-in-right">
            <div class="w-full max-w-md">
                <div class="bg-white dark:bg-gray-800 rounded-xl shadow-lg p-8 border border-gray-200 dark:border-gray-700 transition-colors duration-200">
                    <div class="text-center mb-8">
                        <div class="inline-flex items-center justify-center w-16 h-16 bg-orange-100 rounded-xl mb-6 lg:hidden">
                            <svg class="w-8 h-8 text-orange-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4"/>
                            </svg>
                        </div>
                        <h1 class="text-3xl font-bold text-gray-900 dark:text-white mb-2">Connexion</h1>
                        <p class="text-gray-600 dark:text-gray-300">Accédez à votre espace de gestion</p>
                    </div>
                    
                    <c:if test="${not empty error}">
                        <div class="mb-6 p-4 bg-red-50 border-l-4 border-red-500 text-red-700 rounded-lg flex items-start">
                            <svg class="w-5 h-5 mr-3 mt-0.5 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/>
                            </svg>
                            <span>${error}</span>
                        </div>
                    </c:if>
                    
                    <c:if test="${not empty param.message}">
                        <div class="mb-6 p-4 bg-green-50 border-l-4 border-green-500 text-green-700 rounded-lg flex items-start">
                            <svg class="w-5 h-5 mr-3 mt-0.5 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"/>
                            </svg>
                            <span>${param.message}</span>
                        </div>
                    </c:if>
                    
                    <form action="${pageContext.request.contextPath}/login" method="post" class="space-y-6">
                        <div class="space-y-2">
                            <label for="email" class="block text-sm font-semibold text-gray-700 dark:text-gray-300">Email</label>
                            <input type="email" id="email" name="email" required
                                   class="w-full px-4 py-3 border border-gray-300 dark:border-gray-600 rounded-lg focus:ring-2 focus:ring-orange-500 focus:border-orange-500 transition-all duration-200 outline-none bg-white dark:bg-gray-700 text-gray-900 dark:text-white"
                                   placeholder="votre@email.com">
                        </div>
                        
                        <div class="space-y-2">
                            <label for="password" class="block text-sm font-semibold text-gray-700 dark:text-gray-300">Mot de passe</label>
                            <input type="password" id="password" name="password" required
                                   class="w-full px-4 py-3 border border-gray-300 dark:border-gray-600 rounded-lg focus:ring-2 focus:ring-orange-500 focus:border-orange-500 transition-all duration-200 outline-none bg-white dark:bg-gray-700 text-gray-900 dark:text-white"
                                   placeholder="••••••••">
                        </div>
                        
                        <button type="submit"
                                class="w-full bg-orange-600 text-white py-3 rounded-lg font-semibold hover:bg-orange-700 transition-colors duration-200 shadow-md hover:shadow-lg">
                            Se connecter
                        </button>
                    </form>
                    
                    <div class="mt-8 text-center">
                        <p class="text-gray-600 dark:text-gray-300">Pas encore de compte ? 
                            <a href="${pageContext.request.contextPath}/register#register-form" 
                               class="text-orange-600 font-semibold hover:text-orange-700 transition-colors duration-200">
                                Créer un compte
                            </a>
                        </p>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <script>
        // Smooth scroll to form on page load or when hash is present
        function scrollToForm() {
            const formElement = document.getElementById('login-form');
            if (formElement && window.innerWidth >= 1024) {
                setTimeout(function() {
                    formElement.scrollIntoView({ behavior: 'smooth', block: 'center' });
                }, 100);
            }
        }
        
        window.addEventListener('load', scrollToForm);
        
        // Also scroll if hash is in URL
        if (window.location.hash === '#login-form') {
            scrollToForm();
        }
    </script>
</body>
</html>
