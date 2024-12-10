package com.example.backend_email.service;

import com.example.backend_email.dto.request.user.IntrospectReq;
import com.example.backend_email.dto.request.user.LoginUserReq;
import com.example.backend_email.dto.request.user.TokenReq;
import com.example.backend_email.dto.response.user.IntrospectResponse;
import com.example.backend_email.dto.response.user.LoginResponse;
import com.example.backend_email.exception.AppException;
import com.example.backend_email.exception.ErrorCode;
import com.example.backend_email.model.InvalidToken;
import com.example.backend_email.model.User;
import com.example.backend_email.repo.InvalidTokenRepository;
import com.example.backend_email.repo.UserRepository;
import com.example.backend_email.utils.JwtUtils;
import com.google.i18n.phonenumbers.NumberParseException;
import com.google.i18n.phonenumbers.PhoneNumberUtil;
import com.google.i18n.phonenumbers.Phonenumber.PhoneNumber;
import com.nimbusds.jose.*;
import com.nimbusds.jose.crypto.MACSigner;
import com.nimbusds.jose.crypto.MACVerifier;
import com.nimbusds.jwt.JWTClaimsSet;
import com.nimbusds.jwt.SignedJWT;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Lazy;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.text.ParseException;
import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.Date;
import java.util.Map;
import java.util.UUID;

@Service
public class AuthService {
    @Autowired
    private UserRepository userRepository;

    @Lazy // Trì hoãn khởi tạo OtpService
    @Autowired
    private OtpService otpService;

    @Autowired
    private InvalidTokenRepository invalidTokenRepository;

    @Value("${jwt.secretKey}")
    protected String SECRET_KEY;

    @Autowired
    private JwtUtils jwtUtils;

    @Autowired
    private PasswordEncoder passwordEncoder;

    private final PhoneNumberUtil phoneNumberUtil = PhoneNumberUtil.getInstance();

    public boolean checkPhoneNumber(String phoneNumber, String region){
        try{
            PhoneNumber phone = phoneNumberUtil.parse(phoneNumber,region);
            System.out.println(phoneNumberUtil.isValidNumber(phone));
            return phoneNumberUtil.isValidNumber(phone);
        }catch (NumberParseException e){
            System.out.println("So dien thoai khong hop le");
            return false;
        }

    }

    public LoginResponse authenticated(LoginUserReq request) throws JOSEException {
        var user = userRepository.findUserByPhoneNumber(request.getPhoneNumber())
                .orElseThrow(() -> new AppException(ErrorCode.USER_NOT_FOUND));

        System.out.println("Login user: " + user.getPhoneNumber());

        boolean authenticated = passwordEncoder.matches(request.getPassword(), user.getPassword());

        if(!authenticated){
            throw new AppException(ErrorCode.UNAUTHENTICATED);
        }

        if(user.isTwoFactorEnabled()){
            var otpResponse  = otpService.generateOtp(user.getPhoneNumber(),user.getEmail());

            return LoginResponse.builder()
                    .authenticated(false)
                    .otpToken(otpResponse.getToken())
                    .build();
        }

        var token = generateToken(user);


        return LoginResponse.builder()
                .token(token)
                .firsName(user.getFirstName())
                .lastName(user.getLastName())
                .id(user.getId())
                .email(user.getEmail())
                .profilePic(user.getProfilePic())
                .authenticated(true)
                .build();

    }

    public LoginResponse verifyOtpAndAuthenticate(String otpToken, String providedOtp) throws JOSEException, ParseException {
        // Xác thực OTP
        boolean isValidOtp = otpService.validateOtp(otpToken, providedOtp);
        if (!isValidOtp) {
            throw new AppException(ErrorCode.INVALID_OTP);
        }

        // Lấy email từ OTP token để xác định user
        Map<String, Object> claims = jwtUtils.validateTokenOTP(otpToken);
//        String email = (String) claims.get("email");
        String phoneNumber = (String) claims.get("phoneNumber");
        System.out.println("otp " +  providedOtp);

        var user = userRepository.findUserByPhoneNumber(phoneNumber)
                .orElseThrow(() -> new AppException(ErrorCode.USER_NOT_FOUND));

        var token = generateToken(user);
        return LoginResponse.builder()
                .token(token)
                .firsName(user.getFirstName())
                .lastName(user.getLastName())
                .id(user.getId())
                .email(user.getEmail())
                .profilePic(user.getProfilePic())
                .authenticated(true)
                .build();
    }


    private String generateToken(User user){
        JWSHeader header = new JWSHeader(JWSAlgorithm.HS512);

        JWTClaimsSet jwtClaimsSet = new JWTClaimsSet.Builder()
                .subject(user.getPhoneNumber())
                .issueTime(new Date())
                .expirationTime(new Date(
                        Instant.now().plus(1, ChronoUnit.HOURS).toEpochMilli()
                ))
                .jwtID(UUID.randomUUID().toString())
                .build();

        Payload payload = new Payload(jwtClaimsSet.toJSONObject());
        JWSObject jwsObject = new JWSObject(header, payload);
        try{
            jwsObject.sign(new MACSigner(SECRET_KEY.getBytes()));
            return jwsObject.serialize();
        }
        catch (JOSEException e){

            throw new RuntimeException(e);
        }
    }
    private SignedJWT verifyToken(String token) throws JOSEException, ParseException {
        JWSVerifier verifier = new MACVerifier(SECRET_KEY.getBytes());

        SignedJWT signedJWT = SignedJWT.parse(token);

        Date expiryTime = signedJWT.getJWTClaimsSet().getExpirationTime();

        var verified = signedJWT.verify(verifier);

        if (!(verified && expiryTime.after(new Date())))
            throw new AppException(ErrorCode.UNAUTHENTICATED);

        if (invalidTokenRepository
                .existsById(signedJWT.getJWTClaimsSet().getJWTID()))
            throw new AppException(ErrorCode.UNAUTHENTICATED);

        return signedJWT;
    }

    public IntrospectResponse validateToken(String token) throws JOSEException, ParseException {
//        var token = request.getToken();

        boolean isValid = true;
        try {
            verifyToken(token);
            System.out.println("verify token " + verifyToken(token));
        }catch (AppException exception){
            isValid = false;
        }

        return IntrospectResponse.builder()
                .valid(isValid)
                .build();

    }

    public void logout(TokenReq request) throws ParseException, JOSEException {
        var signToken = verifyToken(request.getToken());

        String jit = signToken.getJWTClaimsSet().getJWTID();
        Date expirateTime = signToken.getJWTClaimsSet().getExpirationTime();

        InvalidToken invalidToken = InvalidToken.builder()
                .id(jit)
                .expireTime(expirateTime)
                .build();

        invalidTokenRepository.save(invalidToken);

    }
}
