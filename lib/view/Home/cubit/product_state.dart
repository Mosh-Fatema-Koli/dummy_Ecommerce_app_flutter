import '../../../data/model/product_model.dart';

abstract class ProductState {
  bool success = false;
  String message = "";
  List<ProductModel> listOfData = [];
  List<ProductModel> cartItems = [];

  @override
  List<Object> get props => [success, message, listOfData, cartItems];
}

final class ProductInitial extends ProductState {}

final class ProductLoadedState extends ProductState {
  ProductLoadedState({
    bool? success,
    String? message,
    List<ProductModel>? listOfData,
    List<ProductModel>? cartItems,
  }) {
    this.success = success ?? this.success;
    this.message = message ?? this.message;
    this.listOfData = listOfData ?? this.listOfData;
    this.cartItems = cartItems ?? this.cartItems;
  }
}

final class ProductErrorState extends ProductState {
  ProductErrorState(String msg) {
    message = msg;
  }
}
