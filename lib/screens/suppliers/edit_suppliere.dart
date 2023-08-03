import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pointify/controllers/home_controller.dart';
import 'package:pointify/responsive/responsiveness.dart';
import 'package:pointify/screens/suppliers/supplier_info_page.dart';

import '../../Real/schema.dart';
import '../../controllers/supplierController.dart';

class EditSupplier extends StatelessWidget {
  final userType;
  final Supplier supplierModel;

  EditSupplier({Key? key, this.userType, required this.supplierModel}) {
    supplierController.nameController.text = supplierModel.fullName!;
  }

  SupplierController supplierController = Get.find<SupplierController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text(
          "Edit Supplier".capitalize!,
          style:
              const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        leading: IconButton(
            onPressed: () {
              if (isSmallScreen(context)) {
                Get.back();
              } else {
                Get.find<HomeController>().selectedWidget.value =
                    SupplierInfoPage(supplierModel: supplierModel);
              }
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            )),
        backgroundColor: Colors.transparent,
        actions: [
          if (!isSmallScreen(context))
            Padding(
              padding: const EdgeInsets.only(right: 8.0, top: 3),
              child: TextButton(
                  onPressed: () {
                    Get.find<HomeController>().selectedWidget.value =
                        SupplierInfoPage(supplierModel: supplierModel);
                    supplierController.updateSupplier(supplierModel);
                  },
                  child: Text("Save Changes".toUpperCase(),
                      style: const TextStyle(
                          color: Colors.purple, fontWeight: FontWeight.bold))),
            )
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(
                horizontal: isSmallScreen(context) ? 10 : 25,
                vertical: isSmallScreen(context) ? 10 : 20)
            .copyWith(bottom: 3),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: supplierController.nameController,
              decoration: InputDecoration(
                  hintText: "name",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5))),
            ),
            SizedBox(
              height: 7,
            ),
            TextFormField(
              controller: supplierController.phoneController,
              keyboardType: TextInputType.phone,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                  hintText: "phone number",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5))),
            ),
            SizedBox(
              height: 7,
            ),
            TextFormField(
              controller: supplierController.emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                  hintText: "Email",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5))),
            ),
            SizedBox(
              height: 7,
            ),
            SizedBox(
              height: 7,
            ),
            TextFormField(
              controller: supplierController.addressController,
              decoration: InputDecoration(
                  hintText: "Address",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5))),
            ),
            SizedBox(
              height: 10,
            ),
            if (isSmallScreen(context))
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Cancel".toUpperCase(),
                      style: const TextStyle(
                          color: Colors.purple, fontWeight: FontWeight.bold),
                    ),
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        supplierController.updateSupplier(supplierModel);
                      },
                      child: Text("Save Changes".toUpperCase(),
                          style: const TextStyle(
                              color: Colors.purple,
                              fontWeight: FontWeight.bold)))
                ],
              )
          ],
        ),
      ),
    );
  }
}
