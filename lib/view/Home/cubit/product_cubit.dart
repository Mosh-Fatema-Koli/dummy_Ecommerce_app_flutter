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
    if (state is! ProductLoadedState) return;

    final current = state as ProductLoadedState;

    // 1️⃣ Update DB
    await _repository.addToCart(product);
    // 2️⃣ Reload cart from DB (single source of truth)
    loadData();

  }




}
