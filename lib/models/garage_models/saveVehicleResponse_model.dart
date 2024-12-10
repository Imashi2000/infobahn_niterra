class SaveVehicleResponse {
  final String status;
  final String message;

  SaveVehicleResponse({
    required this.status,
    required this.message,
  });

  factory SaveVehicleResponse.fromJson(Map<String, dynamic> json) {
    return SaveVehicleResponse(
      status: json['status'],
      message: json['message'],
    );
  }
}