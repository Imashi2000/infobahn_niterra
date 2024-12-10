class UpdatepasswordresponseModel {
  final String status;
  final String message;

  UpdatepasswordresponseModel({
    required this.status,
    required this.message,
  });

  factory UpdatepasswordresponseModel.fromJson(Map<String, dynamic> json) {
    return UpdatepasswordresponseModel(
      status: json['status'],
      message: json['message'],
    );
  }
}
