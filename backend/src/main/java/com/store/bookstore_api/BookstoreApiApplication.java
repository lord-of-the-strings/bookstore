package com.store.bookstore_api;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.security.servlet.SecurityAutoConfiguration;
import org.springframework.boot.autoconfigure.security.servlet.UserDetailsServiceAutoConfiguration;
import org.springframework.context.annotation.Import;
import com.store.bookstore_api.config.FirebaseConfig;
@SpringBootApplication(
		scanBasePackages = "com.store.bookstore_api",
		exclude = {
				SecurityAutoConfiguration.class,
				UserDetailsServiceAutoConfiguration.class
		}
)
@Import(FirebaseConfig.class)
public class BookstoreApiApplication {
	public static void main(String[] args) {
		SpringApplication.run(BookstoreApiApplication.class, args);
	}
}