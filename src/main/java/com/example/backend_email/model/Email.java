package com.example.backend_email.model;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;
import java.util.List;

@Entity
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Email {
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private String id;

    @ManyToOne
    @JoinColumn(name = "sender_id")
    private User sender;

    @Column(nullable = false)
    private String subject;

    @Lob
    private String body;
    @Builder.Default
    private boolean isRead = false;


    private boolean isDraft;

    @Builder.Default
    private boolean isStarred = false; // Tracks if the email is starred


    @Builder.Default
    private boolean isDeleted = false;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    @OneToMany(mappedBy = "email", cascade = CascadeType.ALL)
    private List<Recipient> recipients;

    @OneToMany(mappedBy = "email", cascade = CascadeType.ALL)
    private List<Attachment> attachments;

    @OneToMany(mappedBy = "email", cascade = CascadeType.ALL)
    private List<EmailLabel> labels;

    @ManyToOne
    private Email parentEmail;

    private String folder;

    @PrePersist
    private void setDefaultFolder() {
        if (folder == null) {
            folder = "Inbox";
        }
    }
}




//import jakarta.persistence.Entity;
//import jakarta.persistence.GeneratedValue;
//import jakarta.persistence.GenerationType;
//import jakarta.persistence.Id;
//import lombok.*;
//
//import java.time.LocalDate;
//
//@Entity
//@Getter
//@Setter
//@Builder
//@NoArgsConstructor
//@AllArgsConstructor
//public class Email {
//    @Id
//    @GeneratedValue(strategy = GenerationType.UUID)
//    private String id;
//    private String senderId;
//    private String subject;
//    private String body;
//    private boolean isDraft;
//    private boolean isRead;
//    private LocalDate sendAt;
//
//    private String folderId ;
//
//}
