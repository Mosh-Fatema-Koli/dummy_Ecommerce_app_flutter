import 'dart:convert';

import 'package:boilerplate_of_cubit/data/data_sources/localDB/local_data_controller.dart';

import '../../../core/MiscController.dart';
import '../../../data/data_sources/api_core/api.dart';
import '../../../data/model/product_model.dart';

class ProductRepository {
  final API api = API();
  final DataController _localDataController=DataController();
  final _miscController = MiscController();

  //region fetchData
  Future<void> fetchData({
    required Function(
        bool isSuccess,
        String message,
        List<ProductModel> dataList,
        List<ProductModel> cartList,
        ) onComplete,
  }) async {
    List<ProductModel> list = [];
    List<ProductModel> cartList = [];

    try {
      /// 1️⃣ Check Internet
      final internetStatus = await _miscController.checkInternet();

      if (internetStatus.contains('ignore')) {
        onComplete(
          false,
          "Internet Error!\nYou are offline, Please check your internet connection.",
          list,cartList
        );
        return;
      }

      /// 2️⃣ API Call
      final apiResponse = await api.fetchListData(endpoint: "/products");

      final decodedData = jsonDecode(apiResponse);

      final bool success = decodedData['Success'] ?? false;
      final String message = decodedData['Message'] ?? "Unknown Error";

      if (!success) {
        onComplete(false, "Download Error!\n$message", list,cartList);
        return;
      }

      /// 3️⃣ Parse Product List
      final packetList = decodedData['PacketList']?['products'];

      if (packetList == null || packetList.isEmpty) {
        onComplete(false, "Download Error!\nAPI response packet is Null", list,cartList);
        return;
      }

      list = (packetList as List)
          .map((item) => ProductModel.fromJson(item))
          .toList();
      // Load cart from SQLite

      cartList = await _localDataController.getAllData<ProductModel>(
        tableName: 'Cart',
        fromJson: (json) => ProductModel.fromJson(json),
      );
      onComplete(true, "Data downloaded successfully", list,cartList);
    } catch (e) {
      onComplete(false, "Download Error!\n${e.toString()}", list,cartList);
    }
  }

  //endregion

  /// Cart DB operations
  Future<void> addToCart(ProductModel product) async {
    await _localDataController.addOrUpdate(
      tableName: 'Cart',
      primaryKey: 'id',
      jsonMap: {
        'id': product.id,
        'title': product.title,
        'price': product.price,
        'thumbnail': product.thumbnail,
      },
    );
  }


}
