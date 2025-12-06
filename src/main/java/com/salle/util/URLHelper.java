package com.salle.util;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

/**
 * Utilitaire pour encoder correctement les URLs avec UTF-8
 */
public class URLHelper {
    
    /**
     * Encode un message pour être utilisé dans une URL
     * @param message Le message à encoder
     * @return Le message encodé en UTF-8
     */
    public static String encodeMessage(String message) {
        if (message == null) {
            return "";
        }
        try {
            return URLEncoder.encode(message, StandardCharsets.UTF_8.toString());
        } catch (Exception e) {
            return message;
        }
    }
    
    /**
     * Construit une URL avec un paramètre message encodé
     * @param baseUrl L'URL de base
     * @param message Le message à ajouter
     * @return L'URL complète avec le message encodé
     */
    public static String buildUrlWithMessage(String baseUrl, String message) {
        if (message == null || message.isEmpty()) {
            return baseUrl;
        }
        String separator = baseUrl.contains("?") ? "&" : "?";
        return baseUrl + separator + "message=" + encodeMessage(message);
    }
}

