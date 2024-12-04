package com.example.backend_email.service;

import com.example.backend_email.dto.request.user.TokenReq;
import com.example.backend_email.dto.response.user.OtpResponse;
import com.example.backend_email.exception.AppException;
import com.example.backend_email.exception.ErrorCode;
import com.example.backend_email.utils.JwtUtils;
import com.nimbusds.jose.JOSEException;
import org.springframework.beans.factory.annotation.Autowired;

import org.springframework.context.annotation.Lazy;
import org.springframework.stereotype.Service;

import java.text.ParseException;
import java.util.HashMap;
import java.util.Map;
import java.util.Random;

@Service
public class OtpService {
    @Autowired
    private static final long OTP_EXPIRATION_TIME = 60 * 1000; // 1 phút

    @Autowired
    private EmailService emailService;

    @Lazy // Trì hoãn khởi tạo AuthService
    @Autowired
    private AuthService authService;

    @Autowired
    private JwtUtils jwtUtils;
    public OtpResponse generateOtp(String phoneNumber, String email) throws JOSEException {


        String otp = String.valueOf(new Random().nextInt(900000) + 100000); // 6 chữ số
        Map<String, Object> claims = new HashMap<>();
        claims.put("phoneNumber", phoneNumber);
        claims.put("email", email);
        claims.put("otp", otp);

        String subject = "Your OTP Code";
        String text = "Your OTP is: " + otp + "\nIt will expire in 1 minute.";

        System.out.println(email);
        emailService.sendOtp(email, subject, text);
//        System.out.println("token OTP: " + );
        var otpResponse = OtpResponse.builder()
                .token(jwtUtils.generateToken(claims, OTP_EXPIRATION_TIME))
                .build();
        return otpResponse;
    }

    public boolean validateOtp(String token, String otpProvided) {
        try{
            //Kiểm tra token có nằm trong danh sách Invalid token không?
            if(authService.validateToken(token).isValid()){
                Map<String, Object> claims = jwtUtils.validateTokenOTP(token);

                // Lấy OTP từ payload
                String otp = (String) claims.get("otp");
//                System.out.println("Validate Token");
//                System.out.println("ot");
                // So sánh với OTP được cung cấp
                return otp.equals(otpProvided);
            }
            else{
                return false;
            }
        }catch (ParseException | JOSEException e){
            return false;
        }

    }
    public OtpResponse resendOtp(TokenReq req) throws JOSEException, ParseException {

        System.out.println("token " + req.getToken());
        try {
            Map<String, Object> claims = jwtUtils.validateTokenOTP(req.getToken());
            // Lấy email từ payload
            String phoneNumber = (String) claims.get("phoneNumber");
            String email = (String) claims.get("email");

            System.out.println("email " + email);
            //Gọi hàm logout để bỏ token này vào database
            authService.logout(req);

            return generateOtp(phoneNumber, email);
        }catch(ParseException | JOSEException e){
            throw new AppException(ErrorCode.EXCEPTION);
        }
    }




}
