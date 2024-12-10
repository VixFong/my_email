package com.example.backend_email.controller.user;

import com.example.backend_email.dto.request.user.CreateEmailReq;
import com.example.backend_email.dto.request.user.CreateRecipientReq;
import com.example.backend_email.dto.request.user.LoginUserReq;
import com.example.backend_email.dto.request.user.TokenReq;
import com.example.backend_email.dto.response.ApiResponse;
import com.example.backend_email.dto.response.user.EmailResponse;
import com.example.backend_email.dto.response.user.IntrospectResponse;
import com.example.backend_email.dto.response.user.LoginResponse;
import com.example.backend_email.model.Email;
import com.example.backend_email.service.AuthService;
import com.example.backend_email.service.EmailService;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.nimbusds.jose.JOSEException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.core.type.TypeReference;

import java.text.ParseException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/email")
public class EmailController {
    @Autowired
    private EmailService emailService;
    @PostMapping("/compose")
    public ApiResponse<String> createEmail(@RequestBody CreateEmailReq req) {

        System.out.println("Controller");
        System.out.println("senderId " + req.getSenderId());
        System.out.println("subject " + req.getSubject());
        System.out.println("body " + req.getBody());
        System.out.println("isDraft " + req.isDraft());
        System.out.println("Recipient" + req.getRecipients());

//        String emailId = ;
        return ApiResponse.<String>builder()
                .data(emailService.compose(req)) // Trả về ID email để sử dụng cập nhật attachments
                .build();
    }
    @PostMapping("/attachments/{emailId}")
    public ApiResponse<Void> updateAttachments(
            @PathVariable String emailId,
            @RequestParam("attachments") List<MultipartFile> attachments) {
        // Tìm email từ ID
        Email email = emailService.findEmailById(emailId);

        // Xử lý attachments
        emailService.handleAttachments(attachments, email);

        return ApiResponse.<Void>builder()
                .message("Attachments updated successfully")
                .build();
    }

    @PostMapping("")
    public ResponseEntity<String> debugRequest(@RequestBody String body) {
        System.out.println("Raw body: " + body);

        return ResponseEntity.ok("Received");
    }

    @GetMapping("/folder/{folder}")
    public ApiResponse<List<EmailResponse>> getEmailsByFolder(
            @PathVariable String folder,
            @RequestParam(defaultValue = "false") boolean detailed) {
        List<EmailResponse> emails = emailService.getEmailsByFolder(folder, detailed);
        return ApiResponse.<List<EmailResponse>>builder()
                .data(emails)
                .build();
    }

    @PostMapping("/reply/{email}")
    public ApiResponse<Email> replyToEmail(
            @PathVariable String emailId,
            @RequestBody CreateEmailReq request) {
        System.out.println("Controller");
//        System.out.println("Recipients: " + request.getRecipients());
        return ApiResponse.<Email>builder()
                .data(emailService.replyToEmail(emailId, request))
                .build();
    }




//    @GetMapping("/verify-phoneNumber")
//
//    public boolean isValidPhoneNumber(@RequestParam String phoneNumber, @RequestParam String region){
//        return authService.checkPhoneNumber(phoneNumber,region);
//    }


}
