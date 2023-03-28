import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutterpos/controllers/AuthController.dart';
import 'package:flutterpos/controllers/attendant_controller.dart';
import 'package:flutterpos/controllers/home_controller.dart';
import 'package:flutterpos/controllers/purchase_controller.dart';
import 'package:flutterpos/controllers/shop_controller.dart';
import 'package:flutterpos/screens/product/products_page.dart';
import 'package:flutterpos/screens/stock/stock_page.dart';
import 'package:flutterpos/services/category.dart';
import 'package:flutterpos/utils/colors.dart';
import 'package:flutterpos/widgets/snackBars.dart';
import 'package:get/get.dart';

import '../models/product_category_model.dart';
import '../models/product_count_model.dart';
import '../models/product_model.dart';
import '../screens/sales/all_sales_page.dart';
import '../services/product.dart';
import '../utils/dates.dart';
import '../widgets/loading_dialog.dart';

class ProductController extends GetxController {
  GlobalKey<State> _keyLoader = new GlobalKey<State>();
  RxList<ProductModel> products = RxList([]);
  RxList selectedSupplier = RxList([]);
  RxList<ProductCountModel> countHistoryList = RxList([]);
  RxBool showBadStockWidget = RxBool(false);
  RxBool saveBadstockLoad = RxBool(false);
  Rxn<ProductModel> selectedBadStock = Rxn(null);

  RxList<ProductCategoryModel> productCategory = RxList([]);
  RxString categoryName = RxString("");
  RxString categoryId = RxString("");
  RxString selectedMeasure = RxString("Kg");
  RxBool creatingProductLoad = RxBool(false);
  RxBool getProductLoad = RxBool(false);
  RxBool updateProductLoad = RxBool(false);
  RxBool getProductCountLoad = RxBool(false);
  RxBool loadingCountHistory = RxBool(false);
  RxInt totalSale = RxInt(0);
  RxInt totalProfit = RxInt(0);
  RxString selectedSortOrder = RxString("All");
  RxString selectedSortOrderCount = RxString("All");
  RxString selectedSortOrderSearch = RxString("all");
  RxString selectedSortOrderCountSearch = RxString("all");
  RxString supplierName = RxString("None");
  RxString supplierId = RxString("");

  RxInt initialProductValue = RxInt(0);
  RxString quantityType = RxString("increment");

  TextEditingController itemNameController = TextEditingController();
  TextEditingController buyingPriceController = TextEditingController();
  TextEditingController sellingPriceController = TextEditingController();
  TextEditingController minsellingPriceController = TextEditingController();
  TextEditingController qtyController = TextEditingController();
  TextEditingController discountController = TextEditingController();
  TextEditingController reOrderController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController category = TextEditingController();
  TextEditingController searchProductController = TextEditingController();
  TextEditingController searchProductQuantityController =
      TextEditingController();

