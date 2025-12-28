package com.mobil.kampusapp.user;

public record Preferences(
    boolean notifyAllAnnouncements,
    boolean notifyIncidentStatusChanges
) {
    public static Preferences defaults() { return new Preferences(true, true); }
}
