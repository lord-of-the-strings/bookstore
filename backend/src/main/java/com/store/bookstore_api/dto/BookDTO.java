package com.store.bookstore_api.dto;

import com.store.bookstore_api.model.Book;
import lombok.Data;
import java.math.BigDecimal;

@Data
public class BookDTO {
    private Long id;
    private String title;
    private String author;
    private String description;
    private String coverUrl;
    private BigDecimal price;
    private Integer stock;
    private String categoryName;
    private String categorySlug;

    public static BookDTO from(Book book) {
        BookDTO dto = new BookDTO();
        dto.id = book.getId();
        dto.title = book.getTitle();
        dto.author = book.getAuthor();
        dto.description = book.getDescription();
        dto.coverUrl = book.getCoverUrl();
        dto.price = book.getPrice();
        dto.stock = book.getStock();
        if (book.getCategory() != null) {
            dto.categoryName = book.getCategory().getName();
            dto.categorySlug = book.getCategory().getSlug();
        }
        return dto;
    }
}