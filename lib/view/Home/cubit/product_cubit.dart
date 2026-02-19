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
      onComplete: (isSuccess, message, dataList) {
        if (isClosed) return;

        emit(ProductLoadedState(
          success: isSuccess,
          message: message,
          listOfData: dataList,
        ));
      },
    );
  }


  void addToCart(ProductModel product) {
    if (state is ProductLoadedState) {
      final currentState = state as ProductLoadedState;

      final updatedCart = List<ProductModel>.from(currentState.cartItems)
        ..add(product);

      emit(ProductLoadedState(
        success: true,
        listOfData: currentState.listOfData,
        cartItems: updatedCart,
      ));
    }
  }
}
