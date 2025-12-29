package com.mobil.kampusapp.repository;

import com.mobil.kampusapp.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface UserRepository extends JpaRepository<User, Long> {//kullanıcı veritabanı işlemlerini yapar(jparepositoryden miras alır)
    Optional<User> findByEmail(String email);
    boolean existsByEmail(String email);
}
