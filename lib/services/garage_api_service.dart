import 'dart:convert';
import 'package:http/http.dart' as http;

class GarageAPIService {
  // Base URL for garage-specific requests
  static const String garageBaseUrl = 'https://trustedprog.com/api/connection.php/garage';

  // Basic Auth credentials
  static const String username = 'NiterraMobile';
  static const String password = 'ha@jhashHhg*&63';

  // Method to get the Basic Auth headers
  static Map<String, String> getAuthHeaders() {
    final String basicAuth = 'Basic ' + base64Encode(utf8.encode('$username:$password'));
    return {
      'Authorization': basicAuth,
      'Content-Type': 'application/json', // Ensure requests are in JSON format
    };
  }

  // Method to send POST requests to the Garage API
  static Future<http.Response> sendGarageRequest(Map<String, dynamic> body) async {
    final response = await http.post(
      Uri.parse(garageBaseUrl),
      body: json.encode(body),
      headers: getAuthHeaders(),
    );
    return response;
  }
}
