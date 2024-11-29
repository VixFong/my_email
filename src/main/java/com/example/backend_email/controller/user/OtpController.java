package com.example.backend_email.controller.user;


import com.example.backend_email.dto.request.user.OtpReq;
import com.example.backend_email.dto.request.user.TokenReq;
import com.example.backend_email.dto.response.ApiResponse;
import com.example.backend_email.dto.response.user.OtpResponse;
import com.example.backend_email.service.EmailService;
import com.example.backend_email.service.OtpService;
import com.nimbusds.jose.JOSEException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.text.ParseException;

@RestController
@RequestMapping("/otp")
public class OtpController {
    @Autowired
    private OtpService otpService;

    @Autowired
    private EmailService emailService;

    @PostMapping("/generate")
    public ApiResponse<OtpResponse> generateOtp(@RequestParam String phoneNumber, @RequestParam String email) throws JOSEException {

        return ApiResponse.<OtpResponse>builder()
                .data(otpService.generateOtp(phoneNumber,email))
                .build();
    }

    @PostMapping("/validate")
    public ApiResponse<String> validateOtp(@RequestBody OtpReq req) {
//        if (otpService.isOtpExpired(email)) {
//            return ApiResponse.<String>builder()
//                    .data("OTP has expired. Please request a new OTP.")
//                    .build();
//        }
        boolean isValid = otpService.validateOtp(req.getToken(), req.getOtpProvided());
        return ApiResponse.<String>builder()
                .data( isValid ? "OTP is valid!" : "Invalid OTP. Please try again.")
                .build();
    }

    @PostMapping("/resend")
    public ApiResponse<OtpResponse> resendOtp(@RequestBody TokenReq req) throws ParseException, JOSEException {

        return ApiResponse.<OtpResponse>builder()
//                .data("A new OTP has been sent to your email.")
                .data(otpService.resendOtp(req))
                .build();
    }
}
