import 'package:flutter/material.dart';

Widget noItemsFound(context,isFullScreen){
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      SizedBox(
        height:isFullScreen?
        MediaQuery
            .of(context)
            .size
            .height *
            0.1:0,
      ),
      Center(
        child: Container(
          height: isFullScreen?
          MediaQuery
              .of(context)
              .size
              .height *
              0.4: MediaQuery
              .of(context)
              .size
              .height *
              0.2,
          width: 300,
          padding: EdgeInsets.all(0),
          child: Image.asset(
            "assets/images/no_data.png",
          ),
        ),
      ),
    ],
  );
}