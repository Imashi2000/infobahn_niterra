import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  String? userid;
  String? countryid;
  String? usertypeid;
  String? cityid;

  void setUserDetails(int id, int country, int usertype,int city) {
    userid = id.toString();
    countryid = country.toString();
    usertypeid = usertype.toString();
    cityid = city.toString();
    notifyListeners(); // Notify listeners to update UI
  }

  void clearUserDetails() {
    userid = null;
    countryid = null;
    usertypeid = null;
    cityid = null;
    notifyListeners();
  }
}

