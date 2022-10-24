import 'package:flutter/material.dart';
import '../utils/colors.dart';

class LoadingDialog {
  static Future<void> showLoadingDialog(
      {required BuildContext context,
      required title,
      required GlobalKey key}) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new WillPopScope(
              onWillPop: () async => false,
              child: SimpleDialog(
                  key: key,
                  backgroundColor: Colors.white,
                  children: <Widget>[
                    Center(
                      child: Column(children: [
                        CircularProgressIndicator(
                          backgroundColor: AppColors.mainColor,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          title,
                          style: TextStyle(color: Colors.blueAccent),
                        )
                      ]),
                    )
                  ]));
        });
  }
}
