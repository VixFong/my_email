package com.example.backend_email.dto.request.user;

import com.example.backend_email.model.Recipient;
import lombok.*;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CreateAttachmentReq {
    private String fileName;
    private String filePath;
}
