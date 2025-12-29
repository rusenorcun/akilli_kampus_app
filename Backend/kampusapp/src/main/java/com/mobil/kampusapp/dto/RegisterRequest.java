package com.mobil.kampusapp.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;

public class RegisterRequest {

    @NotBlank
    private String fullName;

    @Email
    @NotBlank
    private String email;

    @NotBlank
    private String password;

    private String department;

    // ROLE_STUDENT / ROLE_STAFF / ROLE_ADMIN
    private String role;

    public RegisterRequest() {}

    public String getFullName() { return fullName; }
    public String getEmail() { return email; }
    public String getPassword() { return password; }
    public String getDepartment() { return department; }
    public String getRole() { return role; }

    public void setFullName(String fullName) { this.fullName = fullName; }
    public void setEmail(String email) { this.email = email; }
    public void setPassword(String password) { this.password = password; }
    public void setDepartment(String department) { this.department = department; }
    public void setRole(String role) { this.role = role; }
}
