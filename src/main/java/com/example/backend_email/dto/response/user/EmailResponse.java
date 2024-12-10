package com.example.backend_email.dto.response.user;

import com.example.backend_email.dto.AttachmentDTO;
import com.example.backend_email.dto.request.user.CreateAttachmentReq;
import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;
import java.util.List;

@Getter
@Setter
@Builder
public class EmailResponse {
    private String id;
    private String senderName;
    private String senderEmail;
    private String subject;
    private String body;       // Only populated in detailed view
    private String preview;    // Short snippet of body for basic view
    private LocalDateTime createdAt;
    private boolean isRead;
    private boolean isStarred;
    private String folder;     // e.g., "Inbox", "Starred", "Draft"
    private List<String> labels;
    private List<AttachmentDTO> attachments;

}
