import 'package:flutter/material.dart';

class Responsive {
  static double screenWidth(BuildContext context) =>
      MediaQuery.of(context).size.width;

  static double screenHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;

  static double pixelRatio(BuildContext context) =>
      MediaQuery.of(context).devicePixelRatio;

  /// Scales font using the shortest side and pixel density
  static double fontSize(BuildContext context, double ratio) {
    final base = MediaQuery.of(context).size.shortestSide;
    return base * ratio;
  }

  static double padding(BuildContext context) => screenWidth(context) * 0.05;

  static double iconSize(BuildContext context) => screenWidth(context) * 0.07;
}
