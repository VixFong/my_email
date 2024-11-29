package com.example.backend_email.dto.request.user;

import lombok.*;

import java.time.LocalDate;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class LoginUserReq {
    private String phoneNumber;
    private String password;
}
