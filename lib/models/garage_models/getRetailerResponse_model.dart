import 'package:niterra/models/garage_models/getRetailerbyCountry_model.dart';

class RetailerResponse {
  final String status;
  final List<RetailerData> data;

  RetailerResponse({
    required this.status,
    required this.data,
  });

  factory RetailerResponse.fromJson(Map<String, dynamic> json) {
    return RetailerResponse(
      status: json['status'] as String,
      data: (json['data'] as List)
          .map((item) => RetailerData.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': data.map((item) => item.toJson()).toList(),
    };
  }
}