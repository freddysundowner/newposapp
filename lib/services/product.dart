import 'dart:convert';

import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:pointify/controllers/product_controller.dart';
import 'package:realm/realm.dart';

import '../Real/schema.dart';
import '../controllers/realm_controller.dart';
import '../controllers/shop_controller.dart';
import '../main.dart';
import 'client.dart';

class Products {
  final RealmController realmService = Get.find<RealmController>();

  final ShopController shopController = Get.find<ShopController>();
  createProduct(Product body, {String? type = ""}) async {
    realmService.realm
        .write<Product>(() => realmService.realm.add<Product>(body));
  }

  updateProduct({required Product product}) async {
    realmService.realm.write<Product>(
        () => realmService.realm.add<Product>(product, update: true));
  }

  updateProductPart(
      {required Product product,
      int? quantity,
      int? buyingPrice,
      int? sellingPrice,
      bool deleted = false,
      bool counted = false,
      DateTime? updatedAt,
      String? counteddate,
      String? type = ""}) async {
    realmService.realm.write(() {
      if (buyingPrice != null) {
        product.buyingPrice = buyingPrice;
      }
      if (sellingPrice != null) {
        product.selling = sellingPrice;
      }
      if (quantity != null) {
        product.quantity = quantity;
      }
      if (counted) {
        product.counted = counted;
      }
      if (updatedAt != null) {
        product.updatedAt = updatedAt;
      }
      if (counteddate != null) {
        product.counteddate = counteddate;
      }

      if (deleted) {
        product.deleted = deleted;
      }
    });
  }

  createProductHistory(ProductHistoryModel body) {
    realmService.realm.write<ProductHistoryModel>(
        () => realmService.realm.add<ProductHistoryModel>(body));
  }

  RealmResults<Product> getProductsBySort(
      {String? type = "all", String? text = "", Shop? shop}) {
    if (shop != null) {
      RealmResults<Product> products =
          realmService.realm.query<Product>('shop == \$0', [shop]);
      return products;
    }
    String filter = " AND deleted == false";
    if (type == "quantity") {
      filter += " AND TRUEPREDICATE SORT(quantity DESC)";
    } else if (type == "outofstock") {
      filter += " AND quantity == 0";
    } else if (type == "runninglow") {
      filter += " AND quantity < stockLevel";
    } else if (type == "highestbuying") {
      filter += " AND TRUEPREDICATE SORT(buyingPrice DESC)";
    } else if (type == "highestselling") {
      filter += " AND TRUEPREDICATE SORT(selling DESC)";
    }
    RealmResults<Product> products = realmService.realm.query<Product>(
        'shop == \$0$filter', [Get.find<ShopController>().currentShop.value]);

    if (type == "search") {
      var newproducts = products.query("name BEGINSWITH \$0", [text!]);
      return _attendantFilter(newproducts);
    }

    //count products filter
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formatted = formatter.format(now);
    if (type == "countedtoday") {
      var newproducts = products.query("counteddate == \$0", [formatted]);
      return _attendantFilter(newproducts);
    }
    if (type == "notcountedtoday") {
      var newproducts = products.query("counteddate != \$0", [formatted]);
      return _attendantFilter(newproducts);
    }
    if (type == "nevercounted") {
      var newproducts = products.query("counteddate == NULL");
      return _attendantFilter(newproducts);
    }
    return _attendantFilter(products);
  }

  _attendantFilter(RealmResults<Product> data) {
    if (userController.switcheduser.value != null) {
      return data
          .query("attendant == \$0 ", [userController.switcheduser.value!]);
    }
    return data;
  }

  Product? getProductByName(String text, Shop shop) {
    RealmResults<Product> products = realmService.realm
        .query<Product>('shop == \$0 AND deleted == false', [shop]);
    products.query(r'name == $0', [text]);
    return products.isNotEmpty ? products.first : null;
  }

  getProductPurchaseHistory(
      {Product? product, DateTime? fromDate, DateTime? toDate}) {
    if (fromDate != null) {
      print(fromDate);
      print(toDate);
      RealmResults<InvoiceItem> invoices = realmService.realm.query<
              InvoiceItem>(
          'date > ${fromDate.millisecondsSinceEpoch} AND date < ${toDate!.millisecondsSinceEpoch} AND product == \$0  AND TRUEPREDICATE SORT(createdAt DESC)',
          [product]);
      print(invoices.length);
      return invoices;
    }
    RealmResults<InvoiceItem> invoices = realmService.realm.query<InvoiceItem>(
        'product == \$0  AND TRUEPREDICATE SORT(createdAt DESC)', [product]);
    return invoices;
  }

  getProductCountHistory({Shop? shop, Product? product}) {
    if (product != null) {
      RealmResults<ProductCountModel> productCountHistory = realmService.realm
          .query<ProductCountModel>(
              'product == \$0  AND TRUEPREDICATE SORT(createdAt DESC)',
              [product]);
      return productCountHistory;
    }
    RealmResults<ProductCountModel> productCountHistory = realmService.realm
        .query<ProductCountModel>(
            'shopId == \$0  AND TRUEPREDICATE SORT(createdAt DESC)',
            [Get.find<ShopController>().currentShop.value]);
    return productCountHistory;
  }

