package com.mobil.kampusapp.controller;

import org.springframework.http.MediaType;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.nio.file.Path;
import java.util.Map;
import java.util.UUID;

@RestController
@RequestMapping("/api/files")
public class FileController {

  @PreAuthorize("isAuthenticated()")
  @PostMapping(consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
  public Map<String, Object> upload(@RequestPart("file") MultipartFile file) throws Exception {
    if (file.getSize() > 5_000_000) throw new IllegalArgumentException("Max 5MB");

    Path dir = Path.of(System.getProperty("java.io.tmpdir"), "kampusapp");
    java.nio.file.Files.createDirectories(dir);
    Path target = dir.resolve(UUID.randomUUID() + "_" + file.getOriginalFilename());
    file.transferTo(target);

    return Map.of(
        "path", target.toString(),
        "size", file.getSize(),
        "name", file.getOriginalFilename()
    );
  }
}
