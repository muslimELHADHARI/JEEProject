<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <jsp:include page="../layout/header.jsp" />
        <!DOCTYPE html>
        <html lang="fr">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>${salle != null ? 'Modifier' : 'Créer'} une Salle - Gestion de Salles</title>
            <script src="https://cdn.tailwindcss.com"></script>
            <script>
                tailwind.config = { darkMode: 'class' }
            </script>
            <style>
                @keyframes fadeInUp {
                    from {
                        opacity: 0;
                        transform: translateY(30px);
                    }

                    to {
                        opacity: 1;
                        transform: translateY(0);
                    }
                }

                @keyframes scaleIn {
                    from {
                        opacity: 0;
                        transform: scale(0.95);
                    }

                    to {
                        opacity: 1;
                        transform: scale(1);
                    }
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
                            ${salle != null ? 'Modifier la Salle' : 'Créer une Nouvelle Salle'}
                        </h1>
                        <p class="text-gray-600 dark:text-gray-300">${salle != null ? 'Modifiez les informations de la
                            salle' : 'Ajoutez une nouvelle salle à votre système'}</p>
                    </div>

                    <c:if test="${not empty error}">
                        <div
                            class="mb-6 p-4 bg-red-50 border-l-4 border-red-500 text-red-700 rounded-lg flex items-start">
                            <svg class="w-5 h-5 mr-3 mt-0.5 flex-shrink-0" fill="none" stroke="currentColor"
                                viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                    d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
                            </svg>
                            <span class="font-semibold">${error}</span>
                        </div>
                    </c:if>

                    <div
                        class="bg-white dark:bg-gray-800 rounded-lg shadow-md p-8 border border-gray-200 dark:border-gray-700 transition-colors duration-200">
                        <form method="post" action="${pageContext.request.contextPath}/salles"
                            enctype="multipart/form-data" class="space-y-6">
                            <c:if test="${salle != null}">
                                <input type="hidden" name="id" value="${salle.id}">
                            </c:if>

                            <div class="space-y-2">
                                <label for="nom" class="block text-sm font-bold text-gray-700">Nom de la salle *</label>
                                <input type="text" id="nom" name="nom" required
                                    value="${salle != null ? salle.nom : ''}"
                                    class="w-full px-5 py-4 border-2 border-orange-200 rounded-xl focus:border-orange-500 focus:ring-4 focus:ring-orange-200 transition-all duration-300 outline-none input-focus bg-white"
                                    placeholder="Ex: Salle de Conférence A">
                            </div>

                            <div class="space-y-2">
                                <label for="description" class="block text-sm font-bold text-gray-700">Description
                                    *</label>
                                <textarea id="description" name="description" required rows="5"
                                    class="w-full px-5 py-4 border-2 border-orange-200 rounded-xl focus:border-orange-500 focus:ring-4 focus:ring-orange-200 transition-all duration-300 outline-none input-focus bg-white resize-none"
                                    placeholder="Décrivez la salle, ses caractéristiques...">${salle != null ? salle.description : ''}</textarea>
                            </div>

                            <div class="grid grid-cols-1 md:grid-cols-2 gap-5">
                                <div class="space-y-2">
                                    <label for="capacite" class="block text-sm font-bold text-gray-700">Capacité
                                        *</label>
                                    <input type="number" id="capacite" name="capacite" required min="1"
                                        value="${salle != null ? salle.capacite : ''}"
                                        class="w-full px-5 py-4 border-2 border-orange-200 rounded-xl focus:border-orange-500 focus:ring-4 focus:ring-orange-200 transition-all duration-300 outline-none input-focus bg-white"
                                        placeholder="Nombre de places">
                                </div>

                                <div class="space-y-2">
                                    <label for="equipements"
                                        class="block text-sm font-bold text-gray-700">Équipements</label>
                                    <input type="text" id="equipements" name="equipements"
                                        value="${salle != null ? salle.equipements : ''}"
                                        placeholder="Ex: Projecteur, Tableau blanc, Wi-Fi"
                                        class="w-full px-5 py-4 border-2 border-orange-200 rounded-xl focus:border-orange-500 focus:ring-4 focus:ring-orange-200 transition-all duration-300 outline-none input-focus bg-white">
                                </div>
                            </div>

                            <div class="space-y-2">
                                <label for="location" class="block text-sm font-bold text-gray-700">Emplacement</label>
                                <input type="text" id="location" name="location"
                                    value="${salle != null ? salle.location : ''}"
                                    placeholder="Ex: Bâtiment A, 2ème étage"
                                    class="w-full px-5 py-4 border-2 border-orange-200 rounded-xl focus:border-orange-500 focus:ring-4 focus:ring-orange-200 transition-all duration-300 outline-none input-focus bg-white">
                            </div>

                            <div class="grid grid-cols-1 md:grid-cols-2 gap-5">
                                <div class="space-y-2">
                                    <label for="imageFile" class="block text-sm font-bold text-gray-700">Image</label>
                                    <input type="file" id="imageFile" name="imageFile" accept="image/*"
                                        class="w-full px-5 py-4 border-2 border-orange-200 rounded-xl focus:border-orange-500 focus:ring-4 focus:ring-orange-200 transition-all duration-300 outline-none input-focus bg-white">
                                    <c:if test="${not empty salle.imagePath}">
                                        <p class="text-xs text-green-600 mt-1">Fichier actuel: ${salle.imagePath}</p>
                                    </c:if>
                                </div>

                                <div class="space-y-2">
                                    <label for="videoFile" class="block text-sm font-bold text-gray-700">Vidéo</label>
                                    <input type="file" id="videoFile" name="videoFile" accept="video/*"
                                        class="w-full px-5 py-4 border-2 border-orange-200 rounded-xl focus:border-orange-500 focus:ring-4 focus:ring-orange-200 transition-all duration-300 outline-none input-focus bg-white">
                                    <c:if test="${not empty salle.videoPath}">
                                        <p class="text-xs text-green-600 mt-1">Fichier actuel: ${salle.videoPath}</p>
                                    </c:if>
                                </div>
                            </div>

                            <div class="flex flex-col sm:flex-row gap-4 pt-4">
                                <button type="submit"
                                    class="flex-1 bg-orange-600 text-white py-3 rounded-lg font-semibold hover:bg-orange-700 transition-colors duration-200 shadow-md hover:shadow-lg flex items-center justify-center space-x-2">
                                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                            d="${salle != null ? 'M5 13l4 4L19 7' : 'M12 4v16m8-8H4'}" />
                                    </svg>
                                    <span>${salle != null ? 'Modifier' : 'Créer'}</span>
                                </button>
                                <a href="${pageContext.request.contextPath}/salles"
                                    class="flex-1 bg-gray-100 text-gray-700 py-4 rounded-xl font-bold hover:bg-gray-200 text-center transition-all duration-300 transform hover:scale-105 border-2 border-gray-200">
                                    Annuler
                                </a>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
            <jsp:include page="../layout/footer.jsp" />
        </body>

        </html>