<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="../layout/header.jsp"/>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Salles - Gestion de Salles</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = { darkMode: 'class' }
    </script>
</head>
<body class="min-h-screen bg-gray-50 dark:bg-gray-900 flex flex-col transition-colors duration-200">
    <div class="flex-1 container mx-auto px-6 py-8">
        <div class="flex justify-between items-center mb-8">
            <div>
                <h1 class="text-3xl font-bold text-gray-900 dark:text-white mb-2">Liste des Salles</h1>
                <p class="text-gray-600 dark:text-gray-300">Gérez vos espaces de réunion</p>
            </div>
            <c:if test="${user.role == 'ADMIN'}">
                <a href="${pageContext.request.contextPath}/salles/new" 
                   class="bg-orange-600 text-white px-6 py-3 rounded-lg font-semibold hover:bg-orange-700 transition-colors duration-200 shadow-md hover:shadow-lg flex items-center space-x-2">
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"/>
                    </svg>
                    <span>Ajouter une salle</span>
                </a>
            </c:if>
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
        
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
            <c:choose>
                <c:when test="${empty salles}">
                    <div class="col-span-full text-center py-16">
                        <svg class="w-20 h-20 text-gray-300 mx-auto mb-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4"/>
                        </svg>
                        <p class="text-gray-500 text-lg font-medium">Aucune salle disponible</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <c:forEach var="salle" items="${salles}">
                        <div class="bg-white dark:bg-gray-800 rounded-lg shadow-md p-6 border border-gray-200 dark:border-gray-700 hover:shadow-lg transition-all duration-200">
                            <div class="flex justify-between items-start mb-4">
                                <h3 class="text-xl font-bold text-gray-900 dark:text-white">${salle.nom}</h3>
                                <span class="px-3 py-1 bg-orange-100 text-orange-700 rounded-full text-sm font-semibold">
                                    ${salle.capacite} places
                                </span>
                            </div>
                            <p class="text-gray-600 dark:text-gray-300 mb-4 line-clamp-2 leading-relaxed">${salle.description}</p>
                            <c:if test="${not empty salle.equipements}">
                                <p class="text-sm text-gray-500 mb-4">
                                    <strong>Équipements:</strong> ${salle.equipements}
                                </p>
                            </c:if>
                            <a href="${pageContext.request.contextPath}/reservations/new?salleId=${salle.id}"
                               class="block bg-orange-600 text-white px-4 py-2 rounded-lg text-center hover:bg-blue-700 transition-colors duration-200 font-medium mt-4">
                                Réserver cette salle
                            </a>
                            <c:if test="${user.role == 'ADMIN'}">
                                <div class="flex space-x-2 mt-4">
                                    <a href="${pageContext.request.contextPath}/salles/edit/${salle.id}" 
                                       class="flex-1 bg-gray-100 text-gray-700 px-4 py-2 rounded-lg text-center hover:bg-gray-200 transition-colors duration-200 font-medium flex items-center justify-center space-x-2">
                                        <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"/>
                                        </svg>
                                        <span>Modifier</span>
                                    </a>
                                    <form method="post" action="${pageContext.request.contextPath}/salles" class="flex-1">
                                        <input type="hidden" name="action" value="delete">
                                        <input type="hidden" name="id" value="${salle.id}">
                                        <button type="submit" 
                                                onclick="return confirm('Êtes-vous sûr de vouloir supprimer cette salle ?')"
                                                class="w-full bg-red-50 text-red-700 px-4 py-2 rounded-lg hover:bg-red-100 transition-colors duration-200 font-medium flex items-center justify-center space-x-2">
                                            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"/>
                                            </svg>
                                            <span>Supprimer</span>
                                        </button>
                                    </form>
                                </div>
                            </c:if>
                        </div>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
    <jsp:include page="../layout/footer.jsp"/>
</body>
</html>
