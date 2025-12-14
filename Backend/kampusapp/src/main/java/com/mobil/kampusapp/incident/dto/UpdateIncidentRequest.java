package com.mobil.kampusapp.incident.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

public record UpdateIncidentRequest(
    @NotBlank @Size(max=2000) String description
) {}
