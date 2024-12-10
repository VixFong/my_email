package com.example.backend_email.service;

import com.cloudinary.Cloudinary;
import com.cloudinary.utils.ObjectUtils;
import com.example.backend_email.dto.AttachmentDTO;
import com.example.backend_email.dto.request.user.CreateAttachmentReq;
import com.example.backend_email.dto.request.user.CreateEmailReq;
import com.example.backend_email.dto.request.user.CreateRecipientReq;
import com.example.backend_email.dto.response.user.EmailResponse;
import com.example.backend_email.exception.AppException;
import com.example.backend_email.exception.ErrorCode;
import com.example.backend_email.model.Attachment;
import com.example.backend_email.model.Email;
import com.example.backend_email.model.Recipient;
import com.example.backend_email.model.User;
import com.example.backend_email.repo.*;
import jakarta.mail.Multipart;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.Comparator;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
public class EmailService {
    @Autowired
    private EmailRepository emailRepository;


    @Autowired
    private UserRepository userRepository;

    @Autowired
    private RecipientRepository recipientRepository;

    @Autowired
    private Cloudinary cloudinary;

    @Autowired
    private AttachmentRepository attachmentRepository;
    public String compose(CreateEmailReq req) {
        // Fetch sender from database
        User sender = userRepository.findById(req.getSenderId())
                .orElseThrow(() -> new AppException(ErrorCode.SENDER_NOT_FOUND));

        System.out.println("req draft" + req.isDraft());
        String folder = req.isDraft() ? "Draft" : "Sent";

        Email email = Email.builder()
                .sender(sender)
                .subject(req.getSubject())
                .body(req.getBody())
                .isDraft(req.isDraft())
                .folder(folder)
                .createdAt(LocalDateTime.now())
//                .updatedAt(LocalDateTime.now())
                .build();

        // Save email
        var saveEmail = emailRepository.save(email);

        // Save recipients
        if(req.getRecipients() != null){
            List<Recipient> recipients = req.getRecipients().stream()
                    .map(recipientDTO -> Recipient.builder()
                            .email(saveEmail)
                            .user(userRepository.findById(recipientDTO.getUserId())
                                    .orElseThrow(() -> new AppException(ErrorCode.RECIPIENT_NOT_FOUND)))
                            .type(recipientDTO.getType())
//                            .type(Recipient.RecipientType.valueOf(recipientDTO.getType()))
                            .build())
                    .toList();
            recipientRepository.saveAll(recipients);
            // Deliver email to recipients' inbox
             recipients.forEach(recipient -> deliverToInbox(recipient.getUser(), saveEmail));
        }
        return email.getId();

    }
    private void deliverToInbox(User recipient, Email email) {
        Email inboxEmail = Email.builder()
                .sender(email.getSender())
                .subject(email.getSubject())
                .body(email.getBody())
                .isRead(false)
                .isDraft(false)
                .folder("Inbox")
                .createdAt(LocalDateTime.now())
                .build();

        inboxEmail.setRecipients(List.of(Recipient.builder()
                .email(inboxEmail) .user(recipient) .type("TO") .build()));
        emailRepository.save(inboxEmail);
    }
    public String updateEmail(String emailId, CreateEmailReq req) {

        Email email = emailRepository.findById(emailId)
                .orElseThrow(() -> new AppException(ErrorCode.MAIL_NOT_FOUND));


        User sender = userRepository.findById(req.getSenderId())
                .orElseThrow(() -> new AppException(ErrorCode.SENDER_NOT_FOUND));

        System.out.println("req draft: " + req.isDraft());
        String folder = req.isDraft() ? "Draft" : "Sent";

        // Update the email attributes
        email.setSender(sender);
        email.setSubject(req.getSubject());
        email.setBody(req.getBody());
        email.setDraft(req.isDraft());
        email.setFolder(folder);
        email.setUpdatedAt(LocalDateTime.now());

        // Update recipients
        List<Recipient> recipients = req.getRecipients().stream()
                .map(recipientDTO -> Recipient.builder()
                        .email(email)
                        .user(userRepository.findById(recipientDTO.getUserId())
                                .orElseThrow(() -> new AppException(ErrorCode.RECIPIENT_NOT_FOUND)))
                        .type(recipientDTO.getType())
                        .build())
                .collect(Collectors.toList());

        email.setRecipients(recipients);

        // Save updated email
        emailRepository.save(email);
        recipientRepository.saveAll(recipients);

        return email.getId();
    }


