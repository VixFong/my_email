package com.example.backend_email.mapper;

import com.example.backend_email.dto.request.user.CreateUserReq;
import com.example.backend_email.dto.request.user.UpdateProfileReq;
import com.example.backend_email.dto.response.user.UserResponse;
import com.example.backend_email.model.User;
import javax.annotation.processing.Generated;
import org.springframework.stereotype.Component;

@Generated(
    value = "org.mapstruct.ap.MappingProcessor",
    date = "2024-12-05T11:21:59+0700",
    comments = "version: 1.5.3.Final, compiler: javac, environment: Java 21.0.1 (Oracle Corporation)"
)
@Component
public class UserMapperImpl implements UserMapper {

    @Override
    public User toUser(CreateUserReq request) {
        if ( request == null ) {
            return null;
        }

        User.UserBuilder user = User.builder();

        user.phoneNumber( request.getPhoneNumber() );
        user.password( request.getPassword() );
        user.dateOfBirth( request.getDateOfBirth() );
        user.firstName( request.getFirstName() );
        user.lastName( request.getLastName() );
        user.email( request.getEmail() );
        user.gmailAccount( request.getGmailAccount() );
        user.gender( request.getGender() );

        return user.build();
    }

    @Override
    public UserResponse toUserResponse(User user) {
        if ( user == null ) {
            return null;
        }

        UserResponse.UserResponseBuilder userResponse = UserResponse.builder();

        userResponse.phoneNumber( user.getPhoneNumber() );
        userResponse.password( user.getPassword() );
        userResponse.firstName( user.getFirstName() );
        userResponse.lastName( user.getLastName() );
        userResponse.dateOfBirth( user.getDateOfBirth() );
        userResponse.gender( user.getGender() );
        userResponse.profilePic( user.getProfilePic() );
        userResponse.email( user.getEmail() );
        userResponse.gmailAccount( user.getGmailAccount() );
        userResponse.twoFactorEnabled( user.isTwoFactorEnabled() );
        userResponse.createdAt( user.getCreatedAt() );
        userResponse.updatedAt( user.getUpdatedAt() );

        return userResponse.build();
    }

    @Override
    public void updateProfileUser(User user, UpdateProfileReq request) {
        if ( request == null ) {
            return;
        }

        user.setPassword( request.getPassword() );
        user.setDateOfBirth( request.getDateOfBirth() );
        user.setFirstName( request.getFirstName() );
        user.setLastName( request.getLastName() );
        user.setEmail( request.getEmail() );
        user.setGmailAccount( request.getGmailAccount() );
        user.setGender( request.getGender() );
        user.setTwoFactorEnabled( request.isTwoFactorEnabled() );
        user.setUpdatedAt( request.getUpdatedAt() );
    }
}
