class ForgotPasswordResponse {
  final String status;
  final String message;

  ForgotPasswordResponse({required this.status, required this.message});

  factory ForgotPasswordResponse.fromJson(Map<String, dynamic> json) {
    return ForgotPasswordResponse(
      status: json['status'],
      message: json['message'],
    );
  }
}
