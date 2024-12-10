import 'dart:convert';
import 'package:niterra/models/garage_models/getAllProdDetByUserProductId_model.dart';
import 'package:niterra/models/garage_models/getBrand_model.dart';
import 'package:niterra/models/garage_models/getPdtdetailbyPartno_model.dart';
import 'package:niterra/models/garage_models/getPlateNoByGarageId_model.dart';
import 'package:niterra/models/garage_models/getProductTypeSub_model.dart';
import 'package:niterra/models/garage_models/getProductsByGarageId_model.dart';
import 'package:niterra/models/garage_models/getProductsbyVehicle_model.dart';
import 'package:niterra/models/garage_models/getRetailerbyCountry_model.dart';
import 'package:niterra/models/garage_models/getVehiclebyPlateno_model.dart';
import 'package:niterra/models/garage_models/get_all_part_no_model.dart';
import 'package:niterra/models/garage_models/get_partno_by_productType_model.dart';
import 'package:niterra/models/garage_models/get_product_category_model.dart';
import 'package:niterra/models/garage_models/get_product_type_model.dart';
import 'package:niterra/models/garage_models/saveProductRequest_model.dart';
import 'package:niterra/models/garage_models/saveProductResponse_model.dart';
import 'package:niterra/services/api_service.dart';

class ProductRegistrationServices {

