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

    private boolean isDraft;

    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    @OneToMany(mappedBy = "email", cascade = CascadeType.ALL)
    private List<Recipient> recipients;

    @OneToMany(mappedBy = "email", cascade = CascadeType.ALL)
    private List<Attachment> attachments;

    @OneToMany(mappedBy = "email", cascade = CascadeType.ALL)
    private List<EmailLabel> labels;
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
