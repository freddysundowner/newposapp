import 'package:flutter/material.dart';
import 'package:flutterpos/controllers/wallet_controller.dart';
import 'package:flutterpos/models/deposit_model.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

showDepositDialog(
    {required context,
    required uid,
    required title,
    String? page  ,
    String ?size,
    DepositModel? depositModel}) {
  WalletController walletController = Get.find<WalletController>();
  if (title == "edit") {
    walletController.amountController.text = depositModel!.amount.toString();
  }
  return showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Container(
            height: MediaQuery.of(context).size.height * 0.4,
            width: MediaQuery.of(context).size.width > 600
                ? MediaQuery.of(context).size.width * 0.2
                : MediaQuery.of(context).size.width * 0.5,
            padding: EdgeInsets.fromLTRB(10, 20, 20, 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${title}".capitalize!,
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 12),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: walletController.amountController,
                  decoration: InputDecoration(
                      hintText: title == "edit"
                          ? depositModel!.amount.toString()
                          : "Amount",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5))),
                ),
                SizedBox(height: 10),
                TextFormField(
                  enabled: false,
                  decoration: InputDecoration(
                      hintText:
                          "${DateFormat("MMMM/dd/yyyy").format(DateTime.now())}",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5))),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        if (title == "edit")
                          walletController.amountController.text = "";
                      },
                      child: Text(
                        "Cancel".toUpperCase(),
                        style: TextStyle(color: Colors.purple),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        if (title == "edit") {
                          // walletController.amountController.text = "";
                          walletController.updateWallet(
                              amount: walletController.amountController.text,
                              id: depositModel!.id,
                              uid: uid);
                        } else {
                          walletController.save(uid, context,page,size);
                        }
                      },
                      child: Text(
                        "Save Now".toUpperCase(),
                        style: TextStyle(color: Colors.purple),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        );
      });
}
