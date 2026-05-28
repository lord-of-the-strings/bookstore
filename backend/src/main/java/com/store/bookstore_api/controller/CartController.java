package com.store.bookstore_api.controller;

import com.store.bookstore_api.dto.CartItemDTO;
import com.store.bookstore_api.model.User;
import com.store.bookstore_api.repository.UserRepository;
import com.store.bookstore_api.service.CartService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/cart")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class CartController {

    private final CartService cartService;

    @GetMapping
    public ResponseEntity<List<CartItemDTO>> getCart(
            @AuthenticationPrincipal User user) {
        return ResponseEntity.ok(cartService.getCart(user));
    }

    @PostMapping("/add")
    public ResponseEntity<CartItemDTO> addToCart(
            @AuthenticationPrincipal User user,
            @RequestBody Map<String, Integer> body) {
        Long bookId = Long.valueOf(body.get("bookId"));
        int quantity = body.getOrDefault("quantity", 1);
        return ResponseEntity.ok(cartService.addToCart(user, bookId, quantity));
    }

    @PutMapping("/{cartItemId}")
    public ResponseEntity<?> updateQuantity(
            @AuthenticationPrincipal User user,
            @PathVariable Long cartItemId,
            @RequestBody Map<String, Integer> body) {
        int quantity = body.get("quantity");
        CartItemDTO updated = cartService.updateQuantity(user, cartItemId, quantity);
        return updated != null
                ? ResponseEntity.ok(updated)
                : ResponseEntity.ok("Item removed");
    }

    @DeleteMapping("/{cartItemId}")
    public ResponseEntity<Void> removeFromCart(
            @AuthenticationPrincipal User user,
            @PathVariable Long cartItemId) {
        cartService.removeFromCart(user, cartItemId);
        return ResponseEntity.noContent().build();
    }

    @DeleteMapping("/clear")
    public ResponseEntity<Void> clearCart(
            @AuthenticationPrincipal User user) {
        cartService.clearCart(user);
        return ResponseEntity.noContent().build();
    }
}