  saveProducts(String shopId, String attendantId, context) async {
    var name = itemNameController.text;
    var qty = qtyController.text;
    var buying = buyingPriceController.text;
    var selling = sellingPriceController.text;
    var minSelling = minsellingPriceController.text;
    var reorder = reOrderController.text;
    var discount = discountController.text;
    var description = descriptionController.text;
    if (name.isEmpty ||
        qty.isEmpty ||
        buying.isEmpty ||
        selling.isEmpty ||
        categoryName.value == "") {
      showSnackBar(
          message: "Please fill all fields marked by *",
          color: Colors.red,
          context: context);
    } else if (int.parse(buying) > int.parse(selling)) {
      showSnackBar(
          message: "Selling price cannot be lower than buying price",
          color: Colors.red,
          context: context);
    } else if (minSelling != "" && int.parse(minSelling) > int.parse(selling)) {
      showSnackBar(
          message: "minimum selling price cannot be greater than selling price",
          color: Colors.red,
          context: context);
    } else if (minSelling != "" && int.parse(buying) > int.parse(minSelling)) {
      showSnackBar(
          message: "minimum selling price cannot be less than buying price",
          color: Colors.red,
          context: context);
    } else if (discount != "" && int.parse(discount) > int.parse(selling)) {
      showSnackBar(
          message: "discount cannot be greater than selling price",
          color: Colors.red,
          context: context);
    } else {
      try {
        creatingProductLoad.value = true;
        Map<String, dynamic> body = {
          "name": name,
          "quantity": int.parse(qty),
          "buyingPrice": int.parse(buying),
          "sellingPrice": selling.toString(),
          "minSellingPrice": minSelling == "" ? selling : minSelling,
          "shop": shopId,
          "attendant": attendantId,
          "unit": selectedMeasure.value,
          "category": categoryId.value,
          "stockLevel": reorder == "" ? 0 : int.parse(reorder),
          "discount": discount == "" ? 0 : int.parse(discount),
          "description": description == null ? "" : description,
          "supplier": supplierName.value == "None" ? "" : supplierId.value,
          "type": "stockin"
        };
        var response = await Products().createProduct(body);
        if (response["status"] == false) {
          showSnackBar(
              message: response["status"], color: Colors.red, context: context);
        } else {
          clearControllers();
          if (MediaQuery.of(context).size.width > 600) {
            Get.find<HomeController>().selectedWidget.value = StockPage();
          } else {
            Get.back();
          }
          await getProductsBySort(shopId: shopId, type: "all");
        }
        creatingProductLoad.value = false;
      } catch (e) {
        creatingProductLoad.value = false;
      }
    }
  }

  createCategory(
      {required String shopId, required BuildContext context}) async {
    try {
      LoadingDialog.showLoadingDialog(
          context: context, title: "Creating category...", key: _keyLoader);
      Map<String, dynamic> body = {"name": category.text, "shop": shopId};
      var response = await Categories().createProductCategory(body: body);
      Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
      if (response["status"] == true) {
        category.text = "";
        getProductCategory(shopId: shopId);
      } else {
        showSnackBar(
            message: response["message"],
            color: AppColors.mainColor,
            context: context);
      }
    } catch (e) {
      Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
    }
  }

  getProductCategory({required shopId}) async {
    try {
      productCategory.clear();
      var response = await Categories().getProductCategories(shopId);
      if (response["status"] == true) {
        List categoriesResponse = response["body"];
        List<ProductCategoryModel> categoriesData = categoriesResponse
            .map((e) => ProductCategoryModel.fromJson(e))
            .toList();
        categoryName.value = categoriesData[0].name!;
        categoryId.value = categoriesData[0].id!;
        productCategory.assignAll(categoriesData);
      } else {
        productCategory.value = [];
      }
    } catch (e) {}
  }

  clearControllers() {
    itemNameController.text = "";
    qtyController.text = "";
    buyingPriceController.text = "";
    sellingPriceController.text = "";
    reOrderController.text = "";
    discountController.text = "";
    descriptionController.text = "";
    category.text = "";
    minsellingPriceController.text = "";
    selectedSupplier.clear();
  }

  getProductsBySort({required String shopId, required String type}) async {
    try {
      getProductLoad.value = true;
      var response = await Products().getProductsBySort(shopId, type);
      products.clear();
      if (response != null) {
        totalSale.value = 0;
        totalProfit.value = 0;
        List fetchedProducts = response["body"];
        List<ProductModel> listProducts =
            fetchedProducts.map((e) => ProductModel.fromJson(e)).toList();
        for (int i = 0; i < listProducts.length; i++) {
          totalSale.value += (int.parse("${listProducts[i].buyingPrice!}")) *
              int.parse("${listProducts[i].quantity}");

          totalProfit.value += ((int.parse(listProducts[i].sellingPrice![0]) -
                  listProducts[i].buyingPrice!) *
              int.parse("${listProducts[i].quantity}"));
        }
        products.assignAll(listProducts);
      } else {
        products.value = [];
      }
      getProductLoad.value = false;
    } catch (e) {
      getProductLoad.value = false;
    }
  }

