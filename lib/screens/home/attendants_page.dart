import 'package:flutter/material.dart';
import 'package:flutterpos/controllers/shop_controller.dart';
import 'package:flutterpos/responsive/responsiveness.dart';
import 'package:flutterpos/screens/attendant/create_attendant.dart';
import 'package:flutterpos/widgets/attendant_card.dart';
import 'package:get/get.dart';

import '../../../../utils/colors.dart';
import '../../controllers/attendant_controller.dart';
import '../../models/attendant_model.dart';
import '../../widgets/smalltext.dart';

class AttendantsPage extends StatelessWidget {
  AttendantsPage({Key? key}) : super(key: key){
    attendantController.getAttendantsByShopId(
        shopId: shopController.currentShop.value?.id);
  }
  AttendantController attendantController = Get.find<AttendantController>();
  ShopController shopController = Get.find<ShopController>();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        body: ResponsiveWidget(
            largeScreen: Container(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  createAttendantWidget(),
                  Obx(() {
                    return attendantController.getAttendantsLoad.value
                        ? Center(child: CircularProgressIndicator())
                        : attendantController.attendants.length == 0
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Center(
                                    child: minorTitle(
                                      title:
                                          "This shop doesn't have attendants yet",
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              )
                            : GridView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount:
                                    attendantController.attendants.length,
                                itemBuilder: (context, index) {
                                  AttendantModel attendantModel =
                                      attendantController.attendants
                                          .elementAt(index);
                                  return attendantCard(
                                      attendantModel: attendantModel);
                                },
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        childAspectRatio: MediaQuery.of(context)
                                                .size
                                                .width *
                                            1.3 /
                                            MediaQuery.of(context).size.height,
                                        crossAxisCount: 3,
                                        crossAxisSpacing: 10,
                                        mainAxisSpacing: 10),
                              );
                  })
                ],
              ),
            ),
            smallScreen: SafeArea(
                child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    createAttendantWidget(),
                    SizedBox(height: 5),
                    Obx(() {
                      return attendantController.getAttendantsLoad.value
                          ? Center(child: CircularProgressIndicator())
                          : attendantController.attendants.length == 0
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Center(
                                      child: minorTitle(
                                        title:
                                            "This shop doesn't have attendants yet",
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                )
                              : ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount:
                                      attendantController.attendants.length,
                                  itemBuilder: (context, index) {
                                    AttendantModel attendantModel =
                                        attendantController.attendants
                                            .elementAt(index);
                                    return attendantCard(
                                        attendantModel: attendantModel);
                                  });
                    })
                  ],
                ),
              ),
            ))));
  }

  Widget createAttendantWidget() {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: InkWell(
        onTap: () {
          Get.to(() => CreateAttendant());
        },
        child: Align(
          alignment: Alignment.topRight,
          child: Container(
            padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.mainColor, width: 2),
            ),
            child: minorTitle(
                title: ""
                    "+ Add attendant",
                color: AppColors.mainColor),
          ),
        ),
      ),
    );
  }
}
