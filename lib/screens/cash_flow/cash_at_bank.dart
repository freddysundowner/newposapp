import 'package:flutter/material.dart';
import 'package:flutterpos/controllers/cashflow_controller.dart';
import 'package:flutterpos/models/bank_model.dart';
import 'package:flutterpos/utils/helper.dart';
import 'package:get/get.dart';

import '../../controllers/shop_controller.dart';
import '../../utils/colors.dart';
import '../../widgets/delete_dialog.dart';
import 'bank_history.dart';

class CashAtBank extends StatelessWidget {
  CashAtBank({Key? key}) : super(key: key) {
    cashflowController
        .fetchCashAtBank(createShopController.currentShop.value?.id);
  }

  ShopController createShopController = Get.find<ShopController>();
  CashflowController cashflowController = Get.find<CashflowController>();

  @override
  Widget build(BuildContext context) {
    return Helper(
      widget: Obx(() {
        return cashflowController.loadingCashAtBank.value
            ? ListView.builder(
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      padding: EdgeInsets.all(15),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadiusDirectional.circular(8),
                        color: Colors.white,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,
                            height: 4,
                            color: Colors.grey.withOpacity(0.3),
                          ),
                          SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(),
                                  SizedBox(width: 2),
                                  Container(
                                      width: 50,
                                      height: 4,
                                      color: Colors.grey.withOpacity(0.3)),
                                ],
                              ),
                              Icon(Icons.credit_card, color: Colors.grey)
                            ],
                          ),
                          SizedBox(height: 4),
                          Container(
                              width: 100,
                              height: 4,
                              color: Colors.grey.withOpacity(0.3)),
                          SizedBox(height: 10),
                          Divider(
                            thickness: 0.5,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                  width: 100,
                                  height: 4,
                                  color: Colors.grey.withOpacity(0.3)),
                              Container(
                                  width: 20,
                                  height: 4,
                                  color: Colors.grey.withOpacity(0.3)),
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                },
                itemCount: 5,
              )
            : ListView.builder(
                itemCount: cashflowController.cashAtBanks.length,
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  BankModel bankModel =
                      cashflowController.cashAtBanks.elementAt(index);
                  return bankCard(context, bankModel: bankModel);
                });
      }),
      appBar: AppBar(
        elevation: 0.3,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        titleSpacing: 0.0,
        iconTheme: IconThemeData(color: Colors.black),
        titleTextStyle: TextStyle(color: Colors.black),
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(
            Icons.arrow_back_ios,
          ),
        ),
        title: Text("Cash At Bank",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            )),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          padding: EdgeInsets.all(10),
          height: kToolbarHeight,
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Totals",
                style: TextStyle(color: Colors.black),
              ),
              Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(20)),
                child: Text("KES ${0}"),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget bankCard(BuildContext context, {required BankModel bankModel}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: EdgeInsets.all(15),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadiusDirectional.circular(8),
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              bankModel.name ?? "",
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text("KES"),
                    SizedBox(width: 2),
                    Text(
                      "${bankModel.amount ?? 0}",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Icon(Icons.credit_card, color: Colors.grey)
              ],
            ),
            SizedBox(height: 4),
            Text(
              "**** **** **** ****",
              style: TextStyle(color: Colors.black),
            ),
            SizedBox(height: 10),
            Divider(
              thickness: 0.5,
              color: Colors.grey,
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    Get.to(() => CashHistory(
                        title: "Faulu", subtitle: "All records", id: "1230"));
                  },
                  child: Text(
                    "View History",
                    style: TextStyle(color: AppColors.mainColor),
                  ),
                ),
                IconButton(
                    onPressed: () {
                      showBottomSheet(context);
                    },
                    icon: Icon(Icons.more_vert, color: Colors.grey)),
              ],
            )
          ],
        ),
      ),
    );
  }

  showBottomSheet(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (_) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.3,
            child: Column(
              children: [
                Container(
                  color: AppColors.mainColor.withOpacity(0.1),
                  width: double.infinity,
                  child: ListTile(
                    title: Text("Manage Bank"),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.edit),
                  onTap: () {
                    Get.back();
                    showDialog(
                        context: context,
                        builder: (_) {
                          return Dialog(
                            child: Container(
                              padding: EdgeInsets.only(
                                  left: 15, right: 15, top: 10, bottom: 3),
                              height: MediaQuery.of(context).size.height * 0.2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Edit Bank"),
                                  Spacer(),
                                  TextFormField(
                                    decoration: InputDecoration(
                                        contentPadding: EdgeInsets.all(10),
                                        fillColor: Colors.white,
                                        filled: true,
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            borderSide: BorderSide(
                                                color: Colors.grey,
                                                width: 0.5)),
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            borderSide: BorderSide(
                                                color: Colors.grey,
                                                width: 0.5))),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      TextButton(
                                          onPressed: () {
                                            Get.back();
                                          },
                                          child: Text(
                                            "Cancel".toUpperCase(),
                                            style: TextStyle(
                                                color: AppColors.mainColor),
                                          )),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      TextButton(
                                          onPressed: () {
                                            Get.back();
                                          },
                                          child: Text(
                                            "Save".toUpperCase(),
                                            style: TextStyle(
                                                color: AppColors.mainColor),
                                          )),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        });
                  },
                  title: Text("Edit"),
                ),
                ListTile(
                  leading: Icon(Icons.delete),
                  onTap: () {
                    Get.back();
                    deleteDialog(context: context, onPressed: () {});
                  },
                  title: Text("Delete"),
                ),
                ListTile(
                  leading: Icon(
                    Icons.clear,
                    color: Colors.red,
                  ),
                  onTap: () {
                    Get.back();
                  },
                  title: Text("Cancel "),
                ),
              ],
            ),
          );
        });
  }
}
