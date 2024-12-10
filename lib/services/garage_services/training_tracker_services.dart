import 'dart:convert';
import 'package:niterra/models/garage_models/getTrainingTracker_model.dart';
import 'package:niterra/services/training_api_service.dart';

class TrainingTrackerService {
  Future<List<TrainingTracker>> fetchTrainingTracker(int userId) async {
    final Map<String, dynamic> requestBody = {
      "action": "getTrainingTracker",
      "userid": userId,
    };

    try {
      final response = await TrainingApiService.sendTrainingRequest(requestBody);

      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'] as List;
        return data.map((item) => TrainingTracker.fromJson(item)).toList();
      } else {
        throw Exception('Failed to fetch training tracker: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching training tracker: $e');
    }
  }
}
