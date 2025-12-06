
package com.salle.controller;

import com.salle.model.User;
import com.salle.service.ReservationService;
import com.salle.service.SalleService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "DashboardController", urlPatterns = {"/dashboard"})
public class DashboardController extends HttpServlet {
    
    private final ReservationService reservationService;
    private final SalleService salleService;
    
    public DashboardController() {
        this.reservationService = new ReservationService();
        this.salleService = new SalleService();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        User user = (User) session.getAttribute("user");
        
        // Load data based on user role
        if (user.getRole() == User.Role.ADMIN) {
            request.setAttribute("reservations", reservationService.getFutureReservations());
            request.setAttribute("salles", salleService.getAllSalles());
        } else {
            request.setAttribute("reservations", reservationService.getReservationsByUser(user.getId()));
            request.setAttribute("salles", salleService.getAllSalles());
        }
        
        request.getRequestDispatcher("/WEB-INF/views/dashboard.jsp").forward(request, response);
    }
}

