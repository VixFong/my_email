package com.example.backend_email.mapper;


import com.example.backend_email.dto.request.user.CreateUserReq;
import com.example.backend_email.dto.request.user.UpdateProfileReq;
import com.example.backend_email.dto.response.user.SearchUserResponse;
import com.example.backend_email.dto.response.user.UserResponse;
import com.example.backend_email.model.User;
import org.mapstruct.Mapper;
import org.mapstruct.MappingTarget;

@Mapper(componentModel = "spring")
public interface UserMapper {
    User toUser(CreateUserReq request);

    UserResponse toUserResponse(User user);

    SearchUserResponse toSearchUserResponse(User user);
    void updateProfileUser(@MappingTarget User user, UpdateProfileReq request);
}
