// import 'package:flutter/material.dart';
//
// import 'package:flutter/material.dart';
// import 'package:flutterpos/controllers/shop_controller.dart';
// import 'package:get/get.dart';
// import '../../../../controllers/attendant_controller.dart';
// import '../../../../controllers/sales_controller.dart';
// import '../../../../controllers/supplierController.dart';
// import '../../controllers/product_controller.dart';
// import '../../widgets/bigtext.dart';
// import '../../widgets/smalltext.dart';
//
//
// class ViewPurchases extends StatelessWidget {
//   ViewPurchases({Key? key}) : super(key: key);
//   ShopController createShopController=Get.find<ShopController>();
//   AttendantController attendantController = Get.find<AttendantController>();
//   SupplierController supplierController = Get.find<SupplierController>();
//   ProductController productController = Get.find<ProductController>();
//   SalesController salesController = Get.find<SalesController>();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0.3,
//         leading: IconButton(
//           onPressed: () {
//             Get.back();
//           },
//           icon: Icon(
//             Icons.arrow_back_ios,
//             color: Colors.black,
//           ),
//         ),
//         title: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             majorTitle(title: "Stock Items", color: Colors.black, size: 16.0),
//             minorTitle(
//                 title: "${createShopController.currentShop.value?.name}",
//                 color: Colors.grey)
//           ],
//         ),
//       ),
//       body :Obx(() {
//         return productController.getProductByDateLoad.value
//             ? Center(
//           child: CircularProgressIndicator(),
//         )
//             : productController.productsByDate.length == 0
//             ? Center(
//           child: Text("No stock Entries Found"),
//         )
//             : ListView.builder(
//             itemCount:
//             productController.productsByDate.length,
//             physics: NeverScrollableScrollPhysics(),
//             shrinkWrap: true,
//             itemBuilder: (context, index) {
//               SupplyOrderBody supplyOrderItem =
//               productController.productsByDate
//                   .elementAt(index);
//
//               return stockCard(
//                   context: context,
//                   product: supplyOrderItem,
//                   type: "today");
//             });
//       }),
//     );
//   }
// }
//
