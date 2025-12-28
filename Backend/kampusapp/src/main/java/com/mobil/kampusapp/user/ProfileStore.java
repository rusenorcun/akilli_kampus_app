package com.mobil.kampusapp.user;

import org.springframework.stereotype.Component;

import java.util.*;
import java.util.concurrent.ConcurrentHashMap;

@Component
public class ProfileStore {

  private final Map<String, UserProfile> profiles = new ConcurrentHashMap<>();

  public ProfileStore() {
    put(new UserProfile("admin@kampus.local", "Sistem Yöneticisi", "Bilgi İşlem", Preferences.defaults()));
    put(new UserProfile("user@kampus.local",  "Öğrenci Kullanıcı", "Mühendislik Fakültesi", Preferences.defaults()));
  }

  public Optional<UserProfile> get(String email){ return Optional.ofNullable(profiles.get(email)); }
  public void put(UserProfile p){ profiles.put(p.email(), p); }

  public Set<String> allEmails(){ return Set.copyOf(profiles.keySet()); }
}
