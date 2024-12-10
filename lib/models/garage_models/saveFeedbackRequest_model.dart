class SaveFeedbackRequest {
  final String action;
  final String userId;
  final String feedback;

  SaveFeedbackRequest({
    required this.action,
    required this.userId,
    required this.feedback,
  });

  Map<String, dynamic> toJson() {
    return {
      "action": action,
      "userid": userId,
      "feedback": feedback,
    };
  }
}
