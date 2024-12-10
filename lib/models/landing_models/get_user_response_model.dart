import 'package:niterra/models/landing_models/designation_model.dart';

class GetUserResponse {
  final String prefix;
  final String name;
  final String surname;
  final String companyName;
  final Designation designation;
  final String userType;
  final String country;
  final String city;
  final String address;
  final String email;
  final String phone;

  GetUserResponse({
    required this.prefix,
    required this.name,
    required this.surname,
    required this.companyName,
    required this.designation,
    required this.userType,
    required this.country,
    required this.city,
    required this.address,
    required this.email,
    required this.phone,
  });

  factory GetUserResponse.fromJson(Map<String, dynamic> json) {
    return GetUserResponse(
      prefix: json['prefix'] ?? '',
      name: json['name'] ?? '',
      surname: json['surname'] ?? '',
      companyName: json['companyname'] ?? '',
      designation: json['designation'] != null
          ? Designation.fromJson(json['designation'])
          : Designation(designation: '', designationId: 0),
      userType: json['usertype'] ?? '',
      country: json['country'] ?? '',
      city: json['city'] ?? '',
      address: json['address'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
    );
  }
}
