import 'package:flutter/material.dart';
import 'package:flutterpos/screens/profile/profile_update.dart';

import 'attendant/create_attendant.dart';
class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CreateAttendant();
  }
}
