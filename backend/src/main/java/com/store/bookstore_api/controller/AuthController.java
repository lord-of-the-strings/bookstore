package com.store.bookstore_api.controller;

import com.store.bookstore_api.model.User;
import com.store.bookstore_api.repository.UserRepository;
import com.store.bookstore_api.security.JwtService;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseToken;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/api/auth")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class AuthController {

    private final UserRepository userRepository;
    private final JwtService jwtService;

    @PostMapping("/verify")
    public ResponseEntity<?> verifyFirebaseToken(@RequestBody Map<String, String> body) {
        String firebaseToken = body.get("firebaseToken");

        if (firebaseToken == null || firebaseToken.isBlank()) {
            return ResponseEntity.badRequest().body("Firebase token is required");
        }

        try {
            FirebaseToken decoded = FirebaseAuth.getInstance().verifyIdToken(firebaseToken);
            String uid = decoded.getUid();
            String phone = (String) decoded.getClaims().get("phone_number");

            User user = userRepository.findByFirebaseUid(uid).orElseGet(() -> {
                User newUser = new User();
                newUser.setFirebaseUid(uid);
                newUser.setPhoneNumber(phone);
                return userRepository.save(newUser);
            });

            String jwt = jwtService.generateToken(uid, user.getRole().name());

            return ResponseEntity.ok(Map.of(
                    "token", jwt,
                    "role", user.getRole().name(),
                    "userId", user.getId()
            ));

        } catch (Exception e) {
            return ResponseEntity.status(401).body("Invalid Firebase token: " + e.getMessage());
        }
    }
}