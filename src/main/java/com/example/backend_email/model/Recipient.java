package com.example.backend_email.model;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonValue;
import jakarta.persistence.*;
import lombok.*;

@Entity
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Recipient {
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private String id;

    @ManyToOne
    @JoinColumn(name = "email_id")
    private Email email;

    @ManyToOne
    @JoinColumn(name = "user_id")
    private User user;

//    @Enumerated(EnumType.STRING)
    private String type; // To, CC, BCC

//    public enum RecipientType {
//        TO, CC, BCC;
//
//        @JsonCreator
//        public static RecipientType fromValue(String value) {
//            return RecipientType.valueOf(value.toUpperCase());
//        }
//
//        @JsonValue
//        public String toValue() {
//            return this.name();
//        }
//    }
}

