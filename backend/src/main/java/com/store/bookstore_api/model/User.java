package com.store.bookstore_api.model;
import jakarta.persistence.*;
import lombok.Data;
import java.time.LocalDateTime;
@Data
@Entity
@Table(name="users")
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    @Column(nullable=false,unique=true)
    private String firebaseUid;
    @Column(unique=true)
    private String phoneNumber;
    @Column(nullable = false)
    @Enumerated(EnumType.STRING)
    private Role role=Role.BUYER;
    @Column(nullable = false)
    private LocalDateTime createdAt=LocalDateTime.now();
    public enum Role{
        BUYER,SELLER,ADMIN
    }
}
