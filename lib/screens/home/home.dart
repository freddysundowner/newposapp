import 'package:flutter/material.dart';


import '../attendant/create_attendant.dart';
class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CreateAttendant();
  }
}
