package com.salle.controller;

import com.salle.exception.InvalidDateException;
import com.salle.exception.OverlapException;
import com.salle.exception.UnauthorizedActionException;
import com.salle.model.User;
import com.salle.service.ReservationService;
import com.salle.service.SalleService;
import com.salle.util.URLHelper;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;

@WebServlet(name = "ReservationController", urlPatterns = {"/reservations", "/reservations/*"})
public class ReservationController extends HttpServlet {
    
    private final ReservationService reservationService;
    private final SalleService salleService;
    private static final DateTimeFormatter DATETIME_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm");
    
    public ReservationController() {
        this.reservationService = new ReservationService();
        this.salleService = new SalleService();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String pathInfo = request.getPathInfo();
        
        if (pathInfo == null || pathInfo.equals("/")) {
            // List reservations
            if (user.getRole() == User.Role.ADMIN) {
                request.setAttribute("reservations", reservationService.getFutureReservations());
            } else {
                request.setAttribute("reservations", reservationService.getReservationsByUser(user.getId()));
            }
            request.setAttribute("salles", salleService.getAllSalles());
            request.getRequestDispatcher("/WEB-INF/views/reservations/list.jsp").forward(request, response);
        } else if (pathInfo.equals("/new")) {
            // Show create form
            String salleIdParam = request.getParameter("salleId");
            if (salleIdParam != null && !salleIdParam.isEmpty()) {
                try {
                    Long salleId = Long.parseLong(salleIdParam);
                    salleService.getSalleById(salleId).ifPresent(salle -> request.setAttribute("selectedSalle", salle));
                } catch (NumberFormatException e) {
                    request.setAttribute("error", "ID de salle invalide");
                }
            }
            request.setAttribute("salles", salleService.getAllSalles());
            request.getRequestDispatcher("/WEB-INF/views/reservations/form.jsp").forward(request, response);
        } else if (pathInfo.startsWith("/edit/")) {
            // Show edit form
            try {
                Long id = Long.parseLong(pathInfo.substring(6));
                reservationService.getReservationById(id).ifPresentOrElse(
                    reservation -> {
                        // Check authorization
                        if (user.getRole() != User.Role.ADMIN && 
                            !reservation.getUser().getId().equals(user.getId())) {
                            try {
                                response.sendError(HttpServletResponse.SC_FORBIDDEN);
                            } catch (IOException e) {
                                throw new RuntimeException(e);
                            }
                            return;
                        }
                        try {
                            request.setAttribute("reservation", reservation);
                            request.setAttribute("salles", salleService.getAllSalles());
                            request.getRequestDispatcher("/WEB-INF/views/reservations/form.jsp").forward(request, response);
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
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String action = request.getParameter("action");
        
        if ("cancel".equals(action)) {
            // Cancel reservation
            try {
                Long id = Long.parseLong(request.getParameter("id"));
                String message = reservationService.cancelReservation(id, user.getId());
                response.sendRedirect(URLHelper.buildUrlWithMessage(request.getContextPath() + "/reservations", message));
            } catch (NumberFormatException e) {
                request.setAttribute("error", "ID invalide");
                doGet(request, response);
            } catch (UnauthorizedActionException e) {
                // This catch block will now handle UnauthorizedActionException that are not related to auto-assignment.
                request.setAttribute("error", e.getMessage());
                doGet(request, response);
            }
        } else if ("delete".equals(action)) {
            // Delete reservation (admin only)
            try {
                Long id = Long.parseLong(request.getParameter("id"));
                reservationService.deleteReservation(id, user.getId());
                response.sendRedirect(URLHelper.buildUrlWithMessage(request.getContextPath() + "/reservations", "Réservation supprimée avec succès"));
            } catch (NumberFormatException e) {
                request.setAttribute("error", "ID invalide");
                doGet(request, response);
            } catch (UnauthorizedActionException e) {
                request.setAttribute("error", e.getMessage());
                doGet(request, response);
            }
        } else {
            // Create or update
            String salleIdStr = request.getParameter("salleId");
            String dateDebutStr = request.getParameter("dateDebut");
            String dateFinStr = request.getParameter("dateFin");
            String motif = request.getParameter("motif");
            String idStr = request.getParameter("id");
            
            Long salleId = null; // Declare salleId here

            if (salleIdStr == null || dateDebutStr == null || dateFinStr == null ||
                salleIdStr.trim().isEmpty() || dateDebutStr.trim().isEmpty() || dateFinStr.trim().isEmpty()) {
                request.setAttribute("error", "Tous les champs sont requis");
                request.setAttribute("salles", salleService.getAllSalles());
                request.getRequestDispatcher("/WEB-INF/views/reservations/form.jsp").forward(request, response);
                return;
            }
            
            try {
                salleId = Long.parseLong(salleIdStr); // Assign salleId here
                LocalDateTime dateDebut = LocalDateTime.parse(dateDebutStr, DATETIME_FORMATTER);
                LocalDateTime dateFin = LocalDateTime.parse(dateFinStr, DATETIME_FORMATTER);
                
                if (idStr != null && !idStr.isEmpty()) {
                    // Update
                    Long id = Long.parseLong(idStr);
                    reservationService.updateReservation(id, user.getId(), salleId, dateDebut, dateFin, 
                                                       motif != null ? motif : "");
                    response.sendRedirect(URLHelper.buildUrlWithMessage(request.getContextPath() + "/reservations", "Réservation modifiée avec succès"));
                } else {
                    // Create
                    reservationService.createReservation(user.getId(), salleId, dateDebut, dateFin, 
                                                        motif != null ? motif : "");
                    response.sendRedirect(URLHelper.buildUrlWithMessage(request.getContextPath() + "/reservations", "Réservation créée avec succès"));
                }
            } catch (NumberFormatException e) {
                request.setAttribute("error", "ID ou format de date invalide");
                request.setAttribute("salles", salleService.getAllSalles());
                request.getRequestDispatcher("/WEB-INF/views/reservations/form.jsp").forward(request, response);
            } catch (DateTimeParseException e) {
                request.setAttribute("error", "Format de date invalide. Utilisez: yyyy-MM-ddTHH:mm");
                request.setAttribute("salles", salleService.getAllSalles());
                request.getRequestDispatcher("/WEB-INF/views/reservations/form.jsp").forward(request, response);
            } catch (OverlapException e) {
                if (e.getMessage().contains("liste d\'attente")) {
                    request.setAttribute("successMessage", e.getMessage());
                    request.setAttribute("addedToWaitingList", true);
                } else {
                    request.setAttribute("error", e.getMessage());
                }
                request.setAttribute("salles", salleService.getAllSalles());
                // Re-populate form fields to persist user input
                request.setAttribute("selectedSalle", salleService.getSalleById(salleId).orElse(null));
                request.setAttribute("dateDebut", dateDebutStr);
                request.setAttribute("dateFin", dateFinStr);
                request.setAttribute("motif", motif);

                request.getRequestDispatcher("/WEB-INF/views/reservations/form.jsp").forward(request, response);
            } catch (InvalidDateException | UnauthorizedActionException e) {
                request.setAttribute("error", e.getMessage());
                request.setAttribute("salles", salleService.getAllSalles());
                // Re-populate form fields to persist user input
                request.setAttribute("selectedSalle", salleService.getSalleById(salleId).orElse(null));
                request.setAttribute("dateDebut", dateDebutStr);
                request.setAttribute("dateFin", dateFinStr);
                request.setAttribute("motif", motif);
                request.getRequestDispatcher("/WEB-INF/views/reservations/form.jsp").forward(request, response);
            }
        }
    }
}

