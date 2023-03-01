import 'package:flutter/material.dart';
import 'package:flutterpos/utils/colors.dart';
import 'package:flutterpos/widgets/delete_dialog.dart';
import 'package:get/get.dart';

import '../bank_history.dart';

Widget categoryCard(context) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: InkWell(
      onTap: () {
        actionsBottomSheet(context: context);
      },
      child: Container(
        padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 3),
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(width: 1, color: Colors.black),
            borderRadius: BorderRadius.circular(8)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.account_balance_wallet,
              color: Colors.grey,
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Name",
                  style: TextStyle(color: Colors.black),
                ),
                Text(
                  "${200}",
                  style: TextStyle(color: Colors.black),
                ),
              ],
            )
          ],
        ),
      ),
    ),
  );
}

actionsBottomSheet({required context}) {
  showModalBottomSheet(
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
                  title: Text("Select Action"),
                ),
              ),
              ListTile(
                leading: Icon(Icons.list),
                onTap: () {
                  Get.back();
                  Get.to(() => CashHistory(
                      title: "Faulu", subtitle: "All records", id: "1230"));
                },
                title: Text("View List"),
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
                                Text("Edit Category"),
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
                                              color: Colors.grey, width: 0.5)),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          borderSide: BorderSide(
                                              color: Colors.grey, width: 0.5))),
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
              )
            ],
          ),
        );
      });
}
