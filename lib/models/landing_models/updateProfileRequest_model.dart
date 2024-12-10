class UpdateProfileRequest {
  final String action;
  final String userId;
  final String name;
  final String surname;
  final String phone;
  final String email;
  final String garageName;
  final String userType;

  UpdateProfileRequest({
    required this.action,
    required this.userId,
    required this.name,
    required this.surname,
    required this.phone,
    required this.email,
    required this.garageName,
    required this.userType,
  });

  Map<String, String> toJson() {
    return {
      "action": action,
      "userid": userId,
      "name": name,
      "surname": surname,
      "phone": phone,
      "email": email,
      "garagename": garageName,
      "usertype": userType,
    };
  }
}
