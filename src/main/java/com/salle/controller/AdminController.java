package com.salle.controller;

import com.salle.model.User;
import com.salle.service.UserService;
import com.salle.util.URLHelper;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "AdminController", urlPatterns = {"/admin/users"})
public class AdminController extends HttpServlet {
    
    private final UserService userService;
    
    public AdminController() {
        this.userService = new UserService();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");
        if (user == null || user.getRole() != User.Role.ADMIN) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }
        
        request.setAttribute("users", userService.getAllUsers());
        request.getRequestDispatcher("/WEB-INF/views/admin/users.jsp").forward(request, response);
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
        
        if ("delete".equals(action)) {
            try {
                Long id = Long.parseLong(request.getParameter("id"));
                userService.deleteUser(id);
                response.sendRedirect(URLHelper.buildUrlWithMessage(request.getContextPath() + "/admin/users", "Utilisateur supprimé avec succès"));
            } catch (Exception e) {
                request.setAttribute("error", "Erreur lors de la suppression: " + e.getMessage());
                request.setAttribute("users", userService.getAllUsers());
                request.getRequestDispatcher("/WEB-INF/views/admin/users.jsp").forward(request, response);
            }
        }
    }
}

