import 'package:boilerplate_of_cubit/library.dart';
import 'package:boilerplate_of_cubit/view/Home/cubit/product_repository.dart';
import 'package:boilerplate_of_cubit/view/Home/cubit/product_state.dart';
import 'package:flutter/material.dart';

import '../../../data/model/product_model.dart';

class ProductCubit extends Cubit<ProductState> {
  ProductCubit() : super(ProductInitial());

  final _repository = ProductRepository();

  void loadData() {
    _repository.fetchData(
      onComplete: (isSuccess, message, dataList,cartList) {
        if (isClosed) return;

        emit(ProductLoadedState(
          success: isSuccess,
          message: message,
          listOfData: dataList,
          cartItems: cartList
        ));
      },
    );
  }


  /// Add product to cart (DB + state)
  Future<void> addToCart(ProductModel product) async {
    await _repository.addToCart(product);

    if (state is ProductLoadedState) {
      final current = state as ProductLoadedState;
      final updatedCart = List<ProductModel>.from(current.cartItems)..add(product);

      emit(ProductLoadedState(
        success: current.success,
        message: current.message,
        listOfData: current.listOfData,
        cartItems: updatedCart,
      ));
    }
  }





}
