import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static Future<void> saveUserDetails(int userId, int countryId, int userTypeId,int cityId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', userId.toString());
    await prefs.setString('countryId', countryId.toString());
    await prefs.setString('userTypeId', userTypeId.toString());
    await prefs.setString('cityId', cityId.toString());
  }

  static Future<Map<String, String?>> getUserDetails() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'userId': prefs.getString('userId'),
      'countryId': prefs.getString('countryId'),
      'userTypeId': prefs.getString('userTypeId'),
      'cityId' : prefs.getString('cityId'),
    };
  }

  static Future<void> clearUserDetails() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');
    await prefs.remove('countryId');
    await prefs.remove('userTypeId');
    await prefs.remove('cityId');
  }
}


