import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pointify/controllers/home_controller.dart';
import 'package:pointify/controllers/shop_controller.dart';
import 'package:pointify/functions/functions.dart';
import 'package:pointify/responsive/responsiveness.dart';
import 'package:pointify/screens/customers/customer_info_page.dart';
import 'package:pointify/screens/sales/create_sale.dart';
import 'package:pointify/utils/helper.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../Real/schema.dart';
import '../../controllers/CustomerController.dart';
import '../../controllers/user_controller.dart';
import '../../controllers/wallet_controller.dart';
import '../../utils/colors.dart';
import 'components/deposit_dialog.dart';
import 'components/wallet_card.dart';

class WalletPage extends StatelessWidget {
  final CustomerModel customerModel;
  final String? page;

  WalletPage({Key? key, required this.customerModel, this.page})
      : super(key: key) {
    walletController.initialPage.value = 0;
    customersController.customer.value = null;
    customersController.getCustomerById(customerModel);
    walletController.getWallet(customerModel, "deposit");
  }

  WalletController walletController = Get.find<WalletController>();
  CustomerController customersController = Get.find<CustomerController>();
  UserController userController = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
        largeScreen: Obx(() {
          return Scaffold(
            appBar: _appBar(context, "large"),
            body: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  walletBalanceContainer(context, "large"),
                  tabsPage(context)
                ],
              ),
            ),
          );
        }),
        smallScreen: Obx(() => Helper(
              appBar: _appBar(context, "small"),
              widget: SingleChildScrollView(
                child: Column(children: [
                  walletBalanceContainer(context, "small"),
                  tabsPage(context)
                ]),
              ),
            )));
  }

  Widget tabsPage(context) {
    return Obx(() => DefaultTabController(
          length: 2,
          initialIndex: walletController.initialPage.value,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.9,
            child: Column(
              children: [
                Container(
                  color: Colors.white,
                  width: double.infinity,
                  height: kToolbarHeight,
                  child: TabBar(
                      unselectedLabelColor: Colors.grey,
                      labelColor: Colors.purple,
                      indicatorColor: Colors.purple,
                      indicatorWeight: 3,
                      onTap: (index) {
                        if (index == 0) {
                          walletController.getWallet(customerModel, "deposit");
                        } else {
                          walletController.getWallet(customerModel, "usage");
                        }
                      },
                      tabs: const [
                        Tab(text: "Deposit"),
                        Tab(text: "Usage"),
                      ]),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    color: Colors.grey.withOpacity(0.1),
                    child: TabBarView(
                      controller: walletController.tabController,
                      children: [
                        DepositHistory(
                          uid: customerModel.id,
                          type: "deposit",
                        ),
                        DepositHistory(
                          uid: customerModel.id,
                          type: "usage",
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }

  Widget walletBalanceContainer(context, type) {
    return Container(
      color: type == "large" ? Colors.white : AppColors.mainColor,
      height: MediaQuery.of(context).size.height * 0.2,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: type == "largr"
            ? MainAxisAlignment.start
            : MainAxisAlignment.center,
        children: [
          Text(
            "Wallet Ballance",
            style: TextStyle(
                color: type == "small" ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          Obx(
            () => Text(
              htmlPrice(customersController.customer.value?.walletBalance ?? 0)
                  .toUpperCase(),
              style: TextStyle(
                  color: type == "small" ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 10),
          if (checkPermission(category: "customers", permission: "deposit"))
            InkWell(
              onTap: () {
                showDepositDialog(
                    context: context,
                    customerModel: customerModel,
                    title: "Deposit",
                    page: page,
                    size: MediaQuery.of(context).size.width <= 600
                        ? "small"
                        : "large");
              },
              child: Container(
                padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color:
                        type == "large" ? AppColors.mainColor : Colors.white),
                child: Text(
                  "Make Deposit",
                  style: TextStyle(
                      color: type == "large" ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold),
                ),
              ),
            )
        ],
      ),
    );
  }

  AppBar _appBar(context, type) {
    return AppBar(
      elevation: 0.2,
      backgroundColor: type == "small" ? AppColors.mainColor : Colors.white,
      leading: IconButton(
          onPressed: () {
            if (page != null && page == "makesale") {
              if (MediaQuery.of(Get.context!).size.width > 600) {
                Get.find<HomeController>().selectedWidget.value = CreateSale();
              } else {
                Get.back();
              }
            } else if (type == "large") {
              Get.find<HomeController>().selectedWidget.value =
                  CustomerInfoPage(
                customerModel: customerModel,
              );
            } else {
              Get.back();
            }
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: type == "small" ? Colors.white : Colors.black,
          )),
      title: Text(
        "${customerModel.fullName}".capitalize!,
        style: TextStyle(color: type == "small" ? Colors.white : Colors.black),
      ),
      centerTitle: false,
      actions: [
        if (userController.user.value?.usertype == "admin")
          IconButton(
              onPressed: () {
                showModalSheet(
                    context, customerModel.fullName, customerModel.id);
              },
              icon: Icon(Icons.download,
                  color: type == "small" ? Colors.white : Colors.black))
      ],
    );
  }

  showModalSheet(context, title, uid) {
    WalletController walletController = Get.find<WalletController>();
    ShopController shopController = Get.find<ShopController>();
    return showModalBottomSheet<void>(
        backgroundColor:
            isSmallScreen(context) ? Colors.white : Colors.transparent,
        context: context,
        builder: (BuildContext context) {
          return Container(
              height: 200,
              color: Colors.white,
              margin: EdgeInsets.only(
                  left: isSmallScreen(context)
                      ? 0
                      : MediaQuery.of(context).size.width * 0.2),
              child: Center(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      padding: EdgeInsets.all(10),
                      width: double.infinity,
                      color: Colors.grey.withOpacity(0.7),
                      child: Text('Select Download Option')),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () async {
                        Navigator.pop(context);
                        walletController.initialPage.value = 0;
                      },
                      child: Container(
                        width: double.infinity,
                        child: Row(
                          children: [
                            Icon(Icons.arrow_downward),
                            SizedBox(
                              width: 10,
                            ),
                            Container(child: Text('Deposit History '))
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () async {
                        Navigator.pop(context);
                        walletController.initialPage.value = 1;
                        // WalletPdf(
                        //     shop: shopController.currentShop.value!.name!,
                        //     deposits: walletController.deposits,
                        //     type: "usage");
                      },
                      child: Container(
                        width: double.infinity,
                        child: Row(
                          children: [
                            Icon(Icons.cloud_download_outlined),
                            SizedBox(
                              width: 10,
                            ),
                            Container(child: Text('Usage History'))
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: double.infinity,
                        child: Row(
                          children: [
                            Icon(Icons.clear),
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                                child: Text(
                              'Cancel',
                              style: TextStyle(color: Colors.red),
                            ))
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              )));
        });
  }
}

class DepositHistory extends StatelessWidget {
  final uid;
  final type;

  DepositHistory({Key? key, required this.uid, required this.type})
      : super(key: key);
  WalletController walletController = Get.find<WalletController>();
  ShopController shopController = Get.find<ShopController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return walletController.gettingWalletLoad.value
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : walletController.deposits.isEmpty
              ? const Center(
                  child: Text("No Entries found"),
                )
              : MediaQuery.of(context).size.width > 600
                  ? SingleChildScrollView(
                      child: Container(
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
                            columnSpacing: 30.0,
                            columns: [
                              DataColumn(
                                  label: Text('Receipt Number',
                                      textAlign: TextAlign.center)),
                              DataColumn(
                                  label: Text(
                                      'Amount(${shopController.currentShop.value?.currency})',
                                      textAlign: TextAlign.center)),
                              DataColumn(
                                  label: Text('Date',
                                      textAlign: TextAlign.center)),
                            ],
                            rows: List.generate(
                                walletController.deposits.length, (index) {
                              DepositModel depositModel =
                                  walletController.deposits.elementAt(index);
                              final y = depositModel.recieptNumber;
                              final x = depositModel.amount.toString();
                              final w = depositModel.createdAt!;

                              return DataRow(cells: [
                                DataCell(Container(width: 75, child: Text(y!))),
                                DataCell(Container(width: 75, child: Text(x))),
                                DataCell(Container(
                                    child: Text(
                                        DateFormat("yyyy-dd-MMM hh:mm a")
                                            .format(w)))),
                              ]);
                            }),
                          ),
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: walletController.deposits.length,
                      shrinkWrap: true,
                      physics: const ScrollPhysics(),
                      itemBuilder: (context, index) {
                        DepositModel depositModel =
                            walletController.deposits.elementAt(index);
                        return WalletUsageCard(
                            context: context,
                            uid: uid,
                            depositBody: depositModel);
                      });
    });
  }
}
