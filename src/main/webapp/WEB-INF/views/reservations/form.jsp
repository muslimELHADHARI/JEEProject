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
    <title>${reservation != null ? 'Modifier' : 'Créer'} une Réservation - Gestion de Salles</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = { darkMode: 'class' }
    </script>
    <style>
        @keyframes fadeInUp {
            from { opacity: 0; transform: translateY(30px); }
            to { opacity: 1; transform: translateY(0); }
        }
        @keyframes scaleIn {
            from { opacity: 0; transform: scale(0.95); }
            to { opacity: 1; transform: scale(1); }
        }
        .animate-fade-in-up {
            animation: fadeInUp 0.6s ease-out forwards;
        }
        .animate-scale-in {
            animation: scaleIn 0.5s ease-out forwards;
        }
        .input-focus:focus {
            transform: translateY(-2px);
            box-shadow: 0 10px 25px rgba(234, 88, 12, 0.2);
        }
    </style>
</head>
<body class="min-h-screen bg-gray-50 dark:bg-gray-900 flex flex-col transition-colors duration-200">
    <div class="flex-1 container mx-auto px-6 py-8">
        <div class="max-w-3xl mx-auto">
            <div class="mb-8">
                <h1 class="text-3xl font-bold text-gray-900 dark:text-white mb-2">
                    ${reservation != null ? 'Modifier la Réservation' : 'Créer une Nouvelle Réservation'}
                </h1>
                <p class="text-gray-600 dark:text-gray-300">${reservation != null ? 'Modifiez les détails de votre réservation' : 'Réservez une salle pour votre événement'}</p>
            </div>
            
            <c:if test="${not empty error}">
                <div class="mb-6 p-4 bg-red-50 border-l-4 border-red-500 text-red-700 rounded-lg flex items-start">
                    <svg class="w-5 h-5 mr-3 mt-0.5 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/>
                    </svg>
                    <span class="font-semibold">${error}</span>
                </div>
            </c:if>
            
            <c:if test="${addedToWaitingList}">
                <div class="mb-6 p-4 bg-blue-50 border-l-4 border-blue-500 text-blue-700 rounded-lg flex items-start">
                    <svg class="w-5 h-5 mr-3 mt-0.5 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/>
                    </svg>
                    <span class="font-semibold">${successMessage}</span>
                </div>
            </c:if>
            
            <div class="bg-white dark:bg-gray-800 rounded-lg shadow-md p-8 border border-gray-200 dark:border-gray-700 transition-colors duration-200">
                <form method="post" action="${pageContext.request.contextPath}/reservations" class="space-y-6">
                    <c:if test="${reservation != null}">
                        <input type="hidden" name="id" value="${reservation.id}">
                    </c:if>
                    
                    <div class="space-y-2">
                        <label for="salleId" class="block text-sm font-semibold text-gray-700 dark:text-gray-300">Salle *</label>
                        <c:if test="${selectedSalle != null}">
                            <input type="text" id="salleDisplay" value="${selectedSalle.nom} (${selectedSalle.capacite} places)" readonly
                                   class="w-full px-4 py-3 border border-gray-300 dark:border-gray-600 rounded-lg bg-gray-100 dark:bg-gray-700 text-gray-900 dark:text-white cursor-not-allowed opacity-80">
                            <input type="hidden" name="salleId" value="${selectedSalle.id}">
                        </c:if>
                        <c:if test="${selectedSalle == null}">
                            <select id="salleId" name="salleId" required
                                    class="w-full px-4 py-3 border border-gray-300 dark:border-gray-600 rounded-lg focus:ring-2 focus:ring-orange-500 focus:border-orange-500 transition-all duration-200 outline-none bg-white dark:bg-gray-700 text-gray-900 dark:text-white">
                                <option value="">Sélectionner une salle</option>
                                <c:forEach var="salle" items="${salles}">
                                    <option value="${salle.id}" 
                                            ${(reservation != null && reservation.salle.id == salle.id) || (param.salleId == salle.id) ? 'selected' : ''}>
                                        ${salle.nom} (${salle.capacite} places)
                                    </option>
                                </c:forEach>
                            </select>
                        </c:if>
                    </div>
                    
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-5">
                        <div class="space-y-2">
                            <label for="dateDebut" class="block text-sm font-semibold text-gray-700 dark:text-gray-300">Date de début *</label>
                            <input type="datetime-local" id="dateDebut" name="dateDebut" required
                                   value="<c:choose><c:when test="${not empty dateDebut}">${dateDebut}</c:when><c:when test="${reservation != null}"><fmt:formatDate value="${reservation.dateDebut}" pattern="yyyy-MM-dd'T'HH:mm"/></c:when><c:otherwise></c:otherwise></c:choose>"
                                   class="w-full px-4 py-3 border border-gray-300 dark:border-gray-600 rounded-lg focus:ring-2 focus:ring-orange-500 focus:border-orange-500 transition-all duration-200 outline-none bg-white dark:bg-gray-700 text-gray-900 dark:text-white">
                        </div>
                        <div class="space-y-2">
                            <label for="dateFin" class="block text-sm font-semibold text-gray-700 dark:text-gray-300">Date de fin *</label>
                            <input type="datetime-local" id="dateFin" name="dateFin" required
                                   value="<c:choose><c:when test="${not empty dateFin}">${dateFin}</c:when><c:when test="${reservation != null}"><fmt:formatDate value="${reservation.dateFin}" pattern="yyyy-MM-dd'T'HH:mm"/></c:when><c:otherwise></c:otherwise></c:choose>"
                                   class="w-full px-4 py-3 border border-gray-300 dark:border-gray-600 rounded-lg focus:ring-2 focus:ring-orange-500 focus:border-orange-500 transition-all duration-200 outline-none bg-white dark:bg-gray-700 text-gray-900 dark:text-white">
                        </div>
                    </div>
                    
                    <div class="space-y-2">
                        <label for="motif" class="block text-sm font-semibold text-gray-700 dark:text-gray-300">Motif</label>
                        <textarea id="motif" name="motif" rows="4"
                                  class="w-full px-4 py-3 border border-gray-300 dark:border-gray-600 rounded-lg focus:ring-2 focus:ring-orange-500 focus:border-orange-500 transition-all duration-200 outline-none bg-white dark:bg-gray-700 text-gray-900 dark:text-white resize-none"
                                  placeholder="Décrivez le motif de votre réservation..."><c:out value='${not empty motif ? motif : (reservation != null ? reservation.motif : "")}'/></textarea>
                    </div>
                    
                    <div class="flex flex-col sm:flex-row gap-4 pt-4">
                        <button type="submit"
                                class="flex-1 bg-orange-600 text-white py-3 rounded-lg font-semibold hover:bg-orange-700 transition-colors duration-200 shadow-md hover:shadow-lg flex items-center justify-center space-x-2">
                            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="${reservation != null ? 'M5 13l4 4L19 7' : 'M12 4v16m8-8H4'}"/>
                            </svg>
                            <span>${reservation != null ? 'Modifier' : 'Créer la réservation'}</span>
                        </button>
                        <a href="${pageContext.request.contextPath}/reservations"
                           class="flex-1 bg-gray-100 dark:bg-gray-700 text-gray-700 dark:text-gray-300 py-3 rounded-lg font-semibold hover:bg-gray-200 dark:hover:bg-gray-600 text-center transition-colors duration-200 border border-gray-300 dark:border-gray-600">
                            Annuler
                        </a>
                    </div>
                </form>
            </div>
        </div>
    </div>
    <jsp:include page="../layout/footer.jsp"/>
</body>
</html>

