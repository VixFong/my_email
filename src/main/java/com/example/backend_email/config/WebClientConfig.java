package com.example.backend_email.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.reactive.CorsWebFilter;
import org.springframework.web.cors.reactive.UrlBasedCorsConfigurationSource;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import java.util.List;

@Configuration
public class WebClientConfig implements  WebMvcConfigurer{


    @Override public void addCorsMappings(CorsRegistry registry) {
        registry.addMapping("/**")
                .allowedOrigins("*")
                .allowedMethods("*")
                .allowedMethods("GET", "POST", "PUT", "DELETE", "OPTIONS");
//                .allowCredentials(true);
    }
//    @Bean
//    public CorsWebFilter corsWebFilter(){
//        CorsConfiguration corsConfiguration = new CorsConfiguration();
////        corsConfiguration.setAllowedOrigins(List.of("*"));
////        corsConfiguration.setAllowedHeaders(List.of("*"));
////        corsConfiguration.setAllowedMethods(List.of("*"));
//
//        corsConfiguration.addAllowedOrigin("*");
//        corsConfiguration.addAllowedHeader("*");
//        corsConfiguration.addAllowedMethod("*");
//        corsConfiguration.setAllowCredentials(true);
//
//        UrlBasedCorsConfigurationSource urlBasedCorsConfigurationSource = new UrlBasedCorsConfigurationSource();
//        urlBasedCorsConfigurationSource.registerCorsConfiguration("/**", corsConfiguration);
//
//        return new CorsWebFilter(urlBasedCorsConfigurationSource);
//    }


}