  searchProduct(String shopId, String type) async {
    try {
      getProductLoad.value = true;
      var response = await Products().searchProduct(
          shopId,
          type == "count"
              ? searchProductQuantityController.text.trim()
              : searchProductController.text.trim());
      if (response != null) {
        totalSale.value = 0;
        totalProfit.value = 0;
        List fetchedProducts = response["body"];
        List<ProductModel> listProducts =
            fetchedProducts.map((e) => ProductModel.fromJson(e)).toList();
        for (int i = 0; i < listProducts.length; i++) {
          totalSale.value += (int.parse("${listProducts[i].buyingPrice!}")) *
              int.parse("${listProducts[i].quantity}");
          totalProfit.value += ((int.parse(listProducts[i].sellingPrice![0]) -
                  listProducts[i].buyingPrice!) *
              int.parse("${listProducts[i].quantity}"));
        }
        products.assignAll(listProducts);
      } else {
        products.value = [];
      }
      getProductLoad.value = false;
      return products.value;
    } catch (e) {
      getProductLoad.value = false;
      return null;
    }
  }

  Future<void> scanQR(
      {required shopId, required type, required context}) async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
      if (type == "count") {
        searchProductQuantityController.text = barcodeScanRes;
      } else {
        searchProductController.text = barcodeScanRes;
      }

