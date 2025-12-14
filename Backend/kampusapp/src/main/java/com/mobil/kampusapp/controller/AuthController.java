package com.mobil.kampusapp.controller;

import com.mobil.kampusapp.dto.AuthResponse;
import com.mobil.kampusapp.dto.LoginRequest;
import com.mobil.kampusapp.dto.MessageResponse;
import jakarta.validation.Valid;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.*;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.provisioning.InMemoryUserDetailsManager;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.*;

import java.util.*;
import java.util.concurrent.ConcurrentHashMap;

@RestController
@RequestMapping("/auth")
public class AuthController {

  private final AuthenticationManager authManager;
  private final InMemoryUserDetailsManager users;
  private final PasswordEncoder encoder;

  // in-memory reset kod deposu: email -> code
  private static final Map<String, String> RESET_CODES = new ConcurrentHashMap<>();

  public AuthController(AuthenticationManager authManager,
                        InMemoryUserDetailsManager users,
                        PasswordEncoder encoder) {
    this.authManager = authManager;
    this.users = users;
    this.encoder = encoder;
  }

  // A) Kimim? — Basic Auth ile çağırırsan user/authority döner
  @GetMapping("/me")
  public Object me(Authentication auth) {
    if (auth == null || !auth.isAuthenticated()) {
      return Map.of("authenticated", false);
    }
    return new AuthResponse(
        true,
        auth.getName(),
        auth.getAuthorities().stream().map(GrantedAuthority::getAuthority).toList()
    );
  }

  // B) Login — JSON ile doğrula (JWT üretmiyoruz, Basic Auth için var)
  @PostMapping("/login")
  public AuthResponse login(@Valid @RequestBody LoginRequest req) {
    var token = new UsernamePasswordAuthenticationToken(req.email(), req.password());
    var result = authManager.authenticate(token); // yanlışsa 401 döner
    return new AuthResponse(
        true,
        result.getName(),
        result.getAuthorities().stream().map(GrantedAuthority::getAuthority).toList()
    );
  }

  // C) Şifremi Unuttum — email al, kod üret + sakla + (dev) döndür
  @PostMapping("/forgot-password")
  public Map<String, String> forgot(@RequestBody Map<String, String> body) {
    var email = Objects.requireNonNull(body.get("email"), "email required");
    if (!users.userExists(email)) {
      return Map.of("message", "If the email exists, a code was sent.");
    }
    var code = String.format("%06d", new Random().nextInt(1_000_000));
    RESET_CODES.put(email, code);
    return Map.of("message", "Code sent (dev).", "devCode", code);
  }

  // D) Şifre Sıfırla — email + code + newPassword
  @PostMapping("/reset-password")
  public MessageResponse reset(@RequestBody Map<String, String> body) {
    var email = Objects.requireNonNull(body.get("email"), "email required");
    var code = Objects.requireNonNull(body.get("code"), "code required");
    var newPassword = Objects.requireNonNull(body.get("newPassword"), "newPassword required");

    var expected = RESET_CODES.get(email);
    if (!Objects.equals(expected, code)) {
      throw new IllegalArgumentException("Invalid code");
    }

    UserDetails u = users.loadUserByUsername(email);
    users.updatePassword(u, encoder.encode(newPassword));
    RESET_CODES.remove(email);
    return new MessageResponse("Password updated");
  }
}
