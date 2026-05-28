package com.store.bookstore_api.service;

import com.store.bookstore_api.dto.CartItemDTO;
import com.store.bookstore_api.model.Book;
import com.store.bookstore_api.model.CartItem;
import com.store.bookstore_api.model.User;
import com.store.bookstore_api.repository.BookRepository;
import com.store.bookstore_api.repository.CartItemRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

import java.math.BigDecimal;
import java.util.List;

@Service
@RequiredArgsConstructor
public class CartService {
    private final CartItemRepository cartItemRepository;
    private final BookRepository bookRepository;
    public List<CartItemDTO> getCart(User user) {
        return cartItemRepository.findByUser(user)
                .stream()
                .map(CartItemDTO::from)
                .toList();
    }
    public CartItemDTO addToCart(User user, Long bookId, int quantity) {
        Book book = bookRepository.findById(bookId).orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Book Not found"));
        if (book.getStock() < quantity) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Not enogh Stock");
        }
        CartItem item = cartItemRepository
                .findByUserAndBookId(user, bookId)
                .orElseGet(() -> {
                    CartItem newItem = new CartItem();
                    newItem.setUser(user);
                    newItem.setBook(book);
                    return newItem;
                });

        item.setQuantity(item.getQuantity() == null
                ? quantity
                : item.getQuantity() + quantity);

        return CartItemDTO.from(cartItemRepository.save(item));
    }
    public CartItemDTO updateQuantity(User user, Long cartItemId, int quantity) {
        CartItem item = cartItemRepository.findById(cartItemId)
                .orElseThrow(() -> new ResponseStatusException(
                        HttpStatus.NOT_FOUND, "Cart item not found"));

        if (!item.getUser().getId().equals(user.getId())) {
            throw new ResponseStatusException(
                    HttpStatus.FORBIDDEN, "Not your cart item");
        }

        if (quantity <= 0) {
            cartItemRepository.delete(item);
            return null;
        }

        item.setQuantity(quantity);
        return CartItemDTO.from(cartItemRepository.save(item));
    }
    public void removeFromCart(User user, Long cartItemId) {
        CartItem item = cartItemRepository.findById(cartItemId)
                .orElseThrow(() -> new ResponseStatusException(
                        HttpStatus.NOT_FOUND, "Cart item not found"));

        if (!item.getUser().getId().equals(user.getId())) {
            throw new ResponseStatusException(
                    HttpStatus.FORBIDDEN, "Not your cart item");
        }

        cartItemRepository.delete(item);
    }
    public void clearCart(User user){
        cartItemRepository.deleteByUser(user);
    }
    public BigDecimal getTotal(User user) {
        return cartItemRepository.findByUser(user)
                .stream()
                .map(item -> item.getBook().getPrice()
                        .multiply(BigDecimal.valueOf(item.getQuantity())))
                .reduce(BigDecimal.ZERO, BigDecimal::add);
    }
}
