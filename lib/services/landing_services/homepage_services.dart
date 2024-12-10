import 'dart:convert';
import 'package:niterra/models/landing_models/location_model.dart';
import 'package:niterra/services/api_service.dart';

class HomePageService{
  Future<List<LocationInfo>> fetchLocations(String country, String city) async {
    final Map<String, String> requestBody = {
      "action": "getGoogleLocation",
      "country": country,
      "city": city,
    };

    try {
      final response = await BasicAPIService.sendPostRequest(requestBody);

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List<dynamic>;
        return data.map((location) => LocationInfo.fromJson(location)).toList();
      } else {
        throw Exception('Failed to fetch locations. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching locations: $e');
      throw Exception('Failed to fetch locations');
    }
  }
}