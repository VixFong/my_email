package com.example.backend_email.service;

import com.example.backend_email.exception.AppException;
import com.example.backend_email.exception.ErrorCode;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.MailException;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;

@Service
public class SendOtpToEmailService {
    @Autowired
    private JavaMailSender mailSender;

    public void sendOtp(String email, String subject, String text) {
        try {
            SimpleMailMessage message = new SimpleMailMessage();
            message.setTo(email);
            message.setSubject(subject);
            message.setText(text);

            mailSender.send(message);
        }catch (MailException e){
            throw new AppException(ErrorCode.INVALID_GMAIL_ACCOUNT);
        }

    }
}
