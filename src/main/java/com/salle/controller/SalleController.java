package com.salle.controller;

import com.salle.model.User;
import com.salle.service.SalleService;
import com.salle.util.URLHelper;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "SalleController", urlPatterns = { "/salles", "/salles/*" })
@jakarta.servlet.annotation.MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 50, // 50MB
        maxRequestSize = 1024 * 1024 * 100 // 100MB
)
public class SalleController extends HttpServlet {

    private final SalleService salleService;

    public SalleController() {
        this.salleService = new SalleService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();

        if (pathInfo == null || pathInfo.equals("/")) {
            request.setAttribute("salles", salleService.getAllSalles());
            request.getRequestDispatcher("/WEB-INF/views/salles/list.jsp").forward(request, response);
        } else if (pathInfo.equals("/new")) {
            checkAdmin(request, response);
            if (response.isCommitted())
                return;
            request.getRequestDispatcher("/WEB-INF/views/salles/form.jsp").forward(request, response);
        } else if (pathInfo.startsWith("/edit/")) {
            checkAdmin(request, response);
            if (response.isCommitted())
                return;
            try {
                Long id = Long.parseLong(pathInfo.substring(6));
                salleService.getSalleById(id).ifPresentOrElse(
                        salle -> {
                            try {
                                request.setAttribute("salle", salle);
                                request.getRequestDispatcher("/WEB-INF/views/salles/form.jsp").forward(request,
                                        response);
                            } catch (Exception e) {
                                throw new RuntimeException(e);
                            }
                        },
                        () -> {
                            try {
                                response.sendError(HttpServletResponse.SC_NOT_FOUND);
                            } catch (IOException e) {
                                throw new RuntimeException(e);
                            }
                        });
            } catch (NumberFormatException e) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            }
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        checkAdmin(request, response);
        if (response.isCommitted())
            return;

        String action = request.getParameter("action");

        if ("delete".equals(action)) {
            try {
                Long id = Long.parseLong(request.getParameter("id"));
                salleService.deleteSalle(id);
                response.sendRedirect(URLHelper.buildUrlWithMessage(request.getContextPath() + "/salles",
                        "Salle supprimée avec succès"));
            } catch (Exception e) {
                request.setAttribute("error", "Erreur lors de la suppression: " + e.getMessage());
                request.setAttribute("salles", salleService.getAllSalles());
                request.getRequestDispatcher("/WEB-INF/views/salles/list.jsp").forward(request, response);
            }
            return;
        }

        String nom = request.getParameter("nom");
        String description = request.getParameter("description");
        String capaciteStr = request.getParameter("capacite");
        String equipements = request.getParameter("equipements");
        String location = request.getParameter("location");
        String idStr = request.getParameter("id");

        if (nom == null || description == null || capaciteStr == null || nom.trim().isEmpty()) {
            request.setAttribute("error", "Nom, description et capacité sont requis");
            request.getRequestDispatcher("/WEB-INF/views/salles/form.jsp").forward(request, response);
            return;
        }

        try {
            Integer capacite = Integer.parseInt(capaciteStr);

            // Handle File Uploads
            String imagePath = null;
            String videoPath = null;

            jakarta.servlet.http.Part imagePart = request.getPart("imageFile");
            if (imagePart != null && imagePart.getSize() > 0) {
                imagePath = saveFile(imagePart, "images", request);
            }

            jakarta.servlet.http.Part videoPart = request.getPart("videoFile");
            if (videoPart != null && videoPart.getSize() > 0) {
                videoPath = saveFile(videoPart, "videos", request);
            }

            if (idStr != null && !idStr.isEmpty()) {
                // Update
                Long id = Long.parseLong(idStr);
                // Keep existing paths if new files are not uploaded
                com.salle.model.Salle existingSalle = salleService.getSalleById(id).orElse(null);
                if (existingSalle != null) {
                    if (imagePath == null)
                        imagePath = existingSalle.getImagePath();
                    if (videoPath == null)
                        videoPath = existingSalle.getVideoPath();
                }

                salleService.updateSalle(id, nom, description, capacite, equipements, imagePath, videoPath, location);
                response.sendRedirect(URLHelper.buildUrlWithMessage(request.getContextPath() + "/salles",
                        "Salle modifiée avec succès"));
            } else {
                // Create
                salleService.createSalle(nom, description, capacite, equipements, imagePath, videoPath, location);
                response.sendRedirect(
                        URLHelper.buildUrlWithMessage(request.getContextPath() + "/salles", "Salle créée avec succès"));
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Erreur: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/salles/form.jsp").forward(request, response);
        }
    }

    private void checkAdmin(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");
        if (user == null || user.getRole() != User.Role.ADMIN) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
        }
    }

    private String saveFile(jakarta.servlet.http.Part part, String subDir, HttpServletRequest request)
            throws IOException {
        String fileName = java.nio.file.Paths.get(part.getSubmittedFileName()).getFileName().toString();
        // Generate unique name to prevent overwrite
        String uniqueFileName = System.currentTimeMillis() + "_" + fileName;

        // Define upload directory relative to webapp
        String appPath = request.getServletContext().getRealPath("");
        String uploadDir = appPath + java.io.File.separator + "uploads" + java.io.File.separator + subDir;
        System.out.println("DEBUG: appPath=" + appPath);
        System.out.println("DEBUG: uploadDir=" + uploadDir);
        java.io.File uploadDirFile = new java.io.File(uploadDir);
        if (!uploadDirFile.exists()) {
            uploadDirFile.mkdirs();
        }

        String filePath = uploadDir + java.io.File.separator + uniqueFileName;
        part.write(filePath);

        return "uploads/" + subDir + "/" + uniqueFileName;
    }
}
