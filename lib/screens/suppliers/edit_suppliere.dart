import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Real/Models/schema.dart';
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
              Get.back();
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            )),
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 3),
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
                            color: Colors.purple, fontWeight: FontWeight.bold)))
              ],
            )
          ],
        ),
      ),
    );
  }
}
