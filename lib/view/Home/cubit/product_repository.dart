import 'dart:convert';

import '../../../core/MiscController.dart';
import '../../../data/data_sources/api_core/api.dart';
import '../../../data/model/product_model.dart';

class ProductRepository {
  final API api = API();
  final _miscController = MiscController();

  //region fetchData
  Future<void> fetchProducts({
    required Function(bool isSuccess, String message, List<ProductModel> dataList) onComplete,
  }) async {
    List<ProductModel> list = [];

    try {
      final internetStatus = await _miscController.checkInternet();
      if (internetStatus.contains('ignore')) {
        onComplete(false, "Internet Error!\nYou are offline, Please check your internet connection.", list);
        return;
      }

      final apiResponse = await api.fetchListData(endpoint: "/products");
      final decodedResponse = jsonDecode(apiResponse);

      final bool success = decodedResponse['Success'] ?? false;
      final String message = decodedResponse['Message'] ?? 'No message';

      if (!success) {
        onComplete(false, 'Download Error!\n$message', list);
        return;
      }

      final packetList = decodedResponse['PacketList'];
      if (packetList == null) {
        onComplete(false, 'Download Error!\nAPI response packet is null', list);
        return;
      }

      for (var item in packetList) {
        list.add(ProductModel.fromJson(item));
      }

      onComplete(true, 'Data downloaded successfully', list);
    } catch (e) {
      onComplete(false, 'Download Error!\n${e.toString()}', list);
    }
  }
}
