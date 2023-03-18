// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutterpos/controllers/cashflow_controller.dart';
import 'package:flutterpos/responsive/responsiveness.dart';
import 'package:flutterpos/screens/cash_flow/cash_flow_manager.dart';
import 'package:flutterpos/screens/cash_flow/components/cashflow_category_dialog.dart';
import 'package:flutterpos/utils/helper.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../controllers/home_controller.dart';
import '../../controllers/shop_controller.dart';
import 'components/category_card.dart';

class CashFlowCategories extends StatelessWidget {
  CashFlowCategories({Key? key}) : super(key: key);
  ShopController createShopController = Get.find<ShopController>();
  CashflowController cashflowController = Get.find<CashflowController>();

  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
      largeScreen: _tabLayout(context),
      smallScreen: _tabLayout(context),
    );
  }

  Widget _tabLayout(context) {
    return DefaultTabController(
      length: 2,
      child: Helper(
        widget: Column(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                color: MediaQuery.of(context).size.width > 600
                    ? Colors.white
                    : Colors.grey.withOpacity(0.1),
                child: TabBarView(
                  controller: cashflowController.tabController,
                  children: [CashInUi(), CashOutUi()],
                ),
              ),
            )
          ],
        ),
        appBar: AppBar(
          elevation: 0.3,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          titleSpacing: 0.0,
          centerTitle: false,
          iconTheme: IconThemeData(color: Colors.black),
          titleTextStyle: TextStyle(color: Colors.black),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Cashflow Category",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  )),
              Obx(() {
                return Text(
                  createShopController.currentShop.value == null
                      ? ""
                      : "${createShopController.currentShop.value!.name!}"
                          .capitalize!,
                  style: TextStyle(
                    fontSize: 12,
                  ),
                );
              })
            ],
          ),
          bottom: TabBar(
            indicatorColor: Theme.of(context).primaryColor,
            indicatorWeight: 3,
            controller: cashflowController.tabController,
            labelColor: Theme.of(context).primaryColor,
            unselectedLabelColor: Colors.grey,
            onTap: (index) {},
            tabs: [
              Tab(
                text: "CashIn",
              ),
              Tab(
                text: "CashOut",
              )
            ],
          ),
          leading: IconButton(
              onPressed: () {
                if (MediaQuery.of(context).size.width > 600) {
                  Get.find<HomeController>().selectedWidget.value =
                      CashFlowManager();
                } else {
                  Get.back();
                }
              },
              icon: Icon(Icons.arrow_back_ios)),
        ),
      ),
    );
  }

  Widget categoryCard() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          // if (categoryBody.name == "Bank") {
          //   Get.to(() => CashAtBank());
          // }
        },
        child: Container(
          padding: EdgeInsets.all(10),
          width: double.infinity,
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(width: 1, color: Colors.black),
              borderRadius: BorderRadius.circular(8)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.account_balance_wallet,
                color: Colors.grey,
              ),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Apple",
                    style: TextStyle(color: Colors.black),
                  ),
                  SizedBox(height: 3),
                  Text(
                    "${200}",
                    style: TextStyle(color: Colors.black),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CashInUi extends StatelessWidget {
  ShopController createShopController = Get.find<ShopController>();
  CashflowController cashflowController = Get.find<CashflowController>();

  CashInUi({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints:
            BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 25.0, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("KES "),
                  Text(
                    "${700}",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Cash out categories"),
                  TextButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text("Add Category"),
                              content: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                    decoration: InputDecoration(
                                        hintText: "eg.Personaal use etc",
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ))),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    "Cancel".toUpperCase(),
                                    style: TextStyle(color: Colors.blue),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    "Save now".toUpperCase(),
                                    style: TextStyle(color: Colors.blue),
                                  ),
                                ),
                              ],
                            );
                          });
                    },
                    child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: Color.fromARGB(255, 41, 41, 41)
                                .withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10)),
                        child: Text(
                          "+ Add",
                          style: TextStyle(color: Colors.green),
                        )),
                  ),
                ],
              ),
            ),
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "${30} Total",
                  style: TextStyle(
                    color: Colors.grey.shade600,
                  ),
                )),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "TIP: Drag and drop related categories to combine them",
                style: TextStyle(
                  color: Colors.grey.shade600,
                ),
              ),
            ),
            MediaQuery.of(context).size.width > 600
                ? Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                    child: Theme(
                      data:
                          Theme.of(context).copyWith(dividerColor: Colors.grey),
                      child: DataTable(
                        decoration: BoxDecoration(
                            border: Border.all(
                          width: 1,
                          color: Colors.black,
                        )),
                        columnSpacing: 30.0,
                        columns: [
                          DataColumn(
                              label: Text('Name', textAlign: TextAlign.center)),
                          DataColumn(
                              label: Text(
                                  'Amount(${createShopController.currentShop.value?.currency})',
                                  textAlign: TextAlign.center)),
                          DataColumn(
                              label: Text('Date', textAlign: TextAlign.center)),
                          DataColumn(
                              label: Text('', textAlign: TextAlign.center)),
                        ],
                        rows: List.generate(5, (index) {
                          final y = "Rent";
                          final x = "200";
                          return DataRow(cells: [
                            DataCell(Container(width: 75, child: Text(y))),
                            DataCell(Container(width: 75, child: Text(x))),
                            DataCell(Container(
                                width: 75,
                                child: Text(DateFormat("MM-dd-yyyy")
                                    .format(DateTime.now())))),
                            DataCell(Align(
                              child: Container(
                                  padding: EdgeInsets.only(top: 10),
                                  width: 75,
                                  child: cashFlowCategoryDialog(context)),
                              alignment: Alignment.topRight,
                            )),
                          ]);
                        }),
                      ),
                    ),
                  )
                : Expanded(
                    child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio:
                                MediaQuery.of(context).size.width *
                                    3 /
                                    MediaQuery.of(context).size.height,
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10),
                        itemBuilder: (context, index) {
                          return categoryCard(context);
                        },
                        itemCount: 7),
                  ),
          ],
        ),
      ),
    );
  }
}

