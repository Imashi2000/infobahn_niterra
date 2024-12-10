import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:niterra/common/styles/colors.dart';

class CommonLoaders {

  static successSnackBar({
    required title,
    message = '',
    required duration
  }){
    Get.snackbar(
        title,
        message,
        isDismissible: true,
        shouldIconPulse: true,
        colorText: Colors.white,
        backgroundColor: Colors.green,
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: duration),
        margin: EdgeInsets.all(10),
        icon: Icon(Icons.check, color: Colors.white,)
    );
  }

  static errorSnackBar({
    required title,
    message = '',
    required duration
  }){
    Get.snackbar(
        title,
        message,
        isDismissible: true,
        shouldIconPulse: true,
        colorText: Colors.white,
        backgroundColor: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: duration),
        margin: EdgeInsets.all(10),
        icon: Icon(Icons.dangerous, color: Colors.white,)
    );
  }

  static warningSnackBar({
    required title,
    message = '',
    required duration
  }){
    Get.snackbar(
        title,
        message,
        isDismissible: true,
        shouldIconPulse: true,
        colorText: Colors.white,
        backgroundColor: BaseColorTheme.submittedBtnColor,
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: duration),
        margin: EdgeInsets.all(10),
      icon: Icon(Icons.warning_amber_rounded, color: Colors.white),
    );
  }

  static disclaimerSnackBar({
    required String title,
    String message = '',
    required VoidCallback onConfirm,
  }) {
    Get.snackbar(
      title,
      '',
      isDismissible: false, // Prevent dismissing by tapping outside
      shouldIconPulse: true,
      colorText: Colors.white,
      backgroundColor: BaseColorTheme.submittedBtnColor,
      snackPosition: SnackPosition.TOP,
      duration: null, // Persistent until action is taken
      margin: EdgeInsets.all(10),
      icon: Icon(Icons.warning_amber_rounded, color: Colors.white),
      messageText: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message,
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () {
                  onConfirm();
                  Get.back(); // Close the Snackbar
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green, // Button color
                ),
                child: Text(
                  'CONFIRM',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              IconButton(
                icon: Icon(Icons.close, color: Colors.white),
                onPressed: () {
                  Get.back(); // Close the Snackbar
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}