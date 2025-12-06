package com.salle.exception;

public class OverlapException extends Exception {
    
    public OverlapException(String message) {
        super(message);
    }
    
    public OverlapException(String message, Throwable cause) {
        super(message, cause);
    }
}