      searchProduct(shopId, type);
    } on PlatformException {
      showSnackBar(
          message: 'Failed to get platform version.',
          color: Colors.red,
          context: context);
    }
  }

  deleteProduct(
      {required id, required BuildContext context, required shopId}) async {
    try {
      getProductLoad.value = true;
      var response = await Products().deleteProduct(id: id);
      if (response["status"] == true) {
        await getProductsBySort(shopId: shopId, type: "all");
      } else {
        showSnackBar(
            message: response["message"],
            color: AppColors.mainColor,
            context: context);
      }

      getProductLoad.value = false;
    } catch (e) {
      getProductLoad.value = false;
    }
  }

  updateProduct(
      {required id, required BuildContext context, required shopId}) async {
    try {
      updateProductLoad.value = true;
      if (itemNameController.text == "" ||
          qtyController.text == "" ||
          sellingPriceController.text == "" ||
          buyingPriceController.text == "") {
        showSnackBar(
            message: "Please fill all the fields",
            color: Colors.red,
            context: context);
      } else {
        Map<String, dynamic> body = {
          "name": itemNameController.text,
          "quantity": int.parse(qtyController.text),
          "buyingPrice": int.parse(buyingPriceController.text),
          "sellingPrice": sellingPriceController.text,
          "minSellingPrice": minsellingPriceController.text,
          "measureUnit": selectedMeasure.value,
          "category": categoryId.value,
          "stockLevel": reOrderController.text,
          "discount": int.parse(discountController.text),
          "description": descriptionController.text,
          "supplier": supplierName.value == "None" ? "" : supplierId.value,
        };
        var response = await Products().updateProduct(id: id, body: body);
        if (response["status"] == true) {
          clearControllers();
          await getProductsBySort(shopId: shopId, type: "all");
          var stockinProducts = Get.find<PurchaseController>().selectedList;
          int index = stockinProducts.indexWhere((e) =>
              products.indexWhere((element) => element.id == e.id) != -1);
          if (index != -1) {
            Get.find<PurchaseController>().selectedList.removeAt(index);
            Get.find<PurchaseController>().selectedList.add(products[index]);
            Get.find<PurchaseController>().selectedList.refresh();
            Get.find<PurchaseController>().calculateAmount(index);
          }
          stockinProducts.refresh();
          Get.find<PurchaseController>().selectedList.refresh();
          if (MediaQuery.of(context).size.width > 600) {
            Get.find<HomeController>().selectedWidget.value = ProductPage();
          } else {
            Get.back();
          }
        } else {
          showSnackBar(
              message: response["message"],
              color: AppColors.mainColor,
              context: context);
        }
        updateProductLoad.value = false;
      }
    } catch (e) {
      updateProductLoad.value = false;
    }
  }

  assignTextFields(ProductModel productModel) {
    itemNameController.text = productModel.name!;
    qtyController.text = productModel.quantity!.toString();
    buyingPriceController.text = productModel.buyingPrice!.toString();
    sellingPriceController.text = productModel.selling!.toString();
    reOrderController.text = productModel.stockLevel!.toString();
    discountController.text = productModel.discount!.toString();
    descriptionController.text = productModel.description!;
    categoryName.value = productModel.category!.name!;
    categoryId.value = productModel.category!.id!;
    minsellingPriceController.text = productModel.minPrice.toString();
    selectedMeasure.value = productModel.unit!;
  }

  getProductsByCount(String shopId, String type) async {
    try {
      getProductCountLoad.value = true;
      var startDate = convertTimeToMilliSeconds()["startDate"];
      var endDate = convertTimeToMilliSeconds()["endDate"];
      var response = await Products()
          .getProductCountInShop(shopId, type, startDate, endDate);
      products.clear();
      if (response != null) {
        List fetchedProducts = response["body"];
        List<ProductModel> listProducts =
            fetchedProducts.map((e) => ProductModel.fromJson(e)).toList();
        products.assignAll(listProducts);
      } else {
        products.value = [];
      }
      getProductCountLoad.value = false;
    } catch (e) {
      getProductCountLoad.value = false;
    }
  }

  increamentInitial(index) {
    quantityType.value = "increment";
    products[index].quantity = int.parse("${products[index].quantity}") + 1;
    products.refresh();
  }

  decreamentInitial(index) {
    quantityType.value = "decrement";
    if (products[index].quantity! > 0) {
      products[index].quantity = int.parse("${products[index].quantity}") - 1;
    }
    products.refresh();
  }

  updateQuantity({required ProductModel product, required context}) async {
    try {
      Map<String, dynamic> body = {
        "quantity": product.quantity,
        "shop": Get.find<ShopController>().currentShop.value!.id,
        "attendantId": Get.find<AuthController>().usertype == "admin"
            ? Get.find<AuthController>().currentUser.value?.id
            : Get.find<AttendantController>().attendant.value?.id,
        "product": product.id,
      };
      await Products().updateProductCount(body);
    } catch (e) {
      print(e);
    }
  }

  getProductCount(shopId) async {
    try {
      loadingCountHistory.value = true;
      countHistoryList.clear();
      var response = await Products().getProductCount(shopId);
      if (response != null) {
        List history = response["body"];
        List<ProductCountModel> countHistory =
            history.map((e) => ProductCountModel.fromJson(e)).toList();

        countHistoryList.assignAll(countHistory);
      } else {
        countHistoryList.value = [];
      }
      loadingCountHistory.value = false;
    } catch (e) {
      print(e);
      loadingCountHistory.value = false;
    }
  }

  saveBadStock({required String shop, required page, required context}) async {
    try {
      saveBadstockLoad.value = true;
      Map<String, dynamic> body = {
        "productId": selectedBadStock.value?.id,
        "quantity": qtyController.text,
        "description": itemNameController.text,
        "shopId": shop
      };
      var response = await Products().saveBadStock(body: body);
      if (response["status"] == true) {
        showBadStockWidget.value = false;
        selectedBadStock.value = null;
        qtyController.clear();
        itemNameController.clear();
        if (MediaQuery.of(context).size.width > 600) {
          if (page == "sales") {
            Get.find<HomeController>().selectedWidget.value =
                AllSalesPage(page: "badstock");
          } else {
            Get.find<HomeController>().selectedWidget.value = StockPage();
          }
        } else {
          Get.back();
        }
      }
      saveBadstockLoad.value = false;
    } catch (e) {
      saveBadstockLoad.value = false;
      print(e);
    }
  }
}
