package com.mobil.kampusapp.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.config.Customizer;
import org.springframework.security.config.annotation.authentication.configuration.AuthenticationConfiguration;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.core.userdetails.*;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.provisioning.InMemoryUserDetailsManager;
import org.springframework.security.web.SecurityFilterChain;

@Configuration
@EnableMethodSecurity
public class SecurityConfig {

  @Bean
  public PasswordEncoder passwordEncoder() { return new BCryptPasswordEncoder(); }

  @Bean
  public InMemoryUserDetailsManager userDetailsService(PasswordEncoder enc) {
    UserDetails admin = User.withUsername("admin@kampus.local")
        .password(enc.encode("Admin123!"))
        .roles("ADMIN")
        .authorities("INCIDENT_READ","INCIDENT_WRITE","USER_MANAGE")
        .build();

    UserDetails user = User.withUsername("user@kampus.local")
        .password(enc.encode("User123!"))
        .roles("USER")
        .authorities("INCIDENT_READ")
        .build();

    return new InMemoryUserDetailsManager(admin, user);
  }

  @Bean
  public AuthenticationManager authenticationManager(AuthenticationConfiguration cfg) throws Exception {
    return cfg.getAuthenticationManager();
  }

  @Bean
  public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
    http
      .csrf(csrf -> csrf.disable())
      .authorizeHttpRequests(auth -> auth
          .requestMatchers("/auth/login", "/auth/me", "/auth/forgot-password", "/auth/reset-password").permitAll()
          .requestMatchers("/actuator/**").permitAll()
          .anyRequest().authenticated()
      )
      .httpBasic(Customizer.withDefaults());
    return http.build();
  }
}
