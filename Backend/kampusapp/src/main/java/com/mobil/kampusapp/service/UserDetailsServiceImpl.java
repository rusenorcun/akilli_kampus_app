// File: src/main/java/com/mobil/kampusapp/service/UserDetailsServiceImpl.java
package com.mobil.kampusapp.service;

import com.mobil.kampusapp.entity.Role;
import com.mobil.kampusapp.entity.User;
import com.mobil.kampusapp.repository.UserRepository;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class UserDetailsServiceImpl implements org.springframework.security.core.userdetails.UserDetailsService {

    private final UserRepository users;

    public UserDetailsServiceImpl(UserRepository users) {
        this.users = users;
    }

    @Override
    public UserDetails loadUserByUsername(String email) throws UsernameNotFoundException {
        User u = users.findByEmail(email.toLowerCase())
                .orElseThrow(() -> new UsernameNotFoundException("User not found: " + email));

        Role role = (u.getRole() == null) ? Role.ROLE_STUDENT : u.getRole();

        return new org.springframework.security.core.userdetails.User(
                u.getEmail(),
                u.getPassword(),
                List.of(new SimpleGrantedAuthority(role.name()))
        );
    }
}
