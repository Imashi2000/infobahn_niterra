class UserData {
  final int userId;
  final int userTypeId;
  final String userType;
  final String name;
  final String surname;
  final int countryId;
  final int cityId;
  final List<String> pagesId;
  final String email;
  final String phone;

  UserData({
    required this.userId,
    required this.userTypeId,
    required this.userType,
    required this.name,
    required this.surname,
    required this.countryId,
    required this.cityId,
    required this.pagesId,
    required this.email,
    required this.phone,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      userId: json['userid'],
      userTypeId: json['usertypeid'],
      userType: json['usertype'],
      name: json['name'],
      surname: json['surname'],
      countryId: json['countryid'],
      cityId: json['cityid'],
      pagesId: List<String>.from(json['pagesid']),
      email: json['email'],
      phone: json['phone'],
    );
  }
}