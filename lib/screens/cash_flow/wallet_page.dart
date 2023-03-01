import 'package:flutter/material.dart';
import 'package:flutterpos/models/deposit_model.dart';
import 'package:flutterpos/utils/helper.dart';
import 'package:get/get.dart';

import '../../controllers/CustomerController.dart';
import '../../controllers/wallet_controller.dart';
import '../../utils/colors.dart';
import 'components/deposit_dialog.dart';
import 'components/wallet_card.dart';

class WalletPage extends StatelessWidget {
  final title;
  final uid;

  WalletPage({Key? key, required this.title, required this.uid})
      : super(key: key);
  WalletController walletController = Get.find<WalletController>();
  CustomerController customersController = Get.find<CustomerController>();

  @override
  Widget build(BuildContext context) {
    customersController.getCustomerById(uid);
    walletController.getWallet(uid);
    return Obx(() => Helper(
          appBar: AppBar(
            elevation: 0.0,
            leading: IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: Icon(Icons.arrow_back_ios)),
            title: Text(title),
            actions: [
              IconButton(
                  onPressed: () {
                    showModalSheet(context, title, uid);
                  },
                  icon: Icon(Icons.download))
            ],
          ),
          widget: SingleChildScrollView(
            child: Column(children: [
              Container(
                color: AppColors.mainColor,
                height: MediaQuery.of(context).size.height * 0.3,
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Wallet Ballance",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "KES ${customersController.customer.value?.walletBalance}"
                          .toUpperCase(),
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    InkWell(
                      onTap: () {
                        showDepositDialog(
                          context: context,
                          uid: uid,
                          title: "Add a deposit",
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.white),
                        child: Text(
                          "Make Deposit",
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
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
                          controller: walletController.tabController,
                          indicatorWeight: 3,
                          onTap: (index) {
                            if (index == 0) {
                              walletController.getWallet(uid);
                            } else {}
                          },
                          tabs: [
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
                            DepositHistory(uid: uid),
                            UsageHistory(
                              uid: uid,
                              customer: title,
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              )
            ]),
          ),
        ));
  }

  showModalSheet(context, title, uid) {
    return showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return Container(
              height: 200,
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
                        // await walletController.getWalletUsage(uid);
                        // createPdf(
                        //     type: "deposit",
                        //     walletController: walletController,
                        //     attendant: Get.find<  AuthController>().currentUser.value!.name,
                        //     customer: title,
                        //     shop:Get.find<CreateShopController>().currentShop.value!.name );
                        Navigator.pop(context);
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
                        // await  walletController.getWalletUsage(uid);
                        // createPdf(
                        //     type: "usage",
                        //     walletController: walletController,
                        //     attendant: Get.find<  AuthController>().currentUser.value!.name,
                        //     customer: title,
                        //     shop:Get.find<CreateShopController>().currentShop.value!.name );
                        Navigator.pop(context);
                        Navigator.pop(context);
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

  DepositHistory({Key? key, required this.uid}) : super(key: key);
  WalletController walletController = Get.find<WalletController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return walletController.gettingWalletLoad.value
          ? Center(
              child: CircularProgressIndicator(),
            )
          : walletController.deposits.length == 0
              ? Center(
                  child: Text("No Entries found"),
                )
              : ListView.builder(
                  itemCount: walletController.deposits.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    DepositModel depositModel =
                        walletController.deposits.elementAt(index);
                    return WalletCard(
                        context: context,
                        uid: uid,
                        type: "deposit",
                        depositBody: depositModel);
                  });
    });
  }
}

class UsageHistory extends StatelessWidget {
  final uid;
  final customer;

  UsageHistory({Key? key, required this.uid, required this.customer})
      : super(key: key);
  WalletController walletController = Get.find<WalletController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return walletController.gettingUsageLoad.value
          ? Center(
              child: CircularProgressIndicator(),
            )
          : walletController.usages.length == 0
              ? Center(
                  child: Text("No Entries found"),
                )
              : ListView.builder(
                  itemCount: walletController.usages.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    DepositModel depositModel =
                        walletController.usages.elementAt(index);
                    return WalletCard(
                        context: context,
                        uid: uid,
                        type: "usage",
                        customer: customer,
                        depositBody: depositModel);
                  });
    });
  }
}
