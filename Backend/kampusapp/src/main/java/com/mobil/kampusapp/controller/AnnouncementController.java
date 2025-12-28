package com.mobil.kampusapp.controller;

import com.mobil.kampusapp.notify.NotificationCenter;
import com.mobil.kampusapp.user.Preferences;
import com.mobil.kampusapp.user.ProfileStore;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.time.Instant;
import java.util.ArrayDeque;
import java.util.Deque;
import java.util.List;
import java.util.concurrent.atomic.AtomicLong;

@RestController
@RequestMapping("/api/announcements")
public class AnnouncementController {

  public record AnnReq(String title, String content, boolean emergency){}
  public record AnnDTO(long id, String title, String content, boolean emergency, Instant ts){}

  private static final AtomicLong ANN_SEQ = new AtomicLong(1);
  private static final Deque<AnnDTO> ANNS = new ArrayDeque<>(); 

  private final NotificationCenter notifier;
  private final ProfileStore profiles;

  public AnnouncementController(NotificationCenter notifier, ProfileStore profiles) {
    this.notifier = notifier;
    this.profiles = profiles;
  }

  @PreAuthorize("hasRole('ADMIN')")
  @PostMapping
  public AnnDTO create(@RequestBody AnnReq r){
    AnnDTO dto = new AnnDTO(ANN_SEQ.getAndIncrement(), r.title(), r.content(), r.emergency(), Instant.now());
    ANNS.addFirst(dto);
    while (ANNS.size() > 50) ANNS.removeLast();

    // Broadcast: tercihi açık olan herkese
    for (var email : profiles.allEmails()){
      var pref = profiles.get(email).map(p -> p.preferences()).orElse(Preferences.defaults());
      if (pref.notifyAllAnnouncements()) {
        notifier.pushToUser(email, "ANNOUNCEMENT", r.title(), r.content());
      }
    }
    return dto;
  }

  @GetMapping
  public List<AnnDTO> list(){ return List.copyOf(ANNS); }
}
