package com.mobil.kampusapp.controller;

import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/secure")
public class TestSecureController {

  @GetMapping("/read")
  @PreAuthorize("hasAuthority('INCIDENT_READ')")
  public String canRead() { return "read-ok"; }

  @PostMapping("/write")
  @PreAuthorize("hasAuthority('INCIDENT_WRITE')")
  public String canWrite() { return "write-ok"; }
}
