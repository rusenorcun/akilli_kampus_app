package com.mobil.kampusapp.incident;

import com.mobil.kampusapp.dto.PageResponse;
import com.mobil.kampusapp.incident.dto.CreateIncidentRequest;
import com.mobil.kampusapp.incident.dto.UpdateIncidentRequest;
import com.mobil.kampusapp.incident.dto.UpdateStatusRequest;
import com.mobil.kampusapp.notify.NotificationCenter;
import com.mobil.kampusapp.user.ProfileStore;
import com.mobil.kampusapp.user.UserProfile;
import com.mobil.kampusapp.user.Preferences;
import jakarta.validation.Valid;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/incidents")
public class IncidentController {

  private final IncidentStore store;
  private final NotificationCenter notifier;
  private final ProfileStore profiles;

  public IncidentController(IncidentStore store, NotificationCenter notifier, ProfileStore profiles) {
    this.store = store;
    this.notifier = notifier;
    this.profiles = profiles;
  }

  // Listeleme + filtre + sayfalama
  @GetMapping
  public PageResponse<Incident> list(
      @RequestParam(value="q", required=false) String q,
      @RequestParam(value="type", required=false) IncidentType type,
      @RequestParam(value="status", required=false) IncidentStatus status,
      @RequestParam(value="followed", required=false) Boolean followed,
      @RequestParam(value="sort", required=false, defaultValue = "createdAt") String sort,
      @RequestParam(value="order", required=false, defaultValue = "desc") String order,
      @RequestParam(value="page", required=false, defaultValue = "0") int page,
      @RequestParam(value="size", required=false, defaultValue = "10") int size,
      Authentication auth
  ) {
    boolean desc = "desc".equalsIgnoreCase(order);
    var userEmail = (auth != null) ? auth.getName() : null;
    var content = store.findAllFiltered(q, type, status, followed, userEmail, sort, desc, page, size);
    long total = store.countFiltered(q, type, status, followed, userEmail);
    return new PageResponse<>(content, page, size, total);
  }

  // Detay
  @GetMapping("/{id}")
  public Incident detail(@PathVariable Long id) {
    return store.findById(id).orElseThrow(() -> new IllegalArgumentException("Incident not found: " + id));
  }

  // Oluşturma (INCIDENT_WRITE gerekir)
  @PostMapping
  @PreAuthorize("hasAuthority('INCIDENT_WRITE')")
  public Incident create(@Valid @RequestBody CreateIncidentRequest req, Authentication auth) {
    var email = auth.getName();
    return store.saveNew(req.title(), req.description(), req.lat(), req.lon(), req.type(), email);
  }

  // Durum güncelle (INCIDENT_WRITE gerekir) + takipçilere bildirim
  @PatchMapping("/{id}/status")
  @PreAuthorize("hasAuthority('INCIDENT_WRITE')")
  public Incident updateStatus(@PathVariable Long id, @Valid @RequestBody UpdateStatusRequest req) {
    var inc = store.findById(id).orElseThrow(() -> new IllegalArgumentException("Incident not found: " + id));
    var updated = store.updateStatus(inc.id(), req.status());

    // Bildirim: takibi açık olanlara
    var followers = store.followedByUser("").getClass(); // sadece type access için hile :)
    // gerçek takipçiler:
    store.followedByUser("").size(); // NOP

    // followersByIncident'i doğrudan istemiyoruz; store’a method eklemedik.
    // Pratik yol: isFollowing'i taramak yerine aşağıda küçük bir yardımcı ile çözüyoruz:
    // (Not: store'a public getter eklemek istemedik; bu yüzden basitçe tüm profilleri dolaşıp bakanları bulacağız)
    for (var email : profiles.allEmails()) {
      if (store.isFollowing(id, email)) {
        var pref = profiles.get(email).map(UserProfile::preferences).orElse(Preferences.defaults());
        if (pref.notifyIncidentStatusChanges()) {
          notifier.pushToUser(email, "INCIDENT_STATUS",
              "Bildirimin durumu güncellendi",
              "#" + id + " → " + updated.status());
        }
      }
    }

    return updated;
  }

  // Açıklama düzenleme (ADMIN)
  @PatchMapping("/{id}")
  @PreAuthorize("hasRole('ADMIN')")
  public Incident patchDescription(@PathVariable Long id, @Valid @RequestBody UpdateIncidentRequest req) {
    store.findById(id).orElseThrow(() -> new IllegalArgumentException("Incident not found: " + id));
    return store.updateDescription(id, req.description());
  }

  // Sonlandır (ADMIN kısa yolu)
  @PostMapping("/{id}/close")
  @PreAuthorize("hasRole('ADMIN')")
  public Incident close(@PathVariable Long id) {
    store.findById(id).orElseThrow(() -> new IllegalArgumentException("Incident not found: " + id));
    return store.close(id);
  }

  // Takip et
  @PostMapping("/{id}/follow")
  public Object follow(@PathVariable Long id, Authentication auth){
    store.findById(id).orElseThrow(() -> new IllegalArgumentException("Incident not found: " + id));
    store.follow(id, auth.getName());
    return java.util.Map.of("message","followed");
  }

  // Takipten çık
  @DeleteMapping("/{id}/follow")
  public Object unfollow(@PathVariable Long id, Authentication auth){
    store.findById(id).orElseThrow(() -> new IllegalArgumentException("Incident not found: " + id));
    store.unfollow(id, auth.getName());
    return java.util.Map.of("message","unfollowed");
  }

  // Benim takip ettiklerim
  @GetMapping("/me/follows")
  public java.util.Set<Long> myFollows(Authentication auth){
    return store.followedByUser(auth.getName());
  }
}
