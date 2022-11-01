import 'package:flutter/material.dart';
import 'package:flutterpos/controllers/purchase_controller.dart';
import 'package:get/get.dart';

import '../../widgets/bigtext.dart';

class PurchaseOrderItem extends StatelessWidget {
  final id;

  PurchaseOrderItem({Key? key, required this.id}) : super(key: key);
  PurchaseController purchaseController = Get.find<PurchaseController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.3,
        titleSpacing: 0.0,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
        title: majorTitle(
            title: "Purchased Items", color: Colors.black, size: 16.0),
      ),
      body: Obx(() {
        return purchaseController.getPurchaseOrderItemLoad.value
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(itemBuilder: (context, index) {
                return Container();
              });
      }),
    );
  }
}
