import 'package:flutter/material.dart';
import 'package:niterra/models/landing_models/auth_models/user_preferences.dart';
import 'package:niterra/providers/sign_up_providers.dart';
import 'package:niterra/screens/navbar/home/home_tab_page.dart';
import 'package:provider/provider.dart';


class LogoutHandler {
  /// Perform logout operation
  static Future<void> logout(BuildContext context) async {
    try {
      // Clear user data from SharedPreferences
      await UserPreferences.clearUserDetails();

      // Clear user data from UserProvider
      Provider.of<UserProvider>(context, listen: false).clearUserDetails();

      // Navigate to the sign-in page and clear the navigation stack
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => HomeTabPage()), // Replace with your homepage widget
            (route) => false, // Remove all previous routes
      );
    } catch (e) {
      // Handle logout errors (optional)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error during logout: $e')),
      );
    }
  }
}
