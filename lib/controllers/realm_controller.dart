import 'package:get/get.dart';
import 'package:pointify/Real/Models/schema.dart';
import 'package:pointify/controllers/shop_controller.dart';
import 'package:pointify/controllers/user_controller.dart';
import 'package:realm/realm.dart';

import '../Real/services/r_shop.dart';
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
    if (appController.app.value!.currentUser != null ||
        currentUser?.value != appController.app.value!.currentUser) {
      currentUser?.value ??= appController.app.value!.currentUser;
      realm = Realm(Configuration.flexibleSync(currentUser!.value!, [
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
      ]));
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
      });
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
      Users.createUser(UserModel(ObjectId(), shop: shop));
    } else {
      Users().updateAdmin(admin, shop: shop);
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
}
