import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/model/product_model.dart';
import 'cart_repo.dart';
import 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  final CartRepository _repository = CartRepository();

  CartCubit() : super( CartStateInitial()) {
    loadCart(); // Load cart items on start
  }

  /// Load all cart items from SQLite
  Future<void> loadCart() async {
    try {
      final cartItems = await _repository.loadCart(); // ✅ just await

      emit(CartLoadedState(
        success: true,
        message: 'Cart loaded successfully',
        cartItems: cartItems,
      ));
    } catch (e) {
      emit(CartErrorState('Failed to load cart: ${e.toString()}'));
    }
  }

  /// Add product to cart
  Future<void> addToCart(ProductModel product) async {
    try {
      await _repository.add(product);
      await loadCart(); // Refresh state after adding
    } catch (e) {
      emit(CartErrorState('Failed to add product: ${e.toString()}'));
    }
  }

  /// Remove product from cart
  Future<void> removeFromCart(ProductModel product) async {
    try {
      await _repository.removeFromCart(product);
      await loadCart(); // Refresh state after removing
    } catch (e) {
      emit(CartErrorState('Failed to remove product: ${e.toString()}'));
    }
  }

  /// Subtract product quantity
  Future<void> subtractFromCart(ProductModel product) async {
    try {
      await _repository.substraction(product);
      await loadCart();
    } catch (e) {
      emit(CartErrorState('Failed to update product: ${e.toString()}'));
    }
  }
}
