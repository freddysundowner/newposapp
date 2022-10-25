import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../utils/colors.dart';
import '../../controllers/CustomerController.dart';
import '../../controllers/shop_controller.dart';
import '../../controllers/supplierController.dart';
import '../../widgets/bigtext.dart';
import '../../widgets/smalltext.dart';

class CreateCustomer extends StatelessWidget {

  final type;
  CreateCustomer({Key? key, required this.type})
      : super(key: key);

  CustomerController customersController = Get.find<CustomerController>();
  SupplierController supplierController = Get.find<SupplierController>();
  ShopController shopController = Get.find<ShopController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.96),
      appBar: AppBar(
          elevation: 0.3,
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              majorTitle(
                  title: "${type} Details", color: Colors.black, size: 16.0),
              minorTitle(
                  title: shopController.currentShop.value?.name,
                  color: Colors.grey),
            ],
          )),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Container(
                padding: EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("${type} Name".capitalize!),
                        SizedBox(height: 10),
                        TextFormField(
                          controller: type == "suppliers"
                              ? supplierController.nameController
                              : customersController.nameController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              isDense: true,
                              hintStyle: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold),
                              hintText: "eg.John Doe",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              filled: true,
                              fillColor: Colors.white),
                        )
                      ],
                    ),
                    SizedBox(height: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Phone"),
                        SizedBox(height: 10),
                        TextFormField(
                          controller: type == "suppliers"
                              ? supplierController.phoneController
                              : customersController.phoneController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              isDense: true,
                              hintStyle: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold),
                              hintText: "eg.07XXXXXXXX",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              filled: true,
                              fillColor: Colors.white),
                        )
                      ],
                    ),
                    SizedBox(height: 20),
                    InkWell(
                      splashColor: Colors.transparent,
                      onTap: () {
                        if (type == "suppliers") {
                          supplierController.createSupplier(
                              shopId: shopController.currentShop.value?.id,
                              context: context);
                        } else {
                          customersController.createCustomer(
                              shopId: shopController.currentShop.value?.id,
                              context: context);
                        }
                      },
                      child: Align(
                        alignment: Alignment.center,
                        child: Center(
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width: 3, color: AppColors.mainColor),
                                borderRadius: BorderRadius.circular(40)),
                            child: Center(
                                child: majorTitle(
                                    title: "Save",
                                    color: AppColors.mainColor,
                                    size: 18.0)),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
