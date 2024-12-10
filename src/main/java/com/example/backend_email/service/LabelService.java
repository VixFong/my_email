package com.example.backend_email.service;

import com.example.backend_email.model.Email;
import com.example.backend_email.model.EmailLabel;
import com.example.backend_email.repo.EmailLabelRepository;
import com.example.backend_email.repo.EmailRepository;
import com.example.backend_email.repo.LabelRepository;
import com.example.backend_email.repo.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.example.backend_email.model.Label;

import java.time.LocalDateTime;

@Service
public class LabelService {
    @Autowired
    private UserRepository userRepository;

    @Autowired
    private EmailRepository emailRepository;

    @Autowired
    private LabelRepository labelRepository;

    @Autowired
    private EmailLabelRepository emailLabelRepository;
    public Label createLabel(String userId, String labelName) {
        Label label = Label.builder()
                .user(userRepository.findById(userId)
                        .orElseThrow(() -> new RuntimeException("User not found")))
                .name(labelName)
                .createdAt(LocalDateTime.now())
                .build();
        return labelRepository.save(label);
    }

    public void assignLabelToEmail(String emailId, String labelId) {
        Email email = emailRepository.findById(emailId)
                .orElseThrow(() -> new RuntimeException("Email not found"));
        Label label = labelRepository.findById(labelId)
                .orElseThrow(() -> new RuntimeException("Label not found"));

        EmailLabel emailLabel = EmailLabel.builder()
                .email(email)
                .label(label)
                .build();
        emailLabelRepository.save(emailLabel);
    }

}