class CashOutUi extends StatelessWidget {
  ShopController shopController = Get.find<ShopController>();
  CashflowController cashflowController = Get.find<CashflowController>();

  CashOutUi({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints:
            BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 25.0, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("KES "),
                  Text(
                    "${700}",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Cash out categories"),
                  TextButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text("Add Category"),
                              content: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                    decoration: InputDecoration(
                                        hintText: "eg.Personaal use etc",
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ))),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    "Cancel".toUpperCase(),
                                    style: TextStyle(color: Colors.blue),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    "Save now".toUpperCase(),
                                    style: TextStyle(color: Colors.blue),
                                  ),
                                ),
                              ],
                            );
                          });
                    },
                    child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: Color.fromARGB(255, 41, 41, 41)
                                .withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10)),
                        child: Text(
                          "+ Add",
                          style: TextStyle(color: Colors.green),
                        )),
                  ),
                ],
              ),
            ),
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "${30} Total",
                  style: TextStyle(
                    color: Colors.grey.shade600,
                  ),
                )),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "TIP: Drag and drop related categories to combine them",
                style: TextStyle(
                  color: Colors.grey.shade600,
                ),
              ),
            ),
            MediaQuery.of(context).size.width > 600
                ? Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                    child: Theme(
                      data:
                          Theme.of(context).copyWith(dividerColor: Colors.grey),
                      child: DataTable(
                        decoration: BoxDecoration(
                            border: Border.all(
                          width: 1,
                          color: Colors.black,
                        )),
                        columnSpacing: 30.0,
                        columns: [
                          DataColumn(
                              label: Text('Name', textAlign: TextAlign.center)),
                          DataColumn(
                              label: Text(
                                  'Amount(${shopController.currentShop.value?.currency})',
                                  textAlign: TextAlign.center)),
                          DataColumn(
                              label: Text('Date', textAlign: TextAlign.center)),
                          DataColumn(
                              label: Text('', textAlign: TextAlign.center)),
                        ],
                        rows: List.generate(5, (index) {
                          final y = "Rent";
                          final x = "200";
                          return DataRow(cells: [
                            DataCell(Container(width: 75, child: Text(y))),
                            DataCell(Container(width: 75, child: Text(x))),
                            DataCell(Container(
                                width: 75,
                                child: Text(DateFormat("MM-dd-yyyy")
                                    .format(DateTime.now())))),
                            DataCell(Align(
                              child: Container(
                                  padding: EdgeInsets.only(top: 10),
                                  width: 75,
                                  child: cashFlowCategoryDialog(context)),
                              alignment: Alignment.topRight,
                            )),
                          ]);
                        }),
                      ),
                    ),
                  )
                : Expanded(
                    child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio:
                                MediaQuery.of(context).size.width *
                                    3 /
                                    MediaQuery.of(context).size.height,
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10),
                        itemBuilder: (context, index) {
                          return categoryCard(context);
                        },
                        itemCount: 7),
                  ),
          ],
        ),
      ),
    );
  }
}
