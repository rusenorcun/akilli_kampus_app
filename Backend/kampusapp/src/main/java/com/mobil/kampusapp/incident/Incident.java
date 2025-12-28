package com.mobil.kampusapp.incident;

import java.time.Instant;

public record Incident(
    Long id,
    String title,
    String description,
    Double lat,
    Double lon,
    IncidentType type,
    IncidentStatus status,
    String createdBy,     // email
    Instant createdAt,
    Instant updatedAt
) {}
