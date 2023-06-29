import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:pointify/controllers/product_controller.dart';

import '../../../Real/schema.dart';
import '../../../controllers/sales_controller.dart';
import '../../../controllers/stock_transfer_controller.dart';
import '../../../services/product.dart';

class ProductCountHistory extends StatelessWidget {
  ProductCountHistory({Key? key}) : super(key: key);
  ProductController productController = Get.find<ProductController>();
  SalesController salesController = Get.find<SalesController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return productController.countHistory.isEmpty
          ? const Center(
              child: Text("There are no iems to display"),
            )
          : MediaQuery.of(context).size.width > 600
              ? SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10),
                      Theme(
                        data: Theme.of(context)
                            .copyWith(dividerColor: Colors.grey),
                        child: Container(
                          width: double.infinity,
                          margin:
                              EdgeInsets.only(right: 15, left: 15, bottom: 20),
                          // child: DataTable(
                          //   decoration: BoxDecoration(
                          //       border: Border.all(
                          //     width: 1,
                          //     color: Colors.black,
                          //   )),
                          //   columnSpacing: 30.0,
                          //   columns: [
                          //     DataColumn(
                          //         label: Text('Product',
                          //             textAlign: TextAlign.center)),
                          //     DataColumn(
                          //         label: Text('Quantity',
                          //             textAlign: TextAlign.center)),
                          //     DataColumn(
                          //         label: Text('Buying Price',
                          //             textAlign: TextAlign.center)),
                          //     DataColumn(
                          //         label: Text('Selling Price',
                          //             textAlign: TextAlign.center)),
                          //     DataColumn(
                          //         label: Text('Date',
                          //             textAlign: TextAlign.center)),
                          //   ],
                          //   // rows: List.generate(
                          //   //     productHistoryController.product.length,
                          //   //     (index) {
                          //   //   ProductHistoryModel productBody =
                          //   //       productHistoryController.product
                          //   //           .elementAt(index);
                          //   //   final y = productBody.product!.name;
                          //   //   final x = productBody.quantity;
                          //   //   final w = productBody.product!.buyingPrice;
                          //   //   final z = productBody.product!.sellingPrice![0];
                          //   //   final a = productBody.createdAt;
                          //   //
                          //   //   return DataRow(cells: [
                          //   //     DataCell(Container(width: 75, child: Text(y!))),
                          //   //     DataCell(Container(
                          //   //         width: 75, child: Text(x.toString()))),
                          //   //     DataCell(Container(
                          //   //         width: 75, child: Text(w.toString()))),
                          //   //     DataCell(Container(
                          //   //         width: 75, child: Text(z.toString()))),
                          //   //     DataCell(Container(
                          //   //         width: 75,
                          //   //         child: Text(
                          //   //             DateFormat("dd-MM-yyyy").format(a!)))),
                          //   //   ]);
                          //   // }),
                          // ),
                        ),
                      ),
                      SizedBox(height: 30)
                    ],
                  ),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: productController.countHistory.length,
                  itemBuilder: (context, index) {
                    ProductCountModel productModel =
                        productController.countHistory.elementAt(index);
                    return InkWell(
                      onTap: () {
                        var diff = productModel.quantity! -
                            productModel.initialquantity!;
                        String message = "";
                        if (diff > 0) {
                          message =
                              "Deleting this count will reduce stock balance by  $diff";
                        }
                        if (diff < 0) {
                          message =
                              "Deleting this count will increase stock balance by  ${diff}";
                        }
                        showDialog(
                            context: context,
                            builder: (_) {
                              return AlertDialog(
                                content: Text(message),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Get.back();
                                      },
                                      child: Text("Cancel")),
                                  TextButton(
                                      onPressed: () {
                                        var bal = 0;
                                        if (diff > 0) {
                                          bal = diff * -1;
                                        }
                                        if (diff < 0) {
                                          bal = diff;
                                        }
                                        print(bal);
                                        print(productModel.product!.quantity! +
                                            bal);
                                        Get.back();
                                        Products().updateProductPart(
                                          product: productModel.product!,
                                          quantity:
                                              productModel.product!.quantity! +
                                                  bal,
                                        );
                                        Products()
                                            .deleteProductCount(productModel);
                                        productController.countHistory
                                            .removeAt(index);
                                        productController.countHistory
                                            .refresh();
                                      },
                                      child: Text("Ok"))
                                ],
                              );
                            });
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        '${DateFormat("MMM dd,yyyy, hh:m a").format(productModel.createdAt!)} ',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13)),
                                    SizedBox(
                                      height: 3,
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 6, vertical: 3),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.black12),
                                      child: Text(
                                        'previously ${productModel.initialquantity}, updated to ${productModel.quantity}',
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 3,
                                    ),
                                    Text(
                                        "By~ ${productModel.attendantId?.username}")
                                  ],
                                ),
                                Spacer(),
                                Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                  size: 20,
                                )
                              ],
                            ),
                            Divider()
                          ],
                        ),
                      ),
                    );
                  });
    });
  }
}