    public Email findEmailById(String emailId) {
        System.out.println("email id " + emailId);
        return emailRepository.findById(emailId)
                .orElseThrow(() -> new AppException(ErrorCode.MAIL_NOT_FOUND));
    }
    public void handleAttachments(List<MultipartFile> attachments, Email email) {
        System.out.println("email" + email);

        if (attachments != null && !attachments.isEmpty()) {
            List<Attachment> attachmentEntities = attachments.stream()
                    .map(file -> {
                        try {
                            Map uploadResult = cloudinary.uploader().upload(file.getBytes(),
                                    ObjectUtils.asMap("folder", "emails/" + email.getSender().getEmail(),
                                            "resource_type", "auto"));
                            return Attachment.builder()
                                    .email(email)
                                    .fileName(file.getOriginalFilename())
                                    .fileUrl(uploadResult.get("url").toString())
                                    .build();
                        } catch (IOException e) {
                            throw new AppException(ErrorCode.FAIL_UPLOAD_FILE);
                        }
                    }).toList();
            attachmentRepository.saveAll(attachmentEntities);
        }
    }


    public List<EmailResponse> getEmailsByFolder(String folder, boolean isDetailed) {
        var context = SecurityContextHolder.getContext();

        String phone = context.getAuthentication().getName();
        User user = userRepository.findUserByPhoneNumber(phone)
                .orElseThrow(()->new AppException(ErrorCode.USER_NOT_FOUND));

        List<Email> emails = emailRepository.findByRecipientsUserIdAndFolder(user.getId(),folder);

        List<Email> sortedEmails = emails.stream()
                .sorted(Comparator.comparing(Email::getCreatedAt).reversed())
                .collect(Collectors.toList());

//        for(var i : sortedEmails){
//            System.out.println(i.getCreatedAt());
//
//        }
        return sortedEmails.stream()
                .map(email -> convertToEmailDTO(email, isDetailed))
                .collect(Collectors.toList());
    }

    private EmailResponse convertToEmailDTO(Email email, boolean isDetailed) {
        EmailResponse.EmailResponseBuilder builder = EmailResponse.builder()
                .id(email.getId())
                .senderName(email.getSender().getFirstName() + " " + email.getSender().getLastName())
                .senderEmail(email.getSender().getEmail())
                .subject(email.getSubject())
                .createdAt(email.getCreatedAt())
                .isRead(email.isRead())
                .isStarred(email.getFolder().equalsIgnoreCase("Starred"))
                .folder(email.getFolder());

        if (isDetailed) {
            System.out.println("attachements " + email.getAttachments());
            // Add full details in detailed mode
            builder.body(email.getBody());
            builder.attachments(email.getAttachments().stream()
                    .map(attachment -> AttachmentDTO.builder()
                            .id(attachment.getId())
                            .fileName(attachment.getFileName())
                            .fileUrl(attachment.getFileUrl())
                            .build())
                    .collect(Collectors.toList()));
            builder.labels(email.getLabels().stream()
                    .map(emailLabel -> emailLabel.getLabel().getName())
                    .collect(Collectors.toList()));
        } else {
            // Add only preview of the body in basic mode
            builder.preview(email.getBody().length() > 50 ? email.getBody().substring(0, 50) + "..." : email.getBody());
        }

        return builder.build();
    }


