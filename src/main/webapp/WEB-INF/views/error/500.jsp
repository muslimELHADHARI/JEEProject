<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>500 - Erreur serveur</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="min-h-screen bg-gradient-to-br from-orange-50 to-orange-100 flex items-center justify-center">
    <div class="text-center">
        <h1 class="text-9xl font-bold text-orange-600 mb-4">500</h1>
        <h2 class="text-3xl font-bold text-orange-800 mb-4">Erreur serveur</h2>
        <p class="text-gray-600 mb-8">Une erreur s'est produite. Veuillez réessayer plus tard.</p>
        <a href="${pageContext.request.contextPath}/dashboard" 
           class="bg-gradient-to-r from-orange-500 to-orange-700 text-white px-6 py-3 rounded-lg font-semibold hover:from-orange-600 hover:to-orange-800 transform hover:scale-105 transition-all duration-300">
            Retour au dashboard
        </a>
    </div>
</body>
</html>

