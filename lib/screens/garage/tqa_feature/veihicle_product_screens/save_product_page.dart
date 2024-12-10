import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart';

class ProductRegistrationService {
  static const String _baseUrl =
      "https://trustedprog.com/api/connection.php/garage/saveProduct.php";
  static const String _username = "NiterraMobile";
  static const String _password = "ha@jhashHhg*&63";

  Future<Map<String, dynamic>> saveProduct({
    required String vehicleId,
    required String productId,
    required String productTypeId,
    required String? productSubId,
    required String partNoQty,
    required String purchasePlace,
    required String otherRetailer,
    required File? productImg,
    required File? invoiceImg,
    required String odometer,
    required String garageId,
  }) async {
    try {
      // Encode Base64 for Basic Auth
      String auth = 'Basic ${base64Encode(utf8.encode("$_username:$_password"))}';

      // Prepare the multipart request
      var request = http.MultipartRequest('POST', Uri.parse(_baseUrl))
        ..headers['Authorization'] = auth
        ..fields['action'] = 'saveProduct'
        ..fields['vehicleid'] = vehicleId
        ..fields['productid'] = productId
        ..fields['producttypeid'] = productTypeId
        ..fields['productsubid'] = productSubId ?? ''
        ..fields['partnoqty'] = partNoQty
        ..fields['purchaseplace'] = purchasePlace
        ..fields['otheretailer'] = otherRetailer
        ..fields['odometer'] = odometer
        ..fields['garageid'] = garageId;

      // Attach product image
      if (productImg != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'productimg',
            productImg.path,
            contentType: MediaType('image', extension(productImg.path)),
          ),
        );
      }

      // Attach invoice image
      if (invoiceImg != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'invoiceimg',
            invoiceImg.path,
            contentType: MediaType('image', extension(invoiceImg.path)),
          ),
        );
      }

      // Send the request
      var response = await request.send();
      var responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        return json.decode(responseBody);
      } else {
        throw Exception('Failed to save product: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
