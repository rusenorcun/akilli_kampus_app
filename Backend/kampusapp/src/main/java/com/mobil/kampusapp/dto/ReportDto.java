package com.mobil.kampusapp.dto;

import java.time.LocalDateTime;

public class ReportDto {

    private Long id;
    private String title;
    private String description;
    private String location; 
    private String status;
    private LocalDateTime createdAt;
    private Long userId;
    private String category;

    public ReportDto() {}

    public Long getId() { return id; }
    public String getTitle() { return title; }
    public String getDescription() { return description; }
    public String getLocation() { return location; }
    public String getStatus() { return status; }
    public LocalDateTime getCreatedAt() { return createdAt; }
    public Long getUserId() { return userId; }
    public String getCategory() { return category; }

    public void setId(Long id) { this.id = id; }
    public void setTitle(String title) { this.title = title; }
    public void setDescription(String description) { this.description = description; }
    public void setLocation(String location) { this.location = location; }
    public void setStatus(String status) { this.status = status; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
    public void setUserId(Long userId) { this.userId = userId; }
    public void setCategory(String category) { this.category = category; }
}
