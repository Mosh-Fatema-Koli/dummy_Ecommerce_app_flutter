import 'dart:convert';

import 'package:boilerplate_of_cubit/data/data_sources/localDB/local_data_controller.dart';

import '../../../core/MiscController.dart';
import '../../../data/data_sources/api_core/api.dart';
import '../../../data/model/product_model.dart';

class CartRepository {

  final DataController _localDataController=DataController();

  /// Cart DB operations


  Future<List<ProductModel>> loadCart() async {
    return await _localDataController.getAllData<ProductModel>(
      tableName: 'Cart',
      fromJson: (json) => ProductModel.fromJson(json),
    );
  }

  Future<void> add(ProductModel product) async {
    await _localDataController.addOrUpdate(
      tableName: 'Cart',
      primaryKey: 'id',
      jsonMap: {
        'id': product.id,
        'title': product.title,
        'price': product.price,
        'thumbnail': product.thumbnail,
        'quantity': product.quantity+1,
      },
    );
  }

  Future<void> substraction(ProductModel product) async {
    if(product.quantity==1){
      removeFromCart(product);
    }else{
      await _localDataController.addOrUpdate(
        tableName: 'Cart',
        primaryKey: 'id',
        jsonMap: {
          'id': product.id,
          'title': product.title,
          'price': product.price,
          'thumbnail': product.thumbnail,
          'quantity': product.quantity-1,
        },
      );
    }

  }

  Future<void> removeFromCart(ProductModel product) async {
    await _localDataController.delete(
      tableName: 'Cart',
      where: 'id = ?',
      whereArgs: [product.id],
    );
  }

  Future<int> totalCount() async {
    final items = await loadCart(); // List<ProductModel>
    int total = 0;
    for (var item in items) {
      total += item.quantity; // Make sure quantity is int, not nullable
    }
    return total;
  }
}
