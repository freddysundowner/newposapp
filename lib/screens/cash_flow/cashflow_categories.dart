import 'package:flutter/material.dart';
import 'package:pointify/controllers/cashflow_controller.dart';
import 'package:pointify/functions/functions.dart';
import 'package:pointify/responsive/responsiveness.dart';
import 'package:pointify/screens/cash_flow/cash_flow_manager.dart';
import 'package:pointify/screens/cash_flow/components/cashflow_category_dialog.dart';
import 'package:pointify/utils/helper.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../Real/schema.dart';
import '../../controllers/home_controller.dart';
import '../../controllers/shop_controller.dart';
import '../../utils/colors.dart';
import 'cash_at_bank.dart';
import 'components/category_card.dart';

class CashFlowCategories extends StatelessWidget {
  CashFlowCategories({Key? key}) : super(key: key) {
    cashflowController.initialPage.value = 0;
    cashflowController.cashFlowCategories.clear();
    cashflowController.cashFlowCategories.refresh();
    cashflowController.initialPage.refresh();
    cashflowController.getCategory(
        "cash-in", Get.find<ShopController>().currentShop.value);
  }

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
      initialIndex: 0,
      child: Helper(
        widget: Column(
          children: [
            TabBar(
                onTap: (index) {
                  cashflowController.initialPage.value = index;
                  if (index == 0) {
                    cashflowController.getCategory("cash-in",
                        Get.find<ShopController>().currentShop.value);
                  } else {
                    cashflowController.getCategory("cash-out",
                        Get.find<ShopController>().currentShop.value);
                  }
                },
                tabs: const [
                  Tab(
                      child: Text(
                    "Cash in",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  )),
                  Tab(
                      child: Text(
                    "Cash out",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  )),
                ]),
            Expanded(
              flex: 1,
              child: Container(
                color: Colors.white,
                child: TabBarView(
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    CashInUi(
                      type: "in",
                    ),
                    CashInUi(type: "out")
                  ],
                ),
              ),
            ),
          ],
        ),
        appBar: AppBar(
          elevation: 0.3,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          titleSpacing: 0.0,
          centerTitle: false,
          iconTheme: const IconThemeData(color: Colors.black),
          titleTextStyle: const TextStyle(color: Colors.black),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Cashflow Category",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  )),
              Obx(() {
                return Text(
                  createShopController.currentShop.value == null
                      ? ""
                      : createShopController
                          .currentShop.value!.name!.capitalize!,
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                );
              })
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
              icon: const Icon(Icons.arrow_back_ios)),
        ),
      ),
    );
  }
}

class CashInUi extends StatelessWidget {
  final type;
  ShopController createShopController = Get.find<ShopController>();
  CashflowController cashflowController = Get.find<CashflowController>();

  CashInUi({Key? key, required this.type}) : super(key: key);

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
              padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 10),
              child: Obx(() {
                return Text(
                  type == "in"
                      ? htmlPrice(cashflowController.cashInflowOtherTransactions
                          .fold(
                              0,
                              (previousValue, element) =>
                                  previousValue + element.amount!))
                      : htmlPrice(
                          cashflowController.cashOutflowOtherTransactions.fold(
                                  0,
                                  (previousValue, element) =>
                                      previousValue + element.amount!) +
                              cashflowController.totalcashAtBankHistory.value),
                  style: const TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                );
              }),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Cash $type categories"),
                  TextButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text("Add Category"),
                              content: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                    controller: cashflowController
                                        .textEditingControllerCategory,
                                    decoration: InputDecoration(
                                        hintText: "eg.Personal use etc",
                                        hintStyle:
                                            const TextStyle(fontSize: 12),
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
                                    style: const TextStyle(color: Colors.blue),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    cashflowController.createCategory(
                                        type == "in" ? "cash-in" : "cash-out");
                                  },
                                  child: Text(
                                    "Save now".toUpperCase(),
                                    style: const TextStyle(color: Colors.blue),
                                  ),
                                ),
                              ],
                            );
                          });
                    },
                    child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 41, 41, 41)
                                .withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10)),
                        child: const Text(
                          "+ Add",
                          style: TextStyle(color: Colors.green),
                        )),
                  ),
                ],
              ),
            ),
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: Obx(() => Text(
                      "${cashflowController.cashFlowCategories.length} Total",
                      style: TextStyle(
                        color: Colors.grey.shade600,
                      ),
                    ))),
            Obx(() {
              return !isSmallScreen(context)
                  ? Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 10),
                      child: Theme(
                        data: Theme.of(context)
                            .copyWith(dividerColor: Colors.grey),
                        child: DataTable(
                          decoration: BoxDecoration(
                              border: Border.all(
                            width: 1,
                            color: Colors.black,
                          )),
                          columnSpacing: 20.0,
                          columns: [
                            const DataColumn(
                                label:
                                    Text('Name', textAlign: TextAlign.center)),
                            DataColumn(
                                label: Text(
                                    'Amount(${createShopController.currentShop.value?.currency})',
                                    textAlign: TextAlign.center)),
                            const DataColumn(
                                label: Text('Actions',
                                    textAlign: TextAlign.center)),
                          ],
                          rows: List.generate(
                              cashflowController.cashFlowCategories.length,
                              (index) {
                            CashFlowCategory cashflowCategory =
                                cashflowController.cashFlowCategories
                                    .elementAt(index);
                            final y = cashflowCategory.name.toString();
                            final x = cashflowCategory.amount.toString();

                            return DataRow(cells: [
                              DataCell(Text(y)),
                              DataCell(Text(x)),
                              DataCell(Align(
                                alignment: Alignment.topRight,
                                child: Container(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: y.toLowerCase() == "bank"
                                        ? InkWell(
                                      onTap: (){
                                        Get.find<HomeController>().selectedWidget.value=CashAtBank(page: "CashFlowCategories",);
                                      },
                                      child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 5),
                                          margin: const EdgeInsets.all(3),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                              BorderRadius.circular(10),
                                              color: AppColors.mainColor),
                                          child: const Text(
                                            "View",
                                            style: TextStyle(
                                                color: Colors.white),
                                          )),
                                    )
                                        : cashFlowCategoryDialog(context,
                                            cashflowCategory:
                                                cashflowCategory)),
                              )),
                            ]);
                          }),
                        ),
                      ),
                    )
                  : Expanded(
                      child: GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  childAspectRatio:
                                      MediaQuery.of(context).size.width *
                                          6 /
                                          MediaQuery.of(context).size.height,
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10),
                          itemBuilder: (context, index) {
                            CashFlowCategory cashflowCategory =
                                cashflowController.cashFlowCategories
                                    .elementAt(index);
                            return categoryCard(context,
                                cashflowCategory: cashflowCategory);
                          },
                          itemCount:
                              cashflowController.cashFlowCategories.length),
                    );
            })
          ],
        ),
      ),
    );
  }
}
