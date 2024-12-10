package com.example.backend_email.dto;

import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Builder
public class AttachmentDTO {
    private String id;
    private String fileName;
    private String fileUrl;


}
