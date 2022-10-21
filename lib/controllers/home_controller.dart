import 'package:flutterpos/screens/home/profile_page.dart';
import 'package:get/get.dart';

import '../screens/home/attendants_page.dart';
import '../screens/home/home_page.dart';
import '../screens/home/shops_page.dart';

class HomeController extends GetxController{
  RxInt selectedIndex = RxInt(0);
  List pages = [
    HomePage(),
    ShopsPage(),
    AttendantsPage(),
    ProfilePage()
  ];
}