import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pointify/controllers/home_controller.dart';
import 'package:pointify/controllers/sales_controller.dart';
import 'package:pointify/controllers/shop_controller.dart';
import 'package:pointify/responsive/responsiveness.dart';
import 'package:pointify/widgets/user_card.dart';
import 'package:pointify/widgets/no_items_found.dart';
import 'package:get/get.dart';
import 'package:realm/realm.dart';

import '../../../../utils/colors.dart';
import '../../Real/schema.dart';
import '../../controllers/user_controller.dart';
import '../../main.dart';
import '../../services/users.dart';
import '../../widgets/smalltext.dart';
import 'attendant_details.dart';

class AttendantsPage extends StatelessWidget {
  String? type;
  AttendantsPage({this.type});
  UserController attendantController = Get.find<UserController>();
  ShopController shopController = Get.find<ShopController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: ResponsiveWidget(
            largeScreen: Container(
              padding: EdgeInsets.all(10),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    createAttendantWidget(context),
                    Obx(() {
                      return attendantController.users.isEmpty
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
                                      attendantController.users.length,
                                      (index) {
                                    UserModel attendantModel =
                                        attendantController.users
                                            .elementAt(index);
                                    final y = attendantModel.username;

                                    return DataRow(cells: [
                                      DataCell(Container(child: Text(y!))),
                                      // DataCell(Container(
                                      //     child: Text(x.toString()))),
                                      DataCell(
                                        InkWell(
                                          onTap: () {
                                            Get.find<HomeController>()
                                                    .selectedWidget
                                                    .value =
                                                AttendantDetails(
                                                    userModel: attendantModel);
                                          },
                                          child: Align(
                                            child: Center(
                                              child: Container(
                                                padding: EdgeInsets.all(5),
                                                margin: EdgeInsets.all(5),
                                                decoration: BoxDecoration(
                                                    color: AppColors.mainColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            3)),
                                                width: 75,
                                                child: Text(
                                                  "Edit",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                  textAlign: TextAlign.center,
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
                    Divider(),
                    Obx(() {
                      return StreamBuilder<RealmResultsChanges<UserModel>>(
                          stream: Users.getAllAttendandsByShop().changes,
                          builder: (context, snapshot) {
                            final data = snapshot.data;

                            if (data == null) {
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Center(
                                    child: minorTitle(
                                      title: "No attendants",
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              );
                            }

                            final results = data.results;
                            return ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount:
                                    results.realm.isClosed ? 0 : results.length,
                                itemBuilder: (context, index) {
                                  UserModel attendantModel =
                                      results.elementAt(index);
                                  return attendantCard(
                                      userModel: attendantModel,
                                      function: type != "switch"
                                          ? null
                                          : (UserModel usermodel) {
                                              switchInit(usermodel: usermodel);
                                            });
                                });
                          });
                    })
                  ],
                ),
              ),
            ))));
  }

  void switchInit({UserModel? usermodel}) {
    userController.switcheduser.value = usermodel;

    var fromDate =
        DateTime.parse(DateFormat("yyy-MM-dd").format(DateTime.now()));
    var toDate = DateTime.parse(DateFormat("yyy-MM-dd")
        .format(DateTime.now().add(const Duration(days: 1))));
    Get.find<SalesController>()
        .getSalesByDate(fromDate: fromDate, toDate: toDate, type: "today");
    Get.back();
    userController.switcheduser.refresh();
  }

  Widget createAttendantWidget(context) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: InkWell(
        onTap: () {
          if (type == "switch") {
            userController.switcheduser.value = null;
            switchInit();
            Get.back();
          } else {
            if (MediaQuery.of(context).size.width > 600) {
              Get.find<HomeController>().selectedWidget.value =
                  AttendantDetails(
                userModel: null,
              );
            } else {
              Get.to(() => AttendantDetails(
                    userModel: null,
                  ));
            }
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
                title: type == "switch" ? "Back to Admin" : "+ Add attendant",
                color: AppColors.mainColor),
          ),
        ),
      ),
    );
  }
}
