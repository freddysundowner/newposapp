import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WalletController extends GetxController with GetTickerProviderStateMixin{
  RxBool gettingUsageLoad =RxBool(false);
  RxBool  gettingWalletLoad =RxBool(false);
  RxList usages =RxList([]);
  RxList deposits =RxList([]);

  late TabController tabController ;


  @override
  void onInit() {
    tabController=TabController(length: 2, vsync: this);
    super.onInit();
  }



}