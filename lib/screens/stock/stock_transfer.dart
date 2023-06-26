import 'package:flutter/material.dart';
import 'package:pointify/controllers/home_controller.dart';
import 'package:pointify/controllers/shop_controller.dart';
import 'package:pointify/responsive/responsiveness.dart';
import 'package:pointify/screens/stock/products_selection.dart';
import 'package:pointify/screens/stock/stock_page.dart';
import 'package:pointify/screens/stock/transfer_history.dart';
import 'package:pointify/widgets/shop_card.dart';
import 'package:get/get.dart';

import '../../Real/schema.dart';
import '../../controllers/AuthController.dart';
import '../../utils/colors.dart';
import '../../widgets/bigtext.dart';
import '../../widgets/smalltext.dart';

class StockTransfer extends StatelessWidget {
  StockTransfer({Key? key}) : super(key: key) {
    shopController.getShops();
  }

  ShopController shopController = Get.find<ShopController>();
  AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: false,
        elevation: 0.3,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            majorTitle(
                title: "Stock Transfer", color: Colors.black, size: 16.0),
            minorTitle(
                title: "${shopController.currentShop.value?.name}",
                color: Colors.grey)
          ],
        ),
        leading: IconButton(
          onPressed: () {
            if (MediaQuery.of(context).size.width > 600) {
              Get.find<HomeController>().selectedWidget.value = StockPage();
            } else {
              Get.back();
            }
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
        actions: [
          Center(
            child: InkWell(
              onTap: () {
                if (MediaQuery.of(context).size.width > 600) {
                  Get.find<HomeController>().selectedWidget.value =
                      TransferHistory();
                } else {
                  Get.to(() => TransferHistory());
                }
              },
              child: Container(
                margin: EdgeInsets.all(5),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.mainColor, width: 2)),
                child: majorTitle(
                    title: "Transfer History",
                    color: AppColors.mainColor,
                    size: 12.0),
              ),
            ),
          ),
        ],
      ),
      body: ResponsiveWidget(
          largeScreen: Container(
            padding: EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: majorTitle(
                        title: "Select Shop to transfer to",
                        color: Colors.black,
                        size: 16.0),
                  ),
                  SizedBox(height: 10),
                  Obx(() {
                    return shopController.gettingShopsLoad.value
                        ? const Align(
                            alignment: Alignment.center,
                            child: CircularProgressIndicator())
                        : shopController.allShops.isEmpty
                            ? Center(
                                child: majorTitle(
                                    title: "You do not have shop yet",
                                    color: Colors.black,
                                    size: 16.0),
                              )
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
                                    columns: [
                                      DataColumn(
                                          label: Text('Name',
                                              textAlign: TextAlign.center)),
                                      DataColumn(
                                          label: Text('Location',
                                              textAlign: TextAlign.center)),
                                      DataColumn(
                                          label: Text('Type',
                                              textAlign: TextAlign.center)),
                                      DataColumn(
                                          label: Text('',
                                              textAlign: TextAlign.center)),
                                    ],
                                    rows: List.generate(
                                        shopController.allShops.length,
                                        (index) {
                                      Shop shopModel = shopController.allShops
                                          .elementAt(index);
                                      final y = shopModel.name;
                                      final x = shopModel.location;
                                      // final z = shopModel.category;

                                      return DataRow(cells: [
                                        DataCell(Container(
                                            width: 75, child: Text(y!))),
                                        DataCell(Container(
                                            width: 75,
                                            child: Text(x.toString()))),
                                        // DataCell(Container(
                                        //     width: 75,
                                        //     child: Text(z.toString()))),
                                        DataCell(
                                          InkWell(
                                            onTap: () {
                                              Get.find<HomeController>()
                                                      .selectedWidget
                                                      .value =
                                                  ProductSelections(
                                                      toShop: shopModel);
                                            },
                                            child: Align(
                                              alignment: Alignment.topRight,
                                              child: Center(
                                                child: Container(
                                                  padding: EdgeInsets.all(5),
                                                  margin: EdgeInsets.all(5),
                                                  decoration: BoxDecoration(
                                                      color:
                                                          AppColors.mainColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              3)),
                                                  width: 75,
                                                  child: const Text(
                                                    "Select",
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
                  })
                ],
              ),
            ),
          ),
          smallScreen: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: majorTitle(
                        title: "Select Shop to transfer to",
                        color: Colors.black,
                        size: 16.0),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: shopController.searchController,
                            onChanged: (value) {
                              if (value != "") {
                                shopController.getShops();
                              }
                            },
                            decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.fromLTRB(10, 3, 10, 3),
                                suffixIcon: IconButton(
                                  onPressed: () {},
                                  icon: Icon(Icons.search),
                                ),
                                hintText: "Search Shop to transfer to",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10))),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Obx(() {
                    return shopController.gettingShopsLoad.value
                        ? const Align(
                            alignment: Alignment.center,
                            child: CircularProgressIndicator())
                        : shopController.allShops.isEmpty
                            ? Center(
                                child: majorTitle(
                                    title: "You do not have shop yet",
                                    color: Colors.black,
                                    size: 16.0),
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: shopController.allShops
                                    .where((element) =>
                                        element.id !=
                                        shopController.currentShop.value!.id)
                                    .length,
                                itemBuilder: (context, index) {
                                  List<Shop> shops = shopController.allShops
                                      .where((element) =>
                                          element.id !=
                                          shopController.currentShop.value!.id)
                                      .toList();
                                  Shop shopModel = shops.elementAt(index);
                                  return shopCard(
                                      shopModel: shopModel,
                                      page: "stockTransfer",
                                      context: context);
                                });
                  })
                ],
              ),
            ),
          )),
    );
  }
}
