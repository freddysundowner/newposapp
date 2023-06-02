import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:pointify/Real/Models/schema.dart';
import 'package:realm/realm.dart';

import '../controllers/realm_controller.dart';

class Users {
  static RealmController realmService = Get.find<RealmController>();

  static createUser(UserModel userModel) {
    realmService.realm
        .write<UserModel>(() => realmService.realm.add<UserModel>(userModel));
  }

  static getUserUser() {
    RealmResults<UserModel> user = realmService.realm.query<UserModel>(
        r'_id == $0',
        [ObjectId.fromHexString(realmService.currentUser!.value!.id)]);
    return user;
  }

  Future<void> updateAdmin(RealmResults<UserModel> user, {Shop? shop}) async {
    realmService.realm.write(() {
      user.first.shop = shop;
    });
  }
}
