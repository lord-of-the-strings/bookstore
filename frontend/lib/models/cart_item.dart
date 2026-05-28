class CartItem {
  final int id;
  final int bookId;
  final String title;
  final String author;
  final String? coverUrl;
  final double price;
  final int quantity;
  final double subtotal;

  CartItem({
    required this.id,
    required this.bookId,
    required this.title,
    required this.author,
    this.coverUrl,
    required this.price,
    required this.quantity,
    required this.subtotal,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'],
      bookId: json['bookId'],
      title: json['title'],
      author: json['author'],
      coverUrl: json['coverUrl'],
      price: (json['price'] as num).toDouble(),
      quantity: json['quantity'],
      subtotal: (json['subtotal'] as num).toDouble(),
    );
  }
}