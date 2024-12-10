import 'dart:convert';
import 'package:niterra/models/garage_models/getStaffAssigned_model.dart';
import 'package:niterra/models/garage_models/getStaffToAssign_model.dart';
import 'package:niterra/models/garage_models/getTrainingsByUserType_model.dart';
import 'package:niterra/models/garage_models/saveStaffAssignResponse_model.dart';
import 'package:niterra/models/garage_models/saveStaffAssigned_model.dart';
import 'package:niterra/services/training_api_service.dart';

class ManageTrainingServices {
  Future<List<TrainingByUserType>> fetchTrainingsByUserType(
   int userTypeId,
    int cityId,
    int userId,
  ) async {
    final Map<String, dynamic> requestBody = {
      "action": "getTrainingsByUserType",
      "usertypeid": userTypeId,
      "cityid": cityId,
      "userid": userId,
    };

    try {
      final response = await TrainingApiService.sendTrainingRequest(requestBody);

      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'] as List;
        return data.map((item) => TrainingByUserType.fromJson(item)).toList();
      } else {
        throw Exception('Failed to fetch trainings: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching trainings: $e');
    }
  }

  Future<List<StaffAssigned>> fetchStaffAssigned(int trainingid) async {
    final Map<String, dynamic> requestBody = {
      "action": "getStaffsAssigned",
      "trainingid": trainingid,
    };

    try {
      final response = await TrainingApiService.sendTrainingRequest(requestBody);

      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'] as List;
        return data.map((item) => StaffAssigned.fromJson(item)).toList();
      } else {
        throw Exception('Failed to fetch staff assigned: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching staff assigned: $e');
    }
  }

  Future<List<StaffToAssign>> fetchStaffToAssign(int userid) async {
    final Map<String, dynamic> requestBody = {
      "action": "getStaffsToAssign",
      "userid": userid,
    };

    try {
      final response = await TrainingApiService.sendTrainingRequest(requestBody);

      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'] as List;
        return data.map((item) => StaffToAssign.fromJson(item)).toList();
      } else {
        throw Exception('Failed to fetch trainings: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching assign staff: $e');
    }
  }

  Future<AssignTrainingResponse> submitAssignment(
      AssignTrainingRequest request) async {
    try {
      final response = await TrainingApiService.sendTrainingRequest(request.toJson());

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return AssignTrainingResponse.fromJson(responseData);
      } else {
        throw Exception('Failed to assign training: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error while assigning training: $e');
    }
  }
}