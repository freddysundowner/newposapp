import 'package:flutter/cupertino.dart';
import 'package:flutterpos/models/expense_category_model.dart';
import 'package:get/get.dart';

import '../services/categories.dart';
import '../widgets/loading_dialog.dart';
import '../widgets/snackBars.dart';

class CategoryController extends GetxController {
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  RxList<ExpenseCategoryModel> categories = RxList([]);
  Rxn<ExpenseCategoryModel> selectedCategory = Rxn(null);
  RxBool loadingCategories = RxBool(false);
  TextEditingController textEditingControllerCategoryName =
      TextEditingController();

  getCategories(shopId, type) async {
    try {
      loadingCategories.value == true;
      var response = await Categories().getExpenseCategories(id: shopId);
      categories.clear();
      if (response["status"] == true) {
        List fetchedData = response["body"];
        List<ExpenseCategoryModel> categoryData =
            fetchedData.map((e) => ExpenseCategoryModel.fromJson(e)).toList();
        categories.assignAll(categoryData);
      } else {
        categories.value = [];
      }
      loadingCategories.value == false;
    } catch (e) {
      loadingCategories.value == false;
      print(e);
    }
  }

  createCategory({required shopId, required context}) async {
    try {
      Map<String, dynamic> body = {
        "type": "cash-out",
        "name": textEditingControllerCategoryName.text,
        "shop": shopId,
      };
      LoadingDialog.showLoadingDialog(
          context: context, key: _keyLoader, title: "creating category");
      var response = await Categories().createExpenseCategories(body: body);
      Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
      if (response["status"] == true) {
        textEditingControllerCategoryName.text = "";
        await getCategories(shopId, "cash-out");
      }
    } catch (e) {
      Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
      print(e);
    }
  }
}
