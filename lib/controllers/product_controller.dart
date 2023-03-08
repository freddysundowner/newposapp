import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutterpos/controllers/purchase_controller.dart';
import 'package:flutterpos/controllers/shop_controller.dart';
import 'package:flutterpos/services/category.dart';
import 'package:flutterpos/utils/colors.dart';
import 'package:flutterpos/widgets/snackBars.dart';
import 'package:get/get.dart';

import '../models/product_category_model.dart';
import '../models/product_count_model.dart';
import '../models/product_model.dart';
import '../services/product.dart';
import '../utils/dates.dart';
import '../widgets/loading_dialog.dart';

class ProductController extends GetxController {
  GlobalKey<State> _keyLoader = new GlobalKey<State>();
  RxList<ProductModel> products = RxList([]);
  RxList selectedSupplier = RxList([]);
  RxList<ProductCountModel> countHistoryList = RxList([]);

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
          await getProductsBySort(shopId: shopId, type: "all");
          Get.back();
          showSnackBar(
              message: response["message"],
              color: AppColors.mainColor,
              context: context);
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
      if (response["status"]) {
        category.text = "";
        getProductCategory(shopId: shopId);
        showSnackBar(
            message: response["message"],
            color: AppColors.mainColor,
            context: context);
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
      List prod = [
        {
          "_id": "63fdd0f98b658aafbf4e2289",
          "name": "triple",
          "quantity": 193,
          "category": {
            "_id": "63fdce708b658aafbf4e21ec",
            "name": "machinery",
            "shop": "63fa089e46721b7480474be5",
            "createdAt": "2023-02-28T09:50:40.454Z",
            "updatedAt": "2023-02-28T09:50:40.454Z",
            "__v": 0
          },
          "stockLevel": 110,
          "sellingPrice": [
            "1300"
          ],
          "discount": 0,
          "shop": "63fa089e46721b7480474be5",
          "attendant": {
            "_id": "63f9efe3879e16801054a0b0",
            "fullnames": "peter",
            "attendid": 46056,
            "phonenumber": null,
            "shop": null,
            "password": "",
            "roles": [],
            "createdAt": "2023-02-25T11:24:19.667Z",
            "updatedAt": "2023-02-25T11:24:19.667Z",
            "__v": 0
          },
          "buyingPrice": 1200,
          "minSellingPrice": 1300,
          "badStock": 0,
          "description": "",
          "measureUnit": "",
          "deleted": false,
          "counted": false,
          "createdAt": "2023-02-28T10:01:29.081Z",
          "updatedAt": "2023-03-04T08:44:25.515Z",
          "__v": 0
        },
        {
          "_id": "63fdd0728b658aafbf4e2255",
          "name": "trial",
          "quantity": 20,
          "category": {
            "_id": "63fdce708b658aafbf4e21ec",
            "name": "machinery",
            "shop": "63fa089e46721b7480474be5",
            "createdAt": "2023-02-28T09:50:40.454Z",
            "updatedAt": "2023-02-28T09:50:40.454Z",
            "__v": 0
          },
          "stockLevel": 10,
          "sellingPrice": [
            "1340"
          ],
          "discount": 0,
          "shop": "63fa089e46721b7480474be5",
          "attendant": {
            "_id": "63f9efe3879e16801054a0b0",
            "fullnames": "peter",
            "attendid": 46056,
            "phonenumber": null,
            "shop": null,
            "password": "",
            "roles": [],
            "createdAt": "2023-02-25T11:24:19.667Z",
            "updatedAt": "2023-02-25T11:24:19.667Z",
            "__v": 0
          },
          "buyingPrice": 1200,
          "minSellingPrice": 1340,
          "badStock": 0,
          "description": "",
          "measureUnit": "",
          "deleted": false,
          "counted": false,
          "createdAt": "2023-02-28T09:59:14.650Z",
          "updatedAt": "2023-02-28T09:59:14.650Z",
          "__v": 0
        },
        {
          "_id": "63fdd0008b658aafbf4e222b",
          "name": "trial",
          "quantity": 200,
          "category": {
            "_id": "63fdce708b658aafbf4e21ec",
            "name": "machinery",
            "shop": "63fa089e46721b7480474be5",
            "createdAt": "2023-02-28T09:50:40.454Z",
            "updatedAt": "2023-02-28T09:50:40.454Z",
            "__v": 0
          },
          "stockLevel": 0,
          "sellingPrice": [
            "1300"
          ],
          "discount": 0,
          "shop": "63fa089e46721b7480474be5",
          "attendant": {
            "_id": "63f9efe3879e16801054a0b0",
            "fullnames": "peter",
            "attendid": 46056,
            "phonenumber": null,
            "shop": null,
            "password": "",
            "roles": [],
            "createdAt": "2023-02-25T11:24:19.667Z",
            "updatedAt": "2023-02-25T11:24:19.667Z",
            "__v": 0
          },
          "buyingPrice": 1200,
          "minSellingPrice": 1300,
          "badStock": 0,
          "description": "trial",
          "measureUnit": "",
          "deleted": false,
          "counted": false,
          "createdAt": "2023-02-28T09:57:20.839Z",
          "updatedAt": "2023-02-28T09:57:20.839Z",
          "__v": 0
        },
        {
          "_id": "63fdcdab8b658aafbf4e21c9",
          "name": "cups",
          "quantity": 30,
          "category": {
            "_id": "63fdcd778b658aafbf4e21c3",
            "name": "utensils",
            "shop": "63fa089e46721b7480474be5",
            "createdAt": "2023-02-28T09:46:31.710Z",
            "updatedAt": "2023-02-28T09:46:31.710Z",
            "__v": 0
          },
          "stockLevel": 0,
          "sellingPrice": [
            "2000"
          ],
          "discount": 0,
          "shop": "63fa089e46721b7480474be5",
          "attendant": {
            "_id": "63fda3fed13cf778aab94e2f",
            "fullnames": "kimani",
            "attendid": 89107,
            "phonenumber": null,
            "shop": "63fa089e46721b7480474be5",
            "password": "",
            "roles": [
              {
                "key": "sales",
                "value": "sales"
              },
              {
                "key": "stockin",
                "value": "Stockin "
              },
              {
                "key": "discounts",
                "value": "Discount"
              },
              {
                "key": "add_products",
                "value": "Add products"
              },
              {
                "key": "expenses",
                "value": "Add expenses"
              },
              {
                "key": "customers",
                "value": "Manage Customers"
              },
              {
                "key": "Suppliers",
                "value": "Manage suppliers"
              },
              {
                "key": "stock_balance",
                "value": "Stock balance"
              },
              {
                "key": "count_stock",
                "value": "Count stock"
              },
              {
                "key": "edit_entries",
                "value": "Edit entries"
              }
            ],
            "createdAt": "2023-02-28T06:49:34.652Z",
            "updatedAt": "2023-03-01T12:42:14.026Z",
            "__v": 0
          },
          "buyingPrice": 1600,
          "minSellingPrice": 2000,
          "badStock": 0,
          "description": "Quality and affordable cups",
          "measureUnit": "",
          "deleted": false,
          "counted": false,
          "createdAt": "2023-02-28T09:47:23.056Z",
          "updatedAt": "2023-02-28T09:47:23.056Z",
          "__v": 0
        },
        {
          "_id": "63fdcd1b8b658aafbf4e21b5",
          "name": "Attendant Trial",
          "quantity": 200,
          "category": {
            "_id": "63fc4daf8e7d4a3bbf488792",
            "name": "vegetables",
            "shop": "63fa089e46721b7480474be5",
            "createdAt": "2023-02-27T06:29:03.131Z",
            "updatedAt": "2023-02-27T06:29:03.131Z",
            "__v": 0
          },
          "stockLevel": 0,
          "sellingPrice": [
            "2000"
          ],
          "discount": 0,
          "shop": "63fa089e46721b7480474be5",
          "attendant": {
            "_id": "63fda3fed13cf778aab94e2f",
            "fullnames": "kimani",
            "attendid": 89107,
            "phonenumber": null,
            "shop": "63fa089e46721b7480474be5",
            "password": "",
            "roles": [
              {
                "key": "sales",
                "value": "sales"
              },
              {
                "key": "stockin",
                "value": "Stockin "
              },
              {
                "key": "discounts",
                "value": "Discount"
              },
              {
                "key": "add_products",
                "value": "Add products"
              },
              {
                "key": "expenses",
                "value": "Add expenses"
              },
              {
                "key": "customers",
                "value": "Manage Customers"
              },
              {
                "key": "Suppliers",
                "value": "Manage suppliers"
              },
              {
                "key": "stock_balance",
                "value": "Stock balance"
              },
              {
                "key": "count_stock",
                "value": "Count stock"
              },
              {
                "key": "edit_entries",
                "value": "Edit entries"
              }
            ],
            "createdAt": "2023-02-28T06:49:34.652Z",
            "updatedAt": "2023-03-01T12:42:14.026Z",
            "__v": 0
          },
          "buyingPrice": 1200,
          "minSellingPrice": 2000,
          "badStock": 0,
          "description": "trial attendant",
          "measureUnit": "",
          "deleted": false,
          "counted": false,
          "createdAt": "2023-02-28T09:44:59.274Z",
          "updatedAt": "2023-02-28T09:44:59.274Z",
          "__v": 0
        },
        {
          "_id": "63fc4dc58e7d4a3bbf488795",
          "name": "carrots",
          "quantity": 151,
          "category": {
            "_id": "63fc4daf8e7d4a3bbf488792",
            "name": "vegetables",
            "shop": "63fa089e46721b7480474be5",
            "createdAt": "2023-02-27T06:29:03.131Z",
            "updatedAt": "2023-02-27T06:29:03.131Z",
            "__v": 0
          },
          "stockLevel": 0,
          "sellingPrice": [
            "1400"
          ],
          "discount": 0,
          "shop": "63fa089e46721b7480474be5",
          "attendant": {
            "_id": "63f9efe3879e16801054a0b0",
            "fullnames": "peter",
            "attendid": 46056,
            "phonenumber": null,
            "shop": null,
            "password": "",
            "roles": [],
            "createdAt": "2023-02-25T11:24:19.667Z",
            "updatedAt": "2023-02-25T11:24:19.667Z",
            "__v": 0
          },
          "buyingPrice": 1200,
          "minSellingPrice": 1400,
          "badStock": 0,
          "description": "quality Carrots",
          "measureUnit": "",
          "deleted": false,
          "counted": false,
          "createdAt": "2023-02-27T06:29:25.891Z",
          "updatedAt": "2023-02-28T09:28:23.207Z",
          "__v": 0
        },
        {
          "_id": "63fa091246721b7480474bfd",
          "name": "ahp",
          "quantity": 1,
          "category": {
            "_id": "63fa08ef46721b7480474bf6",
            "name": "electronics",
            "shop": "63fa089e46721b7480474be5",
            "createdAt": "2023-02-25T13:11:11.066Z",
            "updatedAt": "2023-02-25T13:11:11.066Z",
            "__v": 0
          },
          "stockLevel": 10,
          "sellingPrice": [
            "50000"
          ],
          "discount": 0,
          "shop": "63fa089e46721b7480474be5",
          "attendant": {
            "_id": "63f9efe3879e16801054a0b0",
            "fullnames": "peter",
            "attendid": 46056,
            "phonenumber": null,
            "shop": null,
            "password": "",
            "roles": [],
            "createdAt": "2023-02-25T11:24:19.667Z",
            "updatedAt": "2023-02-25T11:24:19.667Z",
            "__v": 0
          },
          "buyingPrice": 30000,
          "minSellingPrice": 50000,
          "badStock": 0,
          "description": "trial",
          "measureUnit": "",
          "deleted": false,
          "counted": false,
          "createdAt": "2023-02-25T13:11:46.769Z",
          "updatedAt": "2023-02-28T06:58:09.505Z",
          "__v": 0
        }
      ];

      List<ProductModel> listProducts =
      prod.map((e) => ProductModel.fromJson(e)).toList();
      products.assignAll(listProducts);
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
    } catch (e) {
      getProductLoad.value = false;
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
      var response = await Products().deleteProduct(id: id);
      if (response["status"] == true) {
        showSnackBar(
            message: response["message"],
            color: AppColors.mainColor,
            context: context);
        await getProductsBySort(shopId: shopId, type: "all");
      } else {
        showSnackBar(
            message: response["message"],
            color: AppColors.mainColor,
            context: context);
      }
    } catch (e) {}
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
          Get.back();
          showSnackBar(
              message: response["message"],
              color: AppColors.mainColor,
              context: context);
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

  updateQuantity(product, context) async {
    try {
      Map<String, dynamic> body = {
        "quantity": product.quantity,
        "shop": Get.find<ShopController>().currentShop.value!.id,
        "type": quantityType.value
      };
      var response = await Products().updateProductCount(product.id, body);
      if (response["status"] == true) {
        showSnackBar(
            message: response["message"],
            color: AppColors.mainColor,
            context: context);
      } else {
        showSnackBar(
            message: response["message"],
            color: AppColors.mainColor,
            context: context);
      }
    } catch (e) {}
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
      loadingCountHistory.value = false;
    }
  }
}
