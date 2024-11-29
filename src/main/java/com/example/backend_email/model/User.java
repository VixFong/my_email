package com.example.backend_email.model;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import lombok.*;

import java.time.LocalDate;

@Entity
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private String id;
    private String phoneNumber;
    private String password;
    private LocalDate dateOfBirth;
    private String firstName;
    private String lastName;
//    private String userName;

    private String email;
    private String gmailAccount;
    private String gender;
    private String profilePic;

    @Builder.Default
    private boolean twoFactorEnabled = false;
    private LocalDate createdAt;
    private LocalDate updatedAt;
}
