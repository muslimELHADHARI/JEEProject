package com.salle.controller;

import com.salle.model.User;
import com.salle.service.NotificationService;
import com.salle.util.URLHelper;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet(name = "NotificationController", urlPatterns = {"/notifications", "/notifications/*"})
public class NotificationController extends HttpServlet {

    private final NotificationService notificationService;

    public NotificationController() {
        this.notificationService = new NotificationService();
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
            // Display all notifications for the user
            request.setAttribute("notifications", notificationService.getNotificationsForUser(user.getId()));
            // Mark all notifications as read when the user views the list
            notificationService.markAllNotificationsAsRead(user.getId());
            request.getRequestDispatcher("/WEB-INF/views/notifications/list.jsp").forward(request, response);
        } else if (pathInfo.startsWith("/markAsRead/")) {
            // Mark a single notification as read
            try {
                Long notificationId = Long.parseLong(pathInfo.substring(13));
                notificationService.markNotificationAsRead(notificationId);
                response.sendRedirect(URLHelper.buildUrlWithMessage(request.getContextPath() + "/notifications", "Notification marquée comme l\'ue."));
            } catch (NumberFormatException e) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID de notification invalide");
            }
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response); // POST requests will be handled by doGet for simplicity for now
    }
}
