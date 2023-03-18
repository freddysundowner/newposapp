import 'package:flutter/material.dart';
import 'package:flutterpos/controllers/home_controller.dart';
import 'package:flutterpos/controllers/shop_controller.dart';
import 'package:flutterpos/models/shop_model.dart';
import 'package:flutterpos/responsive/responsiveness.dart';
import 'package:flutterpos/screens/stock/products_selection.dart';
import 'package:flutterpos/screens/stock/stock_page.dart';
import 'package:flutterpos/screens/stock/transfer_history.dart';
import 'package:flutterpos/widgets/shop_card.dart';
import 'package:get/get.dart';

import '../../controllers/AuthController.dart';
import '../../utils/colors.dart';
import '../../widgets/bigtext.dart';
import '../../widgets/smalltext.dart';

class StockTransfer extends StatelessWidget {
  StockTransfer({Key? key}) : super(key: key) {
    shopController.getShopsByAdminId(
        adminId: authController.currentUser.value?.id);
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
                        ? Align(
                            alignment: Alignment.center,
                            child: CircularProgressIndicator())
                        : shopController.AdminShops.length == 0
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
                                        shopController.AdminShops.length,
                                        (index) {
                                      ShopModel shopModel =
                                          shopController.AdminShops.elementAt(
                                              index);
                                      final y = shopModel.name;
                                      final x = shopModel.location;
                                      final z = shopModel.type;

                                      return DataRow(cells: [
                                        DataCell(Container(
                                            width: 75, child: Text(y!))),
                                        DataCell(Container(
                                            width: 75,
                                            child: Text(x.toString()))),
                                        DataCell(Container(
                                            width: 75,
                                            child: Text(z.toString()))),
                                        DataCell(
                                          InkWell(
                                            onTap: () {
                                              Get.find<HomeController>()
                                                      .selectedWidget
                                                      .value =
                                                  ProductSelections(
                                                      shopModel: shopModel);
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
                                                          BorderRadius.circular(
                                                              3)),
                                                  width: 75,
                                                  child: Text(
                                                    "Select",
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
                                shopController.getShopsByAdminId(
                                    adminId:
                                        authController.currentUser.value?.id,
                                    name: value);
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
                        ? Align(
                            alignment: Alignment.center,
                            child: CircularProgressIndicator())
                        : shopController.AdminShops.length == 0
                            ? Center(
                                child: majorTitle(
                                    title: "You do not have shop yet",
                                    color: Colors.black,
                                    size: 16.0),
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: shopController.AdminShops.length,
                                itemBuilder: (context, index) {
                                  ShopModel shopModel =
                                      shopController.AdminShops.elementAt(
                                          index);
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
