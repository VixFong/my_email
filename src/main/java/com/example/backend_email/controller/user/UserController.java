package com.example.backend_email.controller.user;

import com.cloudinary.Api;
import com.example.backend_email.dto.request.user.CreateUserReq;
import com.example.backend_email.dto.request.user.UpdateProfileReq;
import com.example.backend_email.dto.response.ApiResponse;
import com.example.backend_email.dto.response.user.UserResponse;
import com.example.backend_email.service.UserService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.io.IOException;

@RestController
@RequestMapping("/users")
public class UserController {
    @Autowired
    private UserService userService;

    @PostMapping("/register")
    public ApiResponse<UserResponse> registerUser(@RequestBody CreateUserReq request){
        System.out.println("Controller");
        return ApiResponse.<UserResponse>builder()
                .data(userService.createUser(request))
                .build();
    }

    @GetMapping("info")
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
}
