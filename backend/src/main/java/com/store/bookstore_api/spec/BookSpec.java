package com.store.bookstore_api.spec;

import com.store.bookstore_api.dto.BookFilterParams;
import com.store.bookstore_api.model.Book;
import jakarta.persistence.criteria.Predicate;
import org.springframework.data.jpa.domain.Specification;

import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

public class BookSpec {

    public static Specification<Book> withFilters(BookFilterParams params) {
        return (root, query, cb) -> {
            List<Predicate> predicates = new ArrayList<>();

            // Filter by category slug
            if (params.getCategory() != null && !params.getCategory().isBlank()) {
                predicates.add(cb.equal(
                        root.join("category").get("slug"),
                        params.getCategory()
                ));
            }

            // Filter by min price
            if (params.getMinPrice() != null) {
                predicates.add(cb.greaterThanOrEqualTo(
                        root.get("price"),
                        params.getMinPrice()
                ));
            }

            // Filter by max price
            if (params.getMaxPrice() != null) {
                predicates.add(cb.lessThanOrEqualTo(
                        root.get("price"),
                        params.getMaxPrice()
                ));
            }

            //Search by passed string ?search=keyword, by title or author
            if(params.getSearch()!=null && !params.getSearch().isBlank()) {
                String pattern= "%"+params.getSearch().toLowerCase()+"%";
                predicates.add(cb.or(
                        cb.like(cb.lower(root.get("title")),pattern),
                        cb.like(cb.lower(root.get("author")),pattern)
                ));
            }

            // Sorting
            String sortBy = params.getSortBy() != null ? params.getSortBy() : "title";
            boolean asc = !"desc".equalsIgnoreCase(params.getSortDir());
            query.orderBy(asc ? cb.asc(root.get(sortBy)) : cb.desc(root.get(sortBy)));

            return cb.and(predicates.toArray(new Predicate[0]));
        };
    }
}