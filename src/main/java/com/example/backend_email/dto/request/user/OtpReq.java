package com.example.backend_email.dto.request.user;

import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class OtpReq {
    private String token;
    private String otpProvided;
}