    public List<Email> getEmailsBySender(String senderId) {
        // Fetch emails by sender ID
        return emailRepository.findBySenderId(senderId);
    }

    public Email sendEmail(String emailId) {
        Email email = emailRepository.findById(emailId)
                .orElseThrow(() -> new AppException(ErrorCode.MAIL_NOT_FOUND));

        // Mark email as sent
        email.setDraft(false);
        email.setUpdatedAt(LocalDateTime.now());
        return emailRepository.save(email);
    }



    public Email replyToEmail(String emailId, CreateEmailReq req) {
        Email originalEmail = emailRepository.findById(emailId)
                .orElseThrow(() -> new RuntimeException("Original email not found"));

        // Create reply email
        Email replyEmail = Email.builder()
                .sender(userRepository.findById(req.getSenderId())
                        .orElseThrow(() -> new RuntimeException("Sender not found")))
                .subject("Re: " + originalEmail.getSubject())
                .body(req.getBody())
                .isDraft(false)
                .createdAt(LocalDateTime.now())
//                .updatedAt(LocalDateTime.now())
                .build();
        Email savedReplyEmail = emailRepository.save(replyEmail);

        // Lưu thông tin người nhận (người gửi của email gốc)
        Recipient recipient = Recipient.builder()
                .email(savedReplyEmail)
                .user(originalEmail.getSender())
                .type("TO") .build();
        recipientRepository.save(recipient);

        return savedReplyEmail;
    }

    public Email forwardEmail(String emailId, CreateEmailReq req) {
        Email originalEmail = emailRepository.findById(emailId)
                .orElseThrow(() -> new RuntimeException("Original email not found"));

        // Create forwarded email
        Email forwardedEmail = Email.builder()
                .sender(userRepository.findById(req.getSenderId())
                        .orElseThrow(() -> new RuntimeException("Sender not found")))
                .subject("Fwd: " + originalEmail.getSubject())
                .body(req.getBody())
                .isDraft(false)
                .createdAt(LocalDateTime.now())
                .updatedAt(LocalDateTime.now())
                .build();

        return emailRepository.save(forwardedEmail);
    }

//    public List<Email> searchEmails(String userId, String keyword) {
//        return emailRepository.searchEmails(userId, keyword);
//    }
//
//
//    public List<Email> advancedSearch(AdvancedSearchDTO searchDTO) {
//        return emailRepository.advancedSearch(
//                searchDTO.getUserId(),
//                searchDTO.getDateRangeStart(),
//                searchDTO.getDateRangeEnd(),
//                searchDTO.hasAttachments()
//        );

//    public List<Email> basicSearch(String keyword) {
//        return emailRepository.searchByKeyword(keyword);
//    }

    public List<Email> advancedSearch(String keyword, String senderId, String recipientId,
                                      LocalDateTime startDate, LocalDateTime endDate,
                                      boolean withAttachments) {
        Specification<Email> spec = Specification
                .where(EmailSpecifications.hasKeyword(keyword))
                .and(EmailSpecifications.isSentBy(senderId))
                .and(EmailSpecifications.hasRecipient(recipientId))
                .and(EmailSpecifications.inDateRange(startDate, endDate))
                .and(EmailSpecifications.hasAttachments(withAttachments));

        return emailRepository.findAll(spec);
    }


//    public List<Email> getEmailsByFolder(String userId, String folder) {
//        switch (folder.toLowerCase()) {
//            case "inbox":
//                return emailRepository.findByRecipientUserIdAndNotTrash(userId);
//            case "starred":
//                return emailRepository.findByRecipientUserIdAndStarred(userId);
//            case "sent":
//                return emailRepository.findBySenderId(userId);
//            case "draft":
//                return emailRepository.findBySenderIdAndDraft(userId);
//            case "trash":
//                return emailRepository.findByRecipientUserIdAndTrash(userId);
//            default:
//                throw new RuntimeException("Invalid folder name");
//        }
//    }
}
