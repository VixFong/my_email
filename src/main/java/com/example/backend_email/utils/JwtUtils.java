package com.example.backend_email.utils;

import com.example.backend_email.exception.AppException;
import com.example.backend_email.exception.ErrorCode;
import com.nimbusds.jose.*;
import com.nimbusds.jose.crypto.MACSigner;
import com.nimbusds.jose.crypto.MACVerifier;
import com.nimbusds.jwt.JWTClaimsSet;
import com.nimbusds.jwt.SignedJWT;
import io.jsonwebtoken.Jwts;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import java.text.ParseException;
import java.util.Date;
import java.util.Map;
import java.util.UUID;

@Component
public class JwtUtils {

    @Value("${jwt.secretKey}")
    protected String SECRET_KEY;

    public String generateToken(Map<String, Object> claims,long expiration) throws JOSEException {

        JWSHeader header = new JWSHeader(JWSAlgorithm.HS512);

        JWTClaimsSet jwtClaimsSet = new JWTClaimsSet.Builder()
                .claim("data", claims)
                .issueTime(new Date())
                .expirationTime(new Date(System.currentTimeMillis() + expiration))
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
    public Map<String, Object> validateTokenOTP(String token) throws JOSEException, ParseException {
        JWSVerifier verifier = new MACVerifier(SECRET_KEY.getBytes());
        SignedJWT signedJWT = SignedJWT.parse(token);

        if (!signedJWT.verify(verifier)) {
            throw new AppException(ErrorCode.UNAUTHENTICATED);
        }

        Date expirationTime = signedJWT.getJWTClaimsSet().getExpirationTime();
        if (expirationTime.before(new Date())) {
            throw new AppException(ErrorCode.TOKEN_HAS_EXPIRED);
        }


        return (Map<String, Object>) signedJWT.getJWTClaimsSet().getClaim("data");
    }

//    public boolean isTokenExpired(String token) throws ParseException {
//        SignedJWT signedJWT = SignedJWT.parse(token);
//        Date expirationTime = signedJWT.getJWTClaimsSet().getExpirationTime();
//        return new Date().after(expirationTime);
//    }


}

