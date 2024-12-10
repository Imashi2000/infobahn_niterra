class UpdateprofileresponseModel {
  final String status;
  final String message;

  UpdateprofileresponseModel({
    required this.status,
    required this.message,
  });

  factory UpdateprofileresponseModel.fromJson(Map<String, dynamic> json) {
    return UpdateprofileresponseModel(
      status: json['status'],
      message: json['message'],
    );
  }
}