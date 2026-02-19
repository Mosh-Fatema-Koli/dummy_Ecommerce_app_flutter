
import 'package:boilerplate_of_cubit/view/Home/cubit/product_repository.dart';
import 'package:boilerplate_of_cubit/view/Home/cubit/product_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/MiscController.dart';
import '../../../data/data_sources/api_core/api.dart';


class ProductCubit extends Cubit<ProductState> {
  ProductCubit() : super( ProductInitial());

  final _repository = ProductRepository();

  API api = API();
  final _miscController = MiscController();

  void loadData({BuildContext? context}) {
    if (context != null) {
      _miscController.showProgressDialog(context: context);
    }

    _repository.fetchProducts(
      onComplete: (isSuccess, message, dataList) {
        if (context != null) {
          Navigator.pop(context);
        }

        emit(ProductLoadedState(
          success: isSuccess,
          message: message,
          listOfData: dataList,
        ));
      },
    );
  }

}
