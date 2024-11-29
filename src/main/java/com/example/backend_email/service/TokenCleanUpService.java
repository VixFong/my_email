package com.example.backend_email.service;


import com.example.backend_email.model.InvalidToken;
import com.example.backend_email.repo.InvalidTokenRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;

@Service
public class TokenCleanUpService {

    @Autowired
    private InvalidTokenRepository invalidTokenRepository;

    @Scheduled(cron = "0 0 * * * ?") // Chạy mỗi giờ
    public void cleanupExpiredTokens() {
        LocalDateTime now = LocalDateTime.now();
        List<InvalidToken> expiredTokens = invalidTokenRepository.findByExpireTimeBefore(now);
        invalidTokenRepository.deleteAll(expiredTokens);
    }
}

