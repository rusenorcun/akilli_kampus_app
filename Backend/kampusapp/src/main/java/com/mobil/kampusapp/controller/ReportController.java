package com.mobil.kampusapp.controller;

import com.mobil.kampusapp.dto.ReportCreateRequest;
import com.mobil.kampusapp.dto.ReportDto;
import com.mobil.kampusapp.dto.StatusUpdateRequest;
import com.mobil.kampusapp.entity.ReportStatus;
import com.mobil.kampusapp.service.ReportService;
import jakarta.validation.Valid;
import org.springframework.http.*;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/reports")//raporlarla ilgili istekler buraya gelecek
public class ReportController {

    private final ReportService reports;

    public ReportController(ReportService reports) {
        this.reports = reports;
    }

    @PostMapping
    public ResponseEntity<ReportDto> create(@Valid @RequestBody ReportCreateRequest req) {
        ReportDto created = reports.create(req);
        return ResponseEntity.status(HttpStatus.CREATED).body(created);
    }

    @GetMapping
    public ResponseEntity<List<ReportDto>> getAll() {
        return ResponseEntity.ok(reports.getAll());
    }

    @GetMapping("/{id}")//id ye göre rapor getirir
    public ResponseEntity<ReportDto> getById(@PathVariable Long id) {
        return ResponseEntity.ok(reports.getById(id));
    }

    // Sadece ADMIN rolüne sahip kullanıcılar bu metoda erişebilir
    @PreAuthorize("hasRole('ADMIN')")
    @PutMapping("/{id}/status")
    public ResponseEntity<ReportDto> updateStatus(@PathVariable Long id, @Valid @RequestBody StatusUpdateRequest body) {

        ReportStatus status;
        try {
            status = ReportStatus.valueOf(body.getStatus().trim().toUpperCase());
        } catch (Exception e) {
            throw new IllegalArgumentException("Invalid status: " + body.getStatus());
        }

        return ResponseEntity.ok(reports.updateStatus(id, status));
    }
}
