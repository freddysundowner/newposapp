// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
//
// import '../../../controllers/attendant_controller.dart';
// import '../../../controllers/wallet_controller.dart';
// import '../../../widgets/delete_dialog.dart';
// Widget WalletCard(
//     {
//       required context,
//       required uid,
//       required type,
//       customer}) {
//   return InkWell(
//     onTap: () {
//
//     },
//     child: Container(
//       margin: EdgeInsets.all(5),
//       padding: EdgeInsets.all(10),
//       decoration: BoxDecoration(
//           color: Colors.white, borderRadius: BorderRadius.circular(8)),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Icon(
//             Icons.arrow_downward,
//             color: Colors.green,
//           ),
//           Spacer(),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(DateFormat("dd-MM-yyyy").format(DateTime.now())),
//               SizedBox(height: 10),
//               Text("#QWERTYU"),
//             ],
//           ),
//           Spacer(),
//           Text("KES \n${300}"),
//         ],
//       ),
//     ),
//   );
// }
//
// showBottomSheet(context, uid) {
//   WalletController walletController = Get.find<WalletController>();
//   return showModalBottomSheet<void>(
//       context: context,
//       builder: (BuildContext context) {
//         return Container(
//             height: 150,
//             child: Center(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Container(
//                         padding: EdgeInsets.all(10),
//                         width: double.infinity,
//                         color: Colors.grey.withOpacity(0.7),
//                         child: Text('Select Action')),
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: InkWell(
//                         onTap: () {
//                           Navigator.pop(context);
//                           // showDepositDialog(
//                           //     context: context,
//                           //     uid: uid,
//                           //     title: "edit",
//                           //     walletController: walletController,
//                           //     depositBody: depositBody);
//                         },
//                         child: Row(
//                           children: [
//                             Icon(Icons.edit),
//                             SizedBox(
//                               width: 10,
//                             ),
//                             Container(child: Text('Edit'))
//                           ],
//                         ),
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: GestureDetector(
//                         onTap: () {
//                           Navigator.pop(context);
//                           deleteDialog(
//                               context: context,
//                               onPressed: () {
//                                 // walletController.deleteWallet(
//                                 //     depositBody.id, uid, depositBody.amount);
//                               });
//                         },
//                         child: Row(
//                           children: [
//                             Icon(Icons.delete_outline_rounded),
//                             SizedBox(
//                               width: 10,
//                             ),
//                             Container(child: Text('Delete'))
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 )));
//       });
// }
//
// showBottomSheetUsage(context, uid, customer) {
//   WalletController walletController = Get.find<WalletController>();
//   AttendantController attendantController = Get.find<AttendantController>();
//   return showModalBottomSheet<void>(
//       context: context,
//       builder: (BuildContext context) {
//         return Container(
//             height: 180,
//             child: Center(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Container(
//                         padding: EdgeInsets.all(10),
//                         width: double.infinity,
//                         color: Colors.grey.withOpacity(0.7),
//                         child: Text('Select Download Option')),
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: InkWell(
//                         onTap: () {
//                           Navigator.pop(context);
//                           // Get.to(
//                           //     DepoUsageHistory(
//                           //       type: "deposit",
//                           //       walletController: walletController,
//                           //       attendant: attendantController.name.value,
//                           //       customer: customer,
//                           //       shop: attendantController.shopName.value,
//                           //     ));
//
//                         },
//                         child: Row(
//                           children: [
//                             Icon(Icons.cloud_download_outlined),
//                             SizedBox(
//                               width: 10,
//                             ),
//                             Container(child: Text('Deposit History'))
//                           ],
//                         ),
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: GestureDetector(
//                         onTap: () {
//                           Navigator.pop(context);
//                           // Get.to(DepoUsageHistory(
//                           //   type: "usage",
//                           //   walletController: walletController,
//                           //   attendant: attendantController.name.value,
//                           //   customer: customer,
//                           //   shop: attendantController.shopName.value,
//                           // ));
//                         },
//                         child: Row(
//                           children: [
//                             Icon(Icons.downloading_outlined),
//                             SizedBox(
//                               width: 10,
//                             ),
//                             Container(child: Text('Usage History'))
//                           ],
//                         ),
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: GestureDetector(
//                         onTap: () {
//                           Navigator.pop(context);
//                         },
//                         child: Row(
//                           children: [
//                             Icon(Icons.clear),
//                             SizedBox(
//                               width: 10,
//                             ),
//                             Container(
//                                 child: Text(
//                                   'Cancel',
//                                   style: TextStyle(color: Colors.red),
//                                 ))
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 )));
//       });
// }

// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pointify/controllers/shop_controller.dart';
import 'package:pointify/models/deposit_model.dart';
import 'package:intl/intl.dart';

import 'deposit_dialog.dart';

Widget WalletCard(
    {required DepositModel depositBody,
    required context,
    required uid,
    customer}) {
  return Container(
    margin: EdgeInsets.all(5),
    padding: EdgeInsets.all(10),
    decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(8)),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          depositBody.type == "usage"
              ? Icons.arrow_upward
              : Icons.arrow_downward,
          color: depositBody.type == "usage" ? Colors.red : Colors.green,
        ),
        Spacer(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(DateFormat().format(depositBody.updatedAt!)),
            SizedBox(height: 10),
            Text("Receipt:#${depositBody.recieptNumber.toString()}"),
          ],
        ),
        Spacer(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(Get.find<ShopController>().currentShop.value!.currency!),
                Text(
                  " ${depositBody.amount}",
                  style: TextStyle(
                    color:
                        depositBody.type == "usage" ? Colors.red : Colors.green,
                  ),
                ),
              ],
            ),
            if (depositBody.attendant != null)
              Row(
                children: [
                  Text("By"),
                  Text(
                    " ${depositBody.attendant?.fullnames}",
                    style: TextStyle(
                      color: depositBody.type == "usage"
                          ? Colors.red
                          : Colors.green,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ],
    ),
  );
}
