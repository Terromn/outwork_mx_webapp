import 'package:flutter/cupertino.dart';

class TeMediaQuery {
  static double getPercentageHeight(BuildContext context, double percentage) {
    double screenHeight = MediaQuery.of(context).size.height;
    return (percentage / 100.0) * screenHeight;
  }

  static double getPercentageWidth(BuildContext context, double percentage) {
    double screenWidth = MediaQuery.of(context).size.height;
    return (percentage / 100.0) * screenWidth;
  }
}
