import 'package:flutterpos/controllers/product_controller.dart';
import 'package:get/get.dart';

import '../models/product_model.dart';

class StockTransferController extends GetxController {

  RxList<ProductModel> selectedProducts =RxList([]);

  void addToList(ProductModel productModel) {
    checkProductExistence(productModel);
    var index = selectedProducts.indexWhere((element) => element.id == productModel.id);
    if (index == -1) {
      selectedProducts.add(productModel);
    } else {
      selectedProducts.removeAt(selectedProducts
          .indexWhere((element) => element.id == productModel.id));
    }
    Get.find<ProductController>().products.refresh();
    selectedProducts.refresh();
  }

  checkProductExistence(ProductModel productModel) {
    var index =
    selectedProducts.indexWhere((element) => element.id == productModel.id);
    if (index == -1) {
      return false;
    } else {
      return true;
    }
  }

  void decrementItem(index) {
    if (selectedProducts[index].cartquantity! > 1) {
      selectedProducts[index].cartquantity=  selectedProducts[index].cartquantity! -1;
      selectedProducts.refresh();
    }
  }

  void incrementItem(index) {
    if (selectedProducts[index].quantity! > selectedProducts[index].cartquantity!) {
      selectedProducts[index].cartquantity=  selectedProducts[index].cartquantity! +1;
      selectedProducts.refresh();
    }
  }

  void removeFromList(index) {
    selectedProducts.removeAt(index);
    selectedProducts.refresh();
  }
}
