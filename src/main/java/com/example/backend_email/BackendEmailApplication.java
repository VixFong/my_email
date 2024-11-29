package com.example.backend_email;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.scheduling.annotation.EnableScheduling;

@SpringBootApplication
@EnableScheduling
public class BackendEmailApplication {

	public static void main(String[] args) {
		SpringApplication.run(BackendEmailApplication.class, args);
	}

}
