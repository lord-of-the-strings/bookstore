import '../core/api_client.dart';
import '../models/book.dart';
import '../models/category.dart';

class BookService {
  // Fetch all categories
  static Future<List<Category>> getCategories() async {
    final response = await ApiClient.dio.get('/categories');
    return (response.data as List)
        .map((json) => Category.fromJson(json))
        .toList();
  }

  // Fetch books with optional filters
  static Future<List<Book>> getBooks({
    String? category,
    String? search,
    double? minPrice,
    double? maxPrice,
    String sortBy = 'title',
    String sortDir = 'asc',
    int page = 0,
    int size = 20,
  }) async {
    final response = await ApiClient.dio.get(
      '/books',
      queryParameters: {
        if (category != null) 'category': category,
        if(search != null) 'search': search,
        if (minPrice != null) 'minPrice': minPrice,
        if (maxPrice != null) 'maxPrice': maxPrice,
        'sortBy': sortBy,
        'sortDir': sortDir,
        'page': page,
        'size': size,
      },
    );

    final content = response.data['content'] as List;
    return content.map((json) => Book.fromJson(json)).toList();
  }

  // Fetch single book
  static Future<Book> getBookById(int id) async {
    final response = await ApiClient.dio.get('/books/$id');
    return Book.fromJson(response.data);
  }
}