package com.example.backend_email.repo;

import com.example.backend_email.model.Email;
import org.springframework.data.jpa.domain.Specification;

import java.time.LocalDateTime;

public class EmailSpecifications {

    public static Specification<Email> hasKeyword(String keyword) {
        return (root, query, builder) -> {
            if (keyword == null || keyword.isEmpty()) return null;
            String likePattern = "%" + keyword.toLowerCase() + "%";
            return builder.or(
                    builder.like(builder.lower(root.get("subject")), likePattern),
                    builder.like(builder.lower(root.get("body")), likePattern)
            );
        };
    }

    public static Specification<Email> isSentBy(String senderId) {
        return (root, query, builder) -> {
            if (senderId == null) return null;
            return builder.equal(root.get("sender").get("id"), senderId);
        };
    }

    public static Specification<Email> hasRecipient(String recipientId) {
        return (root, query, builder) -> {
            if (recipientId == null) return null;
            return builder.equal(root.join("recipients").get("user").get("id"), recipientId);
        };
    }

    public static Specification<Email> inDateRange(LocalDateTime startDate, LocalDateTime endDate) {
        return (root, query, builder) -> {
            if (startDate == null && endDate == null) return null;
            if (startDate != null && endDate != null) {
                return builder.between(root.get("createdAt"), startDate, endDate);
            } else if (startDate != null) {
                return builder.greaterThanOrEqualTo(root.get("createdAt"), startDate);
            } else {
                return builder.lessThanOrEqualTo(root.get("createdAt"), endDate);
            }
        };
    }

    public static Specification<Email> hasAttachments(boolean withAttachments) {
        return (root, query, builder) -> {
            if (!withAttachments) return null;
            return builder.isNotEmpty(root.get("attachments"));
        };
    }
}
