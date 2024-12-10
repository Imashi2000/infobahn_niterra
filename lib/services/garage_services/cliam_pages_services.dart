import 'dart:convert';
import 'package:niterra/models/garage_models/getClaimByGarageId.dart';
import 'package:niterra/models/garage_models/getClaimsByClaimId.dart';
import 'package:niterra/models/garage_models/getPartnoByVehicleId_model.dart';
import 'package:niterra/models/garage_models/getPlatenoByCountry_model.dart';
import 'package:niterra/models/garage_models/getProductDetailbyUserproductId_model.dart';
import 'package:niterra/models/garage_models/getStockDataByClaimId_model.dart';
import 'package:niterra/models/garage_models/saveClaimRequest_model.dart';
import 'package:niterra/models/garage_models/saveClaimResponse_model.dart';
import 'package:niterra/services/api_service.dart';

class ClaimServices {
  Future<List<PlateNumberByCountry>> fetchPlateNumbersByCountryId(int countryId) async {
    final Map<String, dynamic> requestBody = {
      "action": "getPlatenoByCountry",
      "countryid": countryId,
    };

    try {
      final response = await BasicAPIService.sendPostRequest(requestBody);
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'] as List;
        return data.map((item) => PlateNumberByCountry.fromJson(item)).toList();
      } else {
        throw Exception('Failed to fetch plate numbers');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<List<PartNoByVehicle>> fetchPartNoByVehicle(int vehicleid) async {
    final Map<String, dynamic> requestBody = {
      "action": "getPartnoByVehicleId",
      "vehicleid": vehicleid,
    };

    try {
      final response = await BasicAPIService.sendPostRequest(requestBody);

      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'] as List;
        return data.map((item) => PartNoByVehicle.fromJson(item)).toList();
      } else {
        throw Exception('Failed to fetch part numbers by vehicle id');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
  Future<ClaimResponse> fetchClaimDetails(int userProductId) async {
    final Map<String, dynamic> requestBody = {
      "action": "getPdtdetByUserproId",
      "userproductid": userProductId,
    };

    try {
      final response = await BasicAPIService.sendPostRequest(requestBody);

      // Log the full response for debugging
      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        return ClaimResponse.fromJson(json.decode(response.body));
      } else {
        throw Exception(
            'Failed to fetch claim details. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching claim details: $e');
      throw Exception('Error: $e');
    }
  }

  Future<SaveClaimResponse> saveClaim(SaveClaimRequest request) async {
    try {
      final response = await BasicAPIService.sendPostRequest(request.toJson());

      if (response.statusCode == 200) {
        return SaveClaimResponse.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to save claim. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<List<ClaimByGarage>> fetchClaimsByGarageId(int garageId) async {
    final Map<String, dynamic> requestBody = {
      "action": "getClaimsByGarageId",
      "garageid": garageId,
    };

    try {
      final response = await BasicAPIService.sendPostRequest(requestBody);

      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'] as List;
        return data.map((item) => ClaimByGarage.fromJson(item)).toList();
      } else {
        throw Exception('Failed to fetch claims by garage ID. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<List<StockDataByClaim>> fetchStockDataByClaim(int claimId) async {
    final Map<String, dynamic> requestBody = {
      "action": "getStockDataByClaimId",
      "claimid": claimId,
    };

    try {
      // Use BasicAPIService to send the POST request
      final response = await BasicAPIService.sendPostRequest(requestBody);

      // Log the full response for debugging
      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      // Parse the response and handle errors
      if (response.statusCode == 200) {
        final body = json.decode(response.body);

        if (body['status'] == 'success') {
          final List<dynamic>? data = body['data'];

          if (data != null && data.isNotEmpty) {
            // Map the response data to StockDataByClaim model objects
            return data.map((item) => StockDataByClaim.fromJson(item)).toList();
          } else {
            // Return an empty list if no data is present
            return [];
          }
        } else {
          throw Exception('Failed to fetch stock data: ${body['message']}');
        }
      } else {
        throw Exception('Failed to fetch stock data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Log and rethrow the exception for higher-level error handling
      print('Error fetching stock data: $e');
      throw Exception('Error fetching stock data: $e');
    }
  }
  Future<ClaimDetailsByClaimId> fetchClaimDetailsById(int claimId) async {
    final Map<String, dynamic> requestBody = {
      "action": "getClaimByClaimId",
      "claimid": claimId,
    };

    try {
      final response = await BasicAPIService.sendPostRequest(requestBody);

      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final body = json.decode(response.body);
        if (body['status'] == 'success') {
          return ClaimDetailsByClaimId.fromJson(body['data'][0]);
        } else {
          throw Exception('Failed to fetch claim details: ${body['message']}');
        }
      } else {
        throw Exception('Failed to fetch claim details. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching claim details: $e');
      throw Exception('Error fetching claim details: $e');
    }
  }
}