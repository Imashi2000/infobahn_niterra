class StaffRegistrationResponse {
  final String status;
  final String message;

  StaffRegistrationResponse({required this.status, required this.message});

  factory StaffRegistrationResponse.fromJson(Map<String, dynamic> json) {
    return StaffRegistrationResponse(
      status: json['status'],
      message: json['message'],
    );
  }
}