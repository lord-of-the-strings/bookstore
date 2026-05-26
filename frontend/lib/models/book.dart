class Book {
  final int id;
  final String title;
  final String author;
  final String description;
  final String? coverUrl;
  final double price;
  final int stock;
  final String? categoryName;
  final String? categorySlug;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.description,
    this.coverUrl,
    required this.price,
    required this.stock,
    this.categoryName,
    this.categorySlug,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'],
      title: json['title'],
      author: json['author'],
      description: json['description'],
      coverUrl: json['coverUrl'],
      price: (json['price'] as num).toDouble(),
      stock: json['stock'],
      categoryName: json['categoryName'],
      categorySlug: json['categorySlug'],
    );
  }
}