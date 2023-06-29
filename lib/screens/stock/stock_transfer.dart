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
              if (isSmallScreen(context)) {
                Get.back();
              } else {
                Get.find<HomeController>().selectedWidget.value = StockPage();
              }
            },
            icon: const Icon(
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
                  margin: const EdgeInsets.all(5),
                  padding: const EdgeInsets.all(10),
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
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(10),
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
                  padding: const EdgeInsets.all(10),
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
                                  const EdgeInsets.fromLTRB(10, 3, 10, 3),
                              suffixIcon: IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.search),
                              ),
                              hintText: "Search Shop to transfer to",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10))),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
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
                          : isSmallScreen(context)
                              ? ListView.builder(
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
                                            shopController
                                                .currentShop.value!.id)
                                        .toList();
                                    Shop shopModel = shops.elementAt(index);
                                    return shopCard(
                                        shopModel: shopModel,
                                        page: "stockTransfer",
                                        context: context);
                                  })
                              : Theme(
                                  data: Theme.of(context)
                                      .copyWith(dividerColor: Colors.grey),
                                  child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
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
                                            label: Text('Type',
                                                textAlign: TextAlign.center)),
                                        DataColumn(
                                            label: Text('',
                                                textAlign: TextAlign.center)),
                                      ],
                                      rows: List.generate(
                                          shopController.allShops
                                              .where((element) =>
                                                  element.id !=
                                                  shopController
                                                      .currentShop.value!.id)
                                              .length, (index) {
                                        List<Shop> shops = shopController
                                            .allShops
                                            .where((element) =>
                                                element.id !=
                                                shopController
                                                    .currentShop.value!.id)
                                            .toList();
                                        Shop shopModel =
                                            shops.elementAt(index);
                                        final y = shopModel.name;
                                        final x = shopModel.location;
                                        final z = shopModel.type?.title;

                                        return DataRow(cells: [
                                          DataCell(Text(y!)),
                                          DataCell(Text(x.toString())),
                                          DataCell(Text(z.toString())),
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
                                                    padding:
                                                        const EdgeInsets.all(
                                                            5),
                                                    margin:
                                                        const EdgeInsets.all(
                                                            5),
                                                    decoration: BoxDecoration(
                                                        color: AppColors
                                                            .mainColor,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(3)),
                                                    width: 75,
                                                    child: const Text(
                                                      "Select",
                                                      style: TextStyle(
                                                          color:
                                                              Colors.white),
                                                      textAlign:
                                                          TextAlign.center,
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
        ));
  }
}
