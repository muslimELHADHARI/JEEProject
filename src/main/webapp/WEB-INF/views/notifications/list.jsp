<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="../layout/header.jsp"/>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mes Notifications - Gestion de Salles</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = { darkMode: 'class' }
    </script>
</head>
<body class="min-h-screen bg-gray-50 dark:bg-gray-900 flex flex-col transition-colors duration-200">
    <div class="flex-1 container mx-auto px-6 py-8">
        <div class="mb-8">
            <h1 class="text-3xl font-bold text-gray-900 dark:text-white mb-2">Mes Notifications</h1>
            <p class="text-gray-600 dark:text-gray-300">Toutes vos alertes et mises à jour importantes</p>
        </div>

        <c:if test="${not empty param.message}">
            <div class="mb-6 p-4 bg-green-50 border-l-4 border-green-500 text-green-700 rounded-lg flex items-start">
                <svg class="w-5 h-5 mr-3 mt-0.5 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"/>
                </svg>
                <span>${param.message}</span>
            </div>
        </c:if>

        <c:if test="${not empty param.error}">
            <div class="mb-6 p-4 bg-red-50 border-l-4 border-red-500 text-red-700 rounded-lg flex items-start">
                <svg class="w-5 h-5 mr-3 mt-0.5 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/>
                </svg>
                <span>${param.error}</span>
            </div>
        </c:if>

        <div class="bg-white dark:bg-gray-800 rounded-lg shadow-md p-6 border border-gray-200 dark:border-gray-700">
            <c:choose>
                <c:when test="${empty notifications}">
                    <div class="text-center py-16">
                        <svg class="w-20 h-20 text-gray-300 mx-auto mb-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 17h5l-1.405-1.405A2.032 2.032 0 0118 14.158V11a6.002 6.002 0 00-4-5.659V5a2 2 0 10-4 0v.341C7.67 6.165 6 8.388 6 11v3.159c0 .538-.214 1.055-.595 1.436L4 17h5m6 0v1a3 3 0 11-6 0v-1m6 0H9"/>
                        </svg>
                        <p class="text-gray-500 text-lg font-medium">Aucune nouvelle notification.</p>
                        <p class="text-gray-500 text-md">Revenez plus tard pour les mises à jour.</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <ul class="divide-y divide-gray-200 dark:divide-gray-700">
                        <c:forEach var="notification" items="${notifications}">
                            <li class="py-4 flex items-center justify-between <c:if test="${!notification.read}">bg-gray-50 dark:bg-gray-700</c:if>">
                                <div class="flex items-center">
                                    <c:if test="${!notification.read}">
                                        <span class="flex h-2 w-2 relative -left-2">
                                            <span class="animate-ping absolute inline-flex h-full w-full rounded-full bg-orange-400 opacity-75"></span>
                                            <span class="relative inline-flex rounded-full h-2 w-2 bg-orange-500"></span>
                                        </span>
                                    </c:if>
                                    <p class="text-sm text-gray-800 dark:text-gray-200 <c:if test="${!notification.read}">font-semibold</c:if>">${notification.message}</p>
                                </div>
                                <div class="flex items-center space-x-4">
                                    <span class="text-xs text-gray-500 dark:text-gray-400"><fmt:formatDate value="${notification.legacyTimestamp}" pattern="dd/MM/yyyy HH:mm"/></span>
                                    <c:if test="${!notification.read}">
                                        <a href="${pageContext.request.contextPath}/notifications/markAsRead/${notification.id}"
                                           class="text-blue-600 hover:text-blue-900 dark:text-blue-400 dark:hover:text-blue-300 text-sm font-medium">
                                            Marquer comme lu
                                        </a>
                                    </c:if>
                                </div>
                            </li>
                        </c:forEach>
                    </ul>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
    <jsp:include page="../layout/footer.jsp"/>
</body>
</html>
