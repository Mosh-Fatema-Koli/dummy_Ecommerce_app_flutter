import '../../../data/model/product_model.dart';

abstract class CartState {
  bool success = false;
  String message = "";
  List<ProductModel> cartItems = [];

  @override
  List<Object> get props => [success, message, cartItems];
}

final class CartStateInitial extends CartState {}

final class CartLoadedState extends CartState {
  CartLoadedState({
    bool? success,
    String? message,
    List<ProductModel>? cartItems,
  }) {
    this.success = success ?? this.success;
    this.message = message ?? this.message;
    this.cartItems = cartItems ?? this.cartItems;
  }
}

final class CartErrorState extends CartState {
  CartErrorState(String msg) {
    message = msg;
  }
}
