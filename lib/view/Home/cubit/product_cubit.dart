import 'package:boilerplate_of_cubit/library.dart';
import 'package:boilerplate_of_cubit/view/Home/cubit/product_repository.dart';
import 'package:boilerplate_of_cubit/view/Home/cubit/product_state.dart';
import 'package:flutter/material.dart';

import '../../../data/model/product_model.dart';

class ProductCubit extends Cubit<ProductState> {
  ProductCubit() : super(ProductInitial());

  final _repository = ProductRepository();

  int _limit = 10;
  int _skip = 0;
  bool _hasMore = true;

  /// Load initial data or refresh
  void loadData({bool isLoadMore = false}) {
    if (!isLoadMore) {
      _skip = 0;
      _hasMore = true;
    } else if (!_hasMore || state is! ProductLoadedState) {
      // No more data to load
      return;
    } else {
      // Show loading more
      emit(ProductLoadedState(
        success: true,
        listOfData: (state as ProductLoadedState).listOfData,
        cartItems: (state as ProductLoadedState).cartItems,
        isLoadingMore: true,
      ));
    }

    _repository.fetchProducts(
      limit: _limit,
      skip: _skip,
      onComplete: (bool isSuccess, String message, List<ProductModel> newList, List<ProductModel> cartList) {
        if (isClosed) return;

        if (!isSuccess && !isLoadMore) {
          emit(ProductErrorState(message));
          return;
        }

        List<ProductModel> updatedList = [];

        if (state is ProductLoadedState && isLoadMore) {
          final currentState = state as ProductLoadedState;
          updatedList = [...currentState.listOfData, ...newList];
        } else {
          updatedList = newList;
        }

        _skip = updatedList.length;
        _hasMore = newList.length == _limit;

        emit(ProductLoadedState(
          success: true,
          message: message,
          listOfData: updatedList,
          cartItems: cartList,
          isLoadingMore: false,
        ));
      },
    );
  }

  /// Load more data (lazy loading)
  void loadMore() {
    if (_hasMore && state is ProductLoadedState) {
      loadData(isLoadMore: true);
    }
  }


  /// Add product to cart (DB + state)
  Future<void> addToCart(ProductModel product) async {
    if (state is! ProductLoadedState) return;

    final current = state as ProductLoadedState;

    // 1️⃣ Update DB
    await _repository.addToCart(product);

    // 2️⃣ Update state only (do NOT fetch from API)
    // Copy existing products but update cartItems
    final updatedCart = await _repository.getCartItems(); // create this in repo

    emit(ProductLoadedState(
      success: true,
      message: current.message,
      listOfData: current.listOfData, // keep same products
      cartItems: updatedCart, // updated cart only
    ));
  }
}


