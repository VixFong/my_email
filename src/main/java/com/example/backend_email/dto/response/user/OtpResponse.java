package com.example.backend_email.dto.response.user;

import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class OtpResponse {
    private String token;
}
