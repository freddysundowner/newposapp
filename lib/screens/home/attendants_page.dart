import 'package:flutter/material.dart';
import 'package:pointify/controllers/home_controller.dart';
import 'package:pointify/controllers/shop_controller.dart';
import 'package:pointify/responsive/responsiveness.dart';
import 'package:pointify/screens/attendant/create_attendant.dart';
import 'package:pointify/widgets/attendant_card.dart';
import 'package:pointify/widgets/no_items_found.dart';
import 'package:get/get.dart';

import '../../../../utils/colors.dart';
import '../../controllers/attendant_controller.dart';
import '../../models/attendant_model.dart';
import '../../widgets/smalltext.dart';
import '../attendant/attendant_details.dart';

class AttendantsPage extends StatelessWidget {
  AttendantController attendantController = Get.find<AttendantController>();
  ShopController shopController = Get.find<ShopController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ResponsiveWidget(
            largeScreen: Container(
              padding: EdgeInsets.all(10),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    createAttendantWidget(context),
                    Obx(() {
                      return attendantController.getAttendantsLoad.value
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : attendantController.attendants.isEmpty
                              ? noItemsFound(context, true)
                              : Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 10),
                                  width: double.infinity,
                                  child: Theme(
                                    data: Theme.of(context)
                                        .copyWith(dividerColor: Colors.grey),
                                    child: DataTable(
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                        width: 1,
                                        color: Colors.black,
                                      )),
                                      columnSpacing: 30.0,
                                      columns: const [
                                        DataColumn(
                                            label: Text('Name',
                                                textAlign: TextAlign.center)),
                                        DataColumn(
                                            label: Text('Location',
                                                textAlign: TextAlign.center)),
                                        DataColumn(
                                            label: Text('',
                                                textAlign: TextAlign.center)),
                                      ],
                                      rows: List.generate(
                                          attendantController.attendants.length,
                                          (index) {
                                        AttendantModel attendantModel =
                                            attendantController.attendants
                                                .elementAt(index);
                                        final y = attendantModel.fullnames;
                                        final x = attendantModel.attendid;

                                        return DataRow(cells: [
                                          DataCell(Container(child: Text(y!))),
                                          DataCell(Container(
                                              child: Text(x.toString()))),
                                          DataCell(
                                            InkWell(
                                              onTap: () {
                                                Get.find<HomeController>()
                                                        .selectedWidget
                                                        .value =
                                                    AttendantDetails(
                                                        attendantModel:
                                                            attendantModel);
                                              },
                                              child: Align(
                                                child: Center(
                                                  child: Container(
                                                    padding: EdgeInsets.all(5),
                                                    margin: EdgeInsets.all(5),
                                                    decoration: BoxDecoration(
                                                        color:
                                                            AppColors.mainColor,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(3)),
                                                    width: 75,
                                                    child: Text(
                                                      "Edit",
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ),
                                                ),
                                                alignment: Alignment.topRight,
                                              ),
                                            ),
                                          ),
                                        ]);
                                      }),
                                    ),
                                  ),
                                );
                    })
                  ],
                ),
              ),
            ),
            smallScreen: SafeArea(
                child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    createAttendantWidget(context),
                    SizedBox(height: 5),
                    Obx(() {
                      return attendantController.getAttendantsLoad.value
                          ? const Center(child: CircularProgressIndicator())
                          : attendantController.attendants.length == 0
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Center(
                                      child: minorTitle(
                                        title: "No attendants",
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                )
                              : ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
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

  Widget createAttendantWidget(context) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: InkWell(
        onTap: () {
          if (MediaQuery.of(context).size.width > 600) {
            Get.find<HomeController>().selectedWidget.value = CreateAttendant();
          } else {
            Get.to(() => CreateAttendant());
          }
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
