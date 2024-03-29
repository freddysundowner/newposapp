import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:pointify/controllers/purchase_controller.dart';
import 'package:pointify/controllers/home_controller.dart';
import 'package:pointify/controllers/shop_controller.dart';
import 'package:pointify/controllers/user_controller.dart';
import 'package:pointify/main.dart';
import 'package:pointify/responsive/responsiveness.dart';
import 'package:pointify/screens/stock/stock_page.dart';
import 'package:pointify/services/purchases.dart';
import 'package:pointify/widgets/snackBars.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:realm/realm.dart';

import '../Real/schema.dart';
import '../services/product.dart';
import '../widgets/alert.dart';

class ProductController extends GetxController {
  RxList<Product> products = RxList([]);
  RxList<ProductCountModel> productsCount = RxList([]);
  RxList selectedSupplier = RxList([]);
  RxList<ProductHistoryModel> productHistoryList = RxList([]);
  RxList<ProductCountModel> countHistory = RxList([]);
  RxList<InvoiceItem> productInvoices = RxList([]);
  RxBool showBadStockWidget = RxBool(false);
  RxBool saveBadstockLoad = RxBool(false);
  Rxn<Product> selectedBadStock = Rxn(null);
  RxList<BadStock> badstocks = RxList([]);

  RxList<ProductCategory> productCategory = RxList([]);
  Rxn<ProductCategory> categoryId = Rxn(null);
  RxString selectedMeasure = RxString("Kg");
  RxInt currentYear = RxInt(DateTime.now().year);
  RxBool creatingProductLoad = RxBool(false);
  RxBool getProductLoad = RxBool(false);
  RxBool updateProductLoad = RxBool(false);
  RxBool getProductCountLoad = RxBool(false);
  RxBool loadingCountHistory = RxBool(false);
  RxInt stockValue = RxInt(0);
  RxInt totalProfitEstimate = RxInt(0);
  RxString selectedSortOrder = RxString("All");
  RxString selectedSortOrderCount = RxString("All");
  RxString selectedSortOrderSearch = RxString("all");
  RxString selectedSortOrderCountSearch = RxString("all");
  RxString supplierName = RxString("None");
  Rxn<Supplier> supplierId = Rxn(null);

  RxInt initialProductValue = RxInt(0);
  RxInt productHistoryTabIndex = RxInt(0);
  var filterStartDate =
      DateTime.parse(DateFormat("yyy-MM-dd").format(DateTime.now())).obs;
  var filterEndDate = DateTime.parse(
          DateFormat("yyy-MM-dd").format(DateTime.now().add(Duration(days: 1))))
      .obs;

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
  TextEditingController searchProductCountController = TextEditingController();

