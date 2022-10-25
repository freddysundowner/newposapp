// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutterpos/controllers/shop_controller.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../controllers/AuthController.dart';
import '../../controllers/CustomerController.dart';
import '../../controllers/attendant_controller.dart';
import '../../controllers/supplierController.dart';
import '../../utils/colors.dart';
import '../../widgets/delete_dialog.dart';
import '../../widgets/edit_dialog.dart';
import '../../widgets/snackBars.dart';

class CustomerInfoPage extends StatelessWidget {
  final id;
  final user;

  CustomerInfoPage({Key? key, required this.id, required this.user})
      : super(key: key);
  CustomerController customerController = Get.find<CustomerController>();
  SupplierController supplierController = Get.find<SupplierController>();

  launchWhatsApp({required number, required message}) async {
    String url = "whatsapp://send?phone=+254${number}&text=$message";
    await canLaunch(url)
        ? launch(url)
        : showSnackBar(message: "Cannot open whatsapp", color: Colors.red);
  }

  launchMessage({required number, required message}) async {
    Uri sms = Uri.parse('sms:$number?body=$message');
    if (await launchUrl(sms)) {
      //app opened
    } else {
      //app is not opened
    }
  }

  @override
  Widget build(BuildContext context) {
    if (user == "suppliers") {
      supplierController.getSupplierById(id);
    } else {
      customerController.getCustomerById(id);
    }

    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: AppColors.mainColor,
          leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: Icon(Icons.arrow_back_ios)),
          actions: [
            IconButton(
                onPressed: () {
                  if (user == "suppliers") {
                    supplierController.assignTextFields();
                  } else {
                    customerController.assignTextFields();
                  }
                  showEditDialog(
                    user: user,
                    context: context,
                  );
                },
                icon: Icon(Icons.edit)),
            IconButton(
                onPressed: () {
                  deleteDialog(
                      context: context,
                      onPressed: () {
                        customerController.deleteCustomer(
                            context, customerController.customer.value?.id);
                      });
                },
                icon: Icon(Icons.delete)),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.4,
                color: AppColors.mainColor,
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    Center(
                      child: Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            border: Border.all(color: Colors.white, width: 2)),
                        child: Icon(
                          Icons.person,
                          color: Colors.grey,
                          size: 50,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Center(
                      child: Obx(() {
                        return Text(
                          user == "suppliers"
                              ? "${supplierController.supplier.value == null ? "" : supplierController.supplier.value?.fullName}"
                              : "${customerController.customer.value == null ? "" : customerController.customer.value?.fullName}",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        );
                      }),
                    ),
                    SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.phone,
                          color: Colors.white,
                          size: 14,
                        ),
                        Obx(() {
                          return Text(
                            user == "suppliers"
                                ? "${supplierController.supplier.value?.phoneNumber}"
                                : "${customerController.customer.value?.phoneNumber}",
                            style: TextStyle(color: Colors.white),
                          );
                        }),
                      ],
                    ),
                    SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                              onPressed: () {
                                launchMessage(
                                    number: user == "suppliers"
                                        ? "${supplierController.supplier.value?.phoneNumber}"
                                        : "${customerController.customer.value?.phoneNumber}",
                                    message: user == "suppliers"
                                        ? "we will be paying your debt very soon"
                                        : "Aquick reminde that you owe our shop please pay your debt ");
                              },
                              icon: Icon(Icons.message),
                              color: Colors.white),
                          IconButton(
                              onPressed: () {
                                launchWhatsApp(
                                    number: user == "suppliers"
                                        ? "${supplierController.supplier.value?.phoneNumber}"
                                        : "${customerController.customer.value?.phoneNumber}",
                                    message: user == "suppliers"
                                        ? "we will be paying your debt very soon"
                                        : "Aquick reminde that you owe our shop please pay your debt ");
                              },
                              icon: Icon(Icons.whatsapp),
                              color: Colors.white),
                          IconButton(
                              onPressed: () async {
                                await launch(
                                    "tel://${user == "suppliers" ? "${supplierController.supplier.value?.phoneNumber}" : "${customerController.customer.value?.phoneNumber}"}");
                              },
                              icon: Icon(Icons.phone),
                              color: Colors.white),
                          if (user != "suppliers")
                            InkWell(
                              onTap: () {},
                              child: Container(
                                padding: EdgeInsets.only(
                                    top: 5, bottom: 5, left: 10, right: 15),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: Colors.white.withOpacity(0.2)),
                                child: Row(
                                  children: [
                                    Icon(Icons.credit_card,
                                        color: Colors.white),
                                    SizedBox(width: 10),
                                    Text(
                                      "Wallet",
                                      style: TextStyle(color: Colors.white),
                                    )
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
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
                          controller: customerController.tabController,
                          indicatorWeight: 3,
                          onTap: (index) {},
                          tabs: customerController.tabs),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        color: Colors.grey.withOpacity(0.11),
                        child: TabBarView(
                          controller: customerController.tabController,
                          children: [
                            CreditInfo(id: id, user: user),
                            Purchase(
                                customerController: customerController,
                                id: id,
                                user: user),
                            Returns(
                              id: id,
                              user: user,
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ));
  }

  showModalSheet(context) {
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
                    child: GestureDetector(
                      onTap: () {
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
                            Container(child: Text('Credit History '))
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
                            Icon(Icons.cloud_download_outlined),
                            SizedBox(
                              width: 10,
                            ),
                            Container(child: Text('Purchase History'))
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

class Purchase extends StatelessWidget {
  final customerController;
  SupplierController supplierController = Get.find<SupplierController>();
  ShopController createShopController = Get.find<ShopController>();
  final id;
  final user;

  Purchase(
      {Key? key,
      required this.customerController,
      required this.id,
      required this.user})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class Returns extends StatelessWidget {
  final id;
  final user;

  Returns({Key? key, required this.id, required this.user}) : super(key: key);
  CustomerController customerController = Get.find<CustomerController>();
  SupplierController supplierController = Get.find<SupplierController>();

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class CreditInfo extends StatelessWidget {
  final id;
  final user;

  CreditInfo({Key? key, required this.id, required this.user})
      : super(key: key);
  AttendantController attendantController = Get.find<AttendantController>();
  ShopController shopController = Get.find<ShopController>();
  AuthController authController = Get.find<AuthController>();

  SupplierController supplierController = Get.find<SupplierController>();
  CustomerController customerController = Get.find<CustomerController>();

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
