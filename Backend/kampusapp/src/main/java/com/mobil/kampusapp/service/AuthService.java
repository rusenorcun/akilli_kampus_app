package com.mobil.kampusapp.service;

import com.mobil.kampusapp.dto.*;
import com.mobil.kampusapp.entity.Role;
import com.mobil.kampusapp.entity.User;
import com.mobil.kampusapp.repository.UserRepository;
import org.springframework.security.authentication.*;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;

@Service
public class AuthService {

    private final UserRepository users;
    private final PasswordEncoder encoder;
    private final AuthenticationManager authManager;
    private final JwtService jwtService;

    public AuthService(UserRepository users,
                        PasswordEncoder encoder,
                        AuthenticationManager authManager,
                        JwtService jwtService) {
        this.users = users;
        this.encoder = encoder;
        this.authManager = authManager;
        this.jwtService = jwtService;
    }

    private Role roleFromUiOrStudent(String uiRole) {
        if (uiRole == null) return Role.ROLE_STUDENT;

        String normalized = uiRole.trim().toUpperCase();
        if (normalized.isBlank()) return Role.ROLE_STUDENT;

        try {
            //   sadece enum isimleri kabul edilir: ROLE_STUDENT/ROLE_STAFF/ROLE_ADMIN
            return Role.valueOf(normalized);
        } catch (IllegalArgumentException ex) {
            //   tanımsız her şey student
            return Role.ROLE_STUDENT;
        }
    }

    public JwtResponse register(RegisterRequest req) {
        String email = req.getEmail().toLowerCase();

        if (users.existsByEmail(email)) {
            throw new IllegalArgumentException("Email already in use.");
        }

        Role roleToSave = roleFromUiOrStudent(req.getRole());

        User u = new User();
        u.setFullName(req.getFullName());
        u.setEmail(email);
        u.setPassword(encoder.encode(req.getPassword()));
        u.setDepartment(req.getDepartment());
        u.setRole(roleToSave);
        u.setCreatedAt(LocalDateTime.now());

        User saved = users.save(u);

        UserDetails principal = org.springframework.security.core.userdetails.User
                .withUsername(saved.getEmail())
                .password(saved.getPassword())
                .authorities(roleToSave.name())
                .build();

        String token = jwtService.generateToken(principal);
        return new JwtResponse(token, saved.getId(), saved.getFullName(), saved.getEmail(), roleToSave);
    }

    public JwtResponse login(LoginRequest req) {
        Authentication auth = authManager.authenticate(
                new UsernamePasswordAuthenticationToken(req.getEmail(), req.getPassword())
        );

        UserDetails principal = (UserDetails) auth.getPrincipal();
        String token = jwtService.generateToken(principal);

        User u = users.findByEmail(principal.getUsername().toLowerCase())
                .orElseThrow(() -> new IllegalArgumentException("User not found after auth."));

        //   DB’de null varsa student yap
        Role safeRole = (u.getRole() == null) ? Role.ROLE_STUDENT : u.getRole();
        if (u.getRole() == null) {
            u.setRole(Role.ROLE_STUDENT);
            users.save(u);
        }

        return new JwtResponse(token, u.getId(), u.getFullName(), u.getEmail(), safeRole);
    }
}