  saveProducts({Product? productData}) async {

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
        categoryId.value == null) {
      isSmallScreen(Get.context)
          ? showSnackBar(
              message: "Please fill all fields marked by *", color: Colors.red)
          : generalAlert(
              title: "Error", message: "Please fill all fields marked by *");
    } else if (int.parse(buying) > int.parse(selling)) {
      isSmallScreen(Get.context)
          ? showSnackBar(
              message: "Selling price cannot be lower than buying price",
              color: Colors.red)
          : generalAlert(
              title: "Error",
              message: "Selling price cannot be lower than buying price");
    } else if (minSelling != "" && int.parse(minSelling) > int.parse(selling)) {
      isSmallScreen(Get.context)
          ? showSnackBar(
              message:
                  "minimum selling price cannot be greater than selling price",
              color: Colors.red)
          : generalAlert(
              title: "Error",
              message:
                  "minimum selling price cannot be greater than selling price");
    } else if (minSelling != "" && int.parse(buying) > int.parse(minSelling)) {
      isSmallScreen(Get.context)
          ? showSnackBar(
              message: "minimum selling price cannot be less than buying price",
              color: Colors.red)
          : generalAlert(
              title: "Error",
              message:
                  "minimum selling price cannot be less than buying price");
    } else if (discount != "" && int.parse(discount) > int.parse(selling)) {
      isSmallScreen(Get.context)
          ? showSnackBar(
              message: "discount cannot be greater than selling price",
              color: Colors.red)
          : generalAlert(
              title: "Error",
              message: "discount cannot be greater than selling price");
    } else {
      try {
        creatingProductLoad.value = true;
        final DateTime now = DateTime.now();
        final DateFormat formatter = DateFormat('yyyy-MM-dd');
        final String formatted = formatter.format(now);

        Product product = Product(
            productData != null ? productData.id : ObjectId(),
            name: name,
            quantity: productData != null ? int.parse(qty) : 0,
            buyingPrice: int.parse(buying),
            selling: int.parse(selling),
            invoiceId: null,
            minPrice: minSelling == "" ? int.parse(selling) : int.parse(minSelling),
            shop: Get.find<ShopController>().currentShop.value,
            attendant: Get.find<UserController>().user.value,
            unit: selectedMeasure.value,
            category: categoryId.value,
            stockLevel: reorder == "" ? 0 : int.parse(reorder),
            discount: discount == "" ? 0 : int.parse(discount),
            description: description.isEmpty ? "" : description,
            supplier: supplierName.value == "None" ? "" : supplierId.value!.id.toString(),
            date: formatted,
            deleted: false,
            createdAt: DateTime.now());
        Invoice? invoice = Get.find<PurchaseController>().invoice.value;
        if (productData == null) {
          await Products().createProduct(product);

          //add produc as a purchase
          Get.find<PurchaseController>().addNewPurchase(
              InvoiceItem(
                  ObjectId(),
                  product: product,
                  price: product.buyingPrice,
                  total: product.buyingPrice! * int.parse(qty),
                  attendantid: userController.user.value,
                  supplier:supplierId.value,
                  createdAt: DateTime.now(),
                  itemCount: int.parse(qty))
          );
          Get.find<PurchaseController>().invoice.value?.balance = 0;
          Get.find<PurchaseController>().createPurchase();
        } else {
          await Products().updateProduct(product: product);
        }
        await Products().updateProductPart(product: product, invoice: invoice);

        //end add product as a purcharse

        if (isSmallScreen(Get.context)) {
          Get.back();
        } else {
          Get.find<HomeController>().selectedWidget.value = StockPage();
        }
        await getProductsBySort(type: "all");
        creatingProductLoad.value = false;
      } catch (e) {
        print(e);
        creatingProductLoad.value = false;
      }
    }
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
    supplierName.value = "None";
    selectedMeasure.value = "Kg";
    categoryId.value = null;
    selectedBadStock.value = null;
  }

  getProductsBySort({required String type, String text = ""}) {
    // products.clear();
    RealmResults<Product> allproducts =
        Products().getProductsBySort(type: type, text: text);
    stockValue.value = allproducts.fold(
        0, (sum, item) => sum + (item.selling! * item.quantity!));
    var totalBuyingTotal = allproducts.fold(
        0, (sum, item) => sum + (item.buyingPrice! * item.quantity!));
    totalProfitEstimate.value = stockValue.value - totalBuyingTotal;
    products.value = allproducts.map((e) => e).toList();
  }

  getProductsCount({required String type, String text = ""}) {
    productsCount.clear();
    RealmResults<Product> allproducts =
        Products().getProductsBySort(type: type, text: text);
    List<Product> products = allproducts.map((e) => e).toList();
    for (var element in products) {
      ProductCountModel productCountModel = ProductCountModel(ObjectId(),
          product: element,
          initialquantity: element.quantity,
          quantity: element.quantity,
          createdAt: DateTime.now(),
          attendantId: Get.find<UserController>().user.value,
          shopId: Get.find<ShopController>().currentShop.value);
      productsCount.add(productCountModel);
    }
    productsCount.refresh();
  }

  getCountHistory({Product? product}) {
    countHistory.clear();
    RealmResults<ProductCountModel> productCountHistoryResponse =
        Products().getProductCountHistory(product: product);
    countHistory.addAll(productCountHistoryResponse.map((e) => e).toList());
    print(countHistory.length);
  }

  increamentInitial(index) {
    productsCount[index].quantity = productsCount[index].quantity! + 1;
    productsCount.refresh();
  }

  decreamentInitial(index) {
    if (productsCount[index].quantity == 0) return;
    productsCount[index].quantity = productsCount[index].quantity! - 1;
    productsCount.refresh();
  }

  Future<void> scanQR(
      {required shopId, required type, required context}) async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
      if (type == "count") {
        searchProductCountController.text = barcodeScanRes;
      } else {
        searchProductController.text = barcodeScanRes;
      }

      getProductsBySort(type: "all");
    } on PlatformException {
      showSnackBar(
          message: 'Failed to get platform version.', color: Colors.red);
    }
  }

  deleteProduct({required Product product}) async {
    await Products().updateProductPart(product: product, deleted: true);
    if (product.invoiceId != null) {
      Purchases().deleteInvoiceItems(product.invoiceId!.items);
      Purchases().deleteInvoices([product.invoiceId!]);
    }
    getProductsBySort(type: "all");
  }

  assignTextFields(Product productModel) {
    itemNameController.text = productModel.name!;
    qtyController.text = productModel.quantity!.toString();
    buyingPriceController.text = productModel.buyingPrice!.toString();
    sellingPriceController.text = productModel.selling!.toString();
    reOrderController.text = productModel.stockLevel!.toString();
    discountController.text = productModel.discount!.toString();
    descriptionController.text = productModel.description!;
    categoryId.value = productModel.category;
    minsellingPriceController.text = productModel.minPrice.toString();
    selectedMeasure.value = productModel.unit!;
  }

  updateQuantity({required Product product, required int quantity}) async {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formatted = formatter.format(now);

    ProductHistoryModel productCountModel = ProductHistoryModel(ObjectId(),
        product: product,
        quantity: quantity,
        shop: Get.find<ShopController>().currentShop.value!.id!.toString(),
        createdAt: DateTime.now(),
        type: "count");
    await Products().updateProductCount(productCountModel);
    await Products().updateProductPart(
        product: product,
        quantity: quantity,
        counted: true,
        counteddate: formatted,
        updatedAt: DateTime.now());
  }

  getProductHistory(String type, {ObjectId? transferId}) async {
    productHistoryList.clear();
    RealmResults<ProductHistoryModel> response =
        Products().getProductHistory(type, transferId: transferId);
    print(response.length);
    productHistoryList.addAll(response.map((e) => e).toList());
  }

  saveBadStock({required page, required context}) async {
    try {
      saveBadstockLoad.value = true;
      BadStock badStock = BadStock(ObjectId(),
          description: itemNameController.text,
          quantity: int.parse(qtyController.text),
          createdAt: DateTime.now(),
          date: DateTime.now().millisecondsSinceEpoch,
          product: selectedBadStock.value,
          attendantId: Get.find<UserController>().user.value,
          shop: Get.find<ShopController>().currentShop.value);

      Products().saveBadStock(badStock);
      Products().updateProductPart(
          product: selectedBadStock.value!,
          quantity: selectedBadStock.value!.quantity! -
              int.parse(qtyController.text));

      getBadStock(
          shopId: Get.find<ShopController>().currentShop.value!.id,
          attendant: '',
          product: null);
      showBadStockWidget.value = false;
      saveBadstockLoad.value = false;
      clearControllers();
    } catch (e) {
      saveBadstockLoad.value = false;
      print(e);
    }
  }

  getBadStock(
      {shopId,
      String? attendant,
      Product? product,
      DateTime? fromDate,
      DateTime? toDate}) async {
    try {
      saveBadstockLoad.value = true;
      badstocks.clear();
      RealmResults<BadStock> response = Products()
          .getBadStock(product: product, fromDate: fromDate, toDate: toDate);
      badstocks.addAll(response.map((e) => e).toList());
      saveBadstockLoad.value = false;
    } catch (e) {
      saveBadstockLoad.value = false;
      print(e);
    }
  }

  getProductPurchaseHistory(Product product,
      {DateTime? fromDate, DateTime? toDate}) {
    if (fromDate == null) {
      fromDate = filterStartDate.value;
      toDate = filterEndDate.value;
    }
    productInvoices.clear();
    RealmResults<InvoiceItem> productsHistory = Products()
        .getProductPurchaseHistory(
            product: product, fromDate: fromDate, toDate: toDate);
    productInvoices.addAll(productsHistory.map((e) => e).toList());
    productInvoices.refresh();
  }
}
