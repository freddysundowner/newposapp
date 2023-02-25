import 'package:flutter/material.dart';
import 'package:flutterpos/controllers/shop_controller.dart';
import 'package:flutterpos/models/sales_model.dart';
import 'package:get/get.dart';

import '../../controllers/sales_controller.dart';
import '../../utils/colors.dart';
import '../../widgets/bigtext.dart';
import '../../widgets/normal_text.dart';
import '../../widgets/sold_card.dart';

class AllSalesPage extends StatelessWidget {
  AllSalesPage({Key? key}) : super(key: key);
  SalesController salesController = Get.find<SalesController>();
  ShopController shopController = Get.find<ShopController>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        salesController.getSalesByDates(
            shopId: shopController.currentShop.value?.id,
            startingDate: DateTime.now(),
            endingDate: DateTime.now(),
            type: "notcashflow");
        return true;
      },
      child: Obx(()=>DefaultTabController(
        length: salesController.tabController.length,
        initialIndex: salesController.salesInitialIndex.value,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0.3,
            titleSpacing: 0.0,
            title:
            majorTitle(title: "Sales", color: Colors.black, size: 18.0),
            leading: IconButton(
              onPressed: () {
                salesController.getSalesByDates(
                    shopId: shopController.currentShop.value?.id,
                    startingDate: DateTime.now(),
                    endingDate: DateTime.now(),
                    type: "notcashflow");
                Get.back();
              },
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              ),
            ),
            bottom: TabBar(
              indicatorColor: AppColors.mainColor,
              unselectedLabelColor: Colors.black,
              labelColor: AppColors.mainColor,
              onTap: (value) {
                salesController.salesInitialIndex.value = value;
                print(salesController.salesInitialIndex.value);
                if (value == 0) {
                  salesController.getSalesByShop(
                      id: shopController.currentShop.value?.id);
                } else if (value == 1) {
                  salesController.getSalesOnCredit(
                    shopId: shopController.currentShop.value?.id,
                  );
                } else {
                  salesController.getSalesByDates(
                      shopId: shopController.currentShop.value?.id,
                      startingDate: DateTime.now(),
                      endingDate: DateTime.now(),
                      type: "notcashflow");
                }
              },
              tabs: [
                Tab(text: 'All Sales'),
                Tab(text: 'On Credit'),
                Tab(text: 'Today'),
              ],
            ),
          ),
          body: Obx(() => TabBarView(
            controller: salesController.tabController,
            physics: NeverScrollableScrollPhysics(),
            children: [
              salesController.salesInitialIndex.value == 0
                  ? AllSales()
                  : salesController.salesInitialIndex.value == 1
                  ? SalesOnCredit()
                  : TodaySales()
            ],
          )),
        ),
      )),

    );
  }
}

class AllSales extends StatelessWidget {
  SalesController salesController = Get.find<SalesController>();
  ShopController shopController = Get.find<ShopController>();

  AllSales({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return salesController.salesByShopLoad.value
          ? Center(
              child: CircularProgressIndicator(),
            )
          : salesController.sales.length == 0
              ? Center(
                  child: normalText(
                      title: "No entries found${salesController.sales.length}",
                      color: Colors.black,
                      size: 14.0),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: salesController.sales.length,
                  itemBuilder: (context, index) {
                    SalesModel salesModel =
                        salesController.sales.elementAt(index);
                    print(salesModel.quantity);
                    return soldCard(salesModel: salesModel);
                  });
    });
  }
}

class TodaySales extends StatelessWidget {
  SalesController salesController = Get.find<SalesController>();
  ShopController createShopController = Get.find<ShopController>();

  TodaySales({Key? key}) : super(key: key) {
    salesController.getSalesByDates(
        shopId: createShopController.currentShop.value?.id,
        startingDate: DateTime.now(),
        endingDate: DateTime.now(),
        type: "notcashflow");
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return salesController.todaySalesLoad.value
          ? Center(
              child: CircularProgressIndicator(),
            )
          : salesController.sales.length == 0
              ? Center(
                  child: normalText(
                      title: "No sales made today",
                      color: Colors.black,
                      size: 14.0),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: salesController.sales.length,
                  itemBuilder: (context, index) {
                    SalesModel salesModel =
                        salesController.sales.elementAt(index);
                    return soldCard(salesModel: salesModel);
                  });
    });
  }
}

class SalesOnCredit extends StatelessWidget {
  SalesController salesController = Get.find<SalesController>();
  ShopController shopController = Get.find<ShopController>();

  SalesOnCredit({Key? key}) : super(key: key) {
    salesController.getSalesOnCredit(
      shopId: shopController.currentShop.value?.id,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return salesController.salesOnCreditLoad.value
          ? Center(
              child: CircularProgressIndicator(),
            )
          : salesController.sales.length == 0
              ? Center(
                  child: normalText(
                      title: "No sales made on credit",
                      color: Colors.black,
                      size: 14.0),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: salesController.sales.length,
                  itemBuilder: (context, index) {
                    SalesModel salesModel =
                        salesController.sales.elementAt(index);
                    return soldCard(salesModel: salesModel);
                  });
    });
  }
}
