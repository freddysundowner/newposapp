import 'package:flutter/material.dart';
import 'package:flutterpos/controllers/shop_controller.dart';
import 'package:flutterpos/screens/attendant/create_attendant.dart';
import 'package:flutterpos/widgets/attendant_card.dart';
import 'package:get/get.dart';

import '../../../../utils/colors.dart';
import '../../controllers/attendant_controller.dart';
import '../../models/attendant_model.dart';
import '../../widgets/bigtext.dart';
import '../../widgets/smalltext.dart';

class AttendantsPage extends StatelessWidget {
  AttendantsPage({Key? key}) : super(key: key);
  AttendantController attendantController = Get.find<AttendantController>();
  ShopController shopController = Get.find<ShopController>();

  @override
  Widget build(BuildContext context) {
    attendantController.getAttendantsByShopId(
        shopId: shopController.currentShop.value?.id);
    return Scaffold(
        body: SafeArea(
            child: SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                majorTitle(
                    title: "Select Shop", color: Colors.black, size: 14.0),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: InkWell(
                    onTap: () {
                      Get.to(() => CreateAttendant());
                    },
                    child: Container(
                      padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border:
                            Border.all(color: AppColors.mainColor, width: 2),
                      ),
                      child: minorTitle(
                          title: "+ Add attendant", color: AppColors.mainColor),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 5),
            InkWell(
              onTap: () async {
                showShopModalBottomSheet(context);
              },
              child: Container(
                padding: EdgeInsets.all(15),
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Obx(() {
                      return minorTitle(
                          title:
                              "${shopController.currentShop.value == null ? "" : shopController.currentShop.value?.name}",
                          color: Colors.grey);
                    }),
                    Icon(
                      Icons.arrow_drop_down,
                      color: Colors.black,
                    )
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Obx(() {
              return attendantController.getAttendantsLoad.value
                  ? Center(child: CircularProgressIndicator())
                  : attendantController.attendants.length == 0
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                              child: minorTitle(
                                title: "This shop doesn't have attendants yet",
                                color: Colors.black,
                              ),
                            ),
                          ],
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: attendantController.attendants.length,
                          itemBuilder: (context, index) {
                            AttendantModel attendantModel =
                                attendantController.attendants.elementAt(index);
                            return attendantCard(
                                attendantModel: attendantModel);
                          });
            })
          ],
        ),
      ),
    )));
  }

  showShopModalBottomSheet(context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10), topRight: Radius.circular(10)),
      ),
      builder: (context) => SingleChildScrollView(
        child: ListView.builder(
            itemCount: 3,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  Get.back();
                },
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: majorTitle(
                      title: "hello", color: Colors.black, size: 16.0),
                ),
              );
            }),
      ),
    );
  }
}
