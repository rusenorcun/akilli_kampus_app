package com.mobil.kampusapp.exception;


import org.springframework.http.*;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.web.bind.annotation.*;

import java.time.Instant;
import java.util.*;

@RestControllerAdvice
public class GlobalExceptionHandler {//genel istisna yakalayıcı

    @ExceptionHandler(AccessDeniedException.class)
    public ResponseEntity<Map<String, Object>> denied(AccessDeniedException ex) {
        Map<String, Object> body = new LinkedHashMap<>();
        body.put("timestamp", Instant.now().toString());
        body.put("status", 403);
        body.put("code", "FORBIDDEN");
        body.put("message", "You are not allowed to update hookup report status.");
        return ResponseEntity.status(HttpStatus.FORBIDDEN).body(body);
    }

    @ExceptionHandler(IllegalArgumentException.class)
    public ResponseEntity<Map<String, Object>> bad(IllegalArgumentException ex) {
        Map<String, Object> body = new LinkedHashMap<>();
        body.put("timestamp", Instant.now().toString());
        body.put("status", 400);
        body.put("code", "BAD_REQUEST");
        body.put("message", ex.getMessage());
        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(body);
    }
}
