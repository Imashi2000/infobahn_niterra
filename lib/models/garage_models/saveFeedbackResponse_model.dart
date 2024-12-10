class SaveFeedbackResponse {
  String status;
  String message;

  SaveFeedbackResponse({required this.status, required this.message});

  factory SaveFeedbackResponse.fromJson(Map<String, dynamic> json) {
    return SaveFeedbackResponse(
      status: json['status'],
      message: json['message'],
    );
  }
}