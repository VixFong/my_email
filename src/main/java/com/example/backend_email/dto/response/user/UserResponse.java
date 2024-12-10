package com.example.backend_email.dto.response.user;

import lombok.*;

import java.time.LocalDate;


@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class UserResponse {
    private String id;
    private String phoneNumber;
    private String password;
    private String firstName;
    private String lastName;


    private LocalDate dateOfBirth;
    private String gender;

    private String profilePic;
    private String email;
    private String gmailAccount;

    private boolean twoFactorEnabled;
    private LocalDate createdAt;
    private LocalDate updatedAt;

}
