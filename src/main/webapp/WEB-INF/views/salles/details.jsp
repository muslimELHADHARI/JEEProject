<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <jsp:include page="../layout/header.jsp" />
        <!DOCTYPE html>
        <html lang="fr">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Détails de la Salle - ${salle.nom}</title>
            <script src="https://cdn.tailwindcss.com"></script>
            <script>
                tailwind.config = { darkMode: 'class' }
            </script>
        </head>

        <body class="min-h-screen bg-gray-50 dark:bg-gray-900 flex flex-col transition-colors duration-200">
            <div class="flex-1 container mx-auto px-6 py-8">
                <div class="mb-6">
                    <a href="${pageContext.request.contextPath}/salles"
                        class="text-gray-600 dark:text-gray-400 hover:text-orange-600 dark:hover:text-orange-400 flex items-center space-x-2 transition-colors duration-200">
                        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                d="M10 19l-7-7m0 0l7-7m-7 7h18" />
                        </svg>
                        <span>Retour à la liste</span>
                    </a>
                </div>

                <div
                    class="bg-white dark:bg-gray-800 rounded-lg shadow-xl overflow-hidden border border-gray-200 dark:border-gray-700">
                    <!-- Header Image -->
                    <div class="relative h-64 md:h-96 w-full bg-gray-200 dark:bg-gray-700">
                        <c:if test="${not empty salle.imagePath}">
                            <img src="${pageContext.request.contextPath}/${salle.imagePath}" alt="${salle.nom}"
                                class="w-full h-full object-cover">
                        </c:if>
                        <c:if test="${empty salle.imagePath}">
                            <div class="w-full h-full flex items-center justify-center">
                                <svg class="w-24 h-24 text-gray-400" fill="none" stroke="currentColor"
                                    viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                        d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z" />
                                </svg>
                            </div>
                        </c:if>
                        <div
                            class="absolute bottom-0 left-0 right-0 bg-gradient-to-t from-black/80 to-transparent p-6 md:p-8">
                            <h1 class="text-3xl md:text-4xl font-bold text-white mb-2">${salle.nom}</h1>
                            <div class="flex items-center space-x-4 text-white/90 flex-wrap gap-y-2">
                                <span class="flex items-center space-x-1">
                                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                            d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0zm6 3a2 2 0 11-4 0 2 2 0 014 0zM7 10a2 2 0 11-4 0 2 2 0 014 0z" />
                                    </svg>
                                    <span>${salle.capacite} personnes</span>
                                </span>
                                <c:if test="${not empty salle.location}">
                                    <span class="flex items-center space-x-1">
                                        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                                d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z" />
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                                d="M15 11a3 3 0 11-6 0 3 3 0 016 0z" />
                                        </svg>
                                        <span>${salle.location}</span>
                                    </span>
                                </c:if>
                            </div>
                        </div>
                    </div>

                    <div class="p-6 md:p-8 grid grid-cols-1 lg:grid-cols-3 gap-8">
                        <!-- Main Content -->
                        <div class="lg:col-span-2 space-y-8">
                            <div>
                                <h2 class="text-2xl font-semibold text-gray-900 dark:text-white mb-4">À propos</h2>
                                <p class="text-gray-600 dark:text-gray-300 text-lg leading-relaxed">${salle.description}
                                </p>
                            </div>

                            <c:if test="${not empty salle.equipements}">
                                <div>
                                    <h2 class="text-2xl font-semibold text-gray-900 dark:text-white mb-4">Équipements
                                    </h2>
                                    <div
                                        class="bg-gray-50 dark:bg-gray-700/50 p-6 rounded-xl border border-gray-100 dark:border-gray-700">
                                        <p class="text-gray-700 dark:text-gray-300">${salle.equipements}</p>
                                    </div>
                                </div>
                            </c:if>

                            <c:if test="${not empty salle.videoPath}">
                                <div id="video-section">
                                    <h2 class="text-2xl font-semibold text-gray-900 dark:text-white mb-4">Vidéo de
                                        présentation</h2>
                                    <div
                                        class="rounded-xl overflow-hidden shadow-lg border border-gray-200 dark:border-gray-700 bg-black">
                                        <video src="${pageContext.request.contextPath}/${salle.videoPath}" controls
                                            class="w-full aspect-video"></video>
                                    </div>
                                </div>
                            </c:if>
                        </div>

                        <!-- Sidebar Actions -->
                        <div class="transform lg:-translate-y-4">
                            <div
                                class="bg-white dark:bg-gray-800 rounded-xl shadow-lg border-t-4 border-orange-500 p-6 sticky top-8">
                                <h3 class="text-xl font-bold text-gray-900 dark:text-white mb-4">Actions</h3>

                                <a href="${pageContext.request.contextPath}/reservations/new?salleId=${salle.id}"
                                    class="block w-full bg-orange-600 text-white text-center py-4 rounded-xl font-bold hover:bg-orange-700 transition-all duration-300 shadow-lg hover:shadow-orange-500/30 transform hover:-translate-y-1 mb-4">
                                    Réserver maintenant
                                </a>

                                <c:if test="${not empty salle.videoPath}">
                                    <a href="#video-section"
                                        class="block w-full bg-orange-600 text-white text-center py-4 rounded-xl font-bold hover:bg-orange-700 transition-all duration-300 shadow-lg hover:shadow-blue-500/30 transform hover:-translate-y-1 mb-4">
                                        Voir la vidéo
                                    </a>
                                </c:if>

                                <c:if test="${user.role == 'ADMIN'}">
                                    <div class="space-y-3 pt-4 border-t border-gray-100 dark:border-gray-700">
                                        <a href="${pageContext.request.contextPath}/salles/edit/${salle.id}"
                                            class="block w-full bg-gray-100 dark:bg-gray-700 text-gray-700 dark:text-gray-200 text-center py-3 rounded-lg font-semibold hover:bg-gray-200 dark:hover:bg-gray-600 transition-colors duration-200">
                                            Modifier la salle
                                        </a>
                                        <form method="post" action="${pageContext.request.contextPath}/salles">
                                            <input type="hidden" name="action" value="delete">
                                            <input type="hidden" name="id" value="${salle.id}">
                                            <button type="submit"
                                                onclick="return confirm('Êtes-vous sûr de vouloir supprimer cette salle ?')"
                                                class="block w-full bg-red-50 text-red-600 text-center py-3 rounded-lg font-semibold hover:bg-red-100 transition-colors duration-200">
                                                Supprimer
                                            </button>
                                        </form>
                                    </div>
                                </c:if>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <jsp:include page="../layout/footer.jsp" />
        </body>

        </html>