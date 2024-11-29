package com.example.backend_email.controller.user;

import com.example.backend_email.dto.request.user.IntrospectReq;
import com.example.backend_email.dto.request.user.LoginUserReq;
import com.example.backend_email.dto.request.user.PasswordReq;
import com.example.backend_email.dto.request.user.TokenReq;
import com.example.backend_email.dto.response.ApiResponse;
import com.example.backend_email.dto.response.user.IntrospectResponse;
import com.example.backend_email.dto.response.user.LoginResponse;
import com.example.backend_email.service.AuthService;
import com.example.backend_email.service.ResetPasswordService;
import com.nimbusds.jose.JOSEException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.text.ParseException;

@RestController
@RequestMapping("/auth")
public class AuthController {
    @Autowired
    private AuthService authService;



    @PostMapping("/login")
    public ApiResponse<LoginResponse> login(@RequestBody LoginUserReq request) throws JOSEException {
        System.out.println("Controller");

        var isAuthenticated = authService.authenticated(request);
        return ApiResponse.<LoginResponse>builder()
                .data(isAuthenticated)
                .build();
    }

    @GetMapping("/verify-phoneNumber")

    public boolean isValidPhoneNumber(@RequestParam String phoneNumber, @RequestParam String region){
        return authService.checkPhoneNumber(phoneNumber,region);
    }

    @PostMapping("/verify-otp")
    public LoginResponse verifyOtp(@RequestParam String otpToken, @RequestParam String otpProvided) throws JOSEException, ParseException {
        return authService.verifyOtpAndAuthenticate(otpToken, otpProvided);
    }

    @PostMapping("/introspect")
    ApiResponse<IntrospectResponse> validate(@RequestBody TokenReq request) throws JOSEException, ParseException {
//        System.out.println("Validation");

        var isValid = authService.validateToken(request.getToken());
//        System.out.println("IsValid "+ isValid.isValid());

        return ApiResponse.<IntrospectResponse>builder()
                .data(isValid)
                .build();
    }


    @PostMapping("/logout")
    ApiResponse<Void> logout(@RequestBody TokenReq request) throws JOSEException, ParseException {
        authService.logout(request);
        return ApiResponse.<Void>builder()
                .build();
    }
}
