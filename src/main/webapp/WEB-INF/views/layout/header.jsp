<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    com.salle.model.User user = (com.salle.model.User) session.getAttribute("user");
    pageContext.setAttribute("user", user);
%>
<header class="bg-white dark:bg-gray-800 shadow-md border-b border-gray-200 dark:border-gray-700 sticky top-0 z-50 transition-colors duration-200">
    <nav class="container mx-auto px-6 py-4">
        <div class="flex items-center justify-between">
            <div class="flex items-center space-x-3">
                <div class="w-10 h-10 bg-gradient-to-br from-orange-500 to-orange-700 rounded-lg flex items-center justify-center shadow-sm">
                    <svg class="w-6 h-6 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4"/>
                    </svg>
                </div>
                <a href="${pageContext.request.contextPath}/dashboard" 
                   class="text-xl font-bold text-gray-800 dark:text-white hover:text-orange-600 dark:hover:text-orange-400 transition-colors duration-200">
                    Gestion Salles
                </a>
            </div>
            <c:if test="${user != null}">
                <div class="flex items-center space-x-8">
                    <a href="${pageContext.request.contextPath}/dashboard" 
                       class="text-gray-700 dark:text-gray-300 hover:text-orange-600 dark:hover:text-orange-400 transition-colors duration-200 font-medium flex items-center space-x-1">
                        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6"/>
                        </svg>
                        <span>Dashboard</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/salles" 
                       class="text-gray-700 dark:text-gray-300 hover:text-orange-600 dark:hover:text-orange-400 transition-colors duration-200 font-medium flex items-center space-x-1">
                        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4"/>
                        </svg>
                        <span>Salles</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/reservations" 
                       class="text-gray-700 dark:text-gray-300 hover:text-orange-600 dark:hover:text-orange-400 transition-colors duration-200 font-medium flex items-center space-x-1">
                        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"/>
                        </svg>
                        <span>Réservations</span>
                    </a>
                    <c:if test="${user.role == 'ADMIN'}">
                        <a href="${pageContext.request.contextPath}/admin/users" 
                           class="text-gray-700 dark:text-gray-300 hover:text-orange-600 dark:hover:text-orange-400 transition-colors duration-200 font-medium flex items-center space-x-1">
                            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197M13 7a4 4 0 11-8 0 4 4 0 018 0z"/>
                            </svg>
                            <span>Administration</span>
                        </a>
                    </c:if>
                    <div class="flex items-center space-x-4 pl-6 border-l border-gray-300 dark:border-gray-600">
                        <!-- Dark Mode Toggle -->
                        <button id="darkModeToggle" 
                                class="p-2 rounded-lg text-gray-700 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-700 transition-colors duration-200"
                                aria-label="Toggle dark mode">
                            <!-- Sun icon (light mode) -->
                            <svg id="sunIcon" class="w-5 h-5 hidden dark:block" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 3v1m0 16v1m9-9h-1M4 12H3m15.364 6.364l-.707-.707M6.343 6.343l-.707-.707m12.728 0l-.707.707M6.343 17.657l-.707.707M16 12a4 4 0 11-8 0 4 4 0 018 0z"/>
                            </svg>
                            <!-- Moon icon (dark mode) -->
                            <svg id="moonIcon" class="w-5 h-5 block dark:hidden" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M20.354 15.354A9 9 0 018.646 3.646 9.003 9.003 0 0012 21a9.003 9.003 0 008.354-5.646z"/>
                            </svg>
                        </button>
                        <div class="text-right">
                            <p class="text-sm font-semibold text-gray-800 dark:text-white">${user.prenom} ${user.nom}</p>
                            <p class="text-xs text-gray-500 dark:text-gray-400">${user.role}</p>
                        </div>
                        <a href="${pageContext.request.contextPath}/logout" 
                           class="bg-gray-100 dark:bg-gray-700 text-gray-700 dark:text-gray-300 px-4 py-2 rounded-lg hover:bg-gray-200 dark:hover:bg-gray-600 transition-colors duration-200 font-medium flex items-center space-x-2">
                            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1"/>
                            </svg>
                            <span>Déconnexion</span>
                        </a>
                    </div>
                </div>
            </c:if>
            <c:if test="${user == null}">
                <div class="flex items-center space-x-4">
                    <!-- Dark Mode Toggle for non-logged users -->
                    <button id="darkModeToggle" 
                            class="p-2 rounded-lg text-gray-700 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-700 transition-colors duration-200"
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
            </c:if>
        </div>
    </nav>
</header>

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
