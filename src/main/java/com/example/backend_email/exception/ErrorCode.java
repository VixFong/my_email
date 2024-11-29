package com.example.backend_email.exception;

import lombok.AllArgsConstructor;
import lombok.Getter;
import org.springframework.http.HttpStatus;
import org.springframework.http.HttpStatusCode;

@Getter
@AllArgsConstructor
public enum ErrorCode {
    USER_EXISTED(201,"Account has existed", HttpStatus.BAD_REQUEST),
    PHONE_EXISTED(201,"Phone number has existed", HttpStatus.BAD_REQUEST),
    EMAIL_EXISTED(201,"Email has existed", HttpStatus.BAD_REQUEST),


    USER_NOT_FOUND(202, "User not found", HttpStatus.NOT_FOUND),
    EMAIL_INVALID(203,"Invalid email",HttpStatus.BAD_REQUEST),
    PHONE_INVALID(203,"Invalid phone number",HttpStatus.BAD_REQUEST),


    PASSWORD_INVALID(204,"Password must be at least 6 characters",HttpStatus.BAD_REQUEST),
    UNAUTHENTICATED(205,"Unauthenticated",HttpStatus.UNAUTHORIZED),
    UNAUTHORIZED(206, "You do not have permission",HttpStatus.FORBIDDEN),
    INVALID_TOKEN(207, "Invalid token",HttpStatus.BAD_REQUEST),
    EXPIRED_TOKEN(208, "Token has been expired",HttpStatus.BAD_REQUEST),
    INVALID_GMAIL_ACCOUNT(209, "Invalid gmail account",HttpStatus.BAD_REQUEST),
    ACCOUNT_LOCKED(210, "Your account has been locked",HttpStatus.BAD_REQUEST),
    ACCOUNT_UNACTIVATED(211, "Your account is not activate. Please contact to admin",HttpStatus.BAD_REQUEST),
    ACCOUNT_ACTIVATED(212, "This account has activated",HttpStatus.BAD_REQUEST),

    NOT_MATCH_PASSWORD(213, "Your confirm password is not match with password",HttpStatus.BAD_REQUEST),
    FAIL_UPLOAD_IMAGE(214, "Upload image fail", HttpStatus.BAD_REQUEST),


    IMAGE_NOT_FOUND(215,"Image not found", HttpStatus.NOT_FOUND),
    IMAGE_TYPE_INVALID(216, "Only JPEG, PNG, and GIF are allowed.",HttpStatus.BAD_REQUEST) ,
    IMAGE_SIZE_INVALID(217,"File size exceeds the maximum limit of 10 MB.",HttpStatus.BAD_REQUEST),

    INVALID_OTP(218,"Invalid OTP.",HttpStatus.BAD_REQUEST),
    INVALID_REQUEST(218,  "No pending registration for this phone number.", HttpStatus.BAD_REQUEST),

    TOKEN_HAS_EXPIRED(218,"Token has been expired.",HttpStatus.BAD_REQUEST),
    EXCEPTION(400,"Exception error", HttpStatus.INTERNAL_SERVER_ERROR)

    ;

    private int code;
    private String message;
    private HttpStatusCode statusCode;
}
