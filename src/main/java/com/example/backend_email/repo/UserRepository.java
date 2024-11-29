package com.example.backend_email.repo;


import com.example.backend_email.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface UserRepository extends JpaRepository<User, String> {
    Optional<User> findUserByPhoneNumber(String phoneNumber);

    Optional<User> findUserByEmail(String email);

    boolean existsUsersByPhoneNumber(String phoneNumber);

}
