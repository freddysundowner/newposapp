// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/AuthController.dart';
import '../../controllers/attendant_controller.dart';
import '../../controllers/shop_controller.dart';
import '../../utils/colors.dart';

class AttendantLanding extends StatelessWidget {
  AttendantLanding({Key? key}) : super(key: key);
  AuthController authController = Get.find<AuthController>();
  AttendantController attendantController = Get.find<AttendantController>();
ShopController createShopController = Get.find<ShopController>();
  Future <void> _refreshUser() async{
    await attendantController.getAttendantsById(authController.currentUser.value!.id);
  }
  List<String> roles =["canmakesales","canaddstockin","canaddexpenses","canaddnewproducts","cancountupdateStockBalance","canviewstockbalanceList"];
  @override
  Widget build(BuildContext context) {

    attendantController.getAttendantsById(authController.currentUser.value!.id);
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
          elevation: 0.0,
          automaticallyImplyLeading: false,
          backgroundColor: AppColors.mainColor,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(() {
                return Text(
                  createShopController.currentShop.value==null?"":
                  "${createShopController.currentShop.value!.name}".capitalize!,
                  style: TextStyle(color: Colors.white),
                );
              }),

            ],
          ),
          actions: [
            IconButton(
              onPressed: () async{
                // authController.getUserById();
                await attendantController.getAttendantsById(authController.currentUser.value!.id);
              },
              icon: Icon(
                Icons.refresh_outlined,
                color: Colors.white,
              ),
            ),
            IconButton(
              onPressed: () {
                authController.logout();
              },
              icon: Icon(
                Icons.logout_outlined,
                color: Colors.white,
              ),
            ),
          ]),
      body: RefreshIndicator(
          onRefresh: _refreshUser,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              SizedBox(height: 50),
          Center(
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.white, width: 4),
                  borderRadius: BorderRadius.circular(50),
                  image: DecorationImage(
                      image: NetworkImage(
                          "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460__340.png"))),
            ),
          ),
          SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Welcome ",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold)),
              Obx(() {
                return Text(
                  "${authController.currentUser.value!.name}".capitalize!,
                  style: TextStyle(
                      color: Colors.amber, fontWeight: FontWeight.bold),
                );
              })
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("AttendantID:", style: TextStyle(color: Colors.grey)),
              // Obx(() {
              //   return Text(
              //     "${attendantController.singleAttendant.value.attendId==null?"":attendantController.singleAttendant.value.attendId}",
              //     style: TextStyle(color: Colors.grey),
              //   );
              // })
            ],
          ),
          SizedBox(height: 5),

    //       Expanded(
    //           child: Obx(()=> ListView(
    //               children:attendantController.singleAttendant.value.roles==null?[]:authController.currentUser.value?.roles!.where((e) => roles.indexWhere((element) => element == e.key) !=-1).map((e) => Container(
    //     margin: EdgeInsets.only(bottom: 20),
    //     child: InkWell(
    //       onTap: () {
    //         if(e.key=="canaddexpenses"){
    //           // Get.to(()=>ExpensesPage());
    //         }else if(e.key=="canaddnewproducts"){
    //           // Get.to(()=>StockSetUp());
    //
    //         }else if(e.key=="canmakesales"){
    //           // Get.to(()=>SalesPage());
    //         }else if(e.key=="canaddstockin"){
    //           // Get.to(AddStockIn(
    //           //   type: "attendant",
    //           // ));
    //         }else if(e.key=="canviewstockbalanceList"){
    //           // Get.to(() => ViewOtherShop());
    //
    //         }else if(e.key=="cancountupdateStockBalance"){
    //           // Get.to(() => CountPage());
    //         }
    //
    //       },
    //       child: Center(
    //         child: Material(
    //           elevation: 10,
    //           color: Colors.transparent,
    //           child: Container(
    //             width: MediaQuery.of(context).size.width * 0.5,
    //             padding: EdgeInsets.all(12),
    //             decoration: BoxDecoration(
    //               color: AppColors.pimaryColor,
    //               borderRadius: BorderRadius.circular(50),
    //             ),
    //             child: Row(
    //               mainAxisAlignment: MainAxisAlignment.center,
    //               children: [
    //                 // Icon(Icons.production_quantity_limits,
    //                 //     color: Colors.white),
    //                 SizedBox(width: 5),
    //                 Text(
    //                   e.name,
    //                   style: TextStyle(color: Colors.white),
    //                 )
    //               ],
    //             ),
    //           ),
    //         ),
    //       ),
    //     ),
    //   )).toList(),
    //
    // ),
    // ),
    // ),
    SizedBox(height: 10),
    InkWell(
    onTap: () {
    // Get.to(CustomCalculator());
    },
    child: Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
    Icon(
    Icons.calculate,
    color: Colors.grey,
    size: 14,
    ),
    SizedBox(width: 2),
    Text(
    "Calculator",
    style: TextStyle(color: Colors.grey, fontSize: 10),
    )

    ],
    ),
    )
    ,
    SizedBox(height: 20),
    ],
    ),
    ),
    );
  }
}
