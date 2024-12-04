package com.example.backend_email.dto.request.user;

import jakarta.persistence.Column;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import lombok.*;
import org.springframework.format.annotation.DateTimeFormat;

import java.time.LocalDate;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CreateUserReq {

    @NotBlank(message = "Phone number is required")
    @Pattern(
            regexp = "^[+]?[0-9]{10,15}$",
            message = "Phone number must be valid and contain 10-15 digits, optionally prefixed with '+'"
    )
    private String phoneNumber;

    @NotBlank(message = "Password is required")
    private String password;
    private String firstName;
    private String lastName;
//    private String userName;

    private LocalDate dateOfBirth;
    private String gender;

//    private String profilePic;
//    @Column(nullable = false, columnDefinition = "BOOLEAN DEFAULT FALSE")

    @Email(message = "EMAIL_INVALID")
    private String email;

    @Email(message = "EMAIL_INVALID")
    private String gmailAccount;

//    private boolean twoFactorEnabled;


}
