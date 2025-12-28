package com.mobil.kampusapp.dto;

import jakarta.validation.constraints.*;

public record RegisterRequest(
    @Email @NotBlank String email,
    @NotBlank @Size(min = 2, max = 120) String fullName,
    @NotBlank @Size(min = 6, max = 64) String password
) {}
