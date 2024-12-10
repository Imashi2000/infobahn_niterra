import 'package:niterra/models/landing_models/user_data_model.dart';

class LoginResponse {
  final String status;
  final String message;
  final List<UserData>? data;

  LoginResponse({required this.status, required this.message, this.data});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      status: json['status'],
      message: json['message'],
      data: json['data'] != null
          ? List<UserData>.from(json['data'].map((item) => UserData.fromJson(item)))
          : null,
    );
  }
}