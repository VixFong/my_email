package com.example.backend_email.service;

import com.example.backend_email.dto.request.user.CreateUserReq;
import com.example.backend_email.dto.request.user.PasswordReq;
import com.example.backend_email.dto.request.user.UpdateProfileReq;
import com.example.backend_email.dto.response.user.OtpResponse;
import com.example.backend_email.dto.response.user.SearchUserResponse;
import com.example.backend_email.dto.response.user.UserResponse;
import com.example.backend_email.exception.AppException;
import com.example.backend_email.exception.ErrorCode;
import com.example.backend_email.mapper.UserMapper;
import com.example.backend_email.model.User;
import com.example.backend_email.repo.UserRepository;

import com.example.backend_email.utils.JwtUtils;
import com.nimbusds.jose.JOSEException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;


import java.io.IOException;
import java.text.ParseException;
import java.time.LocalDate;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
public class UserService {
    @Autowired
    private UserRepository userRepository;

    @Autowired
    private UserMapper userMapper;

    @Autowired
    private ImageService imageService;

    @Autowired
    private OtpService otpService;

    @Autowired
    private AuthService authService;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Autowired
    private JwtUtils jwtUtils;

    private final Map<String, CreateUserReq> otpPendingUsers = new HashMap<>();

    public OtpResponse sendRequestCreateAccount(CreateUserReq req) throws JOSEException{
        System.out.println("Service");
        if(!authService.checkPhoneNumber(req.getPhoneNumber(), "VN")){
            throw new AppException(ErrorCode.PHONE_INVALID);
        }
        else if(userRepository.existsUsersByPhoneNumber(req.getPhoneNumber())){
            throw new AppException(ErrorCode.PHONE_EXISTED);
        }

        if(userRepository.existsUsersByEmail(req.getEmail())){
            System.out.println("ccc");
            throw new AppException(ErrorCode.EMAIL_EXISTED);
        }
        System.out.println("bbbbbbbbb");

        otpPendingUsers.put(req.getPhoneNumber(), req);
        return otpService.generateOtp(req.getPhoneNumber(), req.getGmailAccount());

    }

    public void createUser(String otpToken, String providedOtp) throws JOSEException, ParseException {

        boolean isValidOtp = otpService.validateOtp(otpToken, providedOtp);
        System.out.println(otpToken);
        System.out.println(providedOtp);
        if(!isValidOtp){
            throw new AppException(ErrorCode.INVALID_OTP);
        }
        // Lấy email từ OTP token để xác định user
        Map<String, Object> claims = jwtUtils.validateTokenOTP(otpToken);
        String phoneNumber = (String) claims.get("phoneNumber");

        CreateUserReq req = otpPendingUsers.get(phoneNumber);
        if (req == null) {
            throw new AppException(ErrorCode.INVALID_REQUEST);
        }

        User user = userMapper.toUser(req);
        user.setPassword(passwordEncoder.encode(req.getPassword()));
        user.setProfilePic("https://res.cloudinary.com/dmdddwb1j/image/upload/v1733396553/profile/user_default_hte9qx.jpg");
        user.setCreatedAt(LocalDate.now());

        otpPendingUsers.remove(phoneNumber);
        userMapper.toUserResponse(userRepository.save(user));
    }

    public UserResponse getUser(){
        var context = SecurityContextHolder.getContext();

        String phone = context.getAuthentication().getName();
        User user = userRepository.findUserByPhoneNumber(phone)
                .orElseThrow(()->new AppException(ErrorCode.USER_NOT_FOUND));

        return userMapper.toUserResponse(user);

    }

    public List<SearchUserResponse> searchUser(String keyword){
        var listUsers = userRepository.findByEmailContainingIgnoreCase(keyword).stream()
                .filter(user -> {
                    String email = user.getEmail();

                    String emailPrefix = email.split("@gmail.com")[0];
                    return emailPrefix.contains(keyword);
                })
                .limit(10)
                .collect(Collectors.toList());

        return listUsers.stream()
                .map(userMapper::toSearchUserResponse).collect(Collectors.toList());
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
