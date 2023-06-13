import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:pointify/Real/Models/schema.dart';
import 'package:pointify/controllers/shop_controller.dart';
import 'package:realm/realm.dart';

import '../controllers/realm_controller.dart';

class Users {
  static RealmController realmService = Get.find<RealmController>();

  static createUser(UserModel userModel) {
    realmService.realm
        .write<UserModel>(() => realmService.realm.add<UserModel>(userModel));
  }

  static deleteUser(UserModel userModel) {
    realmService.realm.write(() {
      realmService.realm.delete(userModel);
    });
  }

  static createRole(RolesModel rolesModel) {
    realmService.realm.write<RolesModel>(
        () => realmService.realm.add<RolesModel>(rolesModel));
  }

  static RealmResults<RolesModel> getAllRoles() {
    RealmResults<RolesModel> roles = realmService.realm.all();
    return roles;
  }

  static RealmResults<UserModel> getAllAttendandsByShop() {
    RealmResults<UserModel> user = realmService.realm.query<UserModel>(
        " shop == \$0", [Get.find<ShopController>().currentShop.value]);
    print("attt ${user.length}");
    return user;
  }

  static RealmResults<UserModel> getUserUser(
      {UserModel? userModel, int? uid, String? username}) {
    print("bbb ${realmService.currentUser!.value!.id}");
    if (uid != null) {
      print("UNID == $uid");
      RealmResults<UserModel> user =
          realmService.realm.query<UserModel>('UNID == \$0 ', [uid]);
      print("user == $user");
      return user;
    }
    if (username != null) {
      RealmResults<UserModel> user = realmService.realm.query<UserModel>(
          "username == '$username' AND shop == \$0  AND deleted == false",
          [Get.find<ShopController>().currentShop.value]);
      return user;
    }
    if (userModel != null) {
      RealmResults<UserModel> user = realmService.realm
          .query<UserModel>(r'_id == $0  AND deleted == false', [userModel.id]);
      return user;
    }
    print("last");
    RealmResults<UserModel> user = realmService.realm.query<UserModel>(
        r'authId == $0', [realmService.currentUser!.value!.id]);
    print("last ${user.first.usertype}");
    return user;
  }

  static cashoutGroups() {
    RealmResults<CashFlowCategory> cashoutgroups = realmService.realm.all();
    return cashoutgroups;
  }

  Future<void> updateAdmin(UserModel user,
      {Shop? shop,
      bool? deleted,
      String? username,
      String? authId,
      String? permissions}) async {
    print(permissions);
    realmService.realm.write(() {
      if (shop != null) {
        user.shop = shop;
      }
      if (username != null) {
        user.username = username;
      }
      if (authId != null) {
        user.authId = authId;
      }
      if (deleted != null) {
        user.deleted = deleted;
      }
      if (permissions != null) {
        user.permisions = permissions;
      }
    });
  }
}
