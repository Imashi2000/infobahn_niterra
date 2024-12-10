// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';

// double getScreenWidth(BuildContext context, double ScreenWidth) {
//   return MediaQuery.of(context).size.width / 390 * ScreenWidth;
// }

// double getScreenHeight(BuildContext context, double screenHieght) {
//   return MediaQuery.of(context).size.height / 844 * screenHieght;
// }

class ScreenUtils {
  static double screenHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;

  static double screenWidth(BuildContext context) =>
      MediaQuery.of(context).size.width;

  static double figmaDesignHeight = 852;
  static double figmaDesignWidth = 393;

  static double getBottomNavigationBarHeight(BuildContext context) {
    return MediaQuery.of(context).padding.bottom + kBottomNavigationBarHeight;
  }

  static double availableHeight(BuildContext context) {
    final screenHeight = ScreenUtils.screenHeight(context);
    final bottomBarHeight = getBottomNavigationBarHeight(context);
    return screenHeight - bottomBarHeight;
  }

  static double getResponsiveHeight({
    required BuildContext context,
    required double portionHeightValue,
  }) {
    final availableHeight = ScreenUtils.availableHeight(context);
    double heightFactor = portionHeightValue / figmaDesignHeight;
    double height = availableHeight * heightFactor;
    return height;
  }

  // Screen Size without Bottom Navigation Bar
  static double getResponsiveFullHeightWithoutBottomBar({
    required BuildContext context,
    required double portionHeightValue,
  }) {
    final availableHeight = ScreenUtils.screenHeight(context);
    double heightFactor = portionHeightValue / figmaDesignHeight;
    double height = availableHeight * heightFactor;
    return height;
  }

  static double getResponsiveWidth({
    required BuildContext context,
    required double portionWidthValue,
  }) {
    final screenWidth = ScreenUtils.screenWidth(context);
    double widthFactor = portionWidthValue / figmaDesignWidth;
    double width = screenWidth * widthFactor;
    return width;
  }

  static Widget widthSpace(double value, context) {
    return SizedBox(
      width: ScreenUtils.getResponsiveWidth(
          context: context, portionWidthValue: value),
    );
  }

  static Widget heightSpace(double value, context) {
    return SizedBox(
      height: ScreenUtils.getResponsiveHeight(
          context: context, portionHeightValue: value),
    );
  }
}
