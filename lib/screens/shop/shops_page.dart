import 'package:flutter/material.dart';
import 'package:pointify/controllers/home_controller.dart';
import 'package:pointify/controllers/shop_controller.dart';
import 'package:pointify/responsive/responsiveness.dart';
import 'package:pointify/screens/shop/create_shop.dart';
import 'package:pointify/widgets/no_items_found.dart';
import 'package:get/get.dart';

import '../../Real/Models/schema.dart';
import '../../controllers/AuthController.dart';
import '../../utils/colors.dart';
import '../../widgets/shop_card.dart';
import '../../widgets/smalltext.dart';
import 'shop_details.dart';

class ShopsPage extends StatelessWidget {
  ShopController shopController = Get.find<ShopController>();
  AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: ResponsiveWidget(
        largeScreen: Obx(() => Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          child: searchWidget(),
                          flex: 3,
                        ),
                        Spacer(),
                        createShopContainer(context),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  shopController.gettingShopsLoad.value
                      ? loadingWidget(context)
                      : shopController.allShops.isEmpty
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
                                      shopController.allShops.length, (index) {
                                    Shop shopModel = shopController.allShops
                                        .elementAt(index);
                                    final y = shopModel.name;
                                    final x = shopModel.location;
                                    // final z = shopModel.category;

                                    return DataRow(cells: [
                                      DataCell(Container(child: Text(y!))),
                                      DataCell(
                                          Container(child: Text(x.toString()))),
                                      // DataCell(
                                      //     Container(child: Text(z.toString()))),
                                      DataCell(
                                        InkWell(
                                          onTap: () {
                                            Get.find<HomeController>()
                                                    .selectedWidget
                                                    .value =
                                                ShopDetails(
                                                    shopModel: shopModel);
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
                            ),
                ],
              ),
            )),
        smallScreen: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(3.0),
              child: Align(
                alignment: Alignment.centerRight,
                child: createShopContainer(context),
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: searchWidget(),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Obx(() {
              return shopController.gettingShopsLoad.value
                  ? loadingWidget(context)
                  : shopController.allShops.length == 0
                      ? noItemsFound(context, true)
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: shopController.allShops.length,
                          itemBuilder: (context, index) {
                            Shop shopModel =
                                shopController.allShops.elementAt(index);
                            return shopCard(
                                shopModel: shopModel,
                                page: "shop",
                                context: context);
                          });
            })
          ],
        ),
      ),
    ));
  }

  Widget createShopContainer(context) {
    HomeController homeController = Get.find<HomeController>();
    return InkWell(
      onTap: () {
        if (MediaQuery.of(context).size.width > 600) {
          homeController.selectedWidget.value = CreateShop(page: "shop");
        } else {
          Get.to(CreateShop(
            page: "shop",
          ));
        }
      },
      child: Container(
        padding: ResponsiveWidget.isSmallScreen(context)
            ? EdgeInsets.symmetric(horizontal: 10, vertical: 2)
            : EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: ResponsiveWidget.isSmallScreen(context)
              ? Colors.white
              : AppColors.mainColor,
          borderRadius: ResponsiveWidget.isSmallScreen(context)
              ? BorderRadius.circular(10)
              : BorderRadius.circular(8),
          border: Border.all(color: AppColors.mainColor, width: 2),
        ),
        child: minorTitle(
            title: "+ Add Shop",
            color: ResponsiveWidget.isSmallScreen(context)
                ? AppColors.mainColor
                : Colors.white),
      ),
    );
  }

  Widget searchWidget() {
    return TextFormField(
      controller: shopController.searchController,
      onChanged: (value) {
        shopController.getShops(name: value);
      },
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(10, 5, 10, 5),
        suffixIcon: IconButton(
          onPressed: () {
            if (shopController.searchController.text == "") {
            } else {
              shopController.getShops(
                  name: shopController.searchController.text);
            }
          },
          icon: Icon(Icons.search),
        ),
        hintText: "Search Shop",
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              10,
            ),
            borderSide: BorderSide(color: Colors.grey, width: 1)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey, width: 1)),
      ),
    );
  }

  Widget loadingWidget(context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.4,
        ),
        Center(child: CircularProgressIndicator()),
      ],
    );
  }
}
