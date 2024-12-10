class UpdatePasswordRequest {
  final String action;
  final String userId;
  final String password;

  UpdatePasswordRequest({
    required this.action,
    required this.userId,
    required this.password,
  });

  Map<String, String> toJson() {
    return {
      "action": action,
      "userid": userId,
      "password": password,
    };
  }
}
