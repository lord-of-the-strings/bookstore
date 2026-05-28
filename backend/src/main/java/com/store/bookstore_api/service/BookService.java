package com.store.bookstore_api.service;

import com.store.bookstore_api.dto.BookDTO;
import com.store.bookstore_api.dto.BookFilterParams;
import com.store.bookstore_api.model.Category;
import com.store.bookstore_api.repository.BookRepository;
import com.store.bookstore_api.repository.CategoryRepository;
import com.store.bookstore_api.spec.BookSpec;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class BookService {

    private final BookRepository bookRepository;
    private final CategoryRepository categoryRepository;

    // Get filtered, paginated list of books
    public Page<BookDTO> getBooks(BookFilterParams params) {
        Pageable pageable = PageRequest.of(params.getPage(), params.getSize());
        return bookRepository
                .findAll(BookSpec.withFilters(params), pageable)
                .map(BookDTO::from);
    }

    // Get single book by ID
    public Optional<BookDTO> getBookById(Long id) {
        return bookRepository.findById(id).map(BookDTO::from);
    }

    // Get all categories
    public List<Category> getAllCategories() {
        return categoryRepository.findAll();
    }
}