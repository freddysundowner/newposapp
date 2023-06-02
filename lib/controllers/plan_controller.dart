import 'package:get/get.dart';
import 'package:pointify/services/plans_service.dart';

import '../Real/Models/schema.dart';

class PlanController extends GetxController {
  RxList<Plan> plans = RxList([]);

  getPlans() async {
    var response = await PlansService.getPlans();
    List plansList = response["body"];
    plans.value = []; //plansList.map((e) => Plan.fromJson(e)).toList();
  }
}
