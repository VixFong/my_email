package com.example.backend_email.dto.request.user;

import com.example.backend_email.model.User;
import jakarta.persistence.Column;
import jakarta.persistence.Lob;
import lombok.*;
import org.springframework.web.multipart.MultipartFile;

import java.time.LocalDateTime;
import java.util.List;

@Getter
@Setter
@Builder
@ToString
public class CreateEmailReq {
    private String senderId;
    private String subject;
    private String body;
    private boolean isDraft;
    private List<CreateRecipientReq> recipients;
//    private List<MultipartFile> attachments;

}
