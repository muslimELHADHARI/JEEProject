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

@WebServlet(name = "SalleController", urlPatterns = {"/salles", "/salles/*"})
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
            // List all salles
            request.setAttribute("salles", salleService.getAllSalles());
            request.getRequestDispatcher("/WEB-INF/views/salles/list.jsp").forward(request, response);
        } else if (pathInfo.equals("/new")) {
            // Show create form (admin only)
            HttpSession session = request.getSession(false);
            User user = (User) session.getAttribute("user");
            if (user == null || user.getRole() != User.Role.ADMIN) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN);
                return;
            }
            request.getRequestDispatcher("/WEB-INF/views/salles/form.jsp").forward(request, response);
        } else if (pathInfo.startsWith("/edit/")) {
            // Show edit form (admin only)
            HttpSession session = request.getSession(false);
            User user = (User) session.getAttribute("user");
            if (user == null || user.getRole() != User.Role.ADMIN) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN);
                return;
            }
            try {
                Long id = Long.parseLong(pathInfo.substring(6));
                salleService.getSalleById(id).ifPresentOrElse(
                    salle -> {
                        try {
                            request.setAttribute("salle", salle);
                            request.getRequestDispatcher("/WEB-INF/views/salles/form.jsp").forward(request, response);
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
                    }
                );
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
        
        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");
        if (user == null || user.getRole() != User.Role.ADMIN) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }
        
        String action = request.getParameter("action");
        
        if (action != null && action.equals("delete")) {
            // Delete salle
            try {
                Long id = Long.parseLong(request.getParameter("id"));
                salleService.deleteSalle(id);
                response.sendRedirect(URLHelper.buildUrlWithMessage(request.getContextPath() + "/salles", "Salle supprimée avec succès"));
            } catch (Exception e) {
                request.setAttribute("error", "Erreur lors de la suppression: " + e.getMessage());
                request.setAttribute("salles", salleService.getAllSalles());
                request.getRequestDispatcher("/WEB-INF/views/salles/list.jsp").forward(request, response);
            }
        } else {
            // Create or update
            String nom = request.getParameter("nom");
            String description = request.getParameter("description");
            String capaciteStr = request.getParameter("capacite");
            String equipements = request.getParameter("equipements");
            String idStr = request.getParameter("id");
            
            if (nom == null || description == null || capaciteStr == null ||
                nom.trim().isEmpty() || description.trim().isEmpty()) {
                request.setAttribute("error", "Nom, description et capacité sont requis");
                if (idStr != null && !idStr.isEmpty()) {
                    try {
                        Long id = Long.parseLong(idStr);
                        salleService.getSalleById(id).ifPresent(salle -> request.setAttribute("salle", salle));
                    } catch (NumberFormatException e) {
                        // Ignore
                    }
                }
                request.getRequestDispatcher("/WEB-INF/views/salles/form.jsp").forward(request, response);
                return;
            }
            
            try {
                Integer capacite = Integer.parseInt(capaciteStr);
                
                if (idStr != null && !idStr.isEmpty()) {
                    // Update
                    Long id = Long.parseLong(idStr);
                    salleService.updateSalle(id, nom, description, capacite, equipements != null ? equipements : "");
                    response.sendRedirect(URLHelper.buildUrlWithMessage(request.getContextPath() + "/salles", "Salle modifiée avec succès"));
                } else {
                    // Create
                    salleService.createSalle(nom, description, capacite, equipements != null ? equipements : "");
                    response.sendRedirect(URLHelper.buildUrlWithMessage(request.getContextPath() + "/salles", "Salle créée avec succès"));
                }
            } catch (NumberFormatException e) {
                request.setAttribute("error", "Capacité invalide");
                request.getRequestDispatcher("/WEB-INF/views/salles/form.jsp").forward(request, response);
            } catch (IllegalArgumentException e) {
                request.setAttribute("error", e.getMessage());
                request.getRequestDispatcher("/WEB-INF/views/salles/form.jsp").forward(request, response);
            }
        }
    }
}

