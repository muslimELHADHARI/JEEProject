<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<jsp:include page="layout/header.jsp"/>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - Gestion de Salles</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            darkMode: 'class',
        }
    </script>
    <style>
        @keyframes fadeInUp {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
        .animate-fade-in-up {
            animation: fadeInUp 0.5s ease-out forwards;
        }
    </style>
</head>
<body class="min-h-screen bg-gray-50 dark:bg-gray-900 flex flex-col transition-colors duration-200">
    <div class="flex-1 container mx-auto px-6 py-8">
        <!-- Welcome Section -->
        <div class="mb-10 animate-fade-in-up">
            <h1 class="text-4xl font-bold text-gray-900 dark:text-white mb-2">
                Bienvenue, ${user.prenom} ${user.nom}
            </h1>
            <p class="text-lg text-gray-600 dark:text-gray-300">Vue d'ensemble de votre système de gestion</p>
        </div>
        
        <c:if test="${not empty param.message}">
            <div class="mb-6 p-4 bg-green-50 border-l-4 border-green-500 text-green-700 rounded-lg flex items-start animate-fade-in-up">
                <svg class="w-5 h-5 mr-3 mt-0.5 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"/>
                </svg>
                <span class="font-semibold">${param.message}</span>
            </div>
        </c:if>
        
        <!-- Stats Cards -->
        <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-10">
            <div class="bg-white dark:bg-gray-800 rounded-xl shadow-md p-6 border border-gray-200 dark:border-gray-700 hover:shadow-lg transition-all duration-200 animate-fade-in-up">
                <div class="flex items-center justify-between">
                    <div>
                        <p class="text-sm font-medium text-gray-600 dark:text-gray-400 mb-1">Total Salles</p>
                        <p class="text-4xl font-bold text-gray-900 dark:text-white">${salles.size()}</p>
                    </div>
                    <div class="w-14 h-14 bg-orange-100 rounded-lg flex items-center justify-center">
                        <svg class="w-7 h-7 text-orange-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4"/>
                        </svg>
                    </div>
                </div>
            </div>
            
            <div class="bg-white rounded-xl shadow-md p-6 border border-gray-200 hover:shadow-lg transition-shadow duration-200 animate-fade-in-up" style="animation-delay: 0.1s;">
                <div class="flex items-center justify-between">
                    <div>
                        <p class="text-sm font-medium text-gray-600 mb-1">Réservations</p>
                        <p class="text-4xl font-bold text-gray-900">${reservations.size()}</p>
                    </div>
                    <div class="w-14 h-14 bg-orange-100 rounded-lg flex items-center justify-center">
                        <svg class="w-7 h-7 text-orange-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"/>
                        </svg>
                    </div>
                </div>
            </div>
            
            <div class="bg-white rounded-xl shadow-md p-6 border border-gray-200 hover:shadow-lg transition-shadow duration-200 animate-fade-in-up" style="animation-delay: 0.2s;">
                <div class="flex items-center justify-between">
                    <div>
                        <p class="text-sm font-medium text-gray-600 mb-1">Confirmées</p>
                        <p class="text-4xl font-bold text-gray-900">
                            <c:set var="confirmedCount" value="0"/>
                            <c:forEach var="res" items="${reservations}">
                                <c:if test="${res.statut == 'CONFIRMEE'}">
                                    <c:set var="confirmedCount" value="${confirmedCount + 1}"/>
                                </c:if>
                            </c:forEach>
                            ${confirmedCount}
                        </p>
                    </div>
                    <div class="w-14 h-14 bg-orange-100 rounded-lg flex items-center justify-center">
                        <svg class="w-7 h-7 text-orange-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"/>
                        </svg>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Main Content Grid -->
        <div class="grid grid-cols-1 lg:grid-cols-2 gap-8">
            <!-- Recent Reservations -->
            <div class="bg-white dark:bg-gray-800 rounded-xl shadow-md p-6 border border-gray-200 dark:border-gray-700 animate-fade-in-up transition-all duration-200" style="animation-delay: 0.3s;">
                <div class="flex items-center justify-between mb-6">
                    <h2 class="text-xl font-bold text-gray-900 dark:text-white flex items-center">
                        <svg class="w-6 h-6 mr-2 text-orange-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2"/>
                        </svg>
                        Réservations récentes
                    </h2>
                </div>
                <div class="space-y-4 max-h-96 overflow-y-auto">
                    <c:choose>
                        <c:when test="${empty reservations}">
                            <div class="text-center py-12">
                                <svg class="w-16 h-16 text-gray-300 mx-auto mb-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"/>
                                </svg>
                                <p class="text-gray-500">Aucune réservation</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="reservation" items="${reservations}" begin="0" end="4">
                                <div class="border-l-4 border-orange-500 bg-orange-50 p-4 rounded-lg hover:bg-orange-100 transition-colors duration-200">
                                    <div class="flex justify-between items-start">
                                        <div class="flex-1">
                                            <p class="font-semibold text-gray-900 mb-1">${reservation.salle.nom}</p>
                                            <p class="text-sm text-gray-600 mb-2">
                                                <%
                                                    DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
                                                    DateTimeFormatter timeFormatter = DateTimeFormatter.ofPattern("HH:mm");
                                                    com.salle.model.Reservation res = (com.salle.model.Reservation)pageContext.getAttribute("reservation");
                                                    out.print(dateFormatter.format(res.getDateDebut()) + " - " + timeFormatter.format(res.getDateFin()));
                                                %>
                                            </p>
                                            <c:if test="${not empty reservation.motif}">
                                                <p class="text-xs text-gray-500 italic">${reservation.motif}</p>
                                            </c:if>
                                        </div>
                                        <span class="px-3 py-1 bg-white text-orange-700 rounded-full text-xs font-semibold border border-orange-200">
                                            ${reservation.statut}
                                        </span>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </div>
                <a href="${pageContext.request.contextPath}/reservations" 
                   class="mt-6 inline-flex items-center text-orange-600 hover:text-orange-700 font-semibold transition-colors duration-200">
                    Voir toutes les réservations
                    <svg class="w-4 h-4 ml-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"/>
                    </svg>
                </a>
            </div>
            
            <!-- Quick Actions -->
            <div class="bg-white rounded-xl shadow-md p-6 border border-gray-200 animate-fade-in-up" style="animation-delay: 0.4s;">
                <h2 class="text-xl font-bold text-gray-900 mb-6 flex items-center">
                    <svg class="w-6 h-6 mr-2 text-orange-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 10V3L4 14h7v7l9-11h-7z"/>
                    </svg>
                    Actions rapides
                </h2>
                <div class="space-y-3">
                    <a href="${pageContext.request.contextPath}/reservations/new" 
                       class="block w-full bg-orange-600 text-white py-3 px-6 rounded-lg font-semibold hover:bg-orange-700 transition-colors duration-200 shadow-md hover:shadow-lg text-center flex items-center justify-center space-x-2">
                        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"/>
                        </svg>
                        <span>Nouvelle réservation</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/salles" 
                       class="block w-full bg-gray-100 text-gray-700 py-3 px-6 rounded-lg font-semibold hover:bg-gray-200 transition-colors duration-200 border border-gray-300 text-center flex items-center justify-center space-x-2">
                        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4"/>
                        </svg>
                        <span>Voir les salles</span>
                    </a>
                    <c:if test="${user.role == 'ADMIN'}">
                        <a href="${pageContext.request.contextPath}/salles/new" 
                           class="block w-full bg-gray-100 text-gray-700 py-3 px-6 rounded-lg font-semibold hover:bg-gray-200 transition-colors duration-200 border border-gray-300 text-center flex items-center justify-center space-x-2">
                            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"/>
                            </svg>
                            <span>Ajouter une salle</span>
                        </a>
                        <a href="${pageContext.request.contextPath}/admin/users" 
                           class="block w-full bg-gray-100 text-gray-700 py-3 px-6 rounded-lg font-semibold hover:bg-gray-200 transition-colors duration-200 border border-gray-300 text-center flex items-center justify-center space-x-2">
                            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197M13 7a4 4 0 11-8 0 4 4 0 018 0z"/>
                            </svg>
                            <span>Gérer les utilisateurs</span>
                        </a>
                    </c:if>
                </div>
            </div>
        </div>
    </div>
    <jsp:include page="layout/footer.jsp"/>
</body>
</html>
