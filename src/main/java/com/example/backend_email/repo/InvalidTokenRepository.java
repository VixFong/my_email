package com.example.backend_email.repo;

import com.example.backend_email.model.InvalidToken;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;

@Repository
public interface InvalidTokenRepository extends JpaRepository<InvalidToken, String> {
    List<InvalidToken> findByExpireTimeBefore(LocalDateTime now);
}

