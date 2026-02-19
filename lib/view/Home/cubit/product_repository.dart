import 'dart:convert';

import '../../../core/MiscController.dart';
import '../../../data/data_sources/api_core/api.dart';
import '../../../data/model/product_model.dart';

class ProductRepository {
  final API api = API();
  final _miscController = MiscController();

  //region fetchData
  Future<void> fetchData({
    required Function(
        bool isSuccess,
        String message,
        List<ProductModel> dataList,
        ) onComplete,
  }) async {
    List<ProductModel> list = [];

    try {
      /// 1️⃣ Check Internet
      final internetStatus = await _miscController.checkInternet();

      if (internetStatus.contains('ignore')) {
        onComplete(
          false,
          "Internet Error!\nYou are offline, Please check your internet connection.",
          list,
        );
        return;
      }

      /// 2️⃣ API Call
      final apiResponse = await api.fetchListData(endpoint: "/products");

      final decodedData = jsonDecode(apiResponse);

      final bool success = decodedData['Success'] ?? false;
      final String message = decodedData['Message'] ?? "Unknown Error";

      if (!success) {
        onComplete(false, "Download Error!\n$message", list);
        return;
      }

      /// 3️⃣ Parse Product List
      final packetList = decodedData['PacketList']?['products'];

      if (packetList == null || packetList.isEmpty) {
        onComplete(false, "Download Error!\nAPI response packet is Null", list);
        return;
      }

      list = (packetList as List)
          .map((item) => ProductModel.fromJson(item))
          .toList();

      onComplete(true, "Data downloaded successfully", list);
    } catch (e) {
      onComplete(false, "Download Error!\n${e.toString()}", list);
    }
  }

  //endregion

}
