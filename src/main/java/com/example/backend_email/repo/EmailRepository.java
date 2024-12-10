package com.example.backend_email.repo;

import com.example.backend_email.model.Email;
import com.example.backend_email.model.Label;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface EmailRepository extends JpaRepository<Email, String>, JpaSpecificationExecutor<Email> {
    List<Email> findBySenderId(String senderId);

    List<Email> findByRecipientsUserIdAndFolder(String userId, String folder);

    @Query("SELECT e FROM Email e WHERE e.folder = :folder ORDER BY e.createdAt DESC")
    List<Email> findByFolder(@Param("folder") String folder);

    @Query("SELECT e FROM Email e WHERE e.folder = 'Starred' ORDER BY e.createdAt DESC")
    List<Email> findStarredEmails();

    @Query("SELECT e FROM Email e WHERE e.folder = 'Trash' ORDER BY e.createdAt DESC")
    List<Email> findTrashEmails();



    // Basic search by keyword in subject or body
//    @Query("SELECT e FROM Email e WHERE " +
//            "LOWER(e.subject) LIKE LOWER(CONCAT('%', :keyword, '%')) OR " +
//            "LOWER(e.body) LIKE LOWER(CONCAT('%', :keyword, '%'))")
//    List<Email> searchByKeyword(@Param("keyword") String keyword);

    // Search emails by folder (e.g., Inbox, Sent, Trash, etc.)
//    @Query("SELECT e FROM Email e JOIN e.labels l WHERE l.name = :folderName")
//    List<Email> findByFolder(@Param("folderName") String folderName);

    // Find starred emails
//    @Query("SELECT e FROM Email e WHERE e.isDraft = false AND e.updatedAt IS NOT NULL")
//    List<Email> findStarredEmails();
}
