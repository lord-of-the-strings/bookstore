import '../core/api_client.dart';
import '../models/cart_item.dart';

class CartService {
  static Future<List<CartItem>> getCart() async {
    final response = await ApiClient.dio.get('/cart');
    return (response.data as List)
        .map((json) => CartItem.fromJson(json))
        .toList();
  }

  static Future<CartItem> addToCart(int bookId, {int quantity = 1}) async {
    final response = await ApiClient.dio.post(
      '/cart/add',
      data: {'bookId': bookId, 'quantity': quantity},
    );
    return CartItem.fromJson(response.data);
  }

  static Future<CartItem?> updateQuantity(int cartItemId, int quantity) async {
    final response = await ApiClient.dio.put(
      '/cart/$cartItemId',
      data: {'quantity': quantity},
    );
    if (response.data is String) return null; // item removed
    return CartItem.fromJson(response.data);
  }

  static Future<void> removeFromCart(int cartItemId) async {
    await ApiClient.dio.delete('/cart/$cartItemId');
  }

  static Future<void> clearCart() async {
    await ApiClient.dio.delete('/cart/clear');
  }
}