package com.mobil.kampusapp.service;

import com.mobil.kampusapp.entity.User;
import com.mobil.kampusapp.repository.UserRepository;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;

@Service
public class UserService {

    private final UserRepository users;

    public UserService(UserRepository users) {
        this.users = users;
    }

    public User getMe() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        String email = auth.getName();
        return users.findByEmail(email)
                .orElseThrow(() -> new IllegalArgumentException("Authenticated user not found."));
    }
}
