<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <jsp:include page="../layout/header.jsp" />
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
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                    d="M12 4v16m8-8H4" />
                            </svg>
                            <span>Ajouter une salle</span>
                        </a>
                    </c:if>
                </div>



                <c:if test="${not empty error}">
                    <div class="mb-6 p-4 bg-red-50 border-l-4 border-red-500 text-red-700 rounded-lg flex items-start">
                        <svg class="w-5 h-5 mr-3 mt-0.5 flex-shrink-0" fill="none" stroke="currentColor"
                            viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
                        </svg>
                        <span>${error}</span>
                    </div>
                </c:if>

                <!-- Search and Filter Section -->
                <div
                    class="mb-8 bg-white dark:bg-gray-800 p-6 rounded-xl shadow-sm border border-gray-200 dark:border-gray-700">
                    <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
                        <div class="relative">
                            <input type="text" id="searchInput" placeholder="Rechercher une salle..."
                                class="w-full pl-10 pr-4 py-2 rounded-lg border border-gray-300 dark:border-gray-600 dark:bg-gray-700 dark:text-white focus:ring-2 focus:ring-orange-500 focus:border-transparent outline-none transition-all duration-200">
                            <svg class="w-5 h-5 text-gray-400 absolute left-3 top-2.5" fill="none" stroke="currentColor"
                                viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                    d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
                            </svg>
                        </div>
                        <div>
                            <select id="capacityFilter"
                                class="w-full px-4 py-2 rounded-lg border border-gray-300 dark:border-gray-600 dark:bg-gray-700 dark:text-white focus:ring-2 focus:ring-orange-500 focus:border-transparent outline-none transition-all duration-200">
                                <option value="all">Toutes capacités</option>
                                <option value="small">Petite (< 20 places)</option>
                                <option value="medium">Moyenne (20-50 places)</option>
                                <option value="large">Grande (> 50 places)</option>
                            </select>
                        </div>
                    </div>
                </div>

                <!-- Salles Grid -->
                <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8" id="sallesGrid">
                    <c:choose>
                        <c:when test="${empty salles}">
                            <div class="col-span-full text-center py-16">
                                <svg class="w-20 h-20 text-gray-300 mx-auto mb-4" fill="none" stroke="currentColor"
                                    viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                        d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4" />
                                </svg>
                                <p class="text-gray-500 text-lg font-medium">Aucune salle disponible</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="salle" items="${salles}">
                                <div class="group bg-white dark:bg-gray-800 rounded-xl shadow-lg border border-gray-200 dark:border-gray-700 overflow-hidden hover:shadow-2xl transition-all duration-300 transform hover:-translate-y-1 salle-card"
                                    data-nom="${salle.nom.toLowerCase()}" data-capacite="${salle.capacite}">

                                    <!-- Media Header (Image/Video) -->
                                    <div class="relative h-48 overflow-hidden">
                                        <c:if test="${not empty salle.imagePath}">
                                            <img src="${pageContext.request.contextPath}/${salle.imagePath}"
                                                alt="${salle.nom}"
                                                class="w-full h-full object-cover transition-transform duration-700 group-hover:scale-110">
                                        </c:if>
                                        <c:if test="${empty salle.imagePath}">
                                            <div
                                                class="w-full h-full bg-gradient-to-br from-orange-100 to-orange-200 flex items-center justify-center">
                                                <svg class="w-16 h-16 text-orange-300" fill="none" stroke="currentColor"
                                                    viewBox="0 0 24 24">
                                                    <path stroke-linecap="round" stroke-linejoin="round"
                                                        stroke-width="2"
                                                        d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z" />
                                                </svg>
                                            </div>
                                        </c:if>

                                        <!-- Video Overlay Button -->
                                        <c:if test="${not empty salle.videoPath}">
                                            <button
                                                onclick="openVideoModal('${pageContext.request.contextPath}/${salle.videoPath}', '${salle.nom}')"
                                                class="absolute inset-0 flex items-center justify-center bg-black bg-opacity-30 opacity-0 group-hover:opacity-100 transition-opacity duration-300 cursor-pointer">
                                                <div
                                                    class="w-12 h-12 bg-white rounded-full flex items-center justify-center shadow-lg transform scale-90 group-hover:scale-105 transition-transform">
                                                    <svg class="w-6 h-6 text-orange-600 pl-1" fill="currentColor"
                                                        viewBox="0 0 24 24">
                                                        <path d="M8 5v14l11-7z" />
                                                    </svg>
                                                </div>
                                            </button>
                                        </c:if>

                                        <span
                                            class="absolute top-4 right-4 bg-white/90 backdrop-blur px-3 py-1 rounded-full text-sm font-bold text-orange-600 shadow-sm">
                                            ${salle.capacite} places
                                        </span>
                                    </div>

                                    <div class="p-6">
                                        <h3
                                            class="text-xl font-bold text-gray-900 dark:text-white mb-2 group-hover:text-orange-600 transition-colors">
                                            ${salle.nom}</h3>

                                        <c:if test="${not empty salle.location}">
                                            <div
                                                class="flex items-center text-sm text-gray-500 dark:text-gray-400 mb-3">
                                                <svg class="w-4 h-4 mr-1 text-orange-500" fill="none"
                                                    stroke="currentColor" viewBox="0 0 24 24">
                                                    <path stroke-linecap="round" stroke-linejoin="round"
                                                        stroke-width="2"
                                                        d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z" />
                                                    <path stroke-linecap="round" stroke-linejoin="round"
                                                        stroke-width="2" d="M15 11a3 3 0 11-6 0 3 3 0 016 0z" />
                                                </svg>
                                                ${salle.location}
                                            </div>
                                        </c:if>

                                        <p
                                            class="text-gray-600 dark:text-gray-300 mb-4 line-clamp-2 text-sm leading-relaxed">
                                            ${salle.description}</p>

                                        <div
                                            class="flex items-center justify-between mt-6 pt-4 border-t border-gray-100 dark:border-gray-700">
                                            <button
                                                onclick="openDetailsModal('${salle.nom}', '${salle.description}', '${salle.equipements}', '${salle.capacite}', '${salle.location}', '${pageContext.request.contextPath}/${salle.imagePath}', '${pageContext.request.contextPath}/${salle.videoPath}')"
                                                class="text-sm font-semibold text-gray-500 hover:text-orange-600 transition-colors flex items-center">
                                                Plus de détails
                                                <svg class="w-4 h-4 ml-1" fill="none" stroke="currentColor"
                                                    viewBox="0 0 24 24">
                                                    <path stroke-linecap="round" stroke-linejoin="round"
                                                        stroke-width="2" d="M19 9l-7 7-7-7" />
                                                </svg>
                                            </button>

                                            <a href="${pageContext.request.contextPath}/reservations/new?salleId=${salle.id}"
                                                class="bg-orange-600 text-white px-4 py-2 rounded-lg text-sm font-semibold hover:bg-orange-700 transition-colors shadow-md hover:shadow-lg">
                                                Réserver
                                            </a>
                                        </div>

                                        <c:if test="${user.role == 'ADMIN'}">
                                            <div
                                                class="flex space-x-2 mt-4 pt-4 border-t border-gray-100 dark:border-gray-700">
                                                <a href="${pageContext.request.contextPath}/salles/edit/${salle.id}"
                                                    class="text-xs text-blue-600 hover:underline">Modifier</a>
                                                <form method="post" action="${pageContext.request.contextPath}/salles"
                                                    style="display:inline;">
                                                    <input type="hidden" name="action" value="delete">
                                                    <input type="hidden" name="id" value="${salle.id}">
                                                    <button type="submit" onclick="return confirm('Êtes-vous sûr ?')"
                                                        class="text-xs text-red-600 hover:underline bg-transparent border-0 p-0 cursor-pointer">Supprimer</button>
                                                </form>
                                            </div>
                                        </c:if>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-- Video Modal -->
                <div id="videoModal" class="fixed inset-0 z-50 hidden overflow-y-auto" aria-labelledby="modal-title"
                    role="dialog" aria-modal="true">
                    <div
                        class="flex items-center justify-center min-h-screen pt-4 px-4 pb-20 text-center sm:block sm:p-0">
                        <div class="fixed inset-0 bg-gray-500 bg-opacity-75 transition-opacity" aria-hidden="true"
                            onclick="closeVideoModal()"></div>
                        <span class="hidden sm:inline-block sm:align-middle sm:h-screen"
                            aria-hidden="true">&#8203;</span>
                        <div
                            class="inline-block align-bottom bg-white dark:bg-gray-800 rounded-lg text-left overflow-hidden shadow-xl transform transition-all sm:my-8 sm:align-middle sm:max-w-4xl sm:w-full">
                            <div class="bg-black relative aspect-video">
                                <video id="modalVideoPlayer" class="w-full h-full" controls>
                                    <source src="" type="video/mp4">
                                    Votre navigateur ne supporte pas la balise vidéo.
                                </video>
                                <button onclick="closeVideoModal()"
                                    class="absolute top-4 right-4 text-white hover:text-gray-300">
                                    <svg class="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                            d="M6 18L18 6M6 6l12 12" />
                                    </svg>
                                </button>
                            </div>
                            <div
                                class="px-4 py-3 sm:px-6 bg-gray-50 dark:bg-gray-700 flex justify-between items-center">
                                <h3 class="text-lg leading-6 font-medium text-gray-900 dark:text-white"
                                    id="videoModalTitle"></h3>
                                <button type="button" onclick="closeVideoModal()"
                                    class="w-full inline-flex justify-center rounded-md border border-gray-300 shadow-sm px-4 py-2 bg-white text-base font-medium text-gray-700 hover:bg-gray-50 focus:outline-none sm:mt-0 sm:ml-3 sm:w-auto sm:text-sm">
                                    Fermer
                                </button>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Details Modal -->
                <div id="detailsModal" class="fixed inset-0 z-50 hidden overflow-y-auto" aria-labelledby="modal-title"
                    role="dialog" aria-modal="true">
                    <div
                        class="flex items-center justify-center min-h-screen pt-4 px-4 pb-20 text-center sm:block sm:p-0">
                        <div class="fixed inset-0 bg-gray-500 bg-opacity-75 transition-opacity" aria-hidden="true"
                            onclick="closeDetailsModal()"></div>
                        <span class="hidden sm:inline-block sm:align-middle sm:h-screen"
                            aria-hidden="true">&#8203;</span>
                        <div
                            class="inline-block align-bottom bg-white dark:bg-gray-800 rounded-lg text-left overflow-hidden shadow-xl transform transition-all sm:my-8 sm:align-middle sm:max-w-2xl sm:w-full">
                            <div class="relative h-64">
                                <img id="detailsImage" src="" alt="" class="w-full h-full object-cover">
                                <div
                                    class="absolute inset-0 bg-gradient-to-t from-black/70 to-transparent flex items-end">
                                    <div class="p-6 text-white w-full">
                                        <h3 class="text-3xl font-bold" id="detailsTitle"></h3>
                                        <p class="text-orange-200 flex items-center mt-2" id="detailsLocationWrapper">
                                            <svg class="w-5 h-5 mr-1" fill="none" stroke="currentColor"
                                                viewBox="0 0 24 24">
                                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                                    d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z" />
                                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                                    d="M15 11a3 3 0 11-6 0 3 3 0 016 0z" />
                                            </svg>
                                            <span id="detailsLocation"></span>
                                        </p>
                                    </div>
                                </div>
                            </div>
                            <div class="px-6 py-6">
                                <div class="grid grid-cols-2 gap-6 mb-6">
                                    <div class="bg-gray-50 dark:bg-gray-700 p-4 rounded-lg text-center">
                                        <span class="block text-2xl font-bold text-orange-600"
                                            id="detailsCapacite"></span>
                                        <span class="text-sm text-gray-500 dark:text-gray-400">Capacité maximum</span>
                                    </div>
                                    <div
                                        class="bg-gray-50 dark:bg-gray-700 p-4 rounded-lg flex items-center justify-center">
                                        <button id="detailsVideoBtn" onclick=""
                                            class="hidden flex items-center space-x-2 text-orange-600 hover:text-orange-700 font-semibold">
                                            <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                                    d="M14.752 11.168l-3.197-2.132A1 1 0 0010 9.87v4.263a1 1 0 001.555.832l3.197-2.132a1 1 0 000-1.664z" />
                                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                                    d="M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
                                            </svg>
                                            <span>Voir la vidéo</span>
                                        </button>
                                        <span id="detailsNoVideo" class="text-gray-400 text-sm italic hidden">Aucune
                                            vidéo disponible</span>
                                    </div>
                                </div>

                                <div class="space-y-4">
                                    <div>
                                        <h4 class="text-lg font-semibold text-gray-900 dark:text-white mb-2">Description
                                        </h4>
                                        <p class="text-gray-600 dark:text-gray-300 leading-relaxed"
                                            id="detailsDescription"></p>
                                    </div>
                                    <div>
                                        <h4 class="text-lg font-semibold text-gray-900 dark:text-white mb-2">Équipements
                                        </h4>
                                        <ul class="list-disc list-inside text-gray-600 dark:text-gray-300 space-y-1"
                                            id="detailsEquipements">
                                        </ul>
                                    </div>
                                </div>
                            </div>
                            <div class="bg-gray-50 dark:bg-gray-700 px-6 py-4 flex justify-end">
                                <button type="button" onclick="closeDetailsModal()"
                                    class="mr-3 inline-flex justify-center rounded-md border border-gray-300 shadow-sm px-4 py-2 bg-white text-base font-medium text-gray-700 hover:bg-gray-50 focus:outline-none sm:text-sm">
                                    Fermer
                                </button>
                            </div>
                        </div>
                    </div>
                </div>

                <script>
                    // Search and Filter Logic
                    const searchInput = document.getElementById('searchInput');
                    const capacityFilter = document.getElementById('capacityFilter');
                    const salleCards = document.querySelectorAll('.salle-card');

                    function filterSalles() {
                        const searchTerm = searchInput.value.toLowerCase();
                        const capacityValue = capacityFilter.value;

                        salleCards.forEach(card => {
                            const nom = card.dataset.nom;
                            const capacite = parseInt(card.dataset.capacite);
                            let matchesSearch = nom.includes(searchTerm);
                            let matchesCapacity = true;

                            if (capacityValue === 'small') matchesCapacity = capacite < 20;
                            else if (capacityValue === 'medium') matchesCapacity = capacite >= 20 && capacite <= 50;
                            else if (capacityValue === 'large') matchesCapacity = capacite > 50;

                            if (matchesSearch && matchesCapacity) {
                                card.style.display = 'block';
                                card.classList.add('animate-fade-in-up'); // Re-trigger animation
                            } else {
                                card.style.display = 'none';
                            }
                        });
                    }

                    searchInput.addEventListener('input', filterSalles);
                    capacityFilter.addEventListener('change', filterSalles);

                    // Modal Logic
                    function openVideoModal(videoSrc, title) {
                        const modal = document.getElementById('videoModal');
                        const video = document.getElementById('modalVideoPlayer');
                        const modalTitle = document.getElementById('videoModalTitle');

                        // Fix: Check if URL contains 'null' or is empty properly
                        if (videoSrc.includes('/null') || videoSrc.endsWith('/')) {
                            alert("Vidéo non disponible");
                            return;
                        }

                        video.src = videoSrc;
                        modalTitle.textContent = title;
                        modal.classList.remove('hidden');
                        video.play();
                    }

                    function closeVideoModal() {
                        const modal = document.getElementById('videoModal');
                        const video = document.getElementById('modalVideoPlayer');
                        video.pause();
                        video.currentTime = 0;
                        modal.classList.add('hidden');
                    }

                    function openDetailsModal(title, description, equipements, capacite, location, imageSrc, videoSrc) {
                        const modal = document.getElementById('detailsModal');
                        document.getElementById('detailsTitle').textContent = title;
                        document.getElementById('detailsDescription').textContent = description;
                        document.getElementById('detailsCapacite').textContent = capacite;
                        document.getElementById('detailsImage').src = imageSrc.includes('/null') ? '' : imageSrc;

                        // Location
                        const locWrapper = document.getElementById('detailsLocationWrapper');
                        if (location && location !== 'null' && location.trim() !== '') {
                            document.getElementById('detailsLocation').textContent = location;
                            locWrapper.classList.remove('hidden');
                        } else {
                            locWrapper.classList.add('hidden');
                        }

                        // Equipements list
                        const equipList = document.getElementById('detailsEquipements');
                        equipList.innerHTML = '';
                        if (equipements) {
                            equipements.split(',').forEach(item => {
                                const li = document.createElement('li');
                                li.textContent = item.trim();
                                equipList.appendChild(li);
                            });
                        }

                        // Video Button in Details
                        const vidBtn = document.getElementById('detailsVideoBtn');
                        const noVid = document.getElementById('detailsNoVideo');

                        if (videoSrc && !videoSrc.includes('/null') && !videoSrc.endsWith('/')) {
                            vidBtn.onclick = function () {
                                closeDetailsModal();
                                openVideoModal(videoSrc, title);
                            };
                            vidBtn.classList.remove('hidden');
                            noVid.classList.add('hidden');
                        } else {
                            vidBtn.classList.add('hidden');
                            noVid.classList.remove('hidden');
                        }

                        modal.classList.remove('hidden');
                    }

                    function closeDetailsModal() {
                        document.getElementById('detailsModal').classList.add('hidden');
                    }
                </script>
            </div>
            <jsp:include page="../layout/footer.jsp" />
        </body>

        </html>