package com.example.backend_email.model;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class EmailLabel {
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private String id;

    @ManyToOne
    @JoinColumn(name = "email_id")
    private Email email;

    @ManyToOne
    @JoinColumn(name = "label_id")
    private Label label;
}