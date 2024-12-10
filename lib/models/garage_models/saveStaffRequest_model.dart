class StaffRegistrationModel {
  final String staffName;
  final String staffEmail;
  final String staffPhone;
  final int designationId;
  final int userid;

  StaffRegistrationModel({
    required this.staffName,
    required this.staffEmail,
    required this.staffPhone,
    required this.designationId,
    required this.userid,
  });

  Map<String, dynamic> toJson() {
    return {
      "action": "saveStaff",
      "staffname": staffName,
      "staffemail": staffEmail,
      "staffphone": staffPhone,
      "designationid": designationId.toString(),
      "userid": userid.toString(),
    };
  }
}