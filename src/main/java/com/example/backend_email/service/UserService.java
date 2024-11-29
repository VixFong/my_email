package com.example.backend_email.service;

import com.example.backend_email.dto.request.user.CreateUserReq;
import com.example.backend_email.dto.request.user.PasswordReq;
import com.example.backend_email.dto.request.user.UpdateProfileReq;
import com.example.backend_email.dto.response.user.UserResponse;
import com.example.backend_email.exception.AppException;
import com.example.backend_email.exception.ErrorCode;
import com.example.backend_email.mapper.UserMapper;
import com.example.backend_email.model.User;
import com.example.backend_email.repo.UserRepository;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;


import java.io.IOException;
import java.time.LocalDate;

@Service
public class UserService {
    @Autowired
    private UserRepository userRepository;

    @Autowired
    private UserMapper userMapper;

    @Autowired
    private ImageService imageService;

    @Autowired
    private PasswordEncoder passwordEncoder;

    public UserResponse createUser(CreateUserReq req){
        User user = userMapper.toUser(req);
        if(userRepository.existsUsersByPhoneNumber(user.getPhoneNumber())){
            throw new AppException(ErrorCode.USER_EXISTED);
        }
        user.setPassword(passwordEncoder.encode(req.getPassword()));
        user.setProfilePic("http://res.cloudinary.com/dmdddwb1j/image/upload/v1717317645/profile/tcwclkd3qez4f8aygz5n.jpg");
        user.setCreatedAt(LocalDate.now());



        return userMapper.toUserResponse(userRepository.save(user));
    }

    public UserResponse getUser(){
        var context = SecurityContextHolder.getContext();

        String phone = context.getAuthentication().getName();
        User user = userRepository.findUserByPhoneNumber(phone)
                .orElseThrow(()->new AppException(ErrorCode.USER_NOT_FOUND));

        return userMapper.toUserResponse(user);

    }
    public UserResponse updateProfile(UpdateProfileReq req) throws IOException {
        System.out.println("update Info");
        var context = SecurityContextHolder.getContext();

        String phone = context.getAuthentication().getName();
        System.out.println("phone: " + phone);
//        System.out.println("first name: " + req.getFirstName());
//        System.out.println("file: " + req.getFile());

        User user = userRepository.findUserByPhoneNumber(phone)
                .orElseThrow(()->new AppException(ErrorCode.USER_NOT_FOUND));


        if(req.getFile() != null){
            imageService.uploadImage(req.getFile(), "profile");
        }


        userMapper.updateProfileUser(user, req);

        if(req.getPassword() !=null || !req.getPassword().isEmpty()){
            user.setPassword(passwordEncoder.encode(req.getPassword()));
        }

        user.setUpdatedAt(LocalDate.now());

        return userMapper.toUserResponse(userRepository.save(user));
    }




}
