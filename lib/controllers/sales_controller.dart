import 'package:flutter/cupertino.dart';
import 'package:flutterpos/models/product_model.dart';
import 'package:get/get.dart';

class SalesController extends GetxController {
  RxList<ProductModel> selectedList = RxList([]);
  RxInt grandTotal = RxInt(0);
  TextEditingController textEditingSellingPrice=TextEditingController();
  var selecteProduct = ProductModel().obs;

  changeSelectedList(value) {
    var index = selectedList.indexWhere((element) => element.id == value.id);
    if (index == -1) {
      selectedList.add(value);
      index = selectedList.indexWhere((element) => element.id == value.id);
    } else {
      var data =
          int.parse(selectedList[index].cartquantity.toString()) + 1; // +=1;
      selectedList[index].cartquantity = data;
    }
    calculateAmount(index);

    selectedList.refresh();
    selectedList.reversed;
  }

  decrementItem(index) {
    if (selectedList[index].cartquantity! > 1) {
      selectedList[index].cartquantity = selectedList[index].cartquantity! - 1;
      selectedList.refresh();
    }
    calculateAmount(index);
  }

  incrementItem(index) {
    if (selectedList[index].quantity! > selectedList[index].cartquantity!) {
      selectedList[index].cartquantity = selectedList[index].cartquantity! + 1;
      selectedList.refresh();
    }
    calculateAmount(index);
  }

  removeFromList(index) {
    selectedList.removeAt(index);
    selectedList.refresh();
    calculateAmount(index);
  }

  calculateAmount(index) {
    grandTotal.value = 0;
    if (selectedList.isNotEmpty) {
      selectedList[index].amount =
          (selectedList[index].cartquantity! * selectedList[index].selling!) -
              selectedList[index].allowedDiscount!;
    }
    if (selectedList.isNotEmpty) {
      selectedList.forEach((element) {
        grandTotal.value =
            grandTotal.value + int.parse(element.amount.toString());
      });
    }

    grandTotal.refresh();
    selectedList.refresh();
  }
}
