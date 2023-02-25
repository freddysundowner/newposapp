import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CashflowController extends GetxController
    with GetTickerProviderStateMixin {
  RxList cashInCategories = RxList([]);
  RxList categories = RxList([]);

  late TabController tabController;

  @override
  void onInit() {
    tabController = TabController(length: 2, vsync: this);
    super.onInit();
  }
}
