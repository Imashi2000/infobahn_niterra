class SaveUserResponse {
  final String status;
  final String message;

  SaveUserResponse({
    required this.status,
    required this.message,
  });

  factory SaveUserResponse.fromJson(Map<String, dynamic> json) {
    return SaveUserResponse(
      status: json['status'],
      message: json['message'],
    );
  }
}
