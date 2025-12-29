package com.mobil.kampusapp.repository;

import com.mobil.kampusapp.entity.Category;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface CategoryRepository extends JpaRepository<Category, Long> {//kategori veritabanı işlemlerini yapar(jparepositoryden miras alır)
    Optional<Category> findByNameIgnoreCase(String name);
}
