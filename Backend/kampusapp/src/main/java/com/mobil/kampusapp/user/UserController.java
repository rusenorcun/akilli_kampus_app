package com.mobil.kampusapp.user;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/api/users")
public class UserController {

  private final ProfileStore profiles;

  public UserController(ProfileStore profiles) {
    this.profiles = profiles;
  }

  @GetMapping("/me")
  public Map<String,Object> me(Authentication auth){
    var email = auth.getName();
    var p = profiles.get(email).orElse(new UserProfile(email, email, "", Preferences.defaults()));
    return Map.of(
        "email", p.email(),
        "fullName", p.fullName(),
        "unit", p.unit(),
        "preferences", p.preferences(),
        "authorities", auth.getAuthorities().stream().map(GrantedAuthority::getAuthority).toList()
    );
  }

  public record PrefPatch(Boolean notifyAllAnnouncements, Boolean notifyIncidentStatusChanges) {}

  @PatchMapping("/me/preferences")
  public Map<String,Object> patchPrefs(Authentication auth, @RequestBody PrefPatch patch){
    var email = auth.getName();
    var cur = profiles.get(email).orElse(new UserProfile(email, email, "", Preferences.defaults()));
    var np = new Preferences(
        patch.notifyAllAnnouncements  != null ? patch.notifyAllAnnouncements  : cur.preferences().notifyAllAnnouncements(),
        patch.notifyIncidentStatusChanges != null ? patch.notifyIncidentStatusChanges : cur.preferences().notifyIncidentStatusChanges()
    );
    var updated = new UserProfile(cur.email(), cur.fullName(), cur.unit(), np);
    profiles.put(updated);
    return Map.of("message","preferences-updated", "preferences", np);
  }
}
