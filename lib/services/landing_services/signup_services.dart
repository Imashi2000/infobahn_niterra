import 'dart:convert';
import 'package:niterra/models/landing_models/city_model.dart';
import 'package:niterra/models/landing_models/country.dart';
import 'package:niterra/models/landing_models/designation_model.dart';
import 'package:niterra/models/landing_models/get_user_response_model.dart';
import 'package:niterra/models/landing_models/login_response_model.dart';
import 'package:niterra/models/landing_models/resetPassword_response_model.dart';
import 'package:niterra/models/landing_models/save_user_response_model.dart';
import 'package:niterra/models/landing_models/sign_up_model.dart';
import 'package:niterra/models/landing_models/updatePasswordRequest_model.dart';
import 'package:niterra/models/landing_models/updatePasswordResponse_model.dart';
import 'package:niterra/models/landing_models/updateProfileRequest_model.dart';
import 'package:niterra/models/landing_models/updateProfileResponse_model.dart';
import 'package:niterra/services/api_service.dart';

class ApiService {
  // Fetch countries method
  Future<List<Country>> fetchCountries() async {
    final Map<String, String> requestBody = {
      'action': 'getCountry',
    };

    try {
      // Send the request using ApiHelper's sendPostRequest method
      final response = await BasicAPIService.sendPostRequest(requestBody);

      // Debug: Check the status code and response body
      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        try {
          final data = json.decode(response.body)['data'];
          print('Fetched countries: $data'); // Debug print

          return List<Country>.from(data.map((country) {
            return Country.fromJson(country); // Convert each map to a Country object
          }));
        } catch (e) {
          print('Error decoding JSON: $e');
          throw Exception('Failed to parse countries');
        }
      } else {
        throw Exception('Failed to load countries. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching countries: $e');
      throw Exception('Failed to load countries');
    }
  }

  // Fetch cities method
  Future<List<City>> fetchCities(String countryId) async {
    final Map<String, String> requestBody = {
      'action': 'getCity',
      'country': countryId,
    };

    try {
      // Send the request using ApiHelper's sendPostRequest method
      final response = await BasicAPIService.sendPostRequest(requestBody);

      // Debug: Check the status code and response body
      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        try {
          final data = json.decode(response.body)['data'];
          print('Fetched cities: $data'); // Debug print

          return List<City>.from(data.map((city) {
            return City.fromJson(city); // Convert each map to a City object
          }));
        } catch (e) {
          print('Error decoding JSON: $e');
          throw Exception('Failed to parse cities');
        }
      } else {
        throw Exception('Failed to load cities. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching cities: $e');
      throw Exception('Failed to load cities');
    }
  }

  Future<List<Designation>> fetchDesignation() async {
    final Map<String, String> requestBody = {
      'action': 'getDesignation',
    };

    try {
      final response = await BasicAPIService.sendPostRequest(requestBody);

      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        try {
          final data = json.decode(response.body)['data'];
          print('Fetched designations: $data'); // Debug print

          return List<Designation>.from(data.map((designation) {
            return Designation.fromJson(designation); // Convert each map to a Designation object
          }));
        } catch (e) {
          print('Error decoding JSON: $e');
          throw Exception('Failed to parse designations');
        }
      } else {
        throw Exception('Failed to load designations. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching designations: $e');
      throw Exception('Failed to load designations');
    }
  }

  Future<SaveUserResponse> saveUser(SignUpModel request) async {
    final Map<String, String> requestBody = Map<String, String>.from(request.toJson());

    try {
      final response = await BasicAPIService.sendPostRequest(requestBody);

      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        try {
          final data = json.decode(response.body);
          return SaveUserResponse.fromJson(data);
        } catch (e) {
          print('Error decoding JSON: $e');
          throw Exception('Failed to parse save user response');
        }
      } else {
        throw Exception('Failed to save user. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error saving user: $e');
      throw Exception('Failed to save user');
    }
  }

  Future<LoginResponse> userLogin(String input, String password) async {
    final Map<String, String> requestBody = {
      "action": "userLogin",
      "input": input,
      "password": password,
    };

    try {
      final response = await BasicAPIService.sendPostRequest(requestBody);

      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return LoginResponse.fromJson(data);
      } else {
        throw Exception('Failed to login. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error logging in: $e');
      throw Exception('Failed to login');
    }
  }

  Future<ForgotPasswordResponse> resetPassword(String input) async {
    // Ensure all values in the map are strings to match the expected type
    final Map<String, String> requestBody = {
      "action": "resetPasword",
      "input": input,
      "password": "null", // Ensure this is a string
    };

    try {
      final response = await BasicAPIService.sendPostRequest(requestBody);
      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return ForgotPasswordResponse.fromJson(data);
      } else {
        throw Exception('Failed to reset password. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in resetPassword: $e');
      throw Exception('Failed to reset password');
    }
  }

  Future<GetUserResponse> getUser(int userId) async {
    final Map<String, dynamic> requestBody = {
      "action": "getUser",
      "userid": userId,
    };

    try {
      // Send the request using BasicAPIService's sendPostRequest method
      final response = await BasicAPIService.sendPostRequest(requestBody);

      // Debug: Log the response
      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Check if the response status is success
        if (data['status'] == 'success' && data['data'] != null) {
          // Parse the first user object from the data array
          return GetUserResponse.fromJson(data['data'][0]);
        } else {
          throw Exception('Failed to fetch user: ${data['message'] ?? 'Unknown error'}');
        }
      } else {
        throw Exception('Failed to fetch user. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in getUser: $e');
      throw Exception('Failed to fetch user details');
    }
  }

  Future<UpdateprofileresponseModel> updateProfile(UpdateProfileRequest request) async {
    final Map<String, String> requestBody = request.toJson();

    try {
      final response = await BasicAPIService.sendPostRequest(requestBody);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return UpdateprofileresponseModel.fromJson(data);
      } else {
        throw Exception('Failed to update profile. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error updating profile: $e');
      throw Exception('Failed to update profile');
    }
  }

  // Update Password
  Future<UpdatepasswordresponseModel> updatePassword(UpdatePasswordRequest request) async {
    final Map<String, String> requestBody = request.toJson();

    try {
      final response = await BasicAPIService.sendPostRequest(requestBody);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return UpdatepasswordresponseModel.fromJson(data);
      } else {
        throw Exception('Failed to update password. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error updating password: $e');
      throw Exception('Failed to update password');
    }
  }
}

