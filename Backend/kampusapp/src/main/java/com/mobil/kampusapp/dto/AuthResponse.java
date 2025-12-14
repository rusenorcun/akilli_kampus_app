package com.mobil.kampusapp.dto;

import java.util.List;

public record AuthResponse(
    boolean authenticated,
    String username,
    List<String> authorities
) {}
