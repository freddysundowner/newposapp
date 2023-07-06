import 'package:flutter/material.dart';
import 'package:pointify/controllers/cashflow_controller.dart';
import 'package:pointify/responsive/responsiveness.dart';
import 'package:pointify/screens/cash_flow/cash_flow_manager.dart';
import 'package:pointify/screens/cash_flow/cashflow_category_history.dart';
import 'package:pointify/utils/helper.dart';
import 'package:pointify/widgets/no_items_found.dart';
import 'package:get/get.dart';

import '../../Real/schema.dart';
import '../../controllers/home_controller.dart';
import '../../controllers/shop_controller.dart';
import '../../utils/colors.dart';
import '../../widgets/delete_dialog.dart';

class CashAtBank extends StatelessWidget {
  CashFlowCategory? cashFlowCategory;

  CashAtBank({Key? key, this.cashFlowCategory}) : super(key: key) {
    cashflowController.fetchCashAtBank();
  }

  ShopController createShopController = Get.find<ShopController>();
  CashflowController cashflowController = Get.find<CashflowController>();

  @override
  Widget build(BuildContext context) {
    return Helper(
      widget: Obx(() {
        return cashflowController.loadingCashAtBank.value
            ? ListView.builder(
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return loadingShimmer();
                },
                itemCount: 5,
              )
            : ListView.builder(
                itemCount: cashflowController.cashAtBanks.length,
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  BankModel bankModel =
                      cashflowController.cashAtBanks.elementAt(index);
                  return bankCard(context, bankModel: bankModel);
                });
      }),
      appBar: _appBar(context),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          padding: EdgeInsets.all(10),
          height: kToolbarHeight,
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Totals",
                style: TextStyle(color: Colors.black),
              ),
              Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(20)),
                child: Obx(() => Text(
                    "${createShopController.currentShop.value!.currency!}  ${cashflowController.totalcashAtBank.value}")),
              )
            ],
          ),
        ),
      ),
    );

    //   ResponsiveWidget(
    //   largeScreen: Scaffold(
    //     backgroundColor: Colors.white,
    //     appBar: _appBar(context),
    //     body: Obx(() {
    //       return cashflowController.cashAtBanks.isEmpty
    //           ? noItemsFound(context, true)
    //           : SingleChildScrollView(
    //               child: Container(
    //                 width: double.infinity,
    //                 padding:
    //                     const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
    //                 child: Theme(
    //                   data:
    //                       Theme.of(context).copyWith(dividerColor: Colors.grey),
    //                   child: DataTable(
    //                     decoration: BoxDecoration(
    //                         border: Border.all(
    //                       width: 1,
    //                       color: Colors.black,
    //                     )),
    //                     columnSpacing: 30.0,
    //                     columns: [
    //                       DataColumn(
    //                           label: Text('Name', textAlign: TextAlign.center)),
    //                       DataColumn(
    //                           label: Text(
    //                               'Amount(${createShopController.currentShop.value?.currency})',
    //                               textAlign: TextAlign.center)),
    //                       DataColumn(
    //                           label: Text('', textAlign: TextAlign.center)),
    //                     ],
    //                     rows: List.generate(
    //                         cashflowController.cashAtBanks.length, (index) {
    //                       BankModel bankModel =
    //                           cashflowController.cashAtBanks.elementAt(index);
    //                       final y = bankModel.name;
    //                       final x = bankModel.amount.toString();
    //                       return DataRow(cells: [
    //                         DataCell(Container(child: Text(y!))),
    //                         DataCell(Container(child: Text(x))),
    //                         DataCell(
    //                           Align(
    //                             child: Container(
    //                                 padding: EdgeInsets.only(top: 10),
    //                                 child: showPopUpdialog(context)),
    //                             alignment: Alignment.topRight,
    //                           ),
    //                         ),
    //                       ]);
    //                     }),
    //                   ),
    //                 ),
    //               ),
    //             );
    //     }),
    //   ),
    //   smallScreen:
    //   ,
    // );
  }

  Widget loadingShimmer() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: EdgeInsets.all(15),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadiusDirectional.circular(8),
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 4,
              color: Colors.grey.withOpacity(0.3),
            ),
            SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(),
                    SizedBox(width: 2),
                    Container(
                        width: 50,
                        height: 4,
                        color: Colors.grey.withOpacity(0.3)),
                  ],
                ),
                Icon(Icons.credit_card, color: Colors.grey)
              ],
            ),
            SizedBox(height: 4),
            Container(
                width: 100, height: 4, color: Colors.grey.withOpacity(0.3)),
            SizedBox(height: 10),
            Divider(
              thickness: 0.5,
              color: Colors.grey,
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    width: 100, height: 4, color: Colors.grey.withOpacity(0.3)),
                Container(
                    width: 20, height: 4, color: Colors.grey.withOpacity(0.3)),
              ],
            )
          ],
        ),
      ),
    );
  }

  AppBar _appBar(context) {
    return AppBar(
      elevation: 0.3,
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      titleSpacing: 0.0,
      centerTitle: false,
      iconTheme: IconThemeData(color: Colors.black),
      titleTextStyle: TextStyle(color: Colors.black),
      leading: IconButton(
        onPressed: () {
          if (MediaQuery.of(context).size.width > 600) {
            Get.find<HomeController>().selectedWidget.value = CashFlowManager();
          } else {
            Get.back();
          }
          ;
        },
        icon: Icon(
          Icons.arrow_back_ios,
        ),
      ),
      title: const Text("Cash At Bank",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          )),
    );
  }

  Widget bankCard(BuildContext context, {required BankModel bankModel}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: EdgeInsets.all(15),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadiusDirectional.circular(8),
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              bankModel.name ?? "",
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text("${createShopController.currentShop.value!.currency}"),
                    SizedBox(width: 2),
                    Text(
                      "${bankModel.amount}",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Icon(Icons.credit_card, color: Colors.grey)
              ],
            ),
            SizedBox(height: 4),
            Text(
              "**** **** **** ****",
              style: TextStyle(color: Colors.black),
            ),
            SizedBox(height: 10),
            Divider(
              thickness: 0.5,
              color: Colors.grey,
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    print(cashFlowCategory);
                    Get.to(() => CashCategoryHistory(
                          cashFlowCategory: cashFlowCategory,
                          page: "bank",
                          bank: bankModel,
                        ));
                  },
                  child: Text(
                    "View History",
                    style: TextStyle(color: AppColors.mainColor),
                  ),
                ),
                IconButton(
                    onPressed: () {
                      showBottomSheet(context);
                    },
                    icon: Icon(Icons.more_vert, color: Colors.grey)),
              ],
            )
          ],
        ),
      ),
    );
  }

  showBottomSheet(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        backgroundColor:
            isSmallScreen(context) ? Colors.white : Colors.transparent,
        builder: (_) {
          return Container(
            color: Colors.white,
            height: MediaQuery.of(context).size.height * 0.3,
            margin: EdgeInsets.only(),
            child: Column(
              children: [
                Container(
                  color: AppColors.mainColor.withOpacity(0.1),
                  width: double.infinity,
                  child: ListTile(
                    title: Text("Manage Bank"),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.edit),
                  onTap: () {
                    Get.back();
                    showDialog(
                        context: context,
                        builder: (_) {
                          return Dialog(
                            child: Container(
                              padding: EdgeInsets.only(
                                  left: 15, right: 15, top: 10, bottom: 3),
                              height: MediaQuery.of(context).size.height * 0.2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Edit Bank"),
                                  Spacer(),
                                  TextFormField(
                                    decoration: InputDecoration(
                                        contentPadding: EdgeInsets.all(10),
                                        fillColor: Colors.white,
                                        filled: true,
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            borderSide: BorderSide(
                                                color: Colors.grey,
                                                width: 0.5)),
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            borderSide: BorderSide(
                                                color: Colors.grey,
                                                width: 0.5))),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      TextButton(
                                          onPressed: () {
                                            Get.back();
                                          },
                                          child: Text(
                                            "Cancel".toUpperCase(),
                                            style: TextStyle(
                                                color: AppColors.mainColor),
                                          )),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      TextButton(
                                          onPressed: () {
                                            Get.back();
                                          },
                                          child: Text(
                                            "Save".toUpperCase(),
                                            style: TextStyle(
                                                color: AppColors.mainColor),
                                          )),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        });
                  },
                  title: Text("Edit"),
                ),
                ListTile(
                  leading: Icon(Icons.delete),
                  onTap: () {
                    Get.back();
                    deleteDialog(context: context, onPressed: () {});
                  },
                  title: Text("Delete"),
                ),
                ListTile(
                  leading: Icon(
                    Icons.clear,
                    color: Colors.red,
                  ),
                  onTap: () {
                    Get.back();
                  },
                  title: Text("Cancel "),
                ),
              ],
            ),
          );
        });
  }

  Widget showPopUpdialog(context) {
    return PopupMenuButton(
      itemBuilder: (ctx) => [
        PopupMenuItem(
          child: ListTile(
            leading: Icon(Icons.list),
            onTap: () {
              Get.back();
              Get.find<HomeController>().selectedWidget.value =
                  CashCategoryHistory(
                cashFlowCategory: cashFlowCategory,
                page: "cashflowcategory",
              );
            },
            title: Text("View List"),
          ),
        ),
        PopupMenuItem(
          child: ListTile(
            leading: Icon(Icons.edit),
            onTap: () {
              Get.back();
              showDialog(
                  context: context,
                  builder: (_) {
                    return Dialog(
                      child: Container(
                        padding: EdgeInsets.only(
                            left: 15, right: 15, top: 10, bottom: 3),
                        height: MediaQuery.of(context).size.height * 0.2,
                        width: MediaQuery.of(context).size.width * 0.2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Edit Bank"),
                            Spacer(),
                            TextFormField(
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(10),
                                  fillColor: Colors.white,
                                  filled: true,
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(
                                          color: Colors.grey, width: 0.5)),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(
                                          color: Colors.grey, width: 0.5))),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                    onPressed: () {
                                      Get.back();
                                    },
                                    child: Text(
                                      "Cancel".toUpperCase(),
                                      style:
                                          TextStyle(color: AppColors.mainColor),
                                    )),
                                SizedBox(
                                  width: 10,
                                ),
                                TextButton(
                                    onPressed: () {
                                      Get.back();
                                    },
                                    child: Text(
                                      "Save".toUpperCase(),
                                      style:
                                          TextStyle(color: AppColors.mainColor),
                                    )),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  });
            },
            title: Text("Edit"),
          ),
        ),
        PopupMenuItem(
          child: ListTile(
            leading: Icon(Icons.delete),
            onTap: () {
              Get.back();
              deleteDialog(context: context, onPressed: () {});
            },
            title: Text("Delete"),
          ),
        ),
      ],
      icon: Icon(Icons.more_vert),
    );
  }
}
