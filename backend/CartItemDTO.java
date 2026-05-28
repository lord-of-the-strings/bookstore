package com.store.bookstore_api.dto;

import com.store.bookstore_api.model.CartItem;
import lombok.Data;
import java.math.BigDecimal;

@Data
public class CartItemDTO {
    private Long id;
    private Long bookId;
    private String title;
    private String author;
    private String coverUrl;
    private BigDecimal price;
    private Integer quantity;
    private BigDecimal subtotal;

    public static CartItemDTO from(CartItem item) {
        CartItemDTO dto = new CartItemDTO();
        dto.id = item.getId();
        dto.bookId = item.getBook().getId();
        dto.title = item.getBook().getTitle();
        dto.author = item.getBook().getAuthor();
        dto.coverUrl = item.getBook().getCoverUrl();
        dto.price = item.getBook().getPrice();
        dto.quantity = item.getQuantity();
        dto.subtotal = item.getBook().getPrice()
                .multiply(BigDecimal.valueOf(item.getQuantity()));
        return dto;
    }
}