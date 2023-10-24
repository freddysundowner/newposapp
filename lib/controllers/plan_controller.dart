import 'package:get/get.dart';
import 'package:pointify/services/plans_service.dart';
import 'package:realm/realm.dart';

import '../Real/schema.dart';

class PlanController extends GetxController {
  RxList<Packages> plans = RxList([]);
  RxList<Packages> defaultPlans = RxList([
    Packages(ObjectId(),title: "Free",price: 0,description: "Trial",code: 0,time: 14)
  ]);

  getPlans() async {
    plans.clear();
    RealmResults<Packages> response = PlansService().getPlans();
    if(response.isEmpty){
      for (var element in defaultPlans) {
        PlansService().createPackage(element);
      }
      getPlans();
    }
    plans.addAll(response.map((e) => e).toList());
    plans.refresh();
  }
}
