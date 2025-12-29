package com.mobil.kampusapp.entity;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "users", schema = "dbo",//kullanıcı bilgilerini tutar
        uniqueConstraints = @UniqueConstraint(name = "UQ_users_email", columnNames = "email"))
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "user_id")
    private Long id;

    @Column(name = "full_name", length = 100)
    private String fullName;

    @Column(name = "email", nullable = false, length = 150)
    private String email;

    @Column(name = "password", nullable = false, length = 255)
    private String password;

    @Column(name = "department", length = 100)
    private String department;

    @Enumerated(EnumType.STRING)
    @Column(name = "role", length = 45)
    private Role role = Role.ROLE_STUDENT; //default değer

    @Column(name = "created_at", nullable = false)
    private LocalDateTime createdAt;

    public User() {}

    @PrePersist
    public void prePersist() {
        if (this.createdAt == null) this.createdAt = LocalDateTime.now();
        if (this.role == null) this.role = Role.ROLE_STUDENT; //null gelirse düzelt
        if (this.email != null) this.email = this.email.toLowerCase();
    }

    public Long getId() { return id; }
    public String getFullName() { return fullName; }
    public String getEmail() { return email; }
    public String getPassword() { return password; }
    public String getDepartment() { return department; }
    public Role getRole() { return role; }
    public LocalDateTime getCreatedAt() { return createdAt; }

    public void setId(Long id) { this.id = id; }
    public void setFullName(String fullName) { this.fullName = fullName; }
    public void setEmail(String email) { this.email = email; }
    public void setPassword(String password) { this.password = password; }
    public void setDepartment(String department) { this.department = department; }
    public void setRole(Role role) { this.role = role; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
}
