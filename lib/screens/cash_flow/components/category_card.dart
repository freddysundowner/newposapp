import 'package:flutter/material.dart';
Widget categoryCard( context) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: GestureDetector(
      onTap: () {

      },
      child: Container(
        padding: EdgeInsets.all(10),
        width: double.infinity,
        decoration: BoxDecoration(
            color:Colors.white,
            border: Border.all(
                width: 1,
                color:  Colors.black),
            borderRadius: BorderRadius.circular(8)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.account_balance_wallet,
              color: Colors.grey,
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Name",
                  style: TextStyle(color: Colors.black),
                ),
                Text(
                  "${200}",
                  style: TextStyle(color: Colors.black),
                ),
              ],
            )
          ],
        ),
      ),
    ),
  );
}