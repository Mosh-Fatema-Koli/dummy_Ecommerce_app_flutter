import '../../../data/model/product_model.dart';

sealed class ProductState {
  bool success = false;
  String message = "";
  List<ProductModel> listOfData = [];

  @override
  List<Object> get props => [success, message, listOfData];
}

final class ProductInitial extends ProductState {}

final class ProductLoadedState extends ProductState {
  ProductLoadedState({
    bool? success,
    String? message,
    List<ProductModel>? listOfData,
  }) {
    this.success = success ?? this.success;
    this.message = message ?? this.message;
    this.listOfData = listOfData ?? this.listOfData;
  }
}

final class ProductErrorState extends ProductState {
  ProductErrorState({
    String? message,
  }) {
    this.success = false;
    this.message = message ?? "Unknown error";
    this.listOfData = [];
  }
}
