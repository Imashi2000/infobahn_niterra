import 'dart:convert';
import 'package:niterra/models/garage_models/getConsumerDropdown_model.dart';
import 'package:niterra/models/garage_models/getConsumerbyCountry_model.dart';
import 'package:niterra/models/garage_models/getVehicleByCountry_model.dart';
import 'package:niterra/models/garage_models/getVehicleModel.dart';
import 'package:niterra/models/garage_models/getVehicle_model.dart';
import 'package:niterra/models/garage_models/getvehicle_manufacturer_model.dart';
import 'package:niterra/models/garage_models/saveVehicleRequest_model.dart';
import 'package:niterra/models/garage_models/saveVehicleResponse_model.dart';
import 'package:niterra/services/api_service.dart';

class VehicleRegistrationServices {

  Future<List<ConsumerDropdownModel>> fetchConsumersByCountry(int countryId) async {
    final Map<String, dynamic> requestBody = {
      "action": "getConsumerDropdown",
      "countryid": countryId,
    };

    try {
      final response = await BasicAPIService.sendPostRequest(requestBody);

      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'] as List;
        return data.map((item) => ConsumerDropdownModel.fromJson(item)).toList();
      } else {
        throw Exception('Failed to fetch consumers by country');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<List<VehicleModel>> fetchVehicleTypes() async {
    final Map<String, dynamic> requestBody = {
      "action": "getVehtype",
    };

    try {
      final response = await BasicAPIService.sendPostRequest(requestBody);

      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'] as List;
        return data.map((item) => VehicleModel.fromJson(item)).toList();
      } else {
        throw Exception('Failed to fetch vehicle types');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<List<VehicleManufacturerModel>> fetchManufacturersByType(int vehtypeId) async {
    final Map<String, dynamic> requestBody = {
      "action": "getVehmake",
      "vehtype": vehtypeId,
    };

    try {
      final response = await BasicAPIService.sendPostRequest(requestBody);

      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'] as List;
        return data.map((item) => VehicleManufacturerModel.fromJson(item)).toList();
      } else {
        throw Exception('Failed to fetch vehicle manufacturers');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<List<ModelTypes>> fetchModelsByManufacturer(int vehmakeId) async {
    final Map<String, dynamic> requestBody = {
      "action": "getVehmodel",
      "vehmake": vehmakeId,
    };

    try {
      final response = await BasicAPIService.sendPostRequest(requestBody);
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'] as List;
        return data.map((item) => ModelTypes.fromJson(item)).toList();
      } else {
        throw Exception('Failed to fetch vehicle models');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<SaveVehicleResponse> saveVehicle(SaveVehicleRequest request) async {
    final Map<String, dynamic> requestBody = request.toJson();

    try {
      final response = await BasicAPIService.sendPostRequest(requestBody);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return SaveVehicleResponse.fromJson(data);
      } else {
        throw Exception('Failed to save vehicle. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error saving vehicle: $e');
    }
  }

  Future<List<VehicleByCountry>> fetchVehiclesByCountry(int countryId) async {
    final Map<String, dynamic> requestBody = {
      "action": "getVehicleByCountry",
      "countryid": countryId,
    };

    try {
      final response = await BasicAPIService.sendPostRequest(requestBody);

      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'] as List;
        return data.map((item) => VehicleByCountry.fromJson(item)).toList();
      } else {
        throw Exception('Failed to fetch vehicles by country');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
