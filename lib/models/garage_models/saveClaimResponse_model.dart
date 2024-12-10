class SaveClaimResponse {
  String status;
  String message;

  SaveClaimResponse({required this.status, required this.message});

  factory SaveClaimResponse.fromJson(Map<String, dynamic> json) {
    return SaveClaimResponse(
      status: json['status'],
      message: json['message'],
    );
  }
}