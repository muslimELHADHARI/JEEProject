<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<jsp:include page="../layout/header.jsp"/>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Réservations - Gestion de Salles</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = { darkMode: 'class' }
    </script>
</head>
<body class="min-h-screen bg-gray-50 dark:bg-gray-900 flex flex-col transition-colors duration-200">
    <div class="flex-1 container mx-auto px-6 py-8">
        <div class="flex justify-between items-center mb-8">
            <div>
                <h1 class="text-3xl font-bold text-gray-900 dark:text-white mb-2">Mes Réservations</h1>
                <p class="text-gray-600 dark:text-gray-300">Gérez vos réservations en temps réel</p>
            </div>
            <a href="${pageContext.request.contextPath}/reservations/new" 
               class="bg-orange-600 text-white px-6 py-3 rounded-lg font-semibold hover:bg-orange-700 transition-colors duration-200 shadow-md hover:shadow-lg flex items-center space-x-2">
                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"/>
                </svg>
                <span>Nouvelle réservation</span>
            </a>
        </div>
        
        <c:if test="${not empty param.message}">
            <div class="mb-6 p-4 bg-green-50 border-l-4 border-green-500 text-green-700 rounded-lg flex items-start">
                <svg class="w-5 h-5 mr-3 mt-0.5 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"/>
                </svg>
                <span>${param.message}</span>
            </div>
        </c:if>
        
        <c:if test="${not empty error}">
            <div class="mb-6 p-4 bg-red-50 border-l-4 border-red-500 text-red-700 rounded-lg flex items-start">
                <svg class="w-5 h-5 mr-3 mt-0.5 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/>
                </svg>
                <span>${error}</span>
            </div>
        </c:if>
        
        <div class="bg-white dark:bg-gray-800 rounded-lg shadow-md overflow-hidden border border-gray-200 dark:border-gray-700 transition-colors duration-200">
            <div class="overflow-x-auto">
                <table class="w-full">
                    <thead class="bg-gray-50 dark:bg-gray-700 border-b border-gray-200 dark:border-gray-600">
                        <tr>
                            <th class="px-6 py-4 text-left text-sm font-semibold text-gray-700 dark:text-gray-300">Salle</th>
                            <th class="px-6 py-4 text-left text-sm font-semibold text-gray-700">Date début</th>
                            <th class="px-6 py-4 text-left text-sm font-semibold text-gray-700">Date fin</th>
                            <th class="px-6 py-4 text-left text-sm font-semibold text-gray-700">Motif</th>
                            <c:if test="${user.role == 'ADMIN'}">
                                <th class="px-6 py-4 text-left text-sm font-semibold text-gray-700">Utilisateur</th>
                            </c:if>
                            <th class="px-6 py-4 text-left text-sm font-semibold text-gray-700">Statut</th>
                            <th class="px-6 py-4 text-left text-sm font-semibold text-gray-700">Actions</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-gray-200">
                        <c:choose>
                            <c:when test="${empty reservations}">
                                <tr>
                                    <td colspan="${user.role == 'ADMIN' ? 7 : 6}" class="px-6 py-12 text-center text-gray-500">
                                        <svg class="w-12 h-12 text-gray-300 mx-auto mb-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"/>
                                        </svg>
                                        <p>Aucune réservation</p>
                                    </td>
                                </tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="reservation" items="${reservations}">
                                    <tr class="hover:bg-gray-50 dark:hover:bg-gray-700 transition-colors duration-150">
                                        <td class="px-6 py-4 font-medium text-gray-900 dark:text-white">${reservation.salle.nom}</td>
                                        <td class="px-6 py-4 text-gray-600 dark:text-gray-300">
                                            <%
                                                DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
                                                com.salle.model.Reservation res = (com.salle.model.Reservation)pageContext.getAttribute("reservation");
                                                out.print(formatter.format(res.getDateDebut()));
                                            %>
                                        </td>
                                        <td class="px-6 py-4 text-gray-600">
                                            <%
                                                DateTimeFormatter formatter2 = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
                                                com.salle.model.Reservation res2 = (com.salle.model.Reservation)pageContext.getAttribute("reservation");
                                                out.print(formatter2.format(res2.getDateFin()));
                                            %>
                                        </td>
                                        <td class="px-6 py-4 text-gray-600">${reservation.motif != null ? reservation.motif : '-'}</td>
                                        <c:if test="${user.role == 'ADMIN'}">
                                            <td class="px-6 py-4 text-gray-600">${reservation.user.prenom} ${reservation.user.nom}</td>
                                        </c:if>
                                        <td class="px-6 py-4">
                                            <span class="px-3 py-1 rounded-full text-xs font-semibold
                                                <c:choose>
                                                    <c:when test="${reservation.statut == 'CONFIRMEE'}">bg-green-100 text-green-700</c:when>
                                                    <c:when test="${reservation.statut == 'ANNULEE'}">bg-red-100 text-red-700</c:when>
                                                    <c:otherwise>bg-yellow-100 text-yellow-700</c:otherwise>
                                                </c:choose>">
                                                ${reservation.statut}
                                            </span>
                                        </td>
                                        <td class="px-6 py-4">
                                            <div class="flex space-x-3">
                                                <a href="${pageContext.request.contextPath}/reservations/edit/${reservation.id}" 
                                                   class="text-orange-600 hover:text-orange-700 transition-colors duration-200"
                                                   title="Modifier">
                                                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"/>
                                                    </svg>
                                                </a>
                                                <c:if test="${user.role == 'ADMIN' || reservation.user.id == user.id}">
                                                    <form action="${pageContext.request.contextPath}/reservations" method="post" class="inline-block" onsubmit="return confirm('Êtes-vous sûr de vouloir annuler cette réservation ?');">
                                                        <input type="hidden" name="action" value="cancel"/>
                                                        <input type="hidden" name="id" value="${reservation.id}"/>
                                                        <button type="submit" class="text-red-600 hover:text-red-700 transition-colors duration-200" title="Annuler">
                                                            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"/>
                                                            </svg>
                                                        </button>
                                                    </form>
                                                </c:if>
                                                <c:if test="${user.role == 'ADMIN'}">
                                                    <form action="${pageContext.request.contextPath}/reservations" method="post" class="inline-block" onsubmit="return confirm('Êtes-vous sûr de vouloir supprimer cette réservation ?');">
                                                        <input type="hidden" name="action" value="delete"/>
                                                        <input type="hidden" name="id" value="${reservation.id}"/>
                                                        <button type="submit" class="text-red-600 hover:text-red-700 transition-colors duration-200" title="Supprimer">
                                                            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"/>
                                                            </svg>
                                                        </button>
                                                    </form>
                                                </c:if>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
    <jsp:include page="../layout/footer.jsp"/>
</body>
</html>
