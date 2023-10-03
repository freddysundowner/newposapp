import 'package:get/get.dart';
import 'package:pointify/services/plans_service.dart';
import 'package:realm/realm.dart';

import '../Real/schema.dart';

class PlanController extends GetxController {
  RxList<Packages> plans = RxList([]);

  getPlans() async {
    plans.clear();
    RealmResults<Packages> response = PlansService().getPlans();
    plans.addAll(response.map((e) => e).toList());
    plans.refresh();
  }
}
