package com.example.backend_email.dto.request.user;

import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class PasswordReq {
    private String token;
    private String password;
}
