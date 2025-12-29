package com.mobil.kampusapp.security;

import com.mobil.kampusapp.service.JwtService;
import com.mobil.kampusapp.service.UserDetailsServiceImpl;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.web.authentication.WebAuthenticationDetailsSource;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;

@Component
public class JwtAuthFilter extends OncePerRequestFilter {//her istek için çalışır, jwt token doğrulaması yapar

    private final JwtService jwtService;
    private final UserDetailsServiceImpl userDetailsService;

    public JwtAuthFilter(JwtService jwtService, UserDetailsServiceImpl userDetailsService) {
        this.jwtService = jwtService;
        this.userDetailsService = userDetailsService;
    }

    @Override
    protected void doFilterInternal(HttpServletRequest request,
                                    HttpServletResponse response,
                                    FilterChain filterChain) throws ServletException, IOException {

        String authHeader = request.getHeader("Authorization");//headerdan token al

        if (authHeader == null || !authHeader.startsWith("Bearer ")) {
            filterChain.doFilter(request, response);//token yoksa devam et
            return;
        }

        String jwt = authHeader.substring(7);

        String username;
        try {
            username = jwtService.extractUsername(jwt);//token geçerliyse kullanıcı adını al
        } catch (Exception ex) {
            filterChain.doFilter(request, response);//geçersizse devam et
            return;
        }

        if (username != null && SecurityContextHolder.getContext().getAuthentication() == null) {//kullanıcı adı varsa ve kimlik doğrulama yoksa
            UserDetails userDetails = userDetailsService.loadUserByUsername(username);//kullanıcı detaylarını yükle

            if (jwtService.isTokenValid(jwt, userDetails)) {//token geçerliyse
                UsernamePasswordAuthenticationToken authToken =
                        new UsernamePasswordAuthenticationToken(userDetails, null, userDetails.getAuthorities());//kimlik doğrulama nesnesi oluştur

                authToken.setDetails(new WebAuthenticationDetailsSource().buildDetails(request));//detayları ayarla
                SecurityContextHolder.getContext().setAuthentication(authToken);//güvenlik bağlamına kimlik doğrulamayı ayarla
            }
        }

        filterChain.doFilter(request, response);
    }
}
