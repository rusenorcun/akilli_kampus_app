package com.mobil.kampusapp.repository;

import com.mobil.kampusapp.entity.Report;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ReportRepository extends JpaRepository<Report, Long> {//rapor veritabanı işlemlerini yapar(jparepositoryden miras alır
}
