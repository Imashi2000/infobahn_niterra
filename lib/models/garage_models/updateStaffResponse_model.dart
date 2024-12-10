class UpdateStaffResponseModel {
  final String status;
  final String message;

  UpdateStaffResponseModel({
    required this.status,
    required this.message,
  });

  factory UpdateStaffResponseModel.fromJson(Map<String, dynamic> json) {
    return UpdateStaffResponseModel(
      status: json['status'],
      message: json['message'],
    );
  }
}
