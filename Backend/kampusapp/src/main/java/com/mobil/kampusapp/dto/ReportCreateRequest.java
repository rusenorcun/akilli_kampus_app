package com.mobil.kampusapp.dto;

import jakarta.validation.constraints.NotBlank;

public class ReportCreateRequest {

    @NotBlank
    private String title;

    @NotBlank
    private String description;

    //
    private String location;

    // UI: "Güvenlik", "Temizlik", ...
    @NotBlank
    private String category;

    public ReportCreateRequest() {}

    public String getTitle() { return title; }
    public String getDescription() { return description; }
    public String getLocation() { return location; }
    public String getCategory() { return category; }

    public void setTitle(String title) { this.title = title; }
    public void setDescription(String description) { this.description = description; }
    public void setLocation(String location) { this.location = location; }
    public void setCategory(String category) { this.category = category; }
}
