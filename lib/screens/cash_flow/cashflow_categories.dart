// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutterpos/controllers/cashflow_controller.dart';
import 'package:get/get.dart';

import '../../controllers/shop_controller.dart';
import 'components/category_card.dart';

class CashFlowCategories extends StatelessWidget {
  CashFlowCategories({Key? key}) : super(key: key);
  ShopController createShopController = Get.find<ShopController>();
  CashflowController cashflowController = Get.find<CashflowController>();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.3,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          titleSpacing: 0.0,
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
                      : "${createShopController.currentShop.value!.name!}".capitalize!,
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
                Get.back();
              },
              icon: Icon(Icons.arrow_back_ios)),
        ),
        body: Column(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                color: Colors.grey.withOpacity(0.1),
                child: TabBarView(
                  controller: cashflowController.tabController,
                  children: [CashInUi(), CashOutUi()],
                ),
              ),
            )
          ],
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 25.0, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("KES"),
                Text(
                  "${300}",
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
                Text("Cash in categories"),
                TextButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text("Add Category"),
                            content: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: TextFormField(
                                  decoration: InputDecoration(
                                      hintText:
                                          "eg.Loan,Capital,Contribution etc",
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
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
                          color: Colors.grey.withOpacity(0.2),
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
              "${3} Total",
              style: TextStyle(
                color: Colors.grey.shade600,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "TIP: Drag and drop related categories to combine them",
              style: TextStyle(
                color: Colors.grey.shade600,
              ),
            ),
          ),
          ListView.builder(
              itemCount: 20,
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return categoryCard(context);
              })
        ],
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
                                        borderRadius: BorderRadius.circular(10),
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
                          color:
                              Color.fromARGB(255, 41, 41, 41).withOpacity(0.2),
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
          ListView.builder(
              itemCount: 20,
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return categoryCard(context);
              })
        ],
      ),
    );
  }
}
