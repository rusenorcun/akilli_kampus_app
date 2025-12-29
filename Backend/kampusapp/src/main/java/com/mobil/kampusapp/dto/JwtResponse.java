package com.mobil.kampusapp.dto;

import com.mobil.kampusapp.entity.Role;

public class JwtResponse {

    private String token;
    private Long userId;
    private String fullName;
    private String email;
    private Role role;

    public JwtResponse() {}

    public JwtResponse(String token, Long userId, String fullName, String email, Role role) {
        this.token = token;
        this.userId = userId;
        this.fullName = fullName;
        this.email = email;
        this.role = role;
    }
    // Getters and Setters veri tiplerinin alınması ve ayarlanması için kullanılır
    public String getToken() { return token; }
    public Long getUserId() { return userId; }
    public String getFullName() { return fullName; }
    public String getEmail() { return email; }
    public Role getRole() { return role; }

    public void setToken(String token) { this.token = token; }
    public void setUserId(Long userId) { this.userId = userId; }
    public void setFullName(String fullName) { this.fullName = fullName; }
    public void setEmail(String email) { this.email = email; }
    public void setRole(Role role) { this.role = role; }
}
