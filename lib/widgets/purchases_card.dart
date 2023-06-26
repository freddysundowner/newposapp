import 'package:flutter/material.dart';
import 'package:pointify/controllers/user_controller.dart';
import 'package:pointify/controllers/purchase_controller.dart';
import 'package:pointify/functions/functions.dart';
import 'package:pointify/services/product.dart';
import 'package:pointify/widgets/alert.dart';
import 'package:pointify/widgets/smalltext.dart';
import 'package:get/get.dart';

import '../Real/schema.dart';
import '../utils/colors.dart';
import '../utils/themer.dart';
import 'bigtext.dart';
import 'normal_text.dart';

Widget purchasesItemCard({required InvoiceItem invoiceItem, required index}) {
  PurchaseController purchaseController = Get.find<PurchaseController>();
  UserController attendantController = Get.find<UserController>();
  UserController userController = Get.find<UserController>();
  TextEditingController buyingProceController = TextEditingController();
  TextEditingController sellingPriceController = TextEditingController();
  return Padding(
    padding: const EdgeInsets.all(10.0),
    child: Card(
      elevation: 4,
      child: Container(
        padding: EdgeInsets.all(8.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              majorTitle(
                  title: "${invoiceItem.product?.name}",
                  color: Colors.black,
                  size: 16.0),
              IconButton(
                color: Colors.grey,
                icon: Icon(Icons.clear),
                onPressed: () {
                  purchaseController.removeFromList(index);
                },
              )
            ],
          ),
          SizedBox(height: 3),
          Row(
            children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                majorTitle(title: "Qty", color: Colors.black54, size: 13.0),
                SizedBox(height: 5),
                minorTitle(
                    title: "${invoiceItem.product?.quantity}",
                    color: Colors.grey)
              ]),
              SizedBox(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      majorTitle(
                          title: "Unit S.Price",
                          color: Colors.black54,
                          size: 13.0),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      normalText(
                          title: htmlPrice(invoiceItem.product?.buyingPrice),
                          color: Colors.grey,
                          size: 14.0),
                      SizedBox(width: 10),
                      if (checkPermission(
                          category: "stocks", permission: "edit_price"))
                        InkWell(
                            onTap: () {
                              buyingProceController.text =
                                  invoiceItem.product!.buyingPrice!.toString();
                              sellingPriceController.text =
                                  invoiceItem.product!.selling.toString();

                              showDialog(
                                  context: Get.context!,
                                  builder: (_) {
                                    return AlertDialog(
                                      title: const Text("Edit product prices?"),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            decoration: ThemeHelper()
                                                .inputBoxDecorationShaddow(),
                                            child: TextFormField(
                                              keyboardType:
                                                  TextInputType.number,
                                              controller: buyingProceController,
                                              decoration: ThemeHelper()
                                                  .textInputDecorationDesktop(
                                                      'Buying Price',
                                                      'Enter buyinng price'),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Container(
                                            decoration: ThemeHelper()
                                                .inputBoxDecorationShaddow(),
                                            child: TextFormField(
                                              keyboardType:
                                                  TextInputType.number,
                                              controller:
                                                  sellingPriceController,
                                              decoration: ThemeHelper()
                                                  .textInputDecorationDesktop(
                                                      'Selling Price',
                                                      'Enter selling price'),
                                            ),
                                          ),
                                        ],
                                      ),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              Get.back();
                                            },
                                            child: Text(
                                              "Cancel".toUpperCase(),
                                              style: TextStyle(
                                                  color: AppColors.mainColor),
                                            )),
                                        TextButton(
                                            onPressed: () {
                                              var buyingprice = int.parse(
                                                  buyingProceController.text);
                                              var sellingprice = int.parse(
                                                  sellingPriceController.text);
                                              if (buyingprice > sellingprice) {
                                                generalAlert(
                                                    title: "Erro",
                                                    message:
                                                        "Buying price cannot be more than selling price");
                                                return;
                                              }
                                              Products().updateProductPart(
                                                  product: invoiceItem.product!,
                                                  buyingPrice: buyingprice,
                                                  sellingPrice: sellingprice);
                                              invoiceItem.price = buyingprice;

                                              Get.back();
                                              purchaseController
                                                  .calculateAmount(
                                                      index: index);
                                              purchaseController.invoice
                                                  .refresh();
                                            },
                                            child: Text(
                                              "Update".toUpperCase(),
                                              style: TextStyle(
                                                  color: AppColors.mainColor),
                                            ))
                                      ],
                                    );
                                  });
                            },
                            child: const Text(
                              "Edit Price",
                              style: TextStyle(color: Colors.red),
                            )),
                    ],
                  ),
                ],
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(children: [
                IconButton(
                    onPressed: () {
                      purchaseController.decrementItem(index);
                    },
                    icon: const Icon(Icons.remove,
                        color: Colors.black, size: 16)),
                SizedBox(
                    width: 60,
                    height: 30,
                    child: TextFormField(
                      onChanged: (value) {
                        invoiceItem.itemCount = int.parse(value);
                        purchaseController.calculateAmount(index: index);
                      },
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(10, 2, 10, 2),
                        hintText: invoiceItem.itemCount.toString(),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide:
                                BorderSide(color: Colors.grey, width: 1)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide:
                                BorderSide(color: Colors.grey, width: 1)),
                      ),
                    )),
                IconButton(
                    onPressed: () {
                      purchaseController.incrementItem(index);
                    },
                    icon: Icon(Icons.add, color: Colors.black, size: 16)),
              ]),
              normalText(
                  title: "Total=  ${htmlPrice(invoiceItem.total)}",
                  color: Colors.black,
                  size: 17.0)
            ],
          )
        ]),
      ),
    ),
  );
}
