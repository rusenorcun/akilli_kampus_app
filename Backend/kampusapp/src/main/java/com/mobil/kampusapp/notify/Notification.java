package com.mobil.kampusapp.notify;

import java.time.Instant;

public record Notification(
    long id,
    String type,
    String title,
    String message,
    Instant ts
) {}
