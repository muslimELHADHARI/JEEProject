package com.salle.service;

import com.salle.dao.UserDAO;
import com.salle.model.User;
import org.mindrot.jbcrypt.BCrypt;
import java.util.List;
import java.util.Optional;

public class UserService {
    
    private final UserDAO userDAO;
    
    public UserService() {
        this.userDAO = new UserDAO();
    }
    
    public List<User> getAllUsers() {
        return userDAO.findAll();
    }
    
    public Optional<User> getUserById(Long id) {
        return userDAO.findById(id);
    }
    
    public Optional<User> getUserByEmail(String email) {
        return userDAO.findByEmail(email);
    }
    
    public User createUser(String nom, String prenom, String email, String password, User.Role role) {
        // Check if email already exists
        if (userDAO.findByEmail(email).isPresent()) {
            throw new IllegalArgumentException("Un utilisateur avec cet email existe déjà");
        }
        
        // Hash password
        String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());
        
        User user = new User(nom, prenom, email, hashedPassword, role);
        return userDAO.save(user);
    }
    
    public User updateUser(Long id, String nom, String prenom, String email) {
        Optional<User> userOpt = userDAO.findById(id);
        if (userOpt.isEmpty()) {
            throw new IllegalArgumentException("Utilisateur non trouvé");
        }
        
        User user = userOpt.get();
        
        // Check if email is being changed and if new email already exists
        if (!user.getEmail().equals(email)) {
            if (userDAO.findByEmail(email).isPresent()) {
                throw new IllegalArgumentException("Un utilisateur avec cet email existe déjà");
            }
        }
        
        user.setNom(nom);
        user.setPrenom(prenom);
        user.setEmail(email);
        
        return userDAO.save(user);
    }
    
    public void deleteUser(Long id) {
        userDAO.delete(id);
    }
    
    public User authenticate(String email, String password) {
        Optional<User> userOpt = userDAO.findByEmail(email);
        if (userOpt.isEmpty()) {
            return null;
        }
        
        User user = userOpt.get();
        if (BCrypt.checkpw(password, user.getPassword())) {
            return user;
        }
        
        return null;
    }
    
    public boolean changePassword(Long userId, String oldPassword, String newPassword) {
        Optional<User> userOpt = userDAO.findById(userId);
        if (userOpt.isEmpty()) {
            return false;
        }
        
        User user = userOpt.get();
        if (!BCrypt.checkpw(oldPassword, user.getPassword())) {
            return false;
        }
        
        String hashedPassword = BCrypt.hashpw(newPassword, BCrypt.gensalt());
        user.setPassword(hashedPassword);
        userDAO.save(user);
        return true;
    }
}

