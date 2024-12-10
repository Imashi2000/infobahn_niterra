import 'dart:convert';
import 'package:niterra/models/garage_models/getGarageAgreement_model.dart';
import 'package:niterra/services/training_api_service.dart';

class GarageAgreementService {
  Future<GarageAgreement?> fetchGarageAgreement(int userId) async {
    final Map<String, dynamic> requestBody = {
      "action": "getGarageAgreement",
      "userid": userId,
    };

    try {
      final response = await TrainingApiService.sendTrainingRequest(requestBody);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = json.decode(response.body);

        if (responseBody['status'] == "success") {
          // Parse the `data` field into a `GarageAgreement` object
          final data = responseBody['data'];
          return GarageAgreement.fromJson(data);
        } else if (responseBody['status'] == "notexist") {
          // Handle the "notexist" case
          print('Garage agreement not generated.');
          return null;
        } else {
          throw Exception('Unexpected status: ${responseBody['status']}');
        }
      } else {
        throw Exception(
            'Failed to fetch garage agreement: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching garage agreement: $e');
    }
  }
}
