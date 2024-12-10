class GarageAgreement {
  final String garageName;
  final String contactName;
  final String designation;
  final String email;
  final String phone;
  final String garageStatus;
  final String certificate;
  final String agreement;

  GarageAgreement({
    required this.garageName,
    required this.contactName,
    required this.designation,
    required this.email,
    required this.phone,
    required this.garageStatus,
    required this.certificate,
    required this.agreement,
  });

  factory GarageAgreement.fromJson(Map<String, dynamic> json) {
    return GarageAgreement(
      garageName: json['garagename'],
      contactName: json['contactname'],
      designation: json['designation'],
      email: json['email'],
      phone: json['phone'],
      garageStatus: json['garagestatus'],
      certificate: json['certificate'],
      agreement: json['agreement'],
    );
  }
}
