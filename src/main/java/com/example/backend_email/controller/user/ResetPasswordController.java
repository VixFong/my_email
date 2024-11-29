package com.example.backend_email.controller.user;

import com.example.backend_email.dto.request.user.PasswordReq;
import com.example.backend_email.dto.response.ApiResponse;
import com.example.backend_email.dto.response.user.OtpResponse;
import com.example.backend_email.service.ResetPasswordService;
import com.nimbusds.jose.JOSEException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.text.ParseException;

@RestController
@RequestMapping("/forgot-pass")
public class ResetPasswordController {

    @Autowired
    private ResetPasswordService resetPasswordService;

    @PostMapping("/check-email/{email}")
    ApiResponse<OtpResponse> resetPassword(@RequestParam String phoneNumber) throws JOSEException {
        return ApiResponse.<OtpResponse>builder()
                .data(resetPasswordService.checkAccount(phoneNumber))
                .build();
    }


    @PostMapping("/reset-password")
    ApiResponse<Void> resetPassword(@RequestBody PasswordReq req) throws ParseException, JOSEException {
        resetPasswordService.resetPassword(req);

        return ApiResponse.<Void>builder().build();
    }


}
