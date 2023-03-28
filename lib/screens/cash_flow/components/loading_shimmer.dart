import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
Widget cashFlowloadingShimmer() {
  return SizedBox(
    width: 100.0,
    height: 20.0,
    child: Shimmer.fromColors(
      baseColor: Colors.grey.withOpacity(0.2),
      highlightColor:Colors.grey.withOpacity(0.5),
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(10)
        ),
      ),
    ),
  );
  ;
}