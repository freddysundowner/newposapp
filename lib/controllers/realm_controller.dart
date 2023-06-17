import 'dart:math';

import 'package:get/get.dart';
import 'package:pointify/Real/schema.dart';
import 'package:pointify/controllers/shop_controller.dart';
import 'package:pointify/controllers/user_controller.dart';
import 'package:pointify/services/product.dart';
import 'package:realm/realm.dart';

import '../services/shop_services.dart';
import '../services/sales.dart';
import '../services/users.dart';
import 'AuthController.dart';

class RealmController extends GetxController {
  static const String queryAllName = "getAllItemsSubscription";
  static const String queryMyItemsName = "getMyItemsSubscription";

  ShopController shopController = Get.put(ShopController());
  RxBool showAll = RxBool(false);
  RxBool offlineModeOn = RxBool(false);
  RxBool isWaiting = RxBool(false);
  late Realm realm;
  Rxn<User>? currentUser = Rxn(null);

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    auth();
  }

  auth() {
    AuthController appController = Get.find<AuthController>();
    List<SchemaObject> schemas = [
      Shop.schema,
      ShopTypes.schema,
      ProductCategory.schema,
      UserModel.schema,
      Product.schema,
      RolesModel.schema,
      Supplier.schema,
      Invoice.schema,
      InvoiceItem.schema,
      ProductHistoryModel.schema,
      CustomerModel.schema,
      PayHistory.schema,
      BadStock.schema,
      StockTransferHistory.schema,
      SalesModel.schema,
      ReceiptItem.schema,
      SalesReturn.schema,
      DepositModel.schema,
      ProductCountModel.schema,
      CashFlowCategory.schema,
      ExpenseModel.schema,
      CashOutGroup.schema,
      BankModel.schema,
      CashFlowTransaction.schema,
    ];
    print("real 0");
    if (appController.app.value!.currentUser != null ||
        currentUser?.value != appController.app.value!.currentUser) {
      currentUser?.value ??= appController.app.value!.currentUser;
      print("real 1");
      realm = Realm(Configuration.flexibleSync(currentUser!.value!, schemas));
      print("real 2");
      realm.subscriptions.update((mutableSubscriptions) {
        mutableSubscriptions.add(realm.all<Shop>());
        mutableSubscriptions.add(realm.all<ShopTypes>());
        mutableSubscriptions.add(realm.all<UserModel>());
        mutableSubscriptions.add(realm.all<ProductCategory>());
        mutableSubscriptions.add(realm.all<Product>());
        mutableSubscriptions.add(realm.all<RolesModel>());
        mutableSubscriptions.add(realm.all<Supplier>());
        mutableSubscriptions.add(realm.all<InvoiceItem>());
        mutableSubscriptions.add(realm.all<Invoice>());
        mutableSubscriptions.add(realm.all<ProductHistoryModel>());
        mutableSubscriptions.add(realm.all<PayHistory>());
        mutableSubscriptions.add(realm.all<BadStock>());
        mutableSubscriptions.add(realm.all<StockTransferHistory>());
        mutableSubscriptions.add(realm.all<CustomerModel>());
        mutableSubscriptions.add(realm.all<SalesModel>());
        mutableSubscriptions.add(realm.all<ReceiptItem>());
        mutableSubscriptions.add(realm.all<SalesReturn>());
        mutableSubscriptions.add(realm.all<DepositModel>());
        mutableSubscriptions.add(realm.all<ProductCountModel>());
        mutableSubscriptions.add(realm.all<CashFlowCategory>());
        mutableSubscriptions.add(realm.all<ExpenseModel>());
        mutableSubscriptions.add(realm.all<CashOutGroup>());
        mutableSubscriptions.add(realm.all<BankModel>());
        mutableSubscriptions.add(realm.all<CashFlowTransaction>());
      });
      print("real 3");
    } else {
      print("real 4");
      // realm = Realm(Configuration.local(schemas));
    }
  }

  Future<void> updateSubscriptions() async {
    realm.subscriptions.update((mutableSubscriptions) {
      mutableSubscriptions.clear();
      if (showAll.isTrue) {
        mutableSubscriptions.add(realm.all<Shop>(), name: queryAllName);
      } else {
        mutableSubscriptions.add(
            realm.query<Shop>(r'owner == $0', [currentUser?.value?.id]),
            name: queryMyItemsName);
      }
    });
    await realm.subscriptions.waitForSynchronization();
  }

  Future<String?> setDefaulShop(Shop shop) async {
    RealmResults<UserModel> admin = await Users.getUserUser();
    if (admin.isEmpty) {
      Users.createUser(UserModel(
        ObjectId(),
        Random().nextInt(098459),
        shop: shop,
        deleted: false,
      ));
    } else {
      Users().updateAdmin(admin.first, shop: shop);
    }

    Get.find<UserController>().getUser();
  }

  Future<void> sessionSwitch() async {
    offlineModeOn.value = !offlineModeOn.value;
    if (offlineModeOn.isTrue) {
      realm.syncSession.pause();
    } else {
      try {
        isWaiting.value = true;
        realm.syncSession.resume();
        await updateSubscriptions();
      } finally {
        isWaiting.value = false;
      }
    }
  }

  Future<void> switchSubscription(bool value) async {
    showAll.value = value;
    if (offlineModeOn.isFalse) {
      try {
        isWaiting.value = true;
        await updateSubscriptions();
      } finally {
        isWaiting.value = false;
        refresh();
      }
    }
  }

  // void createItem(String summary, bool isComplete) {
  //   final newItem = Item(ObjectId(), summary, currentUser!.value!.id,
  //       isComplete: isComplete);
  //   realm.write<Item>(() => realm.add<Item>(newItem));
  // }
  //
  // void deleteItem(Item item) {
  //   realm.write(() => realm.delete(item));
  // }
  //
  // Future<void> updateItem(Item item,
  //     {String? summary, bool? isComplete}) async {
  //   realm.write(() {
  //     if (summary != null) {
  //       item.summary = summary;
  //     }
  //     if (isComplete != null) {
  //       item.isComplete = isComplete;
  //     }
  //   });
  // }

  Future<void> close() async {
    if (currentUser != null) {
      await currentUser?.value?.logOut();
      currentUser = null;
    }
    realm.close();
  }

  @override
  void dispose() {
    realm.close();
    super.dispose();
  }

  // void deleteAdmin() {
  //   // UserModel user = Get.find<UserController>().user.value!;
  //   //delete shops by this admin
  //   RealmResults<Shop> shops = ShopService().getShop();
  //   if (shops.isNotEmpty) {
  //     shops.forEach((element) {
  //       //delete sales by this shop
  //       List<SalesModel> sales =
  //           Sales().getSales(shop: element).map((e) => e).toList();
  //       if (sales.isNotEmpty) {
  //         print("${element.name} sales ${sales.length}");
  //         Sales().deleteSaleByShopId(sales);
  //       }
  //       //delete sales receipts by this shop
  //       List<ReceiptItem> saleReceipts =
  //           Sales().getSaleReceipts(shop: element).map((e) => e).toList();
  //       if (saleReceipts.isNotEmpty) {
  //         print("${element.name} saleReceipts ${saleReceipts.length}");
  //         Sales().deleteReceiptItemByShopId(saleReceipts);
  //       }
  //       //delete sales receipts by this shop
  //       List<StockTransferHistory> stockTransfer = Products()
  //           .getTransHistory(shop: element, type: "out")
  //           .map((e) => e)
  //           .toList();
  //       if (stockTransfer.isNotEmpty) {
  //         print("${element.name} stockTransfer ${stockTransfer.length}");
  //         Products().deleteTransHistoryByShopId(stockTransfer);
  //       }
  //       //delete sales receipts by this shop
  //       List<ProductHistoryModel> productHistory = Products()
  //           .getProductHistory("", shop: element.id.toString())
  //           .map((e) => e)
  //           .toList();
  //       if (productHistory.isNotEmpty) {
  //         print("${element.name} productHistory ${productHistory.length}");
  //         Products().deleteProductHistoryModelByShopId(productHistory);
  //       }
  //       //delete sales receipts by this shop
  //       List<ProductCountModel> productCuntHistory =
  //           Products().getProductCountByShopId(element).map((e) => e).toList();
  //       if (productCuntHistory.isNotEmpty) {
  //         print(
  //             "${element.name} productCuntHistory ${productCuntHistory.length}");
  //         Products().deleteProductCountModelByShopId(productCuntHistory);
  //       }
  //       //delete sales receipts by this shop
  //       List<Product> products =
  //           Products().getProductsBySort(shop: element).map((e) => e).toList();
  //       if (productCuntHistory.isNotEmpty) {
  //         print("${element.name} products ${products.length}");
  //         Products().deleteProductsByShopId(products);
  //       }
  //       print("deleting ${element.name}");
  //       ShopService().deleteItem(element);
  //     });
  //   }
  //   // Users.deleteUser(user);
  //   // Get.find<AuthController>()
  //   //     .app
  //   //     .value!
  //   //     .deleteUser(Get.find<AuthController>().app.value!.currentUser!);
  //   print("deleting");
  //   // Get.find<AuthController>().logOut();
  // }
}
