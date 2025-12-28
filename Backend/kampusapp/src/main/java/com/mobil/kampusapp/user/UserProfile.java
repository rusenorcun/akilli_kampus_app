package com.mobil.kampusapp.user;

public record UserProfile(
    String email,
    String fullName,
    String unit,
    Preferences preferences
) {}
