import 'dart:convert';
import 'package:niterra/models/garage_models/cross_reference_model.dart';
import 'package:niterra/services/api_service.dart';

class CrossReferenceAPIService {
  Future<List<CrossReferenceModel>> fetchCrossReferenceData({String? search}) async {
    final Map<String, dynamic> requestBody = {
      "action": "getCrossReference",
      "search": search,
    };

    try {
      final response = await BasicAPIService.sendPostRequest(requestBody);

      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'] as List;
        return data.map((item) => CrossReferenceModel.fromJson(item)).toList();
      } else {
        throw Exception('Failed to fetch cross-reference data');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}


