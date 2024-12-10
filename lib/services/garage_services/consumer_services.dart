import 'dart:convert';
import 'package:niterra/models/garage_models/SaveConsumer_response_model.dart';
import 'package:niterra/models/garage_models/getConsumerbyCountry_model.dart';
import 'package:niterra/models/garage_models/saveConsumer_request_model.dart';
import 'package:niterra/services/api_service.dart';

class ConsumerApiService {

  Future<SaveConsumerResponse> saveConsumer(SaveConsumerRequest request) async {
    final Map<String, String> requestBody = Map<String, String>.from(
        request.toJson());

    try {
      final response = await BasicAPIService.sendPostRequest(requestBody);

      // Debug: Log the response details
      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        try {
          final data = json.decode(response.body);
          return SaveConsumerResponse.fromJson(data);
        } catch (e) {
          print('Error decoding JSON: $e');
          throw Exception('Failed to parse save consumer response');
        }
      } else {
        throw Exception(
            'Failed to save consumer. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error saving consumer: $e');
      throw Exception('Failed to save consumer');
    }
  }

  Future<List<ConsumerbyCountryModel>> fetchConsumersByCountrylist(int countryId) async {
    final Map<String, dynamic> requestBody = {
      "action": "getConsumerbyCountry",
      "countryid": countryId,
    };

    try {
      final response = await BasicAPIService.sendPostRequest(requestBody);

      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'] as List;
        return data.map((item) => ConsumerbyCountryModel.fromJson(item)).toList();
      } else {
        throw Exception('Failed to fetch consumers by country');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

}