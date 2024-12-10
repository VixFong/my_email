package com.example.backend_email.repo;

import com.example.backend_email.model.Attachment;
import com.example.backend_email.model.Recipient;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface AttachmentRepository extends JpaRepository<Attachment, String> {
}
