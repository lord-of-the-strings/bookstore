import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/cart_item.dart';
import '../services/cart_service.dart';

final cartProvider =
    AsyncNotifierProvider<CartNotifier, List<CartItem>>(CartNotifier.new);

class CartNotifier extends AsyncNotifier<List<CartItem>> {
  @override
  Future<List<CartItem>> build() async {
    return CartService.getCart();
  }

  Future<void> addToCart(int bookId) async {
    await CartService.addToCart(bookId);
    ref.invalidateSelf();
  }

  Future<void> updateQuantity(int cartItemId, int quantity) async {
    await CartService.updateQuantity(cartItemId, quantity);
    ref.invalidateSelf();
  }

  Future<void> removeItem(int cartItemId) async {
    await CartService.removeFromCart(cartItemId);
    ref.invalidateSelf();
  }

  Future<void> clearCart() async {
    await CartService.clearCart();
    ref.invalidateSelf();
  }

  double get total => state.value?.fold(
        0,
        (sum, item) => sum! + item.subtotal,
      ) ??
      0;
}

final cartCountProvider = Provider<int>((ref) {
  final cart = ref.watch(cartProvider);
  return cart.value?.fold(0, (sum, item) => sum! + item.quantity) ?? 0;
});