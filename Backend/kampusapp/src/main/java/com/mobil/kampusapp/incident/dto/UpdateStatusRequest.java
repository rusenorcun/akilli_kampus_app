package com.mobil.kampusapp.incident.dto;

import com.mobil.kampusapp.incident.IncidentStatus;
import jakarta.validation.constraints.NotNull;

public record UpdateStatusRequest(@NotNull IncidentStatus status) {}
