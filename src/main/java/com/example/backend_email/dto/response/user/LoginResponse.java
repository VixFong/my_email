package com.example.backend_email.dto.response.user;

import lombok.*;

import java.time.LocalDate;


@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class LoginResponse {
    private String token;
    private boolean authenticated;
    private String otpToken;
    private String firsName;
    private String lastName;
    private String email;

    private String profilePic;
}
