package com.mobil.kampusapp.controller;

import com.mobil.kampusapp.dto.*;
import com.mobil.kampusapp.service.AuthService;
import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/auth")
@CrossOrigin
public class AuthController {

    private final AuthService authService;

    public AuthController(AuthService authService) {
        this.authService = authService;
    }

    @PostMapping("/register")//UI kayıt olma isteği atacak
    public ResponseEntity<JwtResponse> register(@Valid @RequestBody RegisterRequest req) {
        return ResponseEntity.ok(authService.register(req));
    }

    @PostMapping("/login")//UI giriş isteği atacak
    public ResponseEntity<JwtResponse> login(@Valid @RequestBody LoginRequest req) {
        return ResponseEntity.ok(authService.login(req));
    }

    @PostMapping("/logout")//UI çıkış isteği atacak
    public ResponseEntity<?> logout() {
        return ResponseEntity.ok("Logged out (client should discard token).");
    }
}
