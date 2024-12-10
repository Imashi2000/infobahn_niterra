import 'dart:convert';
import 'package:niterra/models/garage_models/getFeedbackByUser_model.dart';
import 'package:niterra/models/garage_models/saveFeedbackRequest_model.dart';
import 'package:niterra/models/garage_models/saveFeedbackResponse_model.dart';
import 'package:niterra/services/api_service.dart';

class FeedBackService{
  Future<List<FeedbackItem>> getFeedback(int userId) async {
    final Map<String, dynamic> requestBody = {
      "action": "getFeedback",
      "userid": userId.toString(),
    };

    try {
      final response = await BasicAPIService.sendPostRequest(requestBody);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        // Check if the response contains an error status
        if (responseData['status'] == 'error') {
          if (responseData['message'] == 'No feedback') {
            return []; // Return an empty list for no feedback
          } else {
            throw Exception(responseData['message']);
          }
        }

        // Parse feedback data if no error
        final data = responseData['data'] as List<dynamic>;
        return data.map((item) => FeedbackItem.fromJson(item)).toList();
      } else {
        throw Exception('Failed to fetch feedback: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching feedback: $e');
    }
  }

  Future<SaveFeedbackResponse> saveFeedback(SaveFeedbackRequest request) async {
    try {
      final response = await BasicAPIService.sendPostRequest(request.toJson());

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return SaveFeedbackResponse.fromJson(jsonResponse);
      } else {
        throw Exception('Failed to save feedback: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error saving feedback: $e');
    }
  }
}