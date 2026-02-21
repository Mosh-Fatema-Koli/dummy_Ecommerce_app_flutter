import '../../../data/model/product_model.dart';

abstract class ProductState {
  bool success = false;
  String message = "";
  List<ProductModel> listOfData = [];
  List<ProductModel> cartItems = [];
  bool isLoadingMore = false; // ✅ made mutable for updates

  @override
  List<Object> get props => [success, message, listOfData, cartItems, isLoadingMore];
}

final class ProductInitial extends ProductState {}

final class ProductLoadedState extends ProductState {
  ProductLoadedState({
    bool? success,
    String? message,
    List<ProductModel>? listOfData,
    List<ProductModel>? cartItems,
    bool? isLoadingMore,
  }) {
    this.success = success ?? this.success;
    this.message = message ?? this.message;
    this.listOfData = listOfData ?? this.listOfData;
    this.cartItems = cartItems ?? this.cartItems;
    this.isLoadingMore = isLoadingMore ?? this.isLoadingMore;
  }
}

final class ProductErrorState extends ProductState {
  ProductErrorState(String msg) {
    message = msg;
  }
}