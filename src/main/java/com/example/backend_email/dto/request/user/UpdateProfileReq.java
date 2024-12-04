package com.example.backend_email.dto.request.user;

import lombok.*;
import org.springframework.web.multipart.MultipartFile;

import java.time.LocalDate;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class UpdateProfileReq {
    private String firstName;
    private String lastName;
    private String password;
    private String email;
    private String gmailAccount;
    private LocalDate dateOfBirth;
    private boolean twoFactorEnabled;
    private String gender;
    private MultipartFile file;
    private LocalDate updatedAt;

}
