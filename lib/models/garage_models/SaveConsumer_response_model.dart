class SaveConsumerResponse {
  String status;
  String message;

  SaveConsumerResponse({
    required this.status,
    required this.message,
  });

  factory SaveConsumerResponse.fromJson(Map<String, dynamic> json) {
    return SaveConsumerResponse(
      status: json["status"],
      message: json["message"],
    );
  }
}
