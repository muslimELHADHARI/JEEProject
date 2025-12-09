package com.salle.service;

import com.salle.dao.NotificationDAO;
import com.salle.dao.UserDAO;
import com.salle.model.Notification;
import com.salle.model.User;

import java.util.List;
import java.util.Optional;

public class NotificationService {

    private final NotificationDAO notificationDAO;
    private final UserDAO userDAO;

    public NotificationService() {
        this.notificationDAO = new NotificationDAO();
        this.userDAO = new UserDAO();
    }

    public void createNotification(Long userId, String message, String type, Long targetEntityId) {
        User user = userDAO.findById(userId).orElseThrow(() -> new IllegalArgumentException("User not found"));
        Notification notification = new Notification(user, message, type, targetEntityId);
        notificationDAO.save(notification);
    }

    public List<Notification> getNotificationsForUser(Long userId) {
        return notificationDAO.findByUserId(userId);
    }

    public long getUnreadNotificationCountForUser(Long userId) {
        return notificationDAO.countUnreadByUserId(userId);
    }

    public void markNotificationAsRead(Long notificationId) {
        notificationDAO.markAsRead(notificationId);
    }

    public void markAllNotificationsAsRead(Long userId) {
        notificationDAO.markAllAsReadByUserId(userId);
    }

    public Optional<Notification> getNotificationById(Long notificationId) {
        return notificationDAO.findById(notificationId);
    }
}
