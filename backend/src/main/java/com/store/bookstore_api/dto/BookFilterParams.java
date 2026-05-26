package com.store.bookstore_api.dto;
import lombok.Data;
@Data
public class BookFilterParams {
    private String category;
    private Double minPrice;
    private Double maxPrice;
    private String sortBy;
    private String sortDir;
    private String search;
    private int page=0;
    private int size=20;
}
