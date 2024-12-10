import 'dart:convert';
import 'package:niterra/models/garage_models/getStaffByGarageId_model.dart';
import 'package:niterra/models/garage_models/saveStaffRequest_model.dart';
import 'package:niterra/models/garage_models/saveStaffResponse_model.dart';
import 'package:niterra/models/garage_models/updateStaffRequest_model.dart';
import 'package:niterra/models/garage_models/updateStaffResponse_model.dart';
import 'package:niterra/services/training_api_service.dart';

class ManageStaffServices{
  Future<List<StaffByGarage>> fetchStaffByGarageId(int garageid) async {
    final Map<String, dynamic> requestBody = {
      "action": "getStaffsByUserId",
      "userid": garageid,
    };

    try {
      final response = await TrainingApiService.sendTrainingRequest(requestBody);

      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'] as List;
        return data.map((item) => StaffByGarage.fromJson(item)).toList();
      } else {
        throw Exception('Failed to fetch consumers by country');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<StaffRegistrationResponse> registerStaff(
      StaffRegistrationModel staffModel) async {
    final Map<String, dynamic> requestBody = staffModel.toJson();

    try {
      final response = await TrainingApiService.sendTrainingRequest(requestBody);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return StaffRegistrationResponse.fromJson(responseData);
      } else {
        throw Exception('Failed to register staff: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error registering staff: $e');
    }
  }

  Future<UpdateStaffResponseModel> updateStaff(
      UpdateStaffRequestModel updateModel) async {
    print("Preparing API request for update: ${updateModel.toJson()}");

    try {
      final response = await TrainingApiService.sendTrainingRequest(updateModel.toJson());
      print("API Response Status: ${response.statusCode}");
      print("API Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return UpdateStaffResponseModel.fromJson(responseData);
      } else {
        print("API Error: ${response.statusCode} - ${response.body}");
        throw Exception('Failed to update staff: ${response.statusCode}');
      }
    } catch (e) {
      print("Exception occurred: $e");
      throw Exception('Error updating staff: $e');
    }
  }

}