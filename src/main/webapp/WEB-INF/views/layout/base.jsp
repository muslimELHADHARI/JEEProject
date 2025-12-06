<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${pageTitle != null ? pageTitle : 'Gestion de Salles'}</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
        @keyframes slideIn {
            from { transform: translateX(-100%); opacity: 0; }
            to { transform: translateX(0); opacity: 1; }
        }
        @keyframes pulse-orange {
            0%, 100% { box-shadow: 0 0 0 0 rgba(234, 88, 12, 0.7); }
            50% { box-shadow: 0 0 0 10px rgba(234, 88, 12, 0); }
        }
        .animate-fade-in {
            animation: fadeIn 0.6s ease-out;
        }
        .animate-slide-in {
            animation: slideIn 0.5s ease-out;
        }
        .animate-pulse-orange {
            animation: pulse-orange 2s infinite;
        }
        .harissa-gradient {
            background: linear-gradient(135deg, #ea580c 0%, #c2410c 50%, #9a3412 100%);
        }
    </style>
</head>
<body class="min-h-screen flex flex-col bg-gradient-to-br from-orange-50 to-orange-100">
    <jsp:include page="header.jsp"/>
    <main class="flex-grow container mx-auto px-4 py-8">
        <jsp:include page="${content}"/>
    </main>
    <jsp:include page="footer.jsp"/>
</body>
</html>

