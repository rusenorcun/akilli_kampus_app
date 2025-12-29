package com.mobil.kampusapp.service;

import com.mobil.kampusapp.dto.ReportCreateRequest;
import com.mobil.kampusapp.dto.ReportDto;
import com.mobil.kampusapp.entity.*;
import com.mobil.kampusapp.repository.CategoryRepository;
import com.mobil.kampusapp.repository.ReportRepository;
import com.mobil.kampusapp.repository.UserRepository;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ReportService {

    private final ReportRepository reports;
    private final UserRepository users;
    private final CategoryRepository categories;

    public ReportService(ReportRepository reports, UserRepository users, CategoryRepository categories) {
        this.reports = reports;
        this.users = users;
        this.categories = categories;
    }

    public ReportDto create(ReportCreateRequest req) {
        String email = currentUserEmail();

        User user = users.findByEmail(email)
                .orElseThrow(() -> new IllegalArgumentException("User not found."));

        String catName = safeTrim(req.getCategory());
        Category cat = categories.findByNameIgnoreCase(catName)
                .orElseThrow(() -> new IllegalArgumentException("Category not found: " + req.getCategory()));

        Report r = new Report();
        r.setTitle(req.getTitle());
        r.setDescription(req.getDescription());
        r.setLocation(safeTrim(req.getLocation())); 
        r.setUser(user);
        r.setCategory(cat);
        r.setStatus(ReportStatus.OPEN);

        Report saved = reports.save(r);
        return toDto(saved);
    }

    public List<ReportDto> getAll() {
        return reports.findAll().stream().map(this::toDto).toList();
    }

    public ReportDto getById(Long id) {
        return toDto(reports.findById(id).orElseThrow(() -> new IllegalArgumentException("Report not found")));
    }

    public ReportDto updateStatus(Long id, ReportStatus status) {
        Report r = reports.findById(id).orElseThrow(() -> new IllegalArgumentException("Report not found"));
        r.setStatus(status);
        return toDto(reports.save(r));
    }

    private ReportDto toDto(Report r) {
        ReportDto dto = new ReportDto();
        dto.setId(r.getId());
        dto.setTitle(r.getTitle());
        dto.setDescription(r.getDescription());
        dto.setLocation(r.getLocation()); 
        dto.setStatus(r.getStatus() != null ? r.getStatus().name() : null);
        dto.setCreatedAt(r.getCreatedAt());
        dto.setUserId(r.getUser() != null ? r.getUser().getId() : null);
        dto.setCategory(r.getCategory() != null ? r.getCategory().getName() : null);
        return dto;
    }

    private String currentUserEmail() {
        Authentication a = SecurityContextHolder.getContext().getAuthentication();
        return a.getName().toLowerCase();
    }

    private String safeTrim(String s) {
        return s == null ? null : s.trim();
    }
    
}
