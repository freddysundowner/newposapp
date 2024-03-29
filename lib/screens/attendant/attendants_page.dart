import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pointify/controllers/home_controller.dart';
import 'package:pointify/controllers/sales_controller.dart';
import 'package:pointify/controllers/shop_controller.dart';
import 'package:pointify/responsive/responsiveness.dart';
import 'package:pointify/screens/home/home_page.dart';
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
import '../home/home.dart';
import 'attendant_details.dart';

class AttendantsPage extends StatelessWidget {
  String? type;

  AttendantsPage({super.key, this.type});

  UserController attendantController = Get.find<UserController>();
  ShopController shopController = Get.find<ShopController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
            child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                createAttendantWidget(context),
                const Divider(),
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
                        return isSmallScreen(context)
                            ? ListView.builder(
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
                                })
                            : Container(
                                padding: const EdgeInsets.symmetric(
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
                                          label: Text('Id',
                                              textAlign: TextAlign.center)),
                                      DataColumn(
                                          label: Text('',
                                              textAlign: TextAlign.center)),
                                    ],
                                    rows:
                                        List.generate(results.length, (index) {
                                      UserModel attendantModel =
                                          results.elementAt(index);
                                      final y = attendantModel.username;
                                      final x = attendantModel.UNID;

                                      return DataRow(cells: [
                                        DataCell(Text(y!)),
                                        DataCell(Text(x.toString())),
                                        DataCell(
                                          InkWell(
                                            onTap: () {
                                              Get.find<HomeController>()
                                                      .selectedWidget
                                                      .value =
                                                  AttendantDetails(
                                                      userModel:
                                                          attendantModel);
                                            },
                                            child: Align(
                                              alignment: Alignment.topRight,
                                              child: Center(
                                                child: Container(
                                                  padding: const EdgeInsets.all(5),
                                                  margin: const EdgeInsets.all(5),
                                                  decoration: BoxDecoration(
                                                      color:
                                                          AppColors.mainColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              3)),
                                                  width: 75,
                                                  child: const Text(
                                                    "Edit",
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ]);
                                    }),
                                  ),
                                ),
                              );
                      });
                })
              ],
            ),
          ),
        )));
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
            isSmallScreen(context)
                ? Get.back()
                : Get.find<HomeController>().selectedWidget.value = HomePage();
          } else {
            if (!isSmallScreen(context)) {
              attendantController.nameController.clear();
              attendantController.passwordController.clear();
              Get.find<HomeController>().selectedWidget.value =
                  AttendantDetails(
                userModel: null,
              );
            } else {
              attendantController.nameController.clear();
              attendantController.passwordController.clear();

              Get.to(() => AttendantDetails(
                    userModel: null,
                  ));
            }
          }
        },
        child: Align(
          alignment: Alignment.topRight,
          child: Container(
            padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
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
