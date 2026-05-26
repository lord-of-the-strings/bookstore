package com.store.bookstore_api.controller;
import com.store.bookstore_api.model.Category;
import com.store.bookstore_api.service.BookService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.List;
@RestController
@RequestMapping("api/categories")
@RequiredArgsConstructor
@CrossOrigin(origins="*")
public class CategoryController {
    private final BookService bookService;
    @GetMapping
    public ResponseEntity<List<Category>> getAllCategories() {
        return ResponseEntity.ok(bookService.getAllCategories());
    }
}
