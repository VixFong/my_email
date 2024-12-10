package com.example.backend_email.controller.user;

import com.cloudinary.Api;
import com.example.backend_email.dto.request.user.CreateUserReq;
import com.example.backend_email.dto.request.user.UpdateProfileReq;
import com.example.backend_email.dto.response.ApiResponse;
import com.example.backend_email.dto.response.user.OtpResponse;
import com.example.backend_email.dto.response.user.SearchUserResponse;
import com.example.backend_email.dto.response.user.UserResponse;
import com.example.backend_email.service.UserService;
import com.nimbusds.jose.JOSEException;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.io.IOException;
import java.text.ParseException;
import java.util.List;

@RestController
@RequestMapping("/users")
public class UserController {
    @Autowired
    private UserService userService;

    @PostMapping("/register")
    public ApiResponse<OtpResponse> registerUser(@RequestBody CreateUserReq request) throws JOSEException {
        System.out.println("Controller");
        return ApiResponse.<OtpResponse>builder()
                .data(userService.sendRequestCreateAccount(request))
                .build();
    }

    @GetMapping("/verify-otp")
    public ApiResponse<Void> verifyOtp(@RequestParam String otpToken, @RequestParam String otpProvided) throws JOSEException, ParseException {
        System.out.println("Verify otp");
        userService.createUser(otpToken, otpProvided);
        return ApiResponse.<Void>builder()
                .build();
    }
    @GetMapping("/info")
    public ApiResponse<UserResponse> getUser(){
        return ApiResponse.<UserResponse>builder()
                .data(userService.getUser())
                .build();
    }

    @PutMapping("/info")
    public ApiResponse<UserResponse> updateProfile(@ModelAttribute UpdateProfileReq request) throws IOException {
        return ApiResponse.<UserResponse>builder()
                .data(userService.updateProfile(request))
                .build();
    }

    @GetMapping("/search")
    public ApiResponse<List<SearchUserResponse>> searchUser(@RequestParam String keyword){
        System.out.println("Controller search");
        return ApiResponse.<List<SearchUserResponse>>builder()
                .data(userService.searchUser(keyword))
                .build();
    }
}