class SaveProductResponse {
  final String status;
  final String message;

  SaveProductResponse({required this.status, required this.message});

  factory SaveProductResponse.fromJson(Map<String, dynamic> json) {
    return SaveProductResponse(
      status: json['status'] as String,
      message: json['message'] as String,
    );
  }
}