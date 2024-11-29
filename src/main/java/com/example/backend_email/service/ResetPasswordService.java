package com.example.backend_email.service;

import com.example.backend_email.dto.request.user.PasswordReq;
import com.example.backend_email.dto.response.user.OtpResponse;
import com.example.backend_email.exception.AppException;
import com.example.backend_email.exception.ErrorCode;
import com.example.backend_email.model.User;
import com.example.backend_email.repo.UserRepository;
import com.example.backend_email.utils.JwtUtils;
import com.nimbusds.jose.JOSEException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.text.ParseException;
import java.util.Map;

@Service
public class ResetPasswordService {
    @Autowired
    private UserRepository userRepository;


    @Autowired
    private OtpService otpService;


    @Autowired
    private JwtUtils jwtUtils;

    @Autowired
    private PasswordEncoder passwordEncoder;

    public OtpResponse checkAccount(String phoneNumber) throws JOSEException {
        var user = userRepository.findUserByPhoneNumber(phoneNumber)
                .orElseThrow(() -> new AppException(ErrorCode.USER_NOT_FOUND));

        return otpService.generateOtp(phoneNumber, user.getGmailAccount());

    }


    public void resetPassword(PasswordReq req) throws ParseException, JOSEException {
        Map<String, Object> claims = jwtUtils.validateTokenOTP(req.getToken());
        // Lấy email từ payload
        String phoneNumber = (String) claims.get("phoneNumber");

        User user = userRepository.findUserByPhoneNumber(phoneNumber)
                .orElseThrow(()->new AppException(ErrorCode.USER_NOT_FOUND));

        user.setPassword(passwordEncoder.encode(req.getPassword()));

        userRepository.save(user);

    }
}
