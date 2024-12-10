import 'dart:convert';
import 'package:http/http.dart' as http;

class BasicAPIService {
  // Common URL for API requests
  static const String baseUrl = 'https://trustedprog.com/api/connection.php';

  // Basic Auth credentials
  static const String username = 'NiterraMobile';
  static const String password = 'ha@jhashHhg*&63';

  // Method to get the Basic Auth header
  static Map<String, String> getAuthHeaders() {
    final String basicAuth = 'Basic ' + base64Encode(utf8.encode('$username:$password'));
    return {
      'Authorization': basicAuth,
      'Content-Type': 'application/json',  // Set content type to JSON for the request
    };
  }

  // Method to send POST request to the API
  static Future<http.Response> sendPostRequest(Map<String, dynamic> body) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      body: json.encode(body),
      headers: getAuthHeaders(),
    );
    return response;
  }
}