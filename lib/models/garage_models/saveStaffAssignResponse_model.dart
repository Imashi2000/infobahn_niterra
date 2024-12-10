class AssignTrainingResponse {
  final String status;
  final String message;

  AssignTrainingResponse({
    required this.status,
    required this.message,
  });

  factory AssignTrainingResponse.fromJson(Map<String, dynamic> json) {
    return AssignTrainingResponse(
      status: json['status'],
      message: json['message'],
    );
  }
}
