package com.mobil.kampusapp.controller;

import com.mobil.kampusapp.entity.User;
import com.mobil.kampusapp.service.UserService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.LinkedHashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/users")
@CrossOrigin
public class UserController {

    private final UserService users;

    public UserController(UserService users) {
        this.users = users;
    }

    @GetMapping("/me")//profil bilgilerini getirir
    public ResponseEntity<Map<String, Object>> me() {
        User u = users.getMe();

        Map<String, Object> body = new LinkedHashMap<>();
        body.put("id", u.getId());
        body.put("fullName", u.getFullName());
        body.put("email", u.getEmail());
        body.put("department", u.getDepartment());
        body.put("role", u.getRole());
        body.put("createdAt", u.getCreatedAt());

        return ResponseEntity.ok(body);
    }
}