  updateProductCount(ProductHistoryModel productCountModel) async {
    realmService.realm.write<ProductHistoryModel>(
        () => realmService.realm.add<ProductHistoryModel>(productCountModel));
  }

  deleteProductCount(ProductCountModel productCountModel) {
    realmService.realm.write(() {
      realmService.realm.delete(productCountModel);
    });
  }

  RealmResults<ProductHistoryModel> getProductHistory(String type,
      {ObjectId? transferId, String? shop}) {
    if (shop != null) {
      RealmResults<ProductHistoryModel> results =
          realmService.realm.query<ProductHistoryModel>('shop =="${shop}"');
      return results;
    }

    if (transferId != null) {
      RealmResults<ProductHistoryModel> results = realmService.realm
          .query<ProductHistoryModel>(
              'stockTransferHistory == \$0', [transferId]);
      var resultsResponse = results.query("type == \$0", [type]);
      return resultsResponse;
    }
    RealmResults<ProductHistoryModel> results = realmService.realm.query<
            ProductHistoryModel>(
        'shop =="${shop ?? Get.find<ShopController>().currentShop.value!.id.toString()}"');
    var resultsResponse = results.query("type == \$0", [type]);
    return resultsResponse;
  }

  createProductStockTransferHistory(
      StockTransferHistory stockTransferHistory) async {
    realmService.realm.write<StockTransferHistory>(() =>
        realmService.realm.add<StockTransferHistory>(stockTransferHistory));
  }

  deleteTransHistoryByShopId(List<StockTransferHistory> sales) {
    realmService.realm.write(() {
      realmService.realm.deleteMany(sales);
    });
  }

  deleteProductHistoryModelByShopId(List<ProductHistoryModel> sales) {
    realmService.realm.write(() {
      realmService.realm.deleteMany(sales);
    });
  }

  deleteProductCountModelByShopId(List<ProductCountModel> sales) {
    realmService.realm.write(() {
      realmService.realm.deleteMany(sales);
    });
  }

  deleteProductsByShopId(List<Product> sales) {
    realmService.realm.write(() {
      realmService.realm.deleteMany(sales);
    });
  }

  RealmResults<StockTransferHistory> getTransHistory(
      {required Shop shop, required type}) {
    if (type == "in") {
      RealmResults<StockTransferHistory> history =
          realmService.realm.query<StockTransferHistory>('to == \$0', [shop]);
      return history;
    }
    RealmResults<StockTransferHistory> history =
        realmService.realm.query<StockTransferHistory>('from == \$0', [shop]);
    print(history.length);
    return history;
  }

  RealmResults<ProductHistoryModel> getProductTransferHistory(
      {required Product product}) {
    RealmResults<ProductHistoryModel> history = realmService.realm
        .query<ProductHistoryModel>(
            "type == 'transfer' AND product == \$0", [product]);
    return history;
  }

  getProductSaleHistory(productId) {}

  saveBadStock(BadStock badStock) async {
    realmService.realm
        .write<BadStock>(() => realmService.realm.add<BadStock>(badStock));
  }

  RealmResults<BadStock> getBadStock(
      {DateTime? fromDate, DateTime? toDate, Product? product}) {
    if (product != null) {
      RealmResults<BadStock> returns = realmService.realm.query<BadStock>(
          'date > ${fromDate!.millisecondsSinceEpoch} AND date < ${toDate!.millisecondsSinceEpoch} AND product == \$0',
          [product]);
      return returns;
    }
    if (fromDate != null && toDate != null) {
      RealmResults<BadStock> returns = realmService.realm.query<BadStock>(
          'date > ${fromDate.millisecondsSinceEpoch} AND date < ${toDate.millisecondsSinceEpoch} AND shop == \$0',
          [shopController.currentShop.value]);
      return returns;
    }
    RealmResults<BadStock> products = realmService.realm.query<BadStock>(
        'shop == \$0 AND TRUEPREDICATE SORT(createdAt DESC)',
        [Get.find<ShopController>().currentShop.value]);
    return products;
  }

  RealmResults<ProductCountModel> getProductCountByShopId(Shop shop) {
    RealmResults<ProductCountModel> returns =
        realmService.realm.query<ProductCountModel>('shopId == \$0', [shop]);
    return returns;
  }

  void createProductCount({required ProductCountModel productCountModel}) {
    productCountModel.attendantId = userController.user.value;

    realmService.realm.write<ProductCountModel>(
        () => realmService.realm.add<ProductCountModel>(productCountModel));
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formatted = formatter.format(now);
    updateProductPart(
        product: productCountModel.product!,
        quantity: productCountModel.quantity,
        counted: true,
        counteddate: formatted,
        updatedAt: DateTime.now());
  }
}
