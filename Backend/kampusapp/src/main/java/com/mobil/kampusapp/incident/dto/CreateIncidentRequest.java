package com.mobil.kampusapp.incident.dto;

import com.mobil.kampusapp.incident.IncidentType;
import jakarta.validation.constraints.*;

public record CreateIncidentRequest(
    @NotBlank @Size(max=120) String title,
    @NotBlank @Size(max=2000) String description,
    @NotNull IncidentType type,
    @NotNull @DecimalMin(value="-90.0") @DecimalMax(value="90.0") Double lat,
    @NotNull @DecimalMin(value="-180.0") @DecimalMax(value="180.0") Double lon
) {}
