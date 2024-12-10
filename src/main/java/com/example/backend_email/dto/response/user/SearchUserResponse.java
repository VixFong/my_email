package com.example.backend_email.dto.response.user;

import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class SearchUserResponse {
    private String id;
    private String profilePic;
    private String firstName;
    private String lastName;
    private String email;
}
