import 'package:flutterpos/screens/home/profile_page.dart';
import 'package:flutterpos/utils/constants.dart';
import 'package:get/get.dart';

import '../screens/home/attendants_page.dart';
import '../screens/home/home_page.dart';
import '../screens/home/shops_page.dart';

class HomeController extends GetxController{
  RxString hoveredItem=RxString(homePage);
  RxString activeItem=RxString(homePage);



  RxInt selectedIndex = RxInt(0);
  List pages = [
    HomePage(),
    ShopsPage(),
    AttendantsPage(),
    ProfilePage()
  ];
}