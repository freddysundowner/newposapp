import 'package:get/get.dart';
import 'package:pointify/services/plans_service.dart';
import 'package:realm/realm.dart';

import '../Real/schema.dart';

class PlanController extends GetxController {
  RxList<Packages> plans = RxList([]);
  // RxList<Packages> plans = RxList([
  //   Packages(ObjectId(),
  //       title: "14 days trial",
  //       description: "Test pointify all features for 14 days",
  //       price: 0,
  //       time: 14,
  //       code: 1),
  //   Packages(
  //     ObjectId(),
  //     title: "30 days",
  //     description: "",
  //     price: 10,
  //     code: 2,
  //     time: 30,
  //   ),
  //   Packages(
  //     ObjectId(),
  //     title: "3 months",
  //     description: "",
  //     price: 1000,
  //     code: 2,
  //     time: 90,
  //   ),
  //   Packages(
  //     ObjectId(),
  //     title: "6 months",
  //     description: "",
  //     price: 1500,
  //     code: 2,
  //     time: 180,
  //   ),
  //   Packages(
  //     ObjectId(),
  //     title: "12 months",
  //     description: "",
  //     price: 2000,
  //     code: 2,
  //     time: 365,
  //   )
  // ]);

  getPlans() async {
    plans.clear();
    RealmResults<Packages> response = PlansService().getPlans();
    plans.addAll(response.map((e) => e).toList());
    plans.refresh();
    // plans.forEach((element) {
    //   PlansService().createPackage(element);
    // });
  }
}
