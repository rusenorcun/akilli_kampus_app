package com.mobil.kampusapp.notify;

import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/notifications")
public class NotificationController {

  private final NotificationCenter center;

  public NotificationController(NotificationCenter center) {
    this.center = center;
  }

  @GetMapping
  public List<Notification> myNotifications(Authentication auth){
    return center.listForUser(auth.getName());
  }
}
