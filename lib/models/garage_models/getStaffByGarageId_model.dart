class StaffByGarage {
  final int staffId;
  final String staffName;
  final String staffPhone;
  final String staffEmail;
  final String designation;

  StaffByGarage({
    required this.staffId,
    required this.staffName,
    required this.staffPhone,
    required this.staffEmail,
    required this.designation,
  });

  factory StaffByGarage.fromJson(Map<String, dynamic> json) {
    return StaffByGarage(
      staffId: json['staffid'],
      staffName: json['staffname'],
      staffPhone: json['staffphone'],
      staffEmail: json['staffemail'],
      designation: json['designation'],
    );
  }
}