  Future<List<PlateNumberByGarage>> fetchPlateNumbersByGarageId(String garageId) async {
    final Map<String, dynamic> requestBody = {
      "action": "getPlatenoByGarageId",
      "garageid": garageId,
    };

    try {
      final response = await BasicAPIService.sendPostRequest(requestBody);
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'] as List;
        return data.map((item) => PlateNumberByGarage.fromJson(item)).toList();
      } else {
        throw Exception('Failed to fetch plate numbers');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<List<BrandModel>> fetchBrands () async{
    final Map<String,dynamic> requestBody = {
      "action":"getBrand"
    };

    try {
      final response = await BasicAPIService.sendPostRequest(requestBody);
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'] as List;
        return data.map((item) => BrandModel.fromJson(item)).toList();
      } else {
        throw Exception('Failed to fetch plate numbers');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<List<AllPartNoModel>> fetchAllPartNos () async{
    final Map<String,dynamic> requestBody = {
      "action":"getAllPartNo"
    };

    try {
      final response = await BasicAPIService.sendPostRequest(requestBody);
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'] as List;
        return data.map((item) => AllPartNoModel.fromJson(item)).toList();
      } else {
        throw Exception('Failed to fetch part numbers');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<List<ProductCategoryModel>> fetchProductCategoryByBrandId(int brandId) async {
    final Map<String, dynamic> requestBody = {
      "action": "getProductCategory",
      "brand": brandId.toString(),
    };

    try {
      final response = await BasicAPIService.sendPostRequest(requestBody);
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'] as List;
        return data.map((item) => ProductCategoryModel.fromJson(item)).toList();
      } else {
        throw Exception('Failed to fetch product categories');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<List<ProductTypeModel>> fetchProductTypeByCategoryId(int categoryId) async {
    final Map<String, dynamic> requestBody = {
      "action": "getProductType",
      "category": categoryId.toString(),
    };

    try {
      final response = await BasicAPIService.sendPostRequest(requestBody);
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'] as List;
        return data.map((item) => ProductTypeModel.fromJson(item)).toList();
      } else {
        throw Exception('Failed to fetch product types');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<List<PartNoByProductTypeModel>> fetchPartNoByProductTypeId(int productTypeId) async {
    final Map<String, dynamic> requestBody = {
      "action": "getPartnoByPdtType",
      "producttype": productTypeId.toString(),
    };

    try {
      final response = await BasicAPIService.sendPostRequest(requestBody);
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'] as List;
        return data.map((item) => PartNoByProductTypeModel.fromJson(item)).toList();
      } else {
        throw Exception('Failed to fetch part numbers by product type');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<List<RetailerData>> fetchRetailersByCountryId(int countryId) async {
    final Map<String, dynamic> requestBody = {
      "action": "getRetailerbyCountry",
      "countryid": countryId,
    };

    try {
      final response = await BasicAPIService.sendPostRequest(requestBody);
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'] as List;
        return data.map((item) => RetailerData.fromJson(item)).toList();
      } else {
        throw Exception('Failed to fetch retailers');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<List<ProductTypeSubModel>> fetchProductTypeSub () async{
    final Map<String,dynamic> requestBody = {
      "action":"getProductTypeSub"
    };

    try {
      final response = await BasicAPIService.sendPostRequest(requestBody);
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'] as List;
        return data.map((item) => ProductTypeSubModel.fromJson(item)).toList();
      } else {
        throw Exception('Failed to fetch product type sub categories for metal GP ');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<ProductDetailsByPartNo> fetchProductDetailsByPartNo(String partNo) async {
    final Map<String, dynamic> requestBody = {
      "action": "getPdtdetailbyPartno",
      "productid": partNo,
    };

    try {
      final response = await BasicAPIService.sendPostRequest(requestBody);
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data']; // Directly access the map
        return ProductDetailsByPartNo.fromJson(data); // Convert the map to a single object
      } else {
        throw Exception('Failed to fetch product details by part number');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<VehicleByPlateNo> fetchModelbyPlateNo(String plateno) async {
    final Map<String, dynamic> requestBody = {
      "action": "getVehiclebyPlateno",
      "vehicleid": plateno,
    };

    try {
      final response = await BasicAPIService.sendPostRequest(requestBody);
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        // Parse the flat JSON response directly
        final data = json.decode(response.body);

        // Check if the response status is success
        if (data['status'] == 'success') {
          // Map to the VehicleByPlateNo model
          return VehicleByPlateNo.fromJson(data);
        } else {
          throw Exception('API returned failure status');
        }
      } else {
        throw Exception('Failed to fetch vehicle model');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }



  Future<SaveProductResponse> saveProduct(SaveProductRequest request) async {
    final Map<String, dynamic> requestBody = request.toJson();
    try {
      final response = await BasicAPIService.sendPostRequest(requestBody);
      print('Response body: ${response.body}');

      if (response.body.isNotEmpty &&
          response.headers['content-type']?.contains('application/json') == true) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == 'success') {
          return SaveProductResponse.fromJson(jsonResponse);
        } else {
          throw Exception('API Error: ${jsonResponse['message']}');
        }
      } else {
        print('Invalid response format: ${response.body}');
        throw Exception('Invalid response format');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<List<ProductsByVehicle>> fetchProductsByVehicle(int vehicleid) async {
    final Map<String, dynamic> requestBody = {
      "action": "getProductsbyVehicle",
      "vehicleid": vehicleid,
    };

    try {
      final response = await BasicAPIService.sendPostRequest(requestBody);

      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'] as List;
        return data.map((item) => ProductsByVehicle.fromJson(item)).toList();
      } else {
        throw Exception('Failed to fetch products by vehicle id');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<List<ProductsByGarageId>> fetchProductsByGarageId(int garageId) async {
    final Map<String, dynamic> requestBody = {
      "action": "getProductsbyGarageId",
      "garageid": garageId,
    };

    try {
      final response = await BasicAPIService.sendPostRequest(requestBody);

      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'] as List;
        return data.map((item) => ProductsByGarageId.fromJson(item)).toList();
      } else {
        throw Exception('Failed to fetch products by garage id');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
  Future<ProductDetails> fetchProductDetailsByUserProductId(int userproductid) async {
    final Map<String, dynamic> requestBody = {
      "action": "getPdtByUserProductId",
      "userproductid": userproductid,
    };

    try {
      final response = await BasicAPIService.sendPostRequest(requestBody);
      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'];
        if (data != null && data.isNotEmpty) {
          return ProductDetails.fromJson(data[0]);
        } else {
          throw Exception('No data found');
        }
      } else {
        throw Exception('Failed to fetch product details');
      }
    } catch (e) {
      throw Exception('Error fetching product details: $e');
    }
  }
}




