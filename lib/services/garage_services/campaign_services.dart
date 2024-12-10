import 'dart:convert';

import 'package:niterra/models/garage_models/getCampaign_model.dart';
import 'package:niterra/models/garage_models/saveEnrollCampaignRequest_model.dart';
import 'package:niterra/models/garage_models/saveEnrollCampaignResponse_model.dart';
import 'package:niterra/services/training_api_service.dart';

class CampaignServices {
  Future<List<Campaign>> fetchCampaigns(int userTypeId, int cityId, int userId) async {
    final Map<String, dynamic> requestBody = {
      "action": "getCampaign",
      "usertypeid": userTypeId,
      "cityid": cityId,
      "userid": userId,
    };

    try {
      final response = await TrainingApiService.sendTrainingRequest(requestBody);

      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'] as List;
        return data.map((item) => Campaign.fromJson(item)).toList();
      } else {
        throw Exception('Failed to fetch campaigns: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching campaigns: $e');
    }
  }

  Future<SaveEnrollCampaignResponse> enrollCampaign(
      EnrollCampaignRequest request) async {
    final Map<String, dynamic> requestBody = request.toJson();

    try {
      final response = await TrainingApiService.sendTrainingRequest(requestBody);

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return SaveEnrollCampaignResponse.fromJson(jsonResponse);
      } else {
        throw Exception('Failed to enroll in campaign: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error during enrollment: $e');
    }
  }
}