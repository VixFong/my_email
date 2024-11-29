package com.example.backend_email.dto.response;


import com.fasterxml.jackson.annotation.JsonInclude;
import lombok.*;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@Builder
@JsonInclude(JsonInclude.Include.NON_NULL)
public class ApiResponse<T>{
    @Builder.Default
    private int code = 200;
    private String message;
    private T data;


}