import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/book.dart';
import '../models/category.dart';
import '../services/book_service.dart';

// Selected category slug (null = all books)
final selectedCategoryProvider = StateProvider<String?>((ref) => null);

// Search query
final searchQueryProvider = StateProvider<String>((ref) => '');

// Categories list
final categoriesProvider = FutureProvider<List<Category>>((ref) async {
  return BookService.getCategories();
});

// Books list
final booksProvider = FutureProvider<List<Book>>((ref) async {
  final category = ref.watch(selectedCategoryProvider);
  final search = ref.watch(searchQueryProvider);
  return BookService.getBooks(
    category: category,
    search: search.isEmpty ? null : search,
  );
});

// Single book detail
final bookDetailProvider = FutureProvider.family<Book, int>((ref, id) async {
  return BookService.getBookById(id);
});