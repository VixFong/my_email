package com.example.backend_email.service;

import com.cloudinary.Cloudinary;
import com.cloudinary.utils.ObjectUtils;
import com.example.backend_email.exception.AppException;
import com.example.backend_email.exception.ErrorCode;
import com.example.backend_email.model.User;
import com.example.backend_email.repo.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.Arrays;
import java.util.List;
import java.util.Map;

@Service
public class ImageService {
    private static final List<String> SUPPORTED_IMAGE_TYPES = Arrays.asList("image/jpeg", "image/png", "image/gif");
    private static final long MAX_FILE_SIZE = 1 * 1024 * 1024; // 10 MB

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private Cloudinary cloudinary;

    public void uploadImage(MultipartFile file, String folder) throws IOException {
        // Check file type
        if (!SUPPORTED_IMAGE_TYPES.contains(file.getContentType())) {
            throw new AppException(ErrorCode.IMAGE_TYPE_INVALID);
        }

        // Check file size
        if (file.getSize() > MAX_FILE_SIZE) {
            throw new AppException(ErrorCode.IMAGE_SIZE_INVALID);

        }
        System.out.println(file.getBytes());
        Map uploadResult = cloudinary.uploader().upload(file.getBytes(), ObjectUtils.asMap("folder", folder ));
        String imageUrl = uploadResult.get("url").toString();

        User user = User.builder()
                .profilePic(imageUrl)
                .build();

        userRepository.save(user);
//        Image image = new Image();
//        image.setName(file.getOriginalFilename());
//        image.setUrl(imageUrl);
//        Image savedImage = imageRepository.save(image);
//        String originalFileName = file.getOriginalFilename();



//        return imageMapper.toImageDTO(savedImage);
    }
}